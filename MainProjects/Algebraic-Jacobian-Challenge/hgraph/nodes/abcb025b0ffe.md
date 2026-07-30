---
author: sync
content_type: definition
created: '2026-07-31T02:29:39'
decl: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.projectiveOpen
docstring: The two pulled-back Laurent opens, indexed in the ambient universe.
file: AlgebraicJacobian/Picard/FiniteMapProjectiveGluing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.projectiveOpen
type: lean
updated: '2026-07-31T02:29:39'
---
abbrev projectiveOpen (_G : D.FiniteMapGenerators pi)
    (b : ULift.{u} Bool) : C.left.Opens :=
  bif b.down then pi.left ⁻¹ᵁ D.V₀ else pi.left ⁻¹ᵁ D.V₁