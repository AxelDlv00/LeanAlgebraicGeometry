---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.degAffField
docstring: 'The chosen finite separable field refinement of a presented étale cover
  of `Spec K`

  (cofinality, `Algebra.EtaleCover.exists_finiteSeparableField_algHom`).'
file: AlgebraicJacobian/Picard/DegreeZero.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.degAffField
type: lean
updated: '2026-07-30T15:28:01'
---
private def degAffField (E : Algebra.EtaleCover K) : Type u :=
  E.exists_finiteSeparableField_algHom.choose

@[reducible]