---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonalChart_def
docstring: Unfolding lemma for `Over.diagonalChart`.
file: AlgebraicJacobian/Curve/DiagonalChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.diagonalChart_def
type: lean
updated: '2026-08-01T09:44:10'
---
lemma diagonalChart_def (C : Over (Spec (.of k))) {U : C.left.Opens}
    (hU : IsAffineOpen U) (elift : Γ(C.left, U) ⊗[k] Γ(C.left, U)) :
    diagonalChart C hU elift
      = (C ⊗ C).left.basicOpen (productChartSections C C hU hU (1 - elift)) :=
  rfl