---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: IsLocalization.AwayCover.mapTriple
docstring: The canonical `A`-algebra map on triple overlaps `W i j k →ₐ[A] W' i j
  k`.
file: AlgebraicJacobian/Algebra/LocalizationCocycleBaseChange.lean
generated: lean
lean_status: lean_ok
stale: true
title: IsLocalization.AwayCover.mapTriple
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def mapTriple (i j k : ι) : W i j k →ₐ[A] W' i j k :=
  IsLocalization.Away.algHomOfIsUnit (S := W i j k) (W' i j k) (f i * (f j * f k)) <| by
    rw [IsScalarTower.algebraMap_apply A A' (W' i j k), map_mul (algebraMap A A'),
      map_mul (algebraMap A A')]
    exact IsLocalization.Away.algebraMap_isUnit (S := W' i j k)
      (algebraMap A A' (f i) * (algebraMap A A' (f j) * algebraMap A A' (f k)))

/-! ## Naturality of the restriction maps under base change

Each square commutes because both composites are `A`-algebra maps out of a localization of
`A`, hence equal by `IsLocalization.algHom_subsingleton`. -/