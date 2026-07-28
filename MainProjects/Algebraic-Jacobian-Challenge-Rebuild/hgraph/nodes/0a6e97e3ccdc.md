---
author: sync
content_type: definition
created: '2026-07-28T15:00:45'
decl: AlgebraicGeometry.Scheme.twoChartCob
docstring: '**The `0`-cochain exhibiting a coboundary unit as a coboundary.** For
  chart units

  `v₁ ∈ Γ(V₀)ˣ`, `v₂ ∈ Γ(V₁)ˣ`, the family `false ↦ v₁⁻¹`, `true ↦ v₂`.


  Written as a dependent match on the `Bool` so that each branch has the *right type
  on the

  nose* — no transport along an equality of opens is needed anywhere, which is the
  whole reason

  the charts are indexed by `Bool` in this file.'
file: AlgebraicJacobian/Tangent/TwoChartCechPic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.twoChartCob
type: lean
updated: '2026-07-28T15:00:45'
---
noncomputable def twoChartCob (v₁ : Γ(X, V false)ˣ) (v₂ : Γ(X, V true)ˣ) :
    ∀ s : Bool, Γ(X, V s)ˣ
  | false => v₁⁻¹
  | true  => v₂