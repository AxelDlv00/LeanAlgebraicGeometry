---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.Scheme.LocalEquations.unitEquations
docstring: '**The trivial (unit) local-equation system**: the constant equation `1`
  on the top cover.

  Its equations are regular (`1` is a nonzerodivisor) and pairwise unit-related (ratio
  `1`); it cuts

  out the *zero* divisor and is the base case of the point-product realization of
  an effective

  divisor.'
file: AlgebraicJacobian/Picard/DivisorFamilyBackward.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.LocalEquations.unitEquations
type: lean
updated: '2026-07-29T15:26:29'
---
noncomputable def unitEquations : X.LocalEquations where
  cover := ⊤
  eqn _ := 1
  regular _ y _ := by rw [map_one]; exact one_mem _
  ratio_isUnit _ _ := ⟨1, by simp⟩

omit [IsIntegral X] in
@[simp]