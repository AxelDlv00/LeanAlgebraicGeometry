# Iter 061 — Objectives (detail)

## Lane 1 — GR-quot C2 chain (`Picard/GrassmannianQuot.lean`) [prove]
BUILD+PROVE sequential: L1 `bundleTransition_cocycle_matrix` → L2 `matrixToFreeIso_mul` →
L3 `bundleTransition_cocycle_transport` → close C2 `bundleTransition_cocycle` (L664).
- L1 = pure matrix Cramer cocycle; recipe in blueprint `lem:gr_bundleCocycle_matrix` (image matrix +
  `mul_submatrix_col` + `(AB)⁻¹=B⁻¹A⁻¹` + `cocycle_imageMatrix_eq`).
- L2 = one-liner (`matrixToFreeIso_hom`+`matrixEnd_comp`).
- L3 = hard ~50-100 LOC term-mode transport; `pullbackBaseChangeTransport`+`glueData_bridge_*` DONE,
  `pullbackComp` OPAQUE, defeq TERMS (no positional rw under Modules diamond).
- C2 = assemble into `_hC2` form for `Scheme.Modules.glue`.
- If L3 stalls: keep L1+L2 + best L3 partial; L3 isolates iter-062.
- Hygiene: mark trivial unmatched helpers `private`.

## Lane 2 — SNAP `relativeTensorCoequalizerIso` (`Picard/SectionGradedRing.lean`) [prove]
BUILD+PROVE the new decl (`lem:relativeTensor_as_coequalizer`): coequalizer of `relTensorActL`,
`relTensorActR` (cofork `relTensorProj`) = underlying `Ab`-presheaf of `P ⊗_p Q`. 3 steps: objectwise
`isColimitCofork` → `evaluationJointlyReflectsColimits` promotion → apex via `tensorObj_obj`.
- Recipe: `TensorProduct.ext'`→`Ab`-transport idiom (iter-060). `(P⊗Q)` = `MonoidalCategory.tensorObj
  (C := MonoidalPresheaf X) P Q`.
- If incomplete: leave objectwise+promotion partials.

## Gate status
Both PASS (blueprint-reviewer iter061 full). Both routes CONVERGING (progress-critic iter061).
