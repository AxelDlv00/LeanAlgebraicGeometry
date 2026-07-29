---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.MeromorphicPresentation.germGenericUnits_unitsEvInf_res
docstring: 'The germ at `η` of a pair value of a restricted presentation cocycle is
  the ratio of

  the trivializing elements: restriction does not move germs at `η`.'
file: AlgebraicJacobian/Picard/PresentationClassLaw.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.MeromorphicPresentation.germGenericUnits_unitsEvInf_res
type: lean
updated: '2026-07-29T15:26:14'
---
lemma germGenericUnits_unitsEvInf_res (P : X.MeromorphicPresentation)
    {𝒲 : X.PointedCover} (h : 𝒲 ≤ P.cover) (x y : X)
    (hη : genericPoint X ∈ 𝒲.opens x ⊓ 𝒲.opens y) :
    germGenericUnits hη
        (unitsEvInf (P.cocycle.res fun k => homOfLE (h k)) x y)
      = P.elem x * (P.elem y)⁻¹ := by
  rw [res_unitsEvInf, germGenericUnits_unitsRestrict]
  exact (P.ratio x y).symm

variable [QuasiCompact (X ↘ Spec (CommRingCat.of K))]