---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.awayInclRight
docstring: 'Inclusion of the away-localisation at `y` into the away-localisation at
  `x * y`

  (inverting the extra factor `x`), as a `k`-algebra map.'
file: AlgebraicJacobian/Picard/GrassmannianCocycle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.awayInclRight
type: lean
updated: '2026-07-17T08:41:25'
---
noncomputable def awayInclRight (k : Type u) [Field k] {A : Type u} [CommRing A]
    [Algebra k A] (x y : A) : Localization.Away y →ₐ[k] Localization.Away (x * y) :=
  IsLocalization.liftAlgHom (M := Submonoid.powers y)
    (f := Algebra.algHom k A (Localization.Away (x * y)))
    (isUnit_algHom_powers _ (by
      have h : IsUnit (algebraMap A (Localization.Away (x * y)) (x * y)) :=
        IsLocalization.Away.algebraMap_isUnit _
      rw [map_mul] at h
      exact isUnit_of_mul_isUnit_right h))