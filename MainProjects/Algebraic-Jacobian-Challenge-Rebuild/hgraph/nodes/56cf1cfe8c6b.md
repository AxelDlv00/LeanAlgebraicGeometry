---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.isAffineOpen_diagonalChart
docstring: The diagonal member is an affine open.
file: AlgebraicJacobian/Curve/DiagonalChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.isAffineOpen_diagonalChart
type: lean
updated: '2026-07-30T15:27:59'
---
theorem isAffineOpen_diagonalChart (C : Over (Spec (.of k))) {U : C.left.Opens}
    (hU : IsAffineOpen U) (elift : Γ(C.left, U) ⊗[k] Γ(C.left, U)) :
    IsAffineOpen (diagonalChart C hU elift) :=
  isAffineOpen_basicOpen_productChartSections C C hU hU _