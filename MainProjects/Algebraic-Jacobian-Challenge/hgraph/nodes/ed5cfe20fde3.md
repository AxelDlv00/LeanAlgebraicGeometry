---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.awayInclRight
docstring: 'Inclusion of the away-localisation at `y` into the away-localisation at
  `x * y`

  (inverting the extra factor `x`). Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.awayInclRight
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def awayInclRight {R : Type*} [CommRing R] (x y : R) :
    Localization.Away y →+* Localization.Away (x * y) :=
  IsLocalization.Away.lift (S := Localization.Away y) y
    (g := algebraMap R (Localization.Away (x * y)))
    (by
      have h : IsUnit (algebraMap R (Localization.Away (x * y)) (x * y)) :=
        IsLocalization.Away.algebraMap_isUnit _
      rw [map_mul] at h
      exact isUnit_of_mul_isUnit_right h)