---
author: sync
content_type: theorem
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.stalkMapₗ_injective
docstring: '**Stalkwise injectivity of `~f` for a monomorphism `f`.**  For an injective
  `R`-module map

  `f`, the `R`-linear `Ab`-stalk map `σ_x = stalkMapₗ f x` of `~f` is injective at
  every point `x`.

  This is the stalkwise-flatness contribution to mono-preservation of `~`, now stated
  on the genuine

  linear stalk map: it combines the identification `stalkMapₗ_eq` with the localisation
  injectivity

  `tilde_toStalk_map_injective`.  Project-local stepping stone toward `tildePreservesFiniteLimits`.'
file: AlgebraicJacobian/Cohomology/TildeExactness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.stalkMapₗ_injective
type: lean
updated: '2026-07-28T14:28:36'
---
theorem stalkMapₗ_injective {M N : ModuleCat R} (f : M ⟶ N) (hf : Function.Injective f.hom)
    (x : PrimeSpectrum.Top R) : Function.Injective (stalkMapₗ f x) := by
  rw [stalkMapₗ_eq]
  exact tilde_toStalk_map_injective f hf x

/-! ## §2. `tildePreservesFiniteLimits`, CLOSED — via basic opens rather than stalks

The plan sketched in the header above (upgrade the *stalk* maps to a jointly-reflecting family)
is not the cheapest route and is not the one taken.  Basic opens are already a basis of
`Spec R`, and over a basic open `D(r)` the sections of `M^~` are *by Mathlib* a localisation of
`M` at the powers of `r` (`AlgebraicGeometry.tilde.toOpen` carries an
`IsLocalizedModule.Away` instance).  So the whole argument is one basis-local injectivity check
whose content is `IsLocalizedModule.map_injective` — localisation is flat — with no stalk
colimit anywhere.  The stalk material of §1 is retained: it is the same mathematics at a point,
and `stalkMapₗ_injective` remains the sharpest per-point statement.

Three steps: package the section map as `R`-linear (`sectMapₗ`), identify it with the localised
map (`sectMapₗ_eq`, by `IsLocalizedModule.ext` — both agree after `toOpen`, which is the
localisation map), and conclude. -/

section BasicOpen

variable {M N : ModuleCat.{u} R}