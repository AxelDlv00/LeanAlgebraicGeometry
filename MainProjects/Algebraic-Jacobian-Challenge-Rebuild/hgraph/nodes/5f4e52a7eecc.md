---
author: sync
content_type: lemma
created: '2026-07-24T17:02:48'
decl: AlgebraicGeometry.descentMul₁₂_comp_descentFace₁₂
file: AlgebraicJacobian/Picard/SpecDegeneracy.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.descentMul₁₂_comp_descentFace₁₂
type: lean
updated: '2026-08-01T09:44:17'
---
private lemma descentMul₁₂_comp_descentFace₁₂ :
    (descentMul₁₂ (A := A) (B := B)).comp (Module.descentFace₁₂ A B)
      = (Module.descentIncl₁ A B).comp (Algebra.TensorProduct.lmul' A) :=
  Algebra.TensorProduct.ext' fun x y => by
    simp [Algebra.TensorProduct.lmul'_apply_tmul, Algebra.TensorProduct.tmul_mul_tmul]