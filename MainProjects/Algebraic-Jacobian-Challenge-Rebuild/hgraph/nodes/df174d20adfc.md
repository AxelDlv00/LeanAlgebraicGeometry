---
author: sync
content_type: theorem
created: '2026-07-19T16:01:13'
decl: AlgebraicGeometry.subsingleton_tensor_residueField_comap_iff
docstring: '(Implementation) **The residue-field seam of a localization**: for a localization

  `R''` of `S₀` at a submonoid, a prime `q` of `R''` over `comap q`, and an `R''`-algebra

  structure on `κ(comap q)` in the `S₀`-tower, the fibre conditions of an `R''`-module
  at

  `κ(comap q)` and at `κ(q)` agree — mathlib''s residue-field comparison

  `Ideal.ResidueField.map` is bijective (localizations are surjective on stalks) and

  `R''`-linear (`IsLocalization.ringHom_ext`).'
file: AlgebraicJacobian/Picard/DivisorFamilyH1Locus.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.subsingleton_tensor_residueField_comap_iff
type: lean
updated: '2026-07-31T20:14:51'
---
private theorem subsingleton_tensor_residueField_comap_iff
    {S₀ R' : Type u} [CommRing S₀] [CommRing R'] [Algebra S₀ R'] (M₀ : Submonoid S₀)
    [IsLocalization M₀ R'] (M : Type u) [AddCommGroup M] [Module R' M]
    (q : PrimeSpectrum R')
    [Algebra R' (PrimeSpectrum.comap (algebraMap S₀ R') q).asIdeal.ResidueField]
    [IsScalarTower S₀ R'
      (PrimeSpectrum.comap (algebraMap S₀ R') q).asIdeal.ResidueField] :
    Subsingleton (M ⊗[R']
        (PrimeSpectrum.comap (algebraMap S₀ R') q).asIdeal.ResidueField) ↔
      Subsingleton (M ⊗[R'] q.asIdeal.ResidueField) := by
  have hcom : (PrimeSpectrum.comap (algebraMap S₀ R') q).asIdeal
      = q.asIdeal.comap (algebraMap S₀ R') := rfl
  refine subsingleton_tensor_congr_of_bijective
    (Ideal.ResidueField.map _ q.asIdeal (algebraMap S₀ R') hcom) ?_ ?_
  · refine IsLocalization.ringHom_ext M₀ (RingHom.ext fun s => ?_)
    rw [RingHom.comp_apply, RingHom.comp_apply, RingHom.comp_apply,
      ← IsScalarTower.algebraMap_apply S₀ R', Ideal.ResidueField.map_algebraMap]
  · exact (RingHom.surjectiveOnStalks_of_isLocalization (M := M₀)
      R').residueFieldMap_bijective _ q.asIdeal hcom