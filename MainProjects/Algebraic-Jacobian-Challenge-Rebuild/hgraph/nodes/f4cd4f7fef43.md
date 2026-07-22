---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Scheme.Hom.functionFieldMap_injective
docstring: 'The function-field map of a morphism of integral schemes is injective
  (a ring

  homomorphism of fields).'
file: AlgebraicJacobian/Curve/BaseFieldTransition.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.functionFieldMap_injective
type: lean
updated: '2026-07-16T21:33:27'
---
theorem Scheme.Hom.functionFieldMap_injective [IsIntegral X] [IsIntegral Y] (f : X ⟶ Y)
    (h : f.base (genericPoint X) = genericPoint Y) :
    Function.Injective (f.functionFieldMap h).hom :=
  RingHom.injective _