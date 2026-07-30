---
author: sync
content_type: definition
created: '2026-07-30T17:24:12'
decl: AlgebraicGeometry.AffAdaptation.thetaOverlapSectionsModule
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaOverlapSectionsModule
type: lean
updated: '2026-07-30T20:44:26'
---
noncomputable def thetaOverlapSectionsModule (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    Module Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
      (A.ThetaOverlapSections (π := π) a i j) :=
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf (D.pieces i ⊓ D.pieces j) :=
    (A.thetaOverlapSectionsModel (π := π) a i j).qcoh
  Scheme.QcohOn.moduleOfLE (F := (thetaChartDatum C R π a).sheaf)
    (le_refl (D.pieces i ⊓ D.pieces j))

attribute [local instance] thetaPieceSectionsModule thetaOverlapSectionsModule

/-- The equation-generated submodule of theta sections on one piece. -/
@[reducible]