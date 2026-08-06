---
author: sync
content_type: theorem
created: '2026-08-06T14:24:57'
decl: AlgebraicGeometry.mem_picRankOneOpen_of_localPresentationCondition
docstring: Constructor using the named arbitrary-affine producer predicate.
file: AlgebraicJacobian/Picard/Pic0RankOneLocus.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_picRankOneOpen_of_localPresentationCondition
type: lean
updated: '2026-08-07T05:01:57'
---
theorem mem_picRankOneOpen_of_localPresentationCondition
    {T : (Over (Spec (.of k)))ᵒᵖ}
    {lam : (picDegLayerFunctor C (genus C : ℤ)).obj T}
    (h : PicRankOneOpen.LocalPresentationCondition pi lam) :
    lam ∈ (PicRankOneOpen pi).obj T := by
  exact mem_picRankOneOpen_of_localPresentations pi h