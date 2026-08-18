---
author: sync
content_type: theorem
created: '2026-08-14T14:17:16'
decl: AlgebraicGeometry.PicRankOneNativePresentation.nonempty_of_pointwiseSplit
docstring: 'Pointwise splitting on an affine test supplies a native presentation nonemptiness

  certificate in the precise form consumed by the public rank-one locus.'
file: AlgebraicJacobian/Picard/Pic0RankOneOpenProducer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneNativePresentation.nonempty_of_pointwiseSplit
type: lean
updated: '2026-08-18T20:51:05'
---
theorem PicRankOneNativePresentation.nonempty_of_pointwiseSplit
    (pi : C.left ⟶ P1 k) [IsFinite pi]
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hsplit : ∀ t : (overSpec k A).left,
      IsSplitWitness C (picEtMap C (Over.testPoint t) lam.1)) :
    Nonempty (PicRankOneNativePresentation pi lam) :=
  ⟨PicRankOneNativePresentation.of_pointwiseSplit pi hpi hsplit⟩