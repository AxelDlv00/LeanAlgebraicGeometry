---
author: sync
content_type: theorem
created: '2026-07-20T18:02:05'
decl: AlgebraicGeometry.IdealPurity.productReadMap_mem_span_range
file: AlgebraicJacobian/Picard/DivSchemeMulIdealBridge.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.IdealPurity.productReadMap_mem_span_range
type: lean
updated: '2026-07-31T20:14:42'
---
private theorem productReadMap_mem_span_range
    (m : S →ₗ[R] B) (r : K →ₗ[R] B) (x : S ⊗[R] K) :
    productReadMap (R := R) m r x ∈ Ideal.span (Set.range r) := by
  induction x using TensorProduct.induction_on with
  | zero => exact Ideal.zero_mem _
  | add x y hx hy =>
      simpa only [map_add] using Ideal.add_mem _ hx hy
  | tmul s k =>
      rw [productReadMap_tmul]
      exact Ideal.mul_mem_left _ _ (Ideal.subset_span ⟨k, rfl⟩)

/-! ## Equality of the first- and second-window reading ideals -/