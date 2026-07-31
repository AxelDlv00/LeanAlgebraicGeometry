---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.fiberCoord
docstring: 'The **pulled-back chart-0 coordinate** `t₀ = π* (X₁/X₀) ∈ Γ(Y, V₀)`: the
  image under

  `π`''s section map of the chart-0 coordinate of `ℙ¹`. The two-cover overlap is the
  basic

  open of `t₀` (`preimage_inf_eq_basicOpen_fiberCoord`), and its `n`-th power is the
  twist''s

  transition cocycle.'
file: AlgebraicJacobian/RiemannRoch/FiberTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.fiberCoord
type: lean
updated: '2026-07-31T20:15:29'
---
noncomputable def fiberCoord : Γ(Y, fiberChart₀ π) :=
  (π.app (P1.chartOpen K 0)).hom ((Proj.awayToSection 𝒜 (X 0)).hom (P1.chartCoord K 0 1))