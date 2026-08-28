---
author: sync
content_type: definition
created: '2026-08-01T09:42:14'
decl: AlgebraicGeometry.AffAdaptation.thetaOverlapProdTower
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaProductBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaOverlapProdTower
type: lean
updated: '2026-08-01T09:42:14'
---
noncomputable def thetaOverlapProdTower : IsScalarTower (↥(gluedSubalgebra A))
    A.chartProd (A.ThetaOverlapProd (π := π) a) := by
  constructor
  intro c b x
  funext p
  change A.toOvlLeft p.1 p.2 (c.1 p.1 * b p.1) • x p =
    A.toOvlLeft p.1 p.2 (c.1 p.1) •
      (A.toOvlLeft p.1 p.2 (b p.1) • x p)
  rw [map_mul, mul_smul]

attribute [local instance] thetaOverlapProdTower

@[reducible]