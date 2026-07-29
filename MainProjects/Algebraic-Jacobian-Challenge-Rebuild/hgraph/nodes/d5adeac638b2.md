---
author: sync
content_type: theorem
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffAdaptation.delta_baseChange_comm'
docstring: The `δ`-naturality square with the verticals inverted.
file: AlgebraicJacobian/Picard/DivisorFamilyAffCert.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.delta_baseChange_comm'
type: lean
updated: '2026-07-29T15:26:34'
---
theorem delta_baseChange_comm' :
    (AlgebraTensorModule.lTensor R' R' (A.deltaLeft - A.deltaRight)) ∘ₗ
        ((A.chartProdBaseChange R' hproj).symm :
          (A.pullback R' hproj).chartProd →ₗ[R'] R' ⊗[R] A.chartProd) =
      ((A.ovlProdBaseChange R' hproj hinf).symm :
          (A.pullback R' hproj).ovlProd →ₗ[R'] R' ⊗[R] A.ovlProd) ∘ₗ
        ((A.pullback R' hproj).deltaLeft - (A.pullback R' hproj).deltaRight) := by
  apply LinearMap.ext
  intro x
  have h := congr($(A.delta_baseChange_comm R' hproj hinf)
    ((A.chartProdBaseChange R' hproj).symm x))
  simp only [LinearMap.comp_apply, LinearEquiv.coe_coe,
    LinearEquiv.apply_symm_apply] at h ⊢
  rw [h, LinearEquiv.symm_apply_apply]

/-! ## The glued transport (clause (c2)) and the flat-cokernel clauses (c3)/(c4)

Everything below rides the abstract keystones of `Picard/FlatCokernel.lean` and the
square-transport lemmas of `DivisorFamilyPullbackGlued.lean`, all stated for bare modules.
The widening is invisible to them. -/

include hinf in