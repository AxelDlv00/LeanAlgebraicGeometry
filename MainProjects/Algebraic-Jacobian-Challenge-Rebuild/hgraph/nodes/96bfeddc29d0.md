---
author: sync
content_type: theorem
created: '2026-07-21T21:31:59'
decl: AlgebraicGeometry.exists_forall_ge_exists_relThetaResSide_eq
docstring: 'A section on either pinned affine chart is the chosen-side reading of
  a global

  theta section at every sufficiently large exponent.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowChartExhaustion.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_forall_ge_exists_relThetaResSide_eq
type: lean
updated: '2026-07-21T22:01:54'
---
theorem exists_forall_ge_exists_relThetaResSide_eq (side : Bool)
    (x : Γ(relCurve C R, relPinnedChart C R pi side)) :
    ∃ m : Nat, ∀ a : Nat, m ≤ a → ∃ s : relThetaSections C R pi a,
      relThetaResSide a side le_rfl s = x := by
  cases side with
  | false =>
      obtain ⟨y, m, hy⟩ :=
        (relCover_isAffineOpen₁ C R (fiberTwoCover pi)).exists_pow_mul_eq_resHom
          (relFiberCoord₁ C R pi)
          (relCover_fiberTwoCover_inf_eq_basicOpen₁ C R pi)
          (inf_le_right :
            (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁ ≤
              (relCover C R (fiberTwoCover pi)).V₁)
          ((relCurve C R).resHom inf_le_left x)
      refine ⟨m, fun a hma => ?_⟩
      let sm : relThetaSections C R pi m := by
        refine ⟨((relCurve C R).resHom inf_le_right x,
          (relCurve C R).resHom inf_le_right y), ?_⟩
        rw [mem_twistSubmodule_iff]
        have hcoord : (relCurve C R).resHom inf_le_right
            (relFiberCoord₁ C R pi) ^ m =
              (((relThetaCocycle C R pi m)⁻¹ :
                Γ(relCurve C R,
                  (relCover C R (fiberTwoCover pi)).V₀ ⊓
                    (relCover C R (fiberTwoCover pi)).V₁)ˣ) :
                Γ(relCurve C R,
                  (relCover C R (fiberTwoCover pi)).V₀ ⊓
                    (relCover C R (fiberTwoCover pi)).V₁)) := by
          rw [← map_pow, ← relFiberCoordOnePow_eq_pow C R pi,
            resHom_relFiberCoordOnePow]
        have hmatch : (relCurve C R).resHom inf_le_left x =
            ((relThetaCocycle C R pi m :
            Γ(relCurve C R,
              (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁)ˣ) :
            Γ(relCurve C R,
              (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁)) *
              (relCurve C R).resHom inf_le_right y := by
          rw [← hy, hcoord, ← mul_assoc, Units.mul_inv, one_mul]
          rfl
        have hmatch' := congrArg ((relCurve C R).resHom
          (le_inf (inf_le_left.trans inf_le_right) inf_le_right :
            ⊤ ⊓ (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁ ≤
                (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁)) hmatch
        rw [map_mul] at hmatch'
        convert hmatch' using 1 <;>
          try simp only [Scheme.resHom_resHom]
        all_goals exact (Scheme.resHom_resHom _ _ _).symm
      obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_le hma
      let oneSide : relThetaSections C R pi d := relThetaSectionSnd C R pi d
      refine ⟨relThetaSectionsMul C R pi m d sm oneSide, ?_⟩
      rw [relThetaResSide_relThetaSectionsMul]
      simp [sm, oneSide]
  | true =>
      obtain ⟨y, m, hy⟩ :=
        (relCover_isAffineOpen₀ C R (fiberTwoCover pi)).exists_pow_mul_eq_resHom
          (relFiberCoord₀ C R pi)
          (relCover_fiberTwoCover_inf_eq_basicOpen₀ C R pi)
          (inf_le_left :
            (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁ ≤
              (relCover C R (fiberTwoCover pi)).V₀)
          ((relCurve C R).resHom inf_le_right x)
      refine ⟨m, fun a hma => ?_⟩
      let sm : relThetaSections C R pi m := by
        refine ⟨((relCurve C R).resHom inf_le_right y,
          (relCurve C R).resHom inf_le_right x), ?_⟩
        rw [mem_twistSubmodule_iff]
        have hcoord : (relCurve C R).resHom inf_le_left
            (relFiberCoord₀ C R pi) ^ m =
              ((relThetaCocycle C R pi m :
                Γ(relCurve C R,
                  (relCover C R (fiberTwoCover pi)).V₀ ⊓
                    (relCover C R (fiberTwoCover pi)).V₁)ˣ) :
                Γ(relCurve C R,
                  (relCover C R (fiberTwoCover pi)).V₀ ⊓
                    (relCover C R (fiberTwoCover pi)).V₁)) := by
          rw [← map_pow, ← relFiberCoordPow_eq_pow C R pi,
            resHom_relFiberCoordPow]
        have hmatch : (relCurve C R).resHom inf_le_left y =
            ((relThetaCocycle C R pi m :
            Γ(relCurve C R,
              (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁)ˣ) :
            Γ(relCurve C R,
              (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁)) *
              (relCurve C R).resHom inf_le_right x := by
          rw [← hy, hcoord]
          rfl
        have hmatch' := congrArg ((relCurve C R).resHom
          (le_inf (inf_le_left.trans inf_le_right) inf_le_right :
            ⊤ ⊓ (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁ ≤
                (relCover C R (fiberTwoCover pi)).V₀ ⊓
                (relCover C R (fiberTwoCover pi)).V₁)) hmatch
        rw [map_mul] at hmatch'
        convert hmatch' using 1 <;>
          try simp only [Scheme.resHom_resHom]
        all_goals
          congr 1
          exact (Scheme.resHom_resHom _ _ _).symm
      obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_le hma
      let oneSide : relThetaSections C R pi d := relThetaSectionFst C R pi d
      refine ⟨relThetaSectionsMul C R pi m d sm oneSide, ?_⟩
      rw [relThetaResSide_relThetaSectionsMul]
      simp [sm, oneSide]