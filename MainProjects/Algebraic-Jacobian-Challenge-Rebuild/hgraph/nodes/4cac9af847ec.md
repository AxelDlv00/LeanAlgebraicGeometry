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
updated: '2026-07-16T21:33:27'
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

end BasicOpenCoverData

/-- **The pinned cocycle datum over `B`** (worksheet §3.2, VERBATIM): the basic-open
cover data of the two pinned charts together with transition units on the pairwise
basic-open overlaps (with explicit inverse witnesses — `Units`) satisfying the cocycle
identities in the overlap section rings (`Scheme.IsGluingCocycle`, including the
normalization `g j j = 1`). This is the DAT-1 constructor input and the object RE-5
descends. -/
structure BasicOpenCocycleDatum [IsAffineHom π] : Type (u + 1) extends
    BasicOpenCoverData C B π where
  /-- The transition units on the pairwise piece overlaps. -/
  unit : ∀ i j : toBasicOpenCoverData.index,
    Γ(relCurve C B, toBasicOpenCoverData.pieces i ⊓ toBasicOpenCoverData.pieces j)ˣ
  /-- The cocycle law. -/
  isGluingCocycle : Scheme.IsGluingCocycle toBasicOpenCoverData.pieces unit

namespace BasicOpenCocycleDatum

variable {C B π} [IsAffineHom π] (D : BasicOpenCocycleDatum C B π)