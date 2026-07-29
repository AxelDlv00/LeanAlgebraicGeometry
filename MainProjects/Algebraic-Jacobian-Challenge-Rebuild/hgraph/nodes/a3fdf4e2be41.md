---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.Diagonal.ker_pointEvTwo
docstring: '**Mirror of deliverable (b).** Given the diagonal-package kernel presentation,
  the

  kernel of the `Polynomial k`-level point evaluation is the principal ideal on the
  push of

  the diagonal generator — the section trick `mk ∘ includeRight ∘ ev₂ = mk`.'
file: AlgebraicJacobian/Algebra/PointFiberIdeal.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicJacobian.Diagonal.ker_pointEvTwo
type: lean
updated: '2026-07-29T15:26:30'
---
theorem ker_pointEvTwo :
    RingHom.ker (pointEvTwo c) = Ideal.span {mapRightTwo c e} := by
  have he : Algebra.TensorProduct.lmul' (R := Polynomial k) (S := B) e = 0 := by
    have : e ∈ RingHom.ker (Algebra.TensorProduct.lmul' (R := Polynomial k) (S := B)) := by
      rw [hgen]; exact Ideal.subset_span rfl
    rwa [RingHom.mem_ker] at this
  apply le_antisymm
  · -- the section trick
    intro w hw
    rw [RingHom.mem_ker] at hw
    have key : ∀ z : B ⊗[Polynomial k] F,
        Ideal.Quotient.mk (Ideal.span {mapRightTwo c e}) z
          = Ideal.Quotient.mk (Ideal.span {mapRightTwo c e})
              ((1 : B) ⊗ₜ[Polynomial k] (pointEvTwo c z)) := by
      intro z
      induction z with
      | zero => simp
      | tmul x y =>
          rw [pointEvTwo_tmul, Ideal.Quotient.eq]
          have hfac : x ⊗ₜ[Polynomial k] y - (1 : B) ⊗ₜ[Polynomial k] (c x * y)
              = (x ⊗ₜ[Polynomial k] (1 : F) - (1 : B) ⊗ₜ[Polynomial k] c x)
                * ((1 : B) ⊗ₜ[Polynomial k] y) := by
            rw [sub_mul, Algebra.TensorProduct.tmul_mul_tmul,
              Algebra.TensorProduct.tmul_mul_tmul, one_mul, mul_one, one_mul]
          rw [hfac]
          exact Ideal.mul_mem_right _ _ (tmul_sub_tmul_mem_span_mapRightTwo c hgen x)
      | add a b ha hb =>
          rw [map_add, map_add, ha, hb, TensorProduct.tmul_add, map_add]
    have hz := key w
    rw [hw, TensorProduct.tmul_zero, map_zero] at hz
    exact (Ideal.Quotient.eq_zero_iff_mem).mp hz
  · rw [Ideal.span_le, Set.singleton_subset_iff, SetLike.mem_coe, RingHom.mem_ker,
      pointEvTwo_mapRightTwo, he, map_zero]

end EvTwoKernel

/-! ### The localised point-fiber ideal (mirror of (c)) -/