---
author: sync
content_type: theorem
created: '2026-07-30T21:42:36'
decl: AlgebraicGeometry.ProjectiveSpace.Coordinates.fromSpec_preimage_basicOpen
docstring: 'The inverse image of `D_+(X_j)` under a normalized coordinate map is the

  ordinary principal open where the coordinate `c_j` is nonzero.'
file: AlgebraicJacobian/Picard/ProjectiveCoordinateChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.Coordinates.fromSpec_preimage_basicOpen
type: lean
updated: '2026-07-30T21:42:36'
---
theorem fromSpec_preimage_basicOpen (i j : J) (c : J → B) (hi : c i = 1) :
    fromSpec i c hi ⁻¹ᵁ
        Proj.basicOpen (homogeneousSubmodule J (ULift.{u} ℤ)) (X j) =
      PrimeSpectrum.basicOpen (c j) := by
  rw [fromSpec, Scheme.Hom.comp_preimage]
  rw [Proj.awayι_preimage_basicOpen (homogeneousSubmodule J (ULift.{u} ℤ))
    (X_mem_deg_one i) Nat.one_pos (X_mem_deg_one j) Nat.one_pos]
  rw [SpecMap_preimage_basicOpen]
  congr 1
  change chartHom i c hi
      (Away.isLocalizationElem (X_mem_deg_one i) (X_mem_deg_one j)) = c j
  rw [isLocalizationElem_eq_chartCoord, chartHom_chartCoord]