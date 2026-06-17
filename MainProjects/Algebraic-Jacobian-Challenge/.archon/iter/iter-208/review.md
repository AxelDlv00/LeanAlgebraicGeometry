# Iter-208 (Archon canonical) — review

## Outcome at a glance

- **The "single-lane (Lane TS only) `prove` iter in which the iter-208 plan's
  Route-A premise — that `tensorObj_restrict_iso`'s residual was a bounded ~30–60
  LOC *sectionwise unfolding* of `PresheafOfModules.pullback` along the open
  immersion (per `analogies/tsroute208.md`) — was put to the prover and DISPROVEN:
  the prover added ONE genuine, GREEN-verified reduction step (strip the outer
  sheafification via `(PresheafOfModules.sheafification (𝟙 Y.ringCatSheaf.obj)).mapIso ?_`,
  exposing the precise presheaf residual `(pullback φ.hom).obj (M.val ⊗ₚ N.val) ≅
  (M.restrict f).val ⊗ₚ (N.restrict f).val`), then found the recipe is wrong —
  `PresheafOfModules.pullback` is the OPAQUE abstract left adjoint
  `(pushforward φ.hom).leftAdjoint` with no sectionwise formula (the recipe
  conflated the opaque `pullback` with the concrete `pushforward`: `restrict_obj`
  is `rfl` because `M.restrict f = SheafOfModules.pushforward β`), so the residual
  is a ~200–300 LOC mathlib-build (H1 presheaf-level `pushforward β ≅ pullback φ`
  via `leftAdjointUniq` + H2 strong-monoidal `restrictScalars`, across 4 absent
  Mathlib lemmas); the plan's **armed reversal pre-commitment FIRED**;
  lean-vs-blueprint-checker ts-iter208 independently returned a matching must-fix
  (blueprint Step 3 + closing paragraph + 2 secondary sections still assert the
  disproven sectionwise route); COE remained PAUSED (5th consecutive iter)" iter.**

- **Build GREEN; 0 `axiom` declarations** (blueprint-doctor confirms project-wide:
  no orphan chapters, no broken `\ref`/`\uses`, no new axioms). sync_leanok ran
  for iter-208 (sha `35e1bc74`, +1 marker).

- **Sorry trajectory**: iter-207 **80** → iter-208 **80** (net 0). TS file 3 → 3
  (one verified reduction step added, 0 sorries closed). COE 3 → 3 (paused). All
  other files untouched.

- **HARD BAR landings**: the critical-path closure (`tensorObj_restrict_iso`)
  **NOT met** — the prover's honest, well-evidenced finding is that it is not
  closable in `prove` mode without a Mathlib-infrastructure build first. The plan
  honored the HARD GATE (TS chapter cleared `complete+correct` via the same-iter
  fast path before dispatch); the prover's finding now re-opens that chapter's
  adequacy (see lvb must-fix).

## The defining tension — the recession pattern's 4th maturation, and the pre-commitment working as designed

This is the FOURTH consecutive iter the TS lane has landed "the foundational
input" while the critical-path sorry count held flat:
- iter-205: cone reduced to one fact (`whiskerLeft`), 0 closed.
- iter-206: two reduction steps + pinned residual, net −1 (dead-instance removal).
- iter-207: `restrictScalarsLaxMonoidal` built axiom-clean, "sole ingredient" disproven.
- iter-208: one reduction step (`mapIso`), Route-A "30–60 LOC" premise disproven.

Each iter the planner found a fresh "almost there" framing, armed a reversal
pre-commitment, dispatched — and the framing was disproven on contact. **This iter
the loop worked exactly as designed**: the plan pre-committed that "the prover
finding the `pullback` opacity is not crackable sectionwise … Route A joins the
δ-route as multi-file-blocked and TS pauses (option c)", and that signal fired.
The mechanism forecloses a FIFTH framing. The next planner must NOT autopilot
another TS helper round; the genuine fork is now narrow and documented
(recommendations.md #1): a dedicated `mathlib-build` lane on ingredients (1)–(4),
or pause TS + pivot.

Worth recording honestly: the work is NOT wasted. The `mapIso` step is permanent
correct infrastructure (Steps 1–3 of the proof are now formalized and GREEN), and
each disproven framing has sharpened the pin — the residual is now a *precisely
named* 4-ingredient mathlib-build (`informal/tensorObj_restrict_iso.md`), not a
vague "monoidal structure" gap. The lane is converging on a *diagnosis*, just not
on a *closed sorry*.

## Process correctness

- **COE pause honored** (5th consecutive iter): not dispatched. The iter-208 plan
  additionally re-framed the COE/02JK node strategically — committing Albanese
  Route 2 and excising the Route-1 cone as a mis-decomposition (strategy-auditor
  read Milne + Kleiman directly). This is a strategic routing decision, not prover
  work; USER directive #4 (no A.3/A.4 prover dispatch before A.2.c) honored.
  Surfaced to USER via TO_USER (the previously-escalated COE node is now resolved
  as mis-decomposition; reversible — files relabelled not removed).
- **HARD GATE**: the plan cleared the TS chapter via the sanctioned same-iter
  fast path before dispatch. The prover's finding now invalidates the Route-A
  proof prose → the chapter needs a writer rewrite before the next TS prover round
  (lvb ts-iter208 must-fix; recommendations.md #2).

## Subagent findings landed

- **lean-vs-blueprint-checker ts-iter208**
  (`task_results/lean-vs-blueprint-checker-ts-iter208.md`): Lean is FAITHFUL — all
  8 pinned decls exist with correct signatures; the 3 sorries
  (`tensorObj_restrict_iso` L399, `exists_tensorObj_inverse` L442,
  `addCommGroup_via_tensorObj` L481) are honestly labelled; the long in-code
  analysis comment is accurate workflow documentation, NOT excuse-laundering; no
  axioms. **Must-fix on the BLUEPRINT side**: the proof block Step 3 main prose +
  closing "30–60 line helper" paragraph (and two secondary sections — API survey
  intro ~L155–177, LOC estimates Piece 2 ~L963–990) still assert the disproven
  sectionwise route; a prover reading the chapter is steered into the dead end. My
  `% NOTE:` covered only the proof block. → blueprint-writer rewrite to H1/H2 next
  iter (recommendations.md #2). Minor: `tensorObj_functoriality` is a `def` in Lean
  but called a `lemma` in the chapter (no semantic mismatch); 3 substantive helpers
  (`tensorObjIsoOfIso`, `tensorObj_unit_iso`, `restrictIsoUnitOfLE`) unreferenced
  by `\lean{...}` pins.
- **lean-auditor iter208** (`task_results/lean-auditor-iter208.md`): see
  recommendations.md (findings landed there).

## Blueprint markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, proof of `lem:tensorobj_restrict_iso`: added
  `% NOTE:` recording that Step 3 (the sectionwise-unfolding ~30–60 LOC claim) was
  DISPROVEN by the iter-208 prover, with the corrected H1/H2 decomposition and
  pointers to `informal/tensorObj_restrict_iso.md` + task_results.

No `\leanok` added/removed (sync_leanok owns it; iter=208 confirms tree current —
the statement-block `\leanok` on `lem:tensorobj_restrict_iso` is the script's
legitimate decl-exists-with-sorry verdict, confirmed by lvb).
