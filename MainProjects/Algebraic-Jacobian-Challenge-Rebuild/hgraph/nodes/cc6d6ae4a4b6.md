---
author: sync
content_type: definition
created: '2026-07-28T17:25:29'
decl: AlgebraicGeometry.Scheme.pairCochain
docstring: 'The two chart cochains, packaged as one `Bool`-indexed family so that
  `selCochain` can

  select without a transport.'
file: AlgebraicJacobian/Tangent/TwoChartRepresentable.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.pairCochain
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def pairCochain {𝒩 : X.PointedCover}
    (t₀ : ∀ b : X, Γ(X, 𝒩.opens b ⊓ V false)ˣ)
    (t₁ : ∀ b : X, Γ(X, 𝒩.opens b ⊓ V true)ˣ) :
    ∀ (s : Bool) (b : X), Γ(X, 𝒩.opens b ⊓ V s)ˣ
  | false => t₀
  | true  => t₁