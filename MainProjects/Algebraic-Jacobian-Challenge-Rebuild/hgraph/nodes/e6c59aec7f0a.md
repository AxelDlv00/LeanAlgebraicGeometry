---
author: sync
content_type: theorem
created: '2026-07-21T12:01:58'
decl: AlgebraicGeometry.IdealPurity.finite_mul_read_mem_span
file: AlgebraicJacobian/Picard/DivSchemeMulIdealFinite.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.IdealPurity.finite_mul_read_mem_span
type: lean
updated: '2026-07-31T20:14:51'
---
private theorem finite_mul_read_mem_span
    (m : ι → B) (r : K →ₗ[R] B) (x : ι → K) :
    (∑ t, m t * r (x t)) ∈ Ideal.span (Set.range r) := by
  classical
  exact Ideal.sum_mem _ fun t _ =>
    Ideal.mul_mem_left _ _ (Ideal.subset_span ⟨x t, rfl⟩)