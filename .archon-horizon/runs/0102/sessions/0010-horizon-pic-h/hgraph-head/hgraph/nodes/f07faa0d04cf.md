---
author: sync
content_type: definition
created: '2026-08-01T09:44:13'
decl: AlgebraicGeometry.AffAdaptation.pieceSectionsColengthOverlapTower
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaOverlapBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.pieceSectionsColengthOverlapTower
type: lean
updated: '2026-08-01T09:44:13'
---
noncomputable def pieceSectionsColengthOverlapTower (A : AffAdaptation D d)
    (i j : D.index) : IsScalarTower Γ(relCurve C R, D.pieces i)
      (A.colength i) (A.ovlColength i j) :=
  IsScalarTower.of_algebraMap_eq fun _ => rfl

attribute [local instance] pieceSectionsColengthOverlapTower

/-- The overlap quotient, restricted to the left piece colength algebra. -/
@[reducible]