---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonalChart_le_productChart
docstring: The diagonal member lies in the product chart `𝔚(U, U)`.
file: AlgebraicJacobian/Curve/DiagonalChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.diagonalChart_le_productChart
type: lean
updated: '2026-07-30T15:28:03'
---
lemma diagonalChart_le_productChart (C : Over (Spec (.of k))) {U : C.left.Opens}
    (hU : IsAffineOpen U) (elift : Γ(C.left, U) ⊗[k] Γ(C.left, U)) :
    diagonalChart C hU elift ≤ productChart C C U U :=
  (C ⊗ C).left.basicOpen_le _