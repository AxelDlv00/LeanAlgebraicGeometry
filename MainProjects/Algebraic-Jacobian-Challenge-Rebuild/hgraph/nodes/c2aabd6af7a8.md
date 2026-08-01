---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: rTensor_mulLeft_eq_mulLeft_tmul
docstring: 'The right-tensor of multiplication-by-`s` is multiplication by `s ⊗ 1`
  on the

  tensor-product algebra.'
file: AlgebraicJacobian/Picard/FibrewiseRegular.lean
generated: lean
lean_status: lean_ok
title: rTensor_mulLeft_eq_mulLeft_tmul
type: lean
updated: '2026-08-01T09:44:15'
---
theorem rTensor_mulLeft_eq_mulLeft_tmul (S : Type u) [CommRing S] [Algebra R S]
    (s : A) :
    (LinearMap.mulLeft R s).rTensor S =
      LinearMap.mulLeft R (s ⊗ₜ[R] (1 : S) : A ⊗[R] S) := by
  refine TensorProduct.ext' (fun a c => ?_)
  rw [LinearMap.rTensor_tmul, LinearMap.mulLeft_apply, LinearMap.mulLeft_apply,
    Algebra.TensorProduct.tmul_mul_tmul, one_mul]