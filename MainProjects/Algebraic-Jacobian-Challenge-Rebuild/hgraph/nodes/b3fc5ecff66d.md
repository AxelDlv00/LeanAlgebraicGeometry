---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.Diagonal.pointSectionMap_tmul
file: AlgebraicJacobian/Algebra/PointFiberIdeal.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicJacobian.Diagonal.pointSectionMap_tmul
type: lean
updated: '2026-07-30T15:28:02'
---
lemma pointSectionMap_tmul (x : B) (y : F) :
    pointSectionMap B F (x ⊗ₜ[Polynomial k] y)
      = Ideal.Quotient.mk (Ideal.span {pointGen k B F}) (x ⊗ₜ[k] y) := by
  rw [pointSectionMap, Algebra.TensorProduct.lift_tmul]
  change (Ideal.Quotient.mk _ (x ⊗ₜ[k] 1)) * (Ideal.Quotient.mk _ (1 ⊗ₜ[k] y)) = _
  rw [← map_mul, Algebra.TensorProduct.tmul_mul_tmul, mul_one, one_mul]