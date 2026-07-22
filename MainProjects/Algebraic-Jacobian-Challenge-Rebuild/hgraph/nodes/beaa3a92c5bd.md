---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.DiagonalChartData.res_chartEqn_mem_nonZeroDivisors
docstring: '**Section regularity of the restricted chart equation**: every restriction
  of `chartEqn` to

  a sub-open is a nonzerodivisor (germs are nonzerodivisors, and sections inject into
  germs).'
file: AlgebraicJacobian/Curve/DiagonalEquations.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.DiagonalChartData.res_chartEqn_mem_nonZeroDivisors
type: lean
updated: '2026-07-16T21:33:27'
---
theorem res_chartEqn_mem_nonZeroDivisors {W : (C ⊗ C).left.Opens}
    (hW : W ≤ diagonalChart C (data.isAffineOpen p) (data.elift p)) :
    ((C ⊗ C).left.presheaf.map (homOfLE hW).op).hom (chartEqn data p) ∈ Γ((C ⊗ C).left, W)⁰ := by
  apply section_mem_nonZeroDivisors_of_germ
  intro y hy
  rw [TopCat.Presheaf.germ_res_apply]
  exact germ_chartEqn_mem_nonZeroDivisors data p (hW hy)

end DiagonalChartData

/-! ## The pointed cover and its local equation -/

open Classical in