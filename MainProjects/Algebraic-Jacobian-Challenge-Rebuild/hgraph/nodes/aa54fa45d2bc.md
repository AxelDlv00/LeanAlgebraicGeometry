---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.TwoCover.smul_delta
docstring: 'Scaling a connecting class: the `k`-action on `H¹` hits `delta` as multiplication

  of the overlap section by the structure constant.'
file: AlgebraicJacobian/Tangent/TruncExpCechH1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.TwoCover.smul_delta
type: lean
updated: '2026-07-31T20:15:29'
---
theorem smul_delta (a : k) (s : Γ(X, U₀ ⊓ U₁)) :
    a • delta k X U₀ U₁ hcov s
      = delta k X U₀ U₁ hcov (X.overAlgebraMap k (U₀ ⊓ U₁) a * s) := by
  rw [← map_smul]
  rfl