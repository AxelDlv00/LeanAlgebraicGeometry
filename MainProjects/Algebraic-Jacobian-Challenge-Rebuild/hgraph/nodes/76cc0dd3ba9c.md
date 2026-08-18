---
author: sync
content_type: theorem
created: '2026-08-01T13:31:19'
decl: AlgebraicGeometry.AffAdaptation.isBaseChange_thetaOverlapSectionsToTripleLinearRing
docstring: Affine restriction of theta sections from a pair to a triple is base change.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTripleBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.isBaseChange_thetaOverlapSectionsToTripleLinearRing
type: lean
updated: '2026-08-18T20:51:01'
---
theorem isBaseChange_thetaOverlapSectionsToTripleLinearRing
    (A : AffAdaptation D d) (a : ℕ) (p q i j l : D.index)
    (h : A.thetaTripleOpen i j l ≤ D.pieces p ⊓ D.pieces q) :
    letI : Algebra Γ(relCurve C R, D.pieces p ⊓ D.pieces q)
        Γ(relCurve C R, A.thetaTripleOpen i j l) :=
      A.overlapSectionsToTripleAlgebra p q i j l h
    letI : Module Γ(relCurve C R, D.pieces p ⊓ D.pieces q)
        (A.ThetaTripleSections (π := π) a i j l) :=
      A.thetaTripleSectionsOverlapModule (π := π) a p q i j l h
    letI : IsScalarTower Γ(relCurve C R, D.pieces p ⊓ D.pieces q)
        Γ(relCurve C R, A.thetaTripleOpen i j l)
        (A.ThetaTripleSections (π := π) a i j l) :=
      A.thetaTripleSectionsOverlapTower (π := π) a p q i j l h
    IsBaseChange Γ(relCurve C R, A.thetaTripleOpen i j l)
      (A.thetaOverlapSectionsToTripleLinearRing (π := π) a p q i j l h) := by
  letI := A.overlapSectionsToTripleAlgebra p q i j l h
  letI := A.thetaTripleSectionsOverlapModule (π := π) a p q i j l h
  letI := A.thetaTripleSectionsOverlapTower (π := π) a p q i j l h
  let MP := A.thetaOverlapSectionsModel (π := π) a p q
  let MT := A.thetaTripleSectionsModel (π := π) a i j l
  let F := thetaChartDatum C R π a
  letI := MP.qcoh
  letI : Module Γ(relCurve C R, D.pieces p ⊓ D.pieces q)
      (F.sheaf.obj.obj (op (D.pieces p ⊓ D.pieces q))) :=
    Scheme.QcohOn.moduleOfLE (F := F.sheaf)
      (le_refl (D.pieces p ⊓ D.pieces q))
  letI := MT.qcoh
  letI : Module Γ(relCurve C R, A.thetaTripleOpen i j l)
      (F.sheaf.obj.obj (op (A.thetaTripleOpen i j l))) :=
    Scheme.QcohOn.moduleOfLE (F := F.sheaf)
      (le_refl (A.thetaTripleOpen i j l))
  have hbij := F.affineSectionsBaseChange_bijective
    (D.hasAffineOverlaps_of_isProper p q)
    (A.isAffineOpen_thetaTripleOpen i j l) h MP MT
  apply IsBaseChange.of_equiv
    (LinearEquiv.ofBijective (F.affineSectionsBaseChange h MP MT) hbij)
  intro x
  change F.affineSectionsBaseChange h MP MT (1 ⊗ₜ x) =
    A.thetaOverlapSectionsToTriple (π := π) a p q i j l h x
  rw [F.affineSectionsBaseChange_tmul, one_smul]
  rfl