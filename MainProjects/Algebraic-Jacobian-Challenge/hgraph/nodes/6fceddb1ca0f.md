---
author: sync
content_type: class
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.Scheme.PicScheme.HasAbelMap
docstring: 'Class **carrying the Abel map** `Div_{C/k} ⟶ Pic^♯_{C/k}`.  It is a

  data-carrying class with field `abel`; the instance `instHasAbelMap` supplies

  the witness `abelMapWitness C`.


  **PROPERTY-FREE DATA SLOT — corrected 2026-07-29 (`review-ajc`, from a

  fresh-context vacuity sweep). The previous text claimed that `abelMap :=

  HasAbelMap.abel` "inherits the concrete construction and the defining property

  `abelMap_app_mk`". Both halves are false under the class binder**, and the

  second is provably so.


  The single field constrains nothing beyond the *type* of `abel`. Machine-checked:

  the constant-zero transformation inhabits the class — its naturality is

  `map_zero` of the pullback group hom, so it is free — and under that instance

  `abelMap C` is identically `0`, sending every divisor class to `0`. Probing

  `abelMap_app_mk`''s conclusion against it, `rfl` **fails**. So `abelMap_app_mk`

  is a statement about `instHasAbelMap` alone, never about the class: a consumer

  quantifying over `[HasAbelMap C]` gets an arbitrary natural transformation with

  no Abel-map content. This is the `ClassDegree` collapse

  (`IdentityComponent.lean:1450-1461`) one level up, and it is the

  property-free-data-field sibling of the `HasDivFunctor` vacuity recorded in this

  file''s §2 caveat.


  Blast radius is small at HEAD and this is a documentation fix, not a repair: the

  only declaration taking `[HasAbelMap C]` is `abelMap` itself, and every real

  consumer routes through `abelMapWitness` directly (`DivDegree.lean:678-703`,

  `IdentityComponent.lean:1539`). **Do not write a new consumer against this

  class.** The cheap repair, for whoever owns this file, is to delete the class and

  use `abelMapWitness`; the alternative is to add the pin as a field, as

  `ClassDegreePinned` did after its own collapse. Recorded as inbox `I-0953`.'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.HasAbelMap
type: lean
updated: '2026-07-29T22:29:08'
---
class HasAbelMap {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] where
  /-- The Abel map itself (data). -/
  abel : divFunctor C ⟶ picSharp C