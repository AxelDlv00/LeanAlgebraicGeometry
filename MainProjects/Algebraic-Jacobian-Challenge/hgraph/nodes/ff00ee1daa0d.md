---
author: sync
content_type: definition
created: '2026-07-28T15:48:27'
decl: AlgebraicGeometry.Scheme.PicSharp.relPicQuotAddEquivAbs
docstring: '**The collapse, additively**: the relative Picard group at a one-point
  test object *is*

  the absolute Picard group as an additive group.


  Additivity is `rfl` on representatives because both group structures are the descent
  of the

  same tensor product (`addCommGroup_via_tensorObj` on the coset quotient,

  `addCommGroup` on the iso-class quotient), and the equivalence is the identity on

  representatives.


  Additivity is the point: a bare `Equiv` would not transport `finrank`, which is
  what the

  tangent-space dimension count needs (inbox I-0495, 2026-07-28).'
file: AlgebraicJacobian/Picard/OnePointRelPicCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicSharp.relPicQuotAddEquivAbs
type: lean
updated: '2026-07-28T15:48:27'
---
noncomputable def relPicQuotAddEquivAbs {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S)
    [Subsingleton T] [Nonempty T] :
    Quotient (relPicSetoid πC πT) ≃+ Quotient (RelPicPresheaf.preimage_subgroup πC πT) where
  __ := relPicQuotEquivAbs πC πT
  map_add' a b := by
    induction a using Quotient.ind with | _ L => ?_
    induction b using Quotient.ind with | _ L' => ?_
    rfl

@[simp]