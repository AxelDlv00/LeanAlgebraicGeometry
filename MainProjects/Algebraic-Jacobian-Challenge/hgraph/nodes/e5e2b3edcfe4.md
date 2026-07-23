---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.FGDescent.MVCoboundaryRel.symm
docstring: Symmetry of the coboundary relation (invert the two chart units).
file: AlgebraicJacobian/Picard/FinitePresentationFunctor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.FGDescent.MVCoboundaryRel.symm
type: lean
updated: '2026-07-24T03:02:10'
---
theorem MVCoboundaryRel.symm {B : Type v} [CommRing B] [Algebra k B]
    {u v : R₀₁ ⊗[k] B} (h : MVCoboundaryRel ρ₀ ρ₁ B u v) :
    MVCoboundaryRel ρ₀ ρ₁ B v u := by
  obtain ⟨a, b, ha, hb, heq⟩ := h
  refine ⟨((ha.unit⁻¹ : (R₀ ⊗[k] B)ˣ) : R₀ ⊗[k] B),
    ((hb.unit⁻¹ : (R₁ ⊗[k] B)ˣ) : R₁ ⊗[k] B),
    Units.isUnit _, Units.isUnit _, ?_⟩
  have h₀ : rTensorAlgHom ρ₀ B ((ha.unit⁻¹ : (R₀ ⊗[k] B)ˣ) : R₀ ⊗[k] B)
      * rTensorAlgHom ρ₀ B a = 1 := by
    rw [← map_mul, IsUnit.val_inv_mul, map_one]
  have h₁ : rTensorAlgHom ρ₁ B b
      * rTensorAlgHom ρ₁ B ((hb.unit⁻¹ : (R₁ ⊗[k] B)ˣ) : R₁ ⊗[k] B) = 1 := by
    rw [← map_mul, IsUnit.mul_val_inv, map_one]
  linear_combination
    (-(v * rTensorAlgHom ρ₁ B ((hb.unit⁻¹ : (R₁ ⊗[k] B)ˣ) : R₁ ⊗[k] B))) * h₀
    + (rTensorAlgHom ρ₀ B ((ha.unit⁻¹ : (R₀ ⊗[k] B)ˣ) : R₀ ⊗[k] B) * u) * h₁
    + (-(rTensorAlgHom ρ₀ B ((ha.unit⁻¹ : (R₀ ⊗[k] B)ˣ) : R₀ ⊗[k] B)
        * rTensorAlgHom ρ₁ B ((hb.unit⁻¹ : (R₁ ⊗[k] B)ˣ) : R₁ ⊗[k] B))) * heq