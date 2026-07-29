---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.twistSheaf
docstring: '**The twisted sheaf `F_g`** of a unit cocycle `g ∈ Γ(X, V₀ ⊓ V₁)ˣ` on
  the two-cover

  `V₀, V₁`: the sheaf of `k`-modules on the small Zariski site of `X` whose sections
  over

  `W` are the pairs `(s₀, s₁) ∈ Γ(W ⊓ V₀) × Γ(W ⊓ V₁)` with `s₀ = g · s₁` on

  `W ⊓ V₀ ⊓ V₁`. For `V₀ ⊔ V₁ = ⊤` this is a line bundle presented by the transition

  cocycle `g`, trivialized on each chart by construction (`twistTriv₀`, `twistTriv₁`).'
file: AlgebraicJacobian/Cohomology/TwistedSheaf.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.twistSheaf
type: lean
updated: '2026-07-29T15:26:35'
---
noncomputable def twistSheaf :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k) :=
  ⟨twistPresheaf k V₀ V₁ g, isSheaf_twistPresheaf k V₀ V₁ g⟩

@[simp]