---
author: sync
content_type: definition
created: '2026-08-01T09:44:13'
decl: AlgebraicGeometry.AffAdaptation.thetaToOverlapRightLinearColength
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaOverlapBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaToOverlapRightLinearColength
type: lean
updated: '2026-08-01T09:44:13'
---
noncomputable def thetaToOverlapRightLinearColength (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    A.ThetaPieceQuotient (π := π) a j →ₗ[A.colength j]
      A.ThetaOverlapQuotient (π := π) a i j :=
  { toFun := A.thetaToOverlapRight (π := π) a i j
    map_add' := (A.thetaToOverlapRight (π := π) a i j).map_add
    map_smul' := A.thetaToOverlapRight_smul (π := π) a i j }