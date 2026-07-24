---
author: sync
content_type: structure
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.Over.DiagonalChartData
docstring: '**The frozen étale-coordinate chart data of the curve `C`.** A choice,
  per point `p` of

  `C.left`, of a standard-smooth affine chart `chart p ∋ p` with an étale `Polynomial
  k`-algebra

  structure on its sections (`coordAlgebra`), compatible with the section `k`-algebra
  structure

  (`isScalarTower`).  All of brick B0''s hypotheses on the chart — flatness, formal

  unramifiedness, essential finiteness — are consequences of `etale`; frozen here
  once so that the

  diagonal member, its equation, and the kernel computation (brick B4) all speak about
  the *same*

  chart per point (the classic assembly discipline).'
file: AlgebraicJacobian/Curve/DiagonalChartData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.DiagonalChartData
type: lean
updated: '2026-07-24T17:02:46'
---
structure DiagonalChartData (C : Over (Spec (.of k))) where
  /-- The chosen affine chart at each point. -/
  chart : C.left → C.left.Opens
  /-- Each chart is an affine open. -/
  isAffineOpen : ∀ p, IsAffineOpen (chart p)
  /-- The point lies in its chart. -/
  mem : ∀ p, p ∈ chart p
  /-- The étale `Polynomial k`-coordinate on the chart sections. -/
  coordAlgebra : ∀ p, Algebra (Polynomial k) Γ(C.left, chart p)
  /-- The coordinate is compatible with the section `k`-algebra structure. -/
  isScalarTower : ∀ p, letI := coordAlgebra p; IsScalarTower k (Polynomial k) Γ(C.left, chart p)
  /-- The coordinate is étale. -/
  etale : ∀ p, letI := coordAlgebra p; Algebra.Etale (Polynomial k) Γ(C.left, chart p)