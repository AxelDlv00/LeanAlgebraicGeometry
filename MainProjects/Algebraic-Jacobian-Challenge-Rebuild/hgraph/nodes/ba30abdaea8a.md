---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.FinCoverData.ovlMap_eq_conj
docstring: 'The overlap comparison is the generic piece-sections comparison at the
  overlap

  generator, conjugated by the opens identifications `basicOpen_ovlGen` (the

  proof-irrelevant `appLE` collapse `Scheme.Hom.appLE_resHom_of_eq`).'
file: AlgebraicJacobian/Picard/DivisorFamilyPullbackOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FinCoverData.ovlMap_eq_conj
type: lean
updated: '2026-07-24T13:02:30'
---
lemma ovlMap_eq_conj (i j : D.index) (s : Γ(relCurve C R, D.pieces i ⊓ D.pieces j)) :
    D.ovlMap R' i j s =
      relResCongrAlg C R' (D.basicOpen_relSectionsMap_ovlGen R' i j)
        (pieceSectionsMap R' (D.chart i ⊓ D.chart j) (D.ovlGen i j)
          ((relResCongrAlg C R (D.basicOpen_ovlGen i j)).symm s)) := by
  have key := (relCurveMap C R R').appLE_resHom_of_eq
    (D.basicOpen_ovlGen i j).symm (D.basicOpen_relSectionsMap_ovlGen R' i j).symm
    (D.baseChange_inf_le_preimage R' i j)
    (relSectionsMap_basicOpen C R R' (D.chart i ⊓ D.chart j) (D.ovlGen i j)).le s
  -- `key : pieceSectionsMap (res s) = res (ovlMap s)`; apply the forward restriction
  have happ := congrArg
    ((relCurve C R').resHom (D.basicOpen_relSectionsMap_ovlGen R' i j).ge) key
  rw [Scheme.resHom_resHom, Scheme.resHom_refl] at happ
  rw [relResCongrAlg_apply, relResCongrAlg_symm_apply]
  exact happ.symm

/-! ## The overlap-section transport -/