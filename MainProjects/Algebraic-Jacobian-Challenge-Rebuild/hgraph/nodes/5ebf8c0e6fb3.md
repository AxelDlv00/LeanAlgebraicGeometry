---
author: sync
content_type: definition
created: '2026-08-01T11:57:32'
decl: AlgebraicGeometry.AffAdaptation.thetaOverlapSectionsToTriple
docstring: 'Restriction of theta sections from any pairwise intersection to a fixed
  triple

  intersection.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTriple.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.thetaOverlapSectionsToTriple
type: lean
updated: '2026-08-01T13:18:10'
---
noncomputable def thetaOverlapSectionsToTriple (A : AffAdaptation D d) (a : ℕ)
    (p q i j l : D.index)
    (h : A.thetaTripleOpen i j l ≤ D.pieces p ⊓ D.pieces q) :
    A.ThetaOverlapSections (π := π) a p q →ₛₗ[
      (relResAlgHom C R h).toRingHom]
      A.ThetaTripleSections (π := π) a i j l := by
  let MP := A.thetaOverlapSectionsModel (π := π) a p q
  let MT := A.thetaTripleSectionsModel (π := π) a i j l
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf
      (D.pieces p ⊓ D.pieces q) := MP.qcoh
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf
      (A.thetaTripleOpen i j l) := MT.qcoh
  refine
    { toFun := secRes (thetaChartDatum C R π a).sheaf h
      map_add' := (secRes (thetaChartDatum C R π a).sheaf h).map_add
      map_smul' := fun r s => ?_ }
  change
    secRes (thetaChartDatum C R π a).sheaf h
        (Scheme.QcohOn.qsmul (F := (thetaChartDatum C R π a).sheaf)
          (le_refl (D.pieces p ⊓ D.pieces q)) r s) =
      Scheme.QcohOn.qsmul (F := (thetaChartDatum C R π a).sheaf)
        (le_refl (A.thetaTripleOpen i j l))
        ((relResAlgHom C R h).toRingHom r)
        (secRes (thetaChartDatum C R π a).sheaf h s)
  rw [MP.qsmul_eq, MT.qsmul_eq]
  exact (gluedRes_gluedQsmul R (thetaChartDatum C R π a).pieces
      (thetaChartDatum C R π a).unit h
      (le_refl (D.pieces p ⊓ D.pieces q)) r s).trans
    (gluedQsmul_res R (thetaChartDatum C R π a).pieces
      (thetaChartDatum C R π a).unit
      (le_refl (A.thetaTripleOpen i j l)) h r
      (gluedRes R (thetaChartDatum C R π a).pieces
        (thetaChartDatum C R π a).unit h s)).symm