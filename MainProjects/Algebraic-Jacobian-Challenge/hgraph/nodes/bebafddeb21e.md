---
author: sync
content_type: theorem
created: '2026-07-28T14:28:36'
decl: AlgebraicGeometry.tilde_injective_app_basicOpen
docstring: '**`~` is injective on sections over every basic open**, for an injective
  `f`: by

  `sectMapₗ_eq` the section map is the localisation of `f` at the powers of `r`, and
  localisation

  preserves injectivity (`IsLocalizedModule.map_injective` — this is flatness of `R
  → R_r`).'
file: AlgebraicJacobian/Cohomology/TildeExactness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.tilde_injective_app_basicOpen
type: lean
updated: '2026-07-28T14:28:36'
---
theorem tilde_injective_app_basicOpen (f : M ⟶ N) (hf : Function.Injective f.hom) (r : R) :
    Function.Injective
      (Scheme.Modules.Hom.app ((tilde.functor R).map f) (PrimeSpectrum.basicOpen r)) := by
  have hloc := sectMapₗ_eq f r
  have hinj : Function.Injective (IsLocalizedModule.map (Submonoid.powers r)
      (tilde.toOpen M (PrimeSpectrum.basicOpen r)).hom
      (tilde.toOpen N (PrimeSpectrum.basicOpen r)).hom f.hom) :=
    IsLocalizedModule.map_injective _ _ _ _ hf
  rw [← hloc] at hinj
  exact hinj

end BasicOpen

set_option backward.isDefEq.respectTransparency false in