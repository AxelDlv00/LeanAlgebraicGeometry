---
author: sync
content_type: theorem
created: '2026-07-30T15:46:04'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.projective_thetaPieceRestriction
docstring: 'Under the existing widened certificate, every intrinsic theta restriction
  is

  projective over the test ring.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaRestriction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.projective_thetaPieceRestriction
type: lean
updated: '2026-07-31T20:15:24'
---
theorem IsCertified.projective_thetaPieceRestriction (A : AffAdaptation D d) {n : ℕ}
    (hc : A.IsCertified n) (a : ℕ) (j : D.index) :
    Module.Projective R (A.ThetaPieceRestriction (π := π) a j) := by
  letI : Module Γ(relCurve C R, D.pieces j) (A.ThetaPieceSections (π := π) a j) :=
    A.thetaPieceSectionsModule (π := π) a j
  haveI : Module.Invertible (A.colength j)
      (A.ThetaPieceRestriction (π := π) a j) :=
    A.invertible_thetaPieceRestriction (π := π) a j
  haveI : Module.Projective R (A.colength j) := hc.projective_colength j
  exact Module.Invertible.projective_trans (A := A.colength j)