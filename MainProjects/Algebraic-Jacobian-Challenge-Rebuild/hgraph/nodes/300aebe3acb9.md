---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: TruncExpCech.truncExpUnit
docstring: '**The truncated exponential is a unit**: `1 + b ε` is invertible in `R[ε]`,
  with

  inverse `1 - b ε`.'
file: AlgebraicJacobian/Tangent/TruncExpUnits.lean
generated: lean
lean_status: lean_ok
title: TruncExpCech.truncExpUnit
type: lean
updated: '2026-07-17T08:41:25'
---
def truncExpUnit (b : R) : (R[ε])ˣ :=
  Units.mkOfMulEqOne (1 + inr b) (1 - inr b) <| by
    calc (1 + inr b) * (1 - inr b)
        = 1 - (inr b : R[ε]) * inr b := by ring
      _ = 1 := by rw [inr_mul_inr_eq_zero, sub_zero]

@[simp]