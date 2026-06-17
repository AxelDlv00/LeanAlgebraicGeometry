# Blueprint-reviewer directive — iter-208 (slug tsgate208) — scoped HARD-GATE fast-path

This is a same-iter fast-path re-review to clear the per-file HARD GATE for ONE
chapter after a route rewrite + purity clean this iter. Read the whole blueprint
as you normally do, but your actionable verdict is needed specifically for:

## Chapter under gate: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

It backs the sole active prover lane this iter (`Picard/TensorObjSubstrate.lean`,
A.1.c.SubT). Last iter's lean-vs-blueprint-checker (ts-iter207) raised a
**must-fix F1**: the proof of `lem:tensorobj_restrict_iso` was the abstract-adjoint
mate-δ route and was NOT formalizable as written (it reduced to the absent
`(PresheafOfModules.pullback φ).Monoidal`). This iter that proof was **rewritten**
to "Route A" — open-immersion sectionwise base change: along an open immersion,
restriction is sectionwise (`restrict_obj`/`restrict_map` are `rfl`) and the
structure-sheaf comparison is the ring isomorphism `f.appIso`, so the comparison
is base change along a ring iso, an isomorphism commuting with ⊗ by
`ModuleCat.restrictScalarsEquivalenceOfRingEquiv`; the iso holds for ARBITRARY
`M, N` (no flatness, no line-bundle hypothesis). The sole project-side ingredient
is a bounded sectionwise unfolding of `PresheafOfModules.pullback φ` along the
open immersion. `lem:restrictscalars_laxmonoidal` was demoted to an off-path
supplement (retained, axiom-clean, explicitly NOT an ingredient of
`lem:tensorobj_restrict_iso`). A blueprint-clean pass (tsrouteA208) then removed
all residual dead-route prose.

## What I need

Render the per-chapter verdict for `Picard_TensorObjSubstrate.tex`:
`complete: true|false`, `correct: true|false`, and any must-fix-this-iter finding.

Specifically confirm:
1. The F1 must-fix is RESOLVED — the `lem:tensorobj_restrict_iso` proof is now a
   formalizable route (Route A), with the one residual ingredient (the bounded
   pullback sectionwise unfolding) clearly identified and not hand-waved.
2. No residual internal contradiction: no surviving prose claims the iso is
   proved via the oplax-δ / `leftAdjointOplaxMonoidal` / `(restrictScalars
   φ).LaxMonoidal` / flatness route.
3. The statement is correctly generalized to arbitrary modules (the Lean
   signature already has no `IsLocallyTrivial` hypothesis), and the downstream
   `\uses` edges are coherent.

If the chapter is `complete: true` AND `correct: true` with no must-fix, the
HARD GATE clears and the prover dispatches this iter. If not, name the precise
residual so I can patch it.

Write your report to `task_results/blueprint-reviewer-tsgate208.md`.
