---
author: sync
content_type: theorem
created: '2026-07-30T21:42:36'
decl: AlgebraicGeometry.ProjectiveSpace.Coordinates.homOfLE_fromOpen
docstring: Coordinate morphisms from open subschemes commute with restriction.
file: AlgebraicJacobian/Picard/ProjectiveCoordinateChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.Coordinates.homOfLE_fromOpen
type: lean
updated: '2026-07-30T21:42:36'
---
theorem homOfLE_fromOpen {Z : Scheme.{u}} {U V : Z.Opens} (h : V ≤ U)
    (i : J) (c : J → Γ(Z, U)) (hi : c i = 1) :
    Z.homOfLE h ≫ fromOpen U i c hi =
      fromOpen V i
        (fun j ↦ (Z.presheaf.map (homOfLE h).op).hom (c j))
        (by rw [hi, map_one]) := by
  rw [fromOpen, fromOpen,
    ← Scheme.Opens.toSpecΓ_SpecMap_presheaf_map_assoc V U h]
  congr 1
  exact SpecMap_fromSpec (Z.presheaf.map (homOfLE h).op).hom i c hi