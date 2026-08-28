---
author: sync
content_type: definition
created: '2026-08-01T09:44:13'
decl: AlgebraicGeometry.AffAdaptation.thetaPieceBaseChangeToOverlapLeftEquiv
docstring: The desired pairwise theta-module base-change equivalence.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaOverlapBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaPieceBaseChangeToOverlapLeftEquiv
type: lean
updated: '2026-08-01T09:44:13'
---
noncomputable def thetaPieceBaseChangeToOverlapLeftEquiv
    (A : AffAdaptation D d) (a : ℕ) (i j : D.index) :
    A.ovlColength i j ⊗[A.colength i] A.ThetaPieceQuotient (π := π) a i
      ≃ₗ[A.ovlColength i j] A.ThetaOverlapQuotient (π := π) a i j :=
  (A.isBaseChange_thetaToOverlapLeftLinearColength (π := π) a i j).equiv

@[simp]