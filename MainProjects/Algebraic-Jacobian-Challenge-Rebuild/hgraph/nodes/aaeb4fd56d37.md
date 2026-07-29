---
author: sync
content_type: definition
created: '2026-07-17T21:01:12'
decl: AlgebraicGeometry.thetaChartCover
docstring: '**The whole-chart cover data**: the two pinned charts themselves, each
  presented as

  the basic open of `1` (partition of unity `1 · 1 = 1`).'
file: AlgebraicJacobian/Cohomology/RelCurveCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaChartCover
type: lean
updated: '2026-07-29T15:31:35'
---
noncomputable def thetaChartCover : BasicOpenCoverData C B π where
  J₀ := PUnit
  J₁ := PUnit
  fintype₀ := inferInstance
  fintype₁ := inferInstance
  h₀ _ := 1
  h₁ _ := 1
  a₀ _ := 1
  a₁ _ := 1
  partition₀ := by simp
  partition₁ := by simp