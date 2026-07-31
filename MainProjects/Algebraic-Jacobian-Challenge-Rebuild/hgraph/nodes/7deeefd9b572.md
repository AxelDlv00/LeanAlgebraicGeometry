---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.isAffineOpen_preimage_chartOpen
docstring: 'The preimage of each standard chart of `ℙ¹` under an affine (e.g. finite)
  morphism is an

  affine open.'
file: AlgebraicJacobian/Curve/MapToP1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isAffineOpen_preimage_chartOpen
type: lean
updated: '2026-07-31T20:15:19'
---
theorem isAffineOpen_preimage_chartOpen [IsAffineHom π] (i : Fin 2) :
    IsAffineOpen (π ⁻¹ᵁ P1.chartOpen k i) :=
  (P1.isAffineOpen_chartOpen k i).preimage π