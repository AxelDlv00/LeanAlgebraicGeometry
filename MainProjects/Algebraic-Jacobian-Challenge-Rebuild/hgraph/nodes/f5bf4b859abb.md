---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonalEqn_of_notMem
docstring: The diagonal equation on an off-diagonal point is `1`.
file: AlgebraicJacobian/Curve/DiagonalEquations.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.diagonalEqn_of_notMem
type: lean
updated: '2026-07-16T21:33:27'
---
lemma diagonalEqn_of_notMem {z : (C ⊗ C).left} (h : z ∉ Set.range (diagonal C).left.base) :
    diagonalEqn data z = 1 := by
  rw [diagonalEqn, dif_neg h]

/-! ## The diagonal local-equation system and its Picard class -/