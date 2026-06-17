# Directive — blueprint-reviewer, RPF same-iter fastpath (iter-198)

## Mode
Scoped re-review of a single chapter just patched by a blueprint-writer; renders an updated HARD GATE verdict so the plan agent may dispatch a prover this iter.

## Iteration framing

Iter-198 blueprint-reviewer `iter198` rendered HARD GATE DEFER on
`blueprint/src/chapters/Picard_RelPicFunctor.tex`:
- `thm:rel_pic_etale_sheaf_group_structure` missing `\lean{...}` pin
- Étale-Grothendieck-topology Mathlib API name not confirmed

Blueprint-writer `rpf-mustfix` returned COMPLETE this iter. The
writer:
1. Added `\lean{AlgebraicGeometry.Scheme.PicSharp.etSheaf_group_structure}` pin to `thm:rel_pic_etale_sheaf_group_structure` with extended `% SOURCE QUOTE:` block (Kleiman L1281-L1340).
2. Confirmed the Mathlib étale-topology API names via `lean_leansearch`:
   - `AlgebraicGeometry.Scheme.etaleTopology` (`Mathlib.AlgebraicGeometry.Sites.Etale`) — big étale topology on `Scheme`.
   - `CategoryTheory.presheafToSheaf` (sheafification with `AddCommGrpCat` target under `HasWeakSheafify`).
   - Fallback: `CategoryTheory.GrothendieckTopology.sheafify` + `plusPlusSheaf`.
3. Added a corrected `\paragraph{Gate annotation (iter-198 refresh)}` replacing the stale 10-iter-old `LineBundle.OnProduct`-gate annotation with the actual residual gate (tensor-product `AddCommGroup` on `LineBundle.OnProduct` via `Scheme.Modules` monoidal-structure gap).
4. Updated the internal-consistency-check intro count "five → six declaration blocks".

Lake build state: green (per iter-197 meta.json; blueprint .tex
edits do not affect lake build).

## Scope

Re-review **only** `blueprint/src/chapters/Picard_RelPicFunctor.tex`. Do NOT touch other chapters; do NOT re-audit the whole blueprint. Output a HARD GATE verdict (CLEAR / DEFER / FAST-PATH-CANDIDATE) on this single chapter.

## Pass criteria

The HARD GATE clears if ALL of:
- `thm:rel_pic_etale_sheaf_group_structure` has a `\lean{...}` pin AND a referenced proof sketch.
- The étale-Grothendieck-topology Mathlib API name is named on the chapter (`AlgebraicGeometry.Scheme.etaleTopology` or equivalent confirmed).
- No new must-fix-this-iter finding introduced by the writer's edits.
- All six prover-gate sorries (L235, L287, L328, L373, L433, L482) have either (a) a backing `\lean{...}` pin in the chapter or (b) explicit gate documentation pointing to an external Mathlib gap.
- Citation discipline preserved: `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source: …}` on declaration blocks; verified verbatim against `references/kleiman-picard-src/kleiman-picard.tex`.

If the gate clears, the plan agent re-engages Lane RPF in iter-198 objectives.

## Output

Write to `task_results/blueprint-reviewer-rpf-fastpath.md` — short, scoped report with the HARD GATE verdict + a one-paragraph rationale + any soon-severity items the planner should track for iter-199.
