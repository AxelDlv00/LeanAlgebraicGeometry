---
author: sync
content_type: definition
created: '2026-08-01T09:44:16'
decl: AlgebraicGeometry.tensorOverlapChosenPullback₃
docstring: 'The chosen threefold pullback whose three pairwise projections are the

  `12`, `23`, and `13` Amitsur faces.'
file: AlgebraicJacobian/Picard/Pic0RepresentabilityPullbacks.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.tensorOverlapChosenPullback₃
type: lean
updated: '2026-08-01T09:44:16'
---
noncomputable def tensorOverlapChosenPullback₃ :
    ChosenPullback₃
      (tensorOverlapChosenPullback (k := k) (L := L))
      (tensorOverlapChosenPullback (k := k) (L := L))
      (tensorOverlapChosenPullback (k := k) (L := L)) where
  chosenPullback := tensorTripleChosenPullback (k := k) (L := L)
  p := tensorTripleBase (k := k) (L := L)
  p₁ := tensorTripleCoord1 (k := k) (L := L)
  p₃ := tensorTripleCoord3 (k := k) (L := L)
  l :=
    { f := tensorTripleFace13 (k := k) (L := L)
      f_p₁ := tensorTripleFace13_inl (k := k) (L := L)
      f_p₂ := tensorTripleFace13_inr (k := k) (L := L)
      f_p := by
        dsimp only [tensorOverlapChosenPullback, ChosenPullback.p]
        exact (congrArg
          (fun q => q ≫ tensorOverlapBase (k := k) (L := L))
          (tensorTripleFace13_inl (k := k) (L := L))).trans
            (tensorTripleCoord1_comp_base (k := k) (L := L)) }
  hp₁ := rfl
  hp₃ := (tensorTripleCoord3_eq_face23_inr (k := k) (L := L)).symm