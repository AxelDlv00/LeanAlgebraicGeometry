---
author: sync
content_type: theorem
created: '2026-08-03T16:37:45'
decl: AlgebraicGeometry.ProjectiveSpace.Coordinates.SpecMap_fromSpec
docstring: '`fromSpec` is natural in the affine coordinate ring.'
file: AlgebraicJacobian/Projective/ProjectiveCoordinateChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.Coordinates.SpecMap_fromSpec
type: lean
updated: '2026-08-07T05:01:59'
---
theorem SpecMap_fromSpec (r : B →+* B') (i : J) (c : J → B)
    (hi : c i = 1) :
    Spec.map (CommRingCat.ofHom r) ≫ fromSpec i c hi =
      fromSpec i (fun j ↦ r (c j)) (by rw [hi, map_one]) := by
  rw [fromSpec, fromSpec, ← Category.assoc, ← Spec.map_comp]
  congr 2
  ext w
  exact DFunLike.congr_fun (comp_chartHom r i c hi) w