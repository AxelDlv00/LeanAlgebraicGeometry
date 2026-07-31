---
author: sync
content_type: theorem
created: '2026-07-31T07:58:12'
decl: AlgebraicGeometry.P1.AlgebraicGeometry.P1.relpic_one
file: ScratchPicG/Probe.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.AlgebraicGeometry.P1.relpic_one
type: lean
updated: '2026-07-31T07:58:12'
---
theorem relpic_one (x : relPic (P1.asOver k) (overSpec k K)) (hx : relPicDeg K x = 0) : x = 1 := by
  induction x using relPic.ind with
  | mk L =>
    rw [relPicDeg_relPicMk] at hx
    rw [eq_one_of_classDeg_eq_zero_baseChange k K L hx]
    exact map_one _

-- step 2: kill a degree-zero PicEtAff class at a field, via cofinal FIELD covers