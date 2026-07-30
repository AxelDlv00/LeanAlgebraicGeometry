---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.thetaSectionSnd_mem
docstring: '**`τ` is a `Θᵃ`-twisted glued section.**'
file: AlgebraicJacobian/Picard/DivisorFamilyThetaSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.thetaSectionSnd_mem
type: lean
updated: '2026-07-30T15:46:04'
---
theorem thetaSectionSnd_mem : A.thetaSectionSnd a ∈ A.thetaGluedSubmodule a := by
  rw [mem_thetaGluedSubmodule_iff]
  rintro ⟨i, j⟩
  rcases i with i₀ | i₁ <;> rcases j with j₀ | j₁
  · -- chart 0 / chart 0: both components are `1`
    rw [thetaSectionSnd_inl, thetaSectionSnd_inl, FinCoverData.thetaOvlUnit_inl_inl,
      Units.val_one, map_one, map_one, map_one, one_mul]
  · -- chart 0 / chart 1: the cocycle value cancels the coordinate
    rw [thetaSectionSnd_inl, thetaSectionSnd_inr, map_one, toOvlRight_mk,
      FinCoverData.thetaOvlUnit_inl_inr, val_unitsRestrict', Scheme.resHom_resHom,
      ← Scheme.resHom_resHom
        (inf_le_right : (relCover C R (fiberTwoCover π)).V₀ ⊓
          (relCover C R (fiberTwoCover π)).V₁ ≤ (relCover C R (fiberTwoCover π)).V₁)
        (inf_le_inf (A.pieces_inl_le i₀) (A.pieces_inr_le j₁))
        (relFiberCoordOnePow C R π a),
      resHom_relFiberCoordOnePow C R π a, ← map_mul, ← map_mul, Units.mul_inv,
      map_one, map_one]
  · -- chart 1 / chart 0: the coordinate restricts to the inverse cocycle value
    rw [thetaSectionSnd_inr, thetaSectionSnd_inl, toOvlLeft_mk, map_one, mul_one,
      FinCoverData.thetaOvlUnit_inr_inl, val_unitsRestrict_inv,
      Scheme.resHom_resHom, ← resHom_relFiberCoordOnePow C R π a,
      Scheme.resHom_resHom]
  · -- chart 1 / chart 1: both components restrict from `t₁ᵃ`
    rw [thetaSectionSnd_inr, thetaSectionSnd_inr, toOvlLeft_mk, toOvlRight_mk,
      FinCoverData.thetaOvlUnit_inr_inr, Units.val_one, map_one, one_mul,
      Scheme.resHom_resHom, Scheme.resHom_resHom]