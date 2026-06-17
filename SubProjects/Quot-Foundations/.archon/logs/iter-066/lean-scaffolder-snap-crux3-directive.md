# Directive — lean-scaffolder, slug `snap-crux3` (iter-066; identical re-dispatch — the iter-065 run was killed by a session wall-clock before landing any decl)

Target: `AlgebraicJacobian/Picard/SectionGradedRing.lean`
Action: create TWO new sorry-bearing declarations realizing the forward-pinned blueprint blocks in `blueprint/src/chapters/Picard_SectionGradedRing.tex`:

1. `AlgebraicGeometry.Scheme.Modules.ztensor_whisker_localIso` — blueprint `lem:snap_ztensor_whisker_localIso` (chapter line ~716): a stalkwise-iso morphism of abelian-group presheaves, whiskered by `− ⊗_ℤ C` (the `relTensorDomainPresheaf` construction already in-file), is again a stalkwise iso, hence in `J.W` for the opens topology.
2. `AlgebraicGeometry.Scheme.Modules.isIso_sheafification_whiskerRight_unit` — blueprint `lem:isIso_sheafification_whiskerRight_unit` (chapter line ~961): sheafification of the right-whiskered sheafification unit `(η_P ▷ Q)^#` is an isomorphism. Read the chapter's 4-step proof block and inject it as a `/- Planner strategy: ... -/` comment above the sorry.

Context to inject into the strategy comments (verified by planner):
- `CategoryTheory.Limits.evaluationJointlyReflectsColimits` EXISTS at `Mathlib/CategoryTheory/Limits/FunctorCategory/Basic.lean:103` (a prior session's leansearch fuzzy-missed it); fallback `combinedIsColimit` same file L145.
- The coequalizer presentation `relativeTensorCoequalizerIso` + the `RelativeTensorCoequalizer` 22-decl API are DONE axiom-clean in-file — the crux proof presents `P ⊗_p Q` via it, uses that sheafification (a left adjoint / localization at `J.W`) preserves the coequalizer, and reduces to the whiskered stalkwise statement (decl 1).
- Abelian-group category in this file is `AddCommGrpCat`, NOT `AddCommGrp`. A fresh `have` mentioning `P ⊗ Q` must spell `MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q`.

Constraints:
- IMPORTANT: each new decl body (and any subsidiary condition) is `sorry` — do NOT attempt proofs.
- Do NOT modify any existing declaration.
- `lake build AlgebraicJacobian.Picard.SectionGradedRing` MUST be green before you finish; the new decls MUST register as real sorries (this is the dispatch-filter fix — the lane is dropped if the file is 0-sorry).
- Statement fidelity to the blueprint blocks is the priority; if the precise stalkwise/`J.W` phrasing of decl 1 needs an auxiliary def to state, create it (sorry-free if purely definitional).
