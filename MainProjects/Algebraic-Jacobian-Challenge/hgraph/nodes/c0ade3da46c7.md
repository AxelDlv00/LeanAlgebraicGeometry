---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.H1Mod
docstring: '**The cover cohomology `Ȟ¹(D) = 𝒜(D) / B(D)` as a `k`-vector space.**
  The

  `k`-linear incarnation of `H1`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.H1Mod
type: lean
updated: '2026-07-16T21:14:28'
---
abbrev H1Mod (D : X.WeilDivisor) : Type u :=
  ↥(sectionSub k (U₀ ⊓ U₁) D) ⧸
    Submodule.comap (sectionSub k (U₀ ⊓ U₁) D).subtype (coboundarySub k U₀ U₁ D)