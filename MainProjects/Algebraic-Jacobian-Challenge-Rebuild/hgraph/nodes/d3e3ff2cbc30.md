---
author: sync
content_type: definition
created: '2026-07-17T23:01:28'
decl: AlgebraicGeometry.DivFamZar.mapAlgHom
docstring: 'Base change of locally certified divisor classes along an explicit `k`-algebra
  map

  of affine tests: `DivFamZar.mapAlg` at the algebra structure `RingHom.toAlgebra`
  of the

  map.  The instance-parameterized `DivFamZar.mapAlg` remains the preferred form whenever

  a scalar tower is already in scope.'
file: AlgebraicJacobian/Picard/DivisorFamilyZarVehicle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivFamZar.mapAlgHom
type: lean
updated: '2026-07-30T15:46:04'
---
def mapAlgHom (φ : A →ₐ[k] A') : DivFamZar C A π n → DivFamZar C A' π n :=
  letI : Algebra A A' := φ.toRingHom.toAlgebra
  haveI : IsScalarTower k A A' := .of_algebraMap_eq fun a => (φ.commutes a).symm
  DivFamZar.mapAlg A' n