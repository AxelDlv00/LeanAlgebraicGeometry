---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.annihilator_le_annihilator_tensorProduct
docstring: '**Annihilator monotonicity under tensoring (left factor)**: any scalar
  that

  annihilates `M` annihilates `M ⊗[R] N`.  A scalar `a ∈ Ann_R M` kills every

  elementary tensor via `a • (m ⊗ n) = (a • m) ⊗ n = 0`, hence the whole tensor

  product by `TensorProduct.induction_on`.


  This is the sections-level input to the schematic-support monotonicity

  `schematicSupport (F ⊗ G) ⊆ schematicSupport F` behind the twisted-fibre proper

  support reduction of `lem:gamma_fiber_baseChange_field`.'
file: AlgebraicJacobian/Picard/SchematicSupport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.annihilator_le_annihilator_tensorProduct
type: lean
updated: '2026-07-16T21:14:27'
---
theorem annihilator_le_annihilator_tensorProduct
    {R : Type*} [CommRing R] {M N : Type*}
    [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N] :
    Module.annihilator R M ≤ Module.annihilator R (M ⊗[R] N) := by
  intro a ha
  rw [Module.mem_annihilator] at ha ⊢
  intro x
  induction x using TensorProduct.induction_on with
  | zero => rw [smul_zero]
  | tmul m n => rw [TensorProduct.smul_tmul', ha m, TensorProduct.zero_tmul]
  | add x y hx hy => rw [smul_add, hx, hy, add_zero]