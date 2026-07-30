---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonal_base_mem_diagonalChart
docstring: '**The `p ↦ z` membership** (worksheet D4): the diagonal image of any point
  of the

  chart `U` lies in the diagonal member `𝔇(U)`.'
file: AlgebraicJacobian/Curve/DiagonalChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.diagonal_base_mem_diagonalChart
type: lean
updated: '2026-07-30T15:46:00'
---
theorem diagonal_base_mem_diagonalChart (C : Over (Spec (.of k))) {U : C.left.Opens}
    (hU : IsAffineOpen U) (elift : Γ(C.left, U) ⊗[k] Γ(C.left, U))
    (hmul : Algebra.TensorProduct.lmul' k elift = 0) {p : C.left} (hp : p ∈ U) :
    (diagonal C).left.base p ∈ diagonalChart C hU elift := by
  rw [← diagonal_preimage_diagonalChart C hU elift hmul] at hp
  exact hp

/-! ## The kernel ideal sheaf of `δ` on the diagonal member (the D3 display) -/