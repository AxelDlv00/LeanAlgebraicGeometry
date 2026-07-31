---
author: sync
content_type: theorem
created: '2026-07-21T12:32:00'
decl: AlgebraicGeometry.exists_basis_baseChange_mul_eq_one
docstring: 'If an `R`-linear map out of `R ⊗[k] M` takes some element to `1`, then
  the

  images of the scalar extensions of a finite `k`-basis of `M` generate `1` in `B`.'
file: AlgebraicJacobian/Picard/DivisorFamilyWindowUnitGeneration.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_basis_baseChange_mul_eq_one
type: lean
updated: '2026-07-31T20:15:25'
---
theorem exists_basis_baseChange_mul_eq_one (basis : Module.Basis ι k M)
    (f : R ⊗[k] M →ₗ[R] B) (x : R ⊗[k] M) (hx : f x = 1) :
    ∃ c : ι → B, ∑ t, c t * f (1 ⊗ₜ basis t) = 1 := by
  classical
  let basisR := basis.baseChange R
  refine ⟨fun t => (basisR.repr x t) • 1, ?_⟩
  calc
    ∑ t, ((basisR.repr x t) • 1) * f (1 ⊗ₜ basis t) =
        ∑ t, (basisR.repr x t) • f (basisR t) := by
      apply Finset.sum_congr rfl
      intro t _
      simp only [basisR, Module.Basis.baseChange_apply, Algebra.smul_def, mul_one]
    _ = f (∑ t, (basisR.repr x t) • basisR t) := by
      rw [map_sum]
      simp only [map_smul]
    _ = f x := by rw [basisR.sum_repr]
    _ = 1 := hx

end Basis

section ThetaWindow

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (R : Type u) [CommRing R] [Algebra k R]
variable (π : C.left ⟶ P1 k) [IsFinite π]

noncomputable local instance instOverCleftWindowUnit : C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
  [IsDominant π]
variable (a : ℕ)