---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.Diagonal.tmul_one_sub_one_tmul_mem_nonZeroDivisors
docstring: '**The regularity engine (deg-D4b §D2).** For a flat coordinate `Polynomial
  k → B`, an

  *arbitrary* `k`-algebra `A`, and *any* `b : A`, the element `u ⊗ 1 - 1 ⊗ b` is a

  nonzerodivisor of `B ⊗[k] A`, where `u := algebraMap (Polynomial k) B X`.


  Instantiations: deg-D4b''s `regular` field is `A = B`, `b = u`

  (`diagGen_mem_nonZeroDivisors`); deg-D4c''s `hreg` is `A =` a chart of the test
  object,

  `b = t^♯ u`. No integrality of `B ⊗[k] A` is used, so the engine runs at every point
  of a

  non-integral product.'
file: AlgebraicJacobian/Algebra/DiagonalRegular.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.Diagonal.tmul_one_sub_one_tmul_mem_nonZeroDivisors
type: lean
updated: '2026-07-31T20:15:16'
---
theorem tmul_one_sub_one_tmul_mem_nonZeroDivisors
    {A : Type*} [CommRing A] [Algebra k A] (b : A) :
    algebraMap (Polynomial k) B X ⊗ₜ[k] (1 : A) - (1 : B) ⊗ₜ[k] b ∈ (B ⊗[k] A)⁰ := by
  set φ : Polynomial k →ₐ[k] B := IsScalarTower.toAlgHom k (Polynomial k) B with hφdef
  have hφ : φ.Flat := by
    rw [show φ.toRingHom = algebraMap (Polynomial k) B from rfl, RingHom.flat_algebraMap_iff]
    infer_instance
  -- the flat map `A[X] ≃ A ⊗ k[X] → A ⊗ B ≃ B ⊗ A` sending `X - C b ↦ u ⊗ 1 - 1 ⊗ b`
  let Θ : Polynomial A →ₐ[k] (B ⊗[k] A) :=
    (Algebra.TensorProduct.comm k A B).toAlgHom.comp
      ((Algebra.TensorProduct.map (AlgHom.id k A) φ).comp (polyEquivTensor k A).toAlgHom)
  have hΘ : Θ.toRingHom.Flat :=
    RingHom.Flat.comp
      (RingHom.Flat.comp
        (RingHom.Flat.of_bijective (polyEquivTensor k A).bijective)
        (RingHom.Flat.tensorProductMap (RingHom.Flat.id A) hφ))
      (RingHom.Flat.of_bijective (Algebra.TensorProduct.comm k A B).bijective)
  have himg : Θ (X - C b)
      = algebraMap (Polynomial k) B X ⊗ₜ[k] (1 : A) - (1 : B) ⊗ₜ[k] b := by
    simp only [Θ, map_sub, AlgHom.comp_apply, AlgEquiv.coe_algHom]
    rw [show polyEquivTensor k A X = (1 : A) ⊗ₜ[k] X by simp [polyEquivTensor_apply],
        show polyEquivTensor k A (C b) = b ⊗ₜ[k] (1 : Polynomial k) by simp [polyEquivTensor_apply]]
    simp [Algebra.TensorProduct.map_tmul, hφdef]
  have hnzd := RingHom.Flat.mem_nonZeroDivisors hΘ
    (Polynomial.Monic.mem_nonZeroDivisors (monic_X_sub_C b))
  rwa [show Θ.toRingHom (X - C b) = Θ (X - C b) from rfl, himg] at hnzd