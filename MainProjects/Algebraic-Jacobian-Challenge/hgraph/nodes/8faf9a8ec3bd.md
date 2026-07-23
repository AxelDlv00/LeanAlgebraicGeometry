---
author: sync
content_type: instance
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pullbackObjUnitToUnit_isIso_of_isIso
docstring: 'An isomorphism of schemes has a `Final` opens-pullback functor, so the
  unit comparison

  `pullbackObjUnitToUnit` of its module pullback is an isomorphism (generalization
  of

  `pullbackObjUnitToUnit_isIso_basicOpen` from `(basicOpenIsoSpecAway g).inv` to an
  arbitrary

  isomorphism).'
file: AlgebraicJacobian/Cohomology/CechTermAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pullbackObjUnitToUnit_isIso_of_isIso
type: lean
updated: '2026-07-24T03:02:09'
---
instance pullbackObjUnitToUnit_isIso_of_isIso {T T' : Scheme.{u}} (φ : T ⟶ T') [IsIso φ] :
    IsIso (SheafOfModules.pullbackObjUnitToUnit φ.toRingCatSheafHom) := by
  haveI : IsIso φ.base := inferInstance
  haveI : (TopologicalSpace.Opens.map φ.base).Final := by
    haveI : (TopologicalSpace.Opens.map φ.base).IsEquivalence :=
      (TopologicalSpace.Opens.mapMapIso (asIso φ.base)).isEquivalence_functor
    infer_instance
  infer_instance