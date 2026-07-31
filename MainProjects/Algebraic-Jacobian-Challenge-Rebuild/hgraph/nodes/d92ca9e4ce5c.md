---
author: sync
content_type: definition
created: '2026-07-30T15:46:03'
decl: AlgebraicGeometry.AffAdaptation.thetaPieceSectionsModule
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaRestriction.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.thetaPieceSectionsModule
type: lean
updated: '2026-07-31T20:14:51'
---
noncomputable def thetaPieceSectionsModule (A : AffAdaptation D d) (a : ℕ) (j : D.index) :
    Module Γ(relCurve C R, D.pieces j) (A.ThetaPieceSections (π := π) a j) :=
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf (D.pieces j) :=
    (A.thetaPieceSectionsModel (π := π) a j).qcoh
  Scheme.QcohOn.moduleOfLE (F := (thetaChartDatum C R π a).sheaf)
    (le_refl (D.pieces j))