---
author: sync
content_type: theorem
created: '2026-08-06T12:29:31'
decl: AlgebraicGeometry.mem_picRankOneOpen_of_localPresentations
docstring: Constructor for the exact lambda-tied arbitrary-affine-pullback presentation
  contract.
file: AlgebraicJacobian/Picard/Pic0RankOneLocus.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_picRankOneOpen_of_localPresentations
type: lean
updated: '2026-08-07T05:01:57'
---
theorem mem_picRankOneOpen_of_localPresentations
    {T : (Over (Spec (.of k)))ᵒᵖ}
    {lam : (picDegLayerFunctor C (genus C : ℤ)).obj T}
    (h : ∀ (A : Type u) [CommRing A] [Algebra k A]
        (t : overSpec k A ⟶ T.unop),
        Nonempty (PicRankOneLocalPresentation pi
          ((picDegLayerFunctor C (genus C : ℤ)).map t.op lam))) :
    lam ∈ (PicRankOneOpen pi).obj T :=
  (mem_picRankOneOpen_iff pi lam).mpr h