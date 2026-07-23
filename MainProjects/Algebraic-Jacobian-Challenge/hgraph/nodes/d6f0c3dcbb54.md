---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.glue_cover_condition
docstring: The cover glue condition `t_ij ≫ f_ji ≫ ι_j = f_ij ≫ ι_i` into `Proj`.
file: AlgebraicJacobian/Picard/SerreTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.glue_cover_condition
type: lean
updated: '2026-07-16T21:14:28'
---
lemma glue_cover_condition (i j : n) :
    (glueData n).t i j ≫ (glueData n).f j i ≫ (basicOpenCover n).f j
      = (glueData n).f i j ≫ (basicOpenCover n).f i := by
  rw [gd_t, gd_f, gd_f, pullbackSymmetry_hom_comp_fst_assoc, pullback.condition]

set_option backward.isDefEq.respectTransparency false in