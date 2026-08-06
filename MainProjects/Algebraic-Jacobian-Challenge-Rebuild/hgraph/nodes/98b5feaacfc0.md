---
author: sync
content_type: theorem
created: '2026-08-06T12:29:31'
decl: AlgebraicGeometry.rankOneAbelRepresented_mem
docstring: 'Immediate consumer theorem: the restricted represented Abel map lands
  in the public locus.

  The stronger canonical inverse still needs the family-level divisor/evaluation producer;
  this

  theorem records the exact target API that consumer lanes can use today.'
file: AlgebraicJacobian/Picard/Pic0RankOneLocus.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rankOneAbelRepresented_mem
type: lean
updated: '2026-08-07T05:01:57'
---
theorem rankOneAbelRepresented_mem {T : (Over (Spec (.of k)))ᵒᵖ}
    (x : (divRankOnePresentationPreimageRepresenter pi).obj T) :
    ((rankOneAbelRepresented pi).app T x :
      (picDegLayerFunctor C (genus C : ℤ)).obj T) ∈ (PicRankOneOpen pi).obj T :=
  ((rankOneAbelRepresented pi).app T x).property