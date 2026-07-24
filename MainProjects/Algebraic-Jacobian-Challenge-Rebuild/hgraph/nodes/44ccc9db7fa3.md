---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.TwoCover.truncExpClass_eq_zero_iff
docstring: 'Vanishing of a truncated-exponential kernel class: `[1 + b ε] = 0` iff
  `b` is a

  Čech coboundary `ρ₁ a₁ + ρ₂ a₂` of the two charts.'
file: AlgebraicJacobian/Tangent/TruncExpCechH1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.TwoCover.truncExpClass_eq_zero_iff
type: lean
updated: '2026-07-24T17:02:48'
---
theorem truncExpClass_eq_zero_iff (b : Γ(X, U₀ ⊓ U₁)) :
    truncExpClass X U₀ U₁ b = 0
      ↔ b ∈ cechCoboundaryAdd (X.resHom (inf_le_left : U₀ ⊓ U₁ ≤ U₀))
          (X.resHom (inf_le_right : U₀ ⊓ U₁ ≤ U₁)) := by
  rw [truncExpClass_eq_engine, EmbeddingLike.map_eq_zero_iff,
    QuotientAddGroup.eq_zero_iff]

/-- Every class in the kernel of the Čech-units reduction is a truncated-exponential