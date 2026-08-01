---
author: sync
content_type: theorem
created: '2026-08-01T05:12:59'
decl: AlgebraicGeometry.AffAdaptation.isFinite_divisorSubschemeOver
docstring: 'The intrinsic divisor of a certified widened adaptation is finite over
  the affine

  test base.  The proof uses precisely certificate clause (c1), locally on the arbitrary

  adapted affine cover.'
file: AlgebraicJacobian/Picard/DivisorSubschemeFinite.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.isFinite_divisorSubschemeOver
type: lean
updated: '2026-08-01T09:44:14'
---
theorem isFinite_divisorSubschemeOver [IsProper C.hom]
    (A : AffAdaptation D d) {n : ℕ} (hc : A.IsCertified n) :
    IsFinite A.divisorSubschemeOver.hom := by
  have hpiece (i : D.index) :
      LocallyQuasiFinite
        (A.divisorPieceMap i ≫ A.divisorSubschemeOver.hom) := by
    rw [A.divisorPieceMap_over i]
    have hf : (algebraMap R (A.colength i)).Finite :=
      RingHom.finite_algebraMap.mpr (hc.finite_colength i)
    haveI : IsFinite
        (Spec.map (CommRingCat.ofHom (algebraMap R (A.colength i)))) :=
      (IsFinite.SpecMap_iff _).mpr hf
    infer_instance
  have hqf : LocallyQuasiFinite A.divisorSubschemeOver.hom :=
    IsZariskiLocalAtSource.of_openCover (A.divisorPieceCover.openCover) hpiece
  haveI : IsProper A.divisorSubschemeι := inferInstance
  haveI : IsProper (relCurve C R ↘ Spec (.of R)) :=
    instIsProperRelCurveHom C R
  have hp : IsProper A.divisorSubschemeOver.hom := by
    change IsProper (A.divisorSubschemeι ≫ (relCurve C R ↘ Spec (.of R)))
    infer_instance
  exact @IsFinite.of_isProper_of_locallyQuasiFinite _ _
    A.divisorSubschemeOver.hom hp hqf