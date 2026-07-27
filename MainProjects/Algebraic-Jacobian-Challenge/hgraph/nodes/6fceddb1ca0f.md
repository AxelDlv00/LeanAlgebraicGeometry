---
author: sync
content_type: class
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.Scheme.PicScheme.HasAbelMap
docstring: 'Class **carrying the Abel map** `Div_{C/k} ⟶ Pic^♯_{C/k}`.  It is a

  data-carrying class with field `abel`, so `abelMap := HasAbelMap.abel`

  inherits the concrete construction and the defining property

  `abelMap_app_mk`.  The instance `instHasAbelMap` supplies the witness

  `abelMapWitness C`.'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.HasAbelMap
type: lean
updated: '2026-07-27T12:33:55'
---
class HasAbelMap {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] where
  /-- The Abel map itself (data). -/
  abel : divFunctor C ⟶ picSharp C