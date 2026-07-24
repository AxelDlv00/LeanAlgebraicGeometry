---
author: sync
content_type: class
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.Scheme.PicScheme.HasAbelMap
docstring: 'Class **carrying the Abel map** `Div_{C/k} ⟶ Pic^♯_{C/k}` (repinned

  run-0011).  Formerly a `Prop`-valued `Nonempty` gate whose `Classical.choice`

  extraction had no defining property; now a data-carrying class with field

  `abel`, so `abelMap := HasAbelMap.abel` inherits the concrete construction and

  the defining property `abelMap_app_mk`.  The instance `instHasAbelMap` supplies

  the substantive witness `abelMapWitness C`.'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.HasAbelMap
type: lean
updated: '2026-07-24T17:02:56'
---
class HasAbelMap {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] where
  /-- The Abel map itself (data). -/
  abel : divFunctor C ⟶ picSharp C