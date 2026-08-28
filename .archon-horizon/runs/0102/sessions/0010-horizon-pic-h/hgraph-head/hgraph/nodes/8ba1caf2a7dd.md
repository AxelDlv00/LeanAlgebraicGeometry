---
author: sync
content_type: definition
created: '2026-08-01T09:44:13'
decl: AlgebraicGeometry.AffAdaptation.pieceSectionsColengthThetaOverlapTower
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaOverlapBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.pieceSectionsColengthThetaOverlapTower
type: lean
updated: '2026-08-01T09:44:13'
---
noncomputable def pieceSectionsColengthThetaOverlapTower
    (A : AffAdaptation D d) (a : ℕ) (i j : D.index) :
    IsScalarTower Γ(relCurve C R, D.pieces i) (A.colength i)
      (A.ThetaOverlapQuotient (π := π) a i j) :=
  IsScalarTower.of_algebraMap_smul fun _ _ => rfl

attribute [local instance] pieceSectionsColengthThetaOverlapTower

@[reducible]