---
author: sync
content_type: theorem
created: '2026-08-01T04:12:00'
decl: AlgebraicGeometry.Scheme.Modules.linearMap_bijective_of_comp_localizations
docstring: 'A map between two localizations of the same module is bijective if it

  intertwines the two localization maps.'
file: AlgebraicJacobian/Picard/AffineStalkLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.linearMap_bijective_of_comp_localizations
type: lean
updated: '2026-08-01T04:12:00'
---
theorem linearMap_bijective_of_comp_localizations
    {R : Type u} [CommRing R] (S : Submonoid R)
    {M M' M'' : Type u} [AddCommGroup M] [Module R M]
    [AddCommGroup M'] [Module R M'] [AddCommGroup M''] [Module R M'']
    {a : M →ₗ[R] M'} {b : M →ₗ[R] M''} {h : M' →ₗ[R] M''}
    (ha : IsLocalizedModule S a) (hb : IsLocalizedModule S b)
    (hh : h.comp a = b) : Function.Bijective h := by
  letI := ha
  letI := hb
  have heq : h = (IsLocalizedModule.linearEquiv S a b).toLinearMap := by
    apply IsLocalizedModule.linearMap_ext S a b
    apply LinearMap.ext
    intro m
    rw [LinearMap.comp_apply, LinearMap.comp_apply, ← LinearMap.comp_apply, hh,
      LinearEquiv.coe_toLinearMap, IsLocalizedModule.linearEquiv_apply]
  rw [heq]
  exact (IsLocalizedModule.linearEquiv S a b).bijective