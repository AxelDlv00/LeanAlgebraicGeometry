---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.chart_overlap_swap
docstring: '`f_ij ≫ ι_i = p₂ ≫ ι_j` on the double overlap.'
file: AlgebraicJacobian/Picard/SerreTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.chart_overlap_swap
type: lean
updated: '2026-07-24T03:02:12'
---
lemma chart_overlap_swap (i j : n) :
    (glueData n).f i j ≫ (basicOpenCover n).f i
      = pullback.snd ((basicOpenCover n).f i) ((basicOpenCover n).f j) ≫ (basicOpenCover n).f j := by
  rw [gd_f, pullback.condition]

set_option backward.isDefEq.respectTransparency false in