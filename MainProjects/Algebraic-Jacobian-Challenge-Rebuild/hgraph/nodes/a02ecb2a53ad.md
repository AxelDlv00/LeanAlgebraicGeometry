---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonalChartEqn
docstring: '**The local equation of the diagonal on the chart**: the transport of
  the diagonal

  generator `u ⊗ 1 − 1 ⊗ u` (`AlgebraicJacobian.Diagonal.diagGen`, with `u` the étale

  coordinate `algebraMap (Polynomial k) Γ(U) X`) through the product-chart identification,

  restricted to the diagonal member `𝔇(U)`.'
file: AlgebraicJacobian/Curve/DiagonalChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.diagonalChartEqn
type: lean
updated: '2026-07-30T15:46:00'
---
noncomputable def diagonalChartEqn (C : Over (Spec (.of k))) {U : C.left.Opens}
    (hU : IsAffineOpen U) [Algebra (Polynomial k) Γ(C.left, U)]
    (elift : Γ(C.left, U) ⊗[k] Γ(C.left, U)) :
    Γ((C ⊗ C).left, diagonalChart C hU elift) :=
  ((C ⊗ C).left.presheaf.map
      (homOfLE (diagonalChart_le_productChart C hU elift)).op).hom
    (productChartSections C C hU hU
      (AlgebraicJacobian.Diagonal.diagGen (k := k) (B := Γ(C.left, U))))