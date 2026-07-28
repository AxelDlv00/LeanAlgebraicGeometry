---
author: sync
content_type: theorem
created: '2026-07-28T15:48:27'
decl: AlgebraicGeometry.locallyOfFiniteType_tensorObj_self
docstring: '**The self-product is locally of finite type over `k̄`.** Same rewrite;
  smooth

  morphisms are locally of finite type and the property composes.'
file: AlgebraicJacobian/Albanese/AVSelfProduct.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.locallyOfFiniteType_tensorObj_self
type: lean
updated: '2026-07-28T15:48:27'
---
theorem locallyOfFiniteType_tensorObj_self (A : Over (Spec (.of kbar)))
    [Smooth A.hom] : LocallyOfFiniteType (A ⊗ A).hom := by
  rw [Over.tensorObj_hom]
  exact inferInstanceAs (LocallyOfFiniteType (pullback.fst A.hom A.hom ≫ A.hom))

omit [IsAlgClosed kbar] in