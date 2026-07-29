---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonalCover
docstring: '**The diagonal pointed cover** (worksheet D4): a point on the diagonal
  `Δ` gets the diagonal

  member `𝔇(chart)` of the chart at its first projection; a point off `Δ` gets the
  complement

  `Δᶜ`.'
file: AlgebraicJacobian/Curve/DiagonalEquations.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.diagonalCover
type: lean
updated: '2026-07-29T15:26:38'
---
noncomputable def diagonalCover {C : Over (Spec (.of k))} (data : DiagonalChartData C)
    [IsSeparated C.hom] : (C ⊗ C).left.PointedCover where
  opens z :=
    if z ∈ Set.range (diagonal C).left.base then
      diagonalChart C (data.isAffineOpen ((fst C C).left.base z))
        (data.elift ((fst C C).left.base z))
    else diagonalComplement C
  mem_opens z := by
    by_cases h : z ∈ Set.range (diagonal C).left.base
    · rw [if_pos h]
      have hz : (diagonal C).left.base ((fst C C).left.base z) = z :=
        (mem_range_diagonal_iff C).mp h
      have hmem := diagonal_base_mem_diagonalChart C
        (data.isAffineOpen ((fst C C).left.base z)) (data.elift ((fst C C).left.base z))
        (data.lmul'_elift ((fst C C).left.base z)) (data.mem ((fst C C).left.base z))
      rwa [hz] at hmem
    · rw [if_neg h]
      exact (mem_diagonalComplement_iff C).mpr h

variable {C : Over (Spec (.of k))} (data : DiagonalChartData C) [IsSeparated C.hom]