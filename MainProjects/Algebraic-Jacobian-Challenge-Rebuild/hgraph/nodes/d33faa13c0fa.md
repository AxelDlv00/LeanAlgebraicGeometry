---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonal_preimage_diagonalChart
docstring: '**The `δ`-preimage of the diagonal member is the whole chart** (worksheet
  D1(c)):

  since `mul elift = 0`, the `δ`-pullback of the transported `1 − elift` is `1`, so

  `δ ⁻¹ 𝔇(U) = δ ⁻¹ 𝔚(U, U) = U`.  In particular `Δ ∩ 𝔚(U, U) ⊆ 𝔇(U)`: the diagonal
  member

  covers all diagonal points of the chart in one piece.'
file: AlgebraicJacobian/Curve/DiagonalChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.diagonal_preimage_diagonalChart
type: lean
updated: '2026-07-31T20:15:18'
---
theorem diagonal_preimage_diagonalChart (C : Over (Spec (.of k))) {U : C.left.Opens}
    (hU : IsAffineOpen U) (elift : Γ(C.left, U) ⊗[k] Γ(C.left, U))
    (hmul : Algebra.TensorProduct.lmul' k elift = 0) :
    (diagonal C).left ⁻¹ᵁ diagonalChart C hU elift = U := by
  have hpre : (diagonal C).left ⁻¹ᵁ productChart C C U U ≤ U :=
    (diagonal_preimage_productChart C U U).le.trans inf_le_left
  rw [diagonalChart_def, Scheme.preimage_basicOpen, Scheme.Hom.app_eq_appLE,
    diagonal_appLE_productChartSections C hU le_rfl hpre (1 - elift), map_sub, map_one,
    hmul, sub_zero, map_one, Scheme.basicOpen_one, diagonal_preimage_productChart,
    inf_idem]