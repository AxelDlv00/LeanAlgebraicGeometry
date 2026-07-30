---
author: sync
content_type: theorem
created: '2026-07-22T08:31:54'
decl: AlgebraicGeometry.range_piRightHom_comp_baseChange_finiteKoszulBoundary
docstring: 'After transporting the target finite product, the range of the

  base-changed boundary is exactly the range of the fibrewise boundary.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowKoszul.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.range_piRightHom_comp_baseChange_finiteKoszulBoundary
type: lean
updated: '2026-07-30T15:28:05'
---
theorem range_piRightHom_comp_baseChange_finiteKoszulBoundary
    (step : ι → L →ₗ[R] M) :
    LinearMap.range
        ((TensorProduct.piRightHom R S S (fun _ : ι => M)).comp
          (LinearMap.baseChange S (finiteKoszulBoundary step))) =
      LinearMap.range
        (finiteKoszulBoundary (fun i => LinearMap.baseChange S (step i))) := by
  classical
  rw [piRightHom_comp_baseChange_finiteKoszulBoundary]
  apply le_antisymm
  · rintro _ ⟨z, rfl⟩
    exact LinearMap.mem_range_self _ _
  · rintro _ ⟨z, rfl⟩
    let e := TensorProduct.piRight R S S (fun _ : ι × ι => L)
    refine ⟨e.symm z, ?_⟩
    simp only [LinearMap.comp_apply]
    have he : TensorProduct.piRightHom R S S (fun _ : ι × ι => L) (e.symm z) = z := by
      change e (e.symm z) = z
      exact e.apply_symm_apply z
    rw [he]

end BaseChange

/-! ## A finite-dimensional equality criterion -/

section Finrank

variable {k₀ A V W : Type u} [Field k₀]
variable [AddCommGroup A] [Module k₀ A]
variable [AddCommGroup V] [Module k₀ V] [FiniteDimensional k₀ V]
variable [AddCommGroup W] [Module k₀ W]