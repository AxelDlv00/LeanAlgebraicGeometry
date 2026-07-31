---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.pulledToOvlLeft_colengthBaseChange
docstring: 'The left overlap-restriction square: the colength transport intertwines
  the

  overlap-restriction maps with their pulled versions.'
file: AlgebraicJacobian/Picard/DivisorFamilyPullbackCert.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.pulledToOvlLeft_colengthBaseChange
type: lean
updated: '2026-07-31T20:14:48'
---
lemma pulledToOvlLeft_colengthBaseChange (i j : A.index) (x : R' ⊗[R] A.colength i) :
    A.pulledToOvlLeft R' i j (A.colengthBaseChange R' i x) =
      A.ovlColengthBaseChange R' i j
        ((AlgebraTensorModule.lTensor R' R' (A.toOvlLeft i j).toLinearMap) x) := by
  induction x with
  | zero => simp only [map_zero]
  | add a b ha hb => simp only [map_add, ha, hb]
  | tmul r' y =>
    obtain ⟨t, rfl⟩ := Ideal.Quotient.mk_surjective y
    have hsmul : (r' ⊗ₜ[R] (Ideal.Quotient.mk (Ideal.span {A.eqn i}) t) :
        R' ⊗[R] A.colength i) =
        r' • ((1 : R') ⊗ₜ[R] (Ideal.Quotient.mk (Ideal.span {A.eqn i}) t)) := by
      rw [TensorProduct.smul_tmul', smul_eq_mul, mul_one]
    rw [hsmul]
    simp only [map_smul]
    congr 1
    have hlt : (AlgebraTensorModule.lTensor R' R' (A.toOvlLeft i j).toLinearMap)
        ((1 : R') ⊗ₜ[R] (Ideal.Quotient.mk (Ideal.span {A.eqn i}) t)) =
        (1 : R') ⊗ₜ[R] (A.toOvlLeft i j (Ideal.Quotient.mk (Ideal.span {A.eqn i}) t)) :=
      rfl
    rw [colengthBaseChange_one_tmul_mk, hlt, toOvlLeft_mk,
      ovlColengthBaseChange_one_tmul_mk, pulledToOvlLeft_mk]
    have hl : A.toFinCoverData.ovlMap R' i j (relResAlgHom C R inf_le_left t)
        = relResAlgHom C R' inf_le_left (A.toFinCoverData.piecesMap R' i t) :=
      A.toFinCoverData.ovlMap_resHom_left R' i j t
    rw [hl]