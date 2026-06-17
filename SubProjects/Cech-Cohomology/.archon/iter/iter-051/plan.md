# Iter-051 plan — RECOVER iter-050's wasted iter (plan-validate parser bug) + re-dispatch the two ready lanes

## Entering state (verified)
iter-050's plan phase did ALL the prep correctly — route-B selection (mathlib-analogist `iter050-residual`),
blueprint corrections (blueprint-writer `iter050-02kg` + `iter050-routeb`), purification (blueprint-clean),
and the HARD GATE clear (blueprint-reviewer `iter050`: both lane chapters complete + correct, 0 must-fix).
**But it dispatched 0 provers.** `meta.json` for iter-050: `planValidate.status = "failed"`, `objectives: 0`;
the `provers/` dir is empty; the `.lean` files are unchanged since iter-049 (mtimes 06-06/06-07).

## Root cause (found this phase)
The plan-validate objective parser (`archon/state/progress.py`) drops any `## Current Objectives` line
containing a `_STOP_MARKER` phrase. The list is: `"do not touch"`, `"do not assign"`, `"do-not-touch"`,
`"off-limits"`, `"off limits"`, `"do not work on"`, `"no objective"` (case-insensitive, substring). **Both**
of iter-050's objective lines carried the caveat **"Do NOT touch …"** (the dead line-110 sorry / the
protected line-679 decl) on the *same physical line* as the `.lean` path → both lines were treated as
off-limits annotations → 0 parseable objectives → prover phase skipped. The "does not yet exist" scaffold
token on the same line did NOT save them; the stop-marker check fires first.

## What I did this phase
1. **Diagnosed** the iter-050 no-run via `meta.json` + `dispatch.jsonl` + reading the parser source
   (`progress.py:_STOP_MARKERS`, `plan_validate.py`). Confirmed the `.lean` targets still absent
   (`sectionCech_homology_exact_of_localizationAway`, `cechAugmented_exact` both grep-empty) and the only
   sorries are the two frozen/superseded ones (CechAcyclic:110 dead, CechHigherDirectImage:679 protected).
2. **Rewrote `## Current Objectives`** in the canonical `### N. **\`File\`**` heading form. Heading-style
   takes parser precedence (`_extract_heading_candidates`) and only `###` lines are scanned for the file
   candidate, so caveats on continuation lines are now harmless. Moved both "Do NOT touch" caveats off the
   heading lines and reworded them ("leave it untouched", "leave that declaration … alone") so NO line
   carries a stop-marker phrase. Added explicit **REFERENCE ANCHOR** bullets (Stacks 02KG / 01HV for Lane 1;
   `lemma-cech-cohomology-quasi-coherent-trivial` for Lane 2) to honour the standing reference-driven directive.
3. **Verified the fix three ways** (dry-run against the real parser): `parse_objectives_with_modes` → 2
   objectives, both `mode: mathlib-build`; stop-marker grep on heading lines → CLEAN; `filter_noop_objectives`
   → both KEPT, 0 dropped.
4. **Cleared the iter-050 reviewer's lone "soon" item** (non-blocking, but a 1-line DAG-accuracy win):
   added `lem:qcoh_isIso_fromTildeGamma` to the proof `\uses{}` of `lem:cech_augmented_resolution` — the
   proof prose already `\ref`s it but the `\uses` had omitted it.
5. **Updated PROGRESS context header** (iter-051: re-dispatch + root-cause note) and **STRATEGY active table**
   (both lane cells: "DISPATCHED iter-050" → "RE-DISPATCHED iter-051", noting the parser-bug no-run). No
   route, decomposition, or >30% estimation change.

## Decision made

### D1 — RE-DISPATCH the identical two lanes; do NOT re-run the plan-prep subagents.
- **Chosen:** re-dispatch Lane 1 (`CechAcyclic.lean`, route-B residual `sectionCech_homology_exact_of_localizationAway`,
  CRITICAL) + Lane 2 (`CechHigherDirectImage.lean`, `cechAugmented_exact`, INDEPENDENT P5a), unchanged in
  substance from iter-050.
- **Why:** iter-050's entire mathematical prep is intact and was gate-cleared; the only defect was the
  objective-line formatting. The fix is purely mechanical. Re-running the analogist/writers/reviewers would
  re-review byte-identical inputs — a hollow dispatch.
- **Reversal signal:** if a prover reports the blueprint sketch is insufficient on contact, THEN dispatch a
  blueprint-writer for that block; nothing in this phase suggests that.

## Subagent skips

- blueprint-reviewer: chapters under `blueprint/src/chapters/` are unchanged since iter-050's
  blueprint-reviewer dispatch, which cleared the HARD GATE for BOTH active lane files (0 must-fix). The only
  blueprint edit this iter was the cosmetic proof-`\uses` wire-up (the iter050 reviewer's own "soon" item) —
  it strengthens the DAG, cannot regress the verdict. No prover ran in iter-050, so no Lean changed.
- progress-critic: iter-050 ran no prover phase (0 dispatched — plan-validate parser bug). There is no new
  trajectory data to assess; the progress-critic `iter050` verdict already cleared both lanes for dispatch.
- strategy-critic: STRATEGY.md is substantively unchanged (only a factual "dispatched-when" correction +
  the parser-bug note); route B was adjudicated and validated by mathlib-analogist `iter050-residual` last
  iter. This iter is a pure recovery of a formatting failure — a strategy-critic pass on an unchanged
  strategy would be a hollow dispatch.

## Next iter (iter-052) plan — ordered
1. **Process Lane 1 + Lane 2 results.** If Lane-1 `sectionCech_homology_exact_of_localizationAway` landed →
   discharge the unconditional 02KG tops in `AffineSerreVanishing.lean` (pass it as `htilde` to the
   `_of_tildeVanishing` forms; small lane). If either lane handed off a decomposition → set the next sub-leaf.
2. **P5a inputs** (consume `affine_serre_vanishing` once tops are unconditional): `Hⁿ(f⁻¹V,G)` Ext-bridge +
   open-immersion/affine vanishing. Parallel-able with the augmented-resolution continuation.
3. **EnoughInjectives connector** + **P5b comparison assembly** (closes the line-679 protected goal).
