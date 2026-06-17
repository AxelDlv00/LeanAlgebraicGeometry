# Blueprint-reviewer directive — iter-061

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). Produce your standard per-chapter completeness + correctness checklist and HARD GATE verdict.

## Gate focus this iter
Two files are about to enter prover objectives. Confirm their chapters are complete + correct with no must-fix:

1. **`Picard/SectionGradedRing.lean`** → `Picard_SectionGradedRing.tex`. Prover will BUILD + PROVE the new decl `relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`). Verify the 3-step promotion sketch (objectwise coequalizer → `evaluationJointlyReflectsColimits` promotion → apex identification via `presheaf_tensorObj_obj`) is detailed enough to formalize, and that its `\uses` deps (`lem:relativeTensor_objectwise_coequalizer`, `def:relTensorActL/ActR/Proj`, the two `_mathlib` anchors) are all present + done.

2. **`Picard/GrassmannianQuot.lean`** → `Picard_GrassmannianQuot.tex`. Prover will BUILD + PROVE the C2 chain: `lem:gr_bundleCocycle_matrix` (L1), `lem:gr_matrixToFreeIso_mul` (L2), `lem:gr_bundleCocycle_transport` (L3, the substantial transport step), then close `lem:gr_bundleCocycle_mul` (C2). Verify each block's statement + proof sketch is adequate to formalize. Note: the plan agent this iter ADDED five coverage-debt blueprint blocks to this chapter — `lem:gr_pullbackFreeIso_eqToHom`, `lem:gr_pullbackFreeIso_trans_symm_eqToIso`, `lem:gr_scalarEnd_sum`, `lem:gr_universalMinorInv_self`, `def:gr_bundleTransitionData`. Check these are pure (no Lean tactic leakage), correctly `\uses`-linked, and faithful to their `\lean{}` targets.

Prior per-file lvb-checker (iter-060) flagged `lem:gr_bundleCocycle_transport`'s sketch as "under-specified for the Lean term-mode (~50-100 LOC reassociation)". Judge whether the MATHEMATICAL content of that block is complete (the Lean reassociation bookkeeping is the prover's domain, not blueprint content) or whether it genuinely omits a mathematical step.

## Also report
- Any chapter flagged `partial`/`false` that still feeds a live lane.
- Coverage-debt / unmatched-node observations beyond the five blocks I added.
- Unstarted-phase blueprint proposals (if any).
