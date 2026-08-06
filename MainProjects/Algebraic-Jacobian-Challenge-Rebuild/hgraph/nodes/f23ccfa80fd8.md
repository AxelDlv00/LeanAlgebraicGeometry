---
author: sync
content_type: definition
created: '2026-08-01T13:31:19'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.thetaOverlapBaseChangeToTripleCoord
docstring: 'Base change of a pairwise theta quotient along a third divisor piece is
  the

  intrinsic theta quotient on the corresponding triple intersection.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTripleProductBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.thetaOverlapBaseChangeToTripleCoord
type: lean
updated: '2026-08-07T05:01:52'
---
noncomputable def IsCertified.thetaOverlapBaseChangeToTripleCoord {n : ℕ}
    (hc : A.IsCertified n) (i j l : D.index) :
    A.colength l ⊗[gluedSubalgebra A]
        A.ThetaOverlapQuotient (π := π) a i j
      ≃ₗ[A.colength l]
        A.ThetaTripleQuotient (π := π) a i j l := by
  letI := hc.gluedPieceThirdTripleTower A i j l
  let hpush : Algebra.IsPushout (gluedSubalgebra A) (A.ovlColength i j)
      (A.colength l) (A.tripleColength i j l) :=
    CommRingCat.isPushout_iff_isPushout.mp
      (hc.isPushout_gluedSubalgebraOverlapPieceMaps A i j l)
  letI : Algebra.IsPushout (gluedSubalgebra A) (A.colength l)
      (A.ovlColength i j) (A.tripleColength i j l) :=
    Algebra.IsPushout.symm hpush
  let e := (Algebra.IsPushout.cancelBaseChange
    (gluedSubalgebra A) (A.colength l) (A.ovlColength i j)
      (A.tripleColength i j l)
      (A.ThetaOverlapQuotient (π := π) a i j)).symm
  exact e.trans ((A.thetaOverlap12BaseChangeToTripleEquiv
    (π := π) a i j l).restrictScalars (A.colength l))

set_option synthInstance.maxHeartbeats 500000 in
-- Elaborating the dependent pure tensor repeats the pushout instance search.
@[simp]