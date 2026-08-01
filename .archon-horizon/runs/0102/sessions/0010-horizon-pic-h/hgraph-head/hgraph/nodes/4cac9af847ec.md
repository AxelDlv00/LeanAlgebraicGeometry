---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.BasicOpenCoverData.coverInf
docstring: 'The restricted chart-0 pieces cover the overlap of the pinned charts (the

  partition witness restricts to a partition witness).'
file: AlgebraicJacobian/Cohomology/GluedSheafDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCoverData.coverInf
type: lean
updated: '2026-08-01T09:44:09'
---
lemma coverInf : (relCover C B (fiberTwoCover π)).V₀ ⊓ (relCover C B (fiberTwoCover π)).V₁
    ≤ ⨆ j : D.J₀, (relCurve C B).basicOpen (D.hInf j) := by
  refine le_iSup_basicOpen_of_sum_eq_one
    (fun j => (relCurve C B).resHom inf_le_left (D.a₀ j)) D.hInf ?_
  have hres := congrArg
    ((relCurve C B).resHom (inf_le_left : (relCover C B (fiberTwoCover π)).V₀ ⊓
      (relCover C B (fiberTwoCover π)).V₁ ≤ (relCover C B (fiberTwoCover π)).V₀))
    D.partition₀
  rw [map_sum, map_one] at hres
  rw [← hres]
  exact Finset.sum_congr rfl fun j _ => (map_mul _ _ _).symm