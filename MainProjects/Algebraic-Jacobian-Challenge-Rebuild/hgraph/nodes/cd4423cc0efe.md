---
author: sync
content_type: lemma
created: '2026-07-31T20:15:16'
decl: AlgebraicGeometry.lbc_single
docstring: '`laurentBaseChange` on a monomial tensor `single n c ⊗ₜ 1`.'
file: AlgebraicJacobian/Algebra/LaurentBaseChange.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.lbc_single
type: lean
updated: '2026-08-01T09:44:08'
---
private lemma lbc_single (n : ℤ) (c : k) :
    laurentBaseChange k A (AddMonoidAlgebra.single n c ⊗ₜ 1)
      = AddMonoidAlgebra.single n (algebraMap k A c) := by
  simp only [laurentBaseChange, AlgEquiv.trans_apply, Algebra.TensorProduct.comm_tmul,
    AlgEquiv.restrictScalars_apply, AddMonoidAlgebra.tensorEquiv_tmul,
    map_one, one_mul, AddMonoidAlgebra.mapAlgHom_single, mapAlgEquiv_single,
    Algebra.TensorProduct.includeRight_apply, Algebra.TensorProduct.rid_tmul,
    Algebra.smul_def, mul_one]