---
author: sync
content_type: definition
created: '2026-08-03T18:38:51'
decl: AlgebraicGeometry.P1FiniteMap.FiniteMapGenerators.liftedBB
docstring: The second generator family on the universe-lifted index.
file: AlgebraicJacobian/Projective/FiniteMapGenerators.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1FiniteMap.FiniteMapGenerators.liftedBB
type: lean
updated: '2026-08-03T18:38:51'
---
def liftedBB : G.LiftedIndex → Γ(C.left, pi ⁻¹ᵁ P1.chartOpen k 1) :=
  fun i => G.bb i.down

@[simp]