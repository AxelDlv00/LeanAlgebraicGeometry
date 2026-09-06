/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import Mathlib.AlgebraicGeometry.Morphisms.Finite
import Mathlib.RingTheory.Unramified.LocalRing

/-!
# Finite stalk maps for injective finite morphisms

A finite morphism injective on scheme points has finite maps on local rings.
Injectivity identifies each prime as the unique prime above its contraction,
so localization preserves module finiteness at that prime.
For finite local-ring maps, Nakayama then turns surjectivity on residue fields
and generation of the target maximal ideal into surjectivity of the ring map.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry TopologicalSpace

namespace Hartshorne

/-- A finite ring map injective on prime spectra induces finite local-ring maps.
The localization argument adapts `StacksPart01.finite_localRingHom_of_unique_primesOver`.
-/
theorem finite_localRingHom_of_injective_comap
    {R S : Type u} [CommRing R] [CommRing S] (f : R →+* S)
    (hf : f.Finite) (hinj : Function.Injective (PrimeSpectrum.comap f))
    (q : PrimeSpectrum S) :
    (Localization.localRingHom (q.comap f).asIdeal q.asIdeal f rfl).Finite := by
  letI := f.toAlgebra
  letI : Module.Finite R S := hf
  let p := (q.comap f).asIdeal
  letI : q.asIdeal.LiesOver p := ⟨rfl⟩
  have hq : p.primesOver S = {q.asIdeal} := by
    ext J
    constructor
    · intro hJ
      haveI : J.IsPrime := hJ.1
      haveI : J.LiesOver p := hJ.2
      have h : (⟨J, hJ.1⟩ : PrimeSpectrum S) = q :=
        hinj (PrimeSpectrum.ext (J.over_def p).symm)
      simpa only [Set.mem_singleton_iff] using congrArg PrimeSpectrum.asIdeal h
    · rintro rfl
      exact ⟨q.isPrime, ⟨rfl⟩⟩
  letI := Localization.AtPrime.algebraOfLiesOver p q.asIdeal
  change Module.Finite (Localization.AtPrime p) (Localization.AtPrime q.asIdeal)
  exact Localization.finite_of_primesOver_eq_singleton hq

set_option backward.isDefEq.respectTransparency false in
/-- Every stalk map of an injective finite morphism is a finite ring map. -/
theorem finite_stalkMap_of_injective {X Y : Scheme.{u}} (f : X ⟶ Y) [IsFinite f]
    (hf : Function.Injective f) (x : X) : (f.stalkMap x).hom.Finite := by
  wlog hY : IsAffine Y generalizing X Y f
  · obtain ⟨U, hU, hfx, _⟩ := Opens.isBasis_iff_nbhd.mp Y.isBasis_affineOpens
      (Opens.mem_top <| f x)
    rw [← RingHom.finite_respectsIso.arrow_mk_iso_iff
      (morphismRestrictStalkMap f U ⟨x, hfx⟩)]
    refine this (f ∣_ U) ?_ ⟨x, hfx⟩ hU
    intro a b hab
    apply Subtype.ext
    apply hf
    simpa only [morphismRestrict_base_coe] using congrArg Subtype.val hab
  letI : IsAffine X := isAffine_of_isAffineHom f
  wlog hXY : ∃ R S, Y = Spec R ∧ X = Spec S generalizing X Y
  · have h : ((X.isoSpec.inv ≫ f ≫ Y.isoSpec.hom).stalkMap
        (X.isoSpec.hom x)).hom.Finite := by
      refine this _ ?_ _ inferInstance ?_
      · exact Y.isoSpec.hom.homeomorph.injective.comp
          (hf.comp X.isoSpec.inv.homeomorph.injective)
      · exact ⟨_, _, rfl, rfl⟩
    rw [Scheme.Hom.stalkMap_comp, Scheme.Hom.stalkMap_comp, CommRingCat.hom_comp,
      RingHom.finite_respectsIso.cancel_right_isIso, CommRingCat.hom_comp,
      RingHom.finite_respectsIso.cancel_left_isIso] at h
    have heq : X.isoSpec.inv (X.isoSpec.hom x) = x := by simp
    rwa [RingHom.finite_respectsIso.arrow_mk_iso_iff (f.arrowStalkMapIsoOfEq heq)] at h
  obtain ⟨R, S, rfl, rfl⟩ := hXY
  obtain ⟨φ, rfl⟩ := Spec.map_surjective f
  rw [RingHom.finite_respectsIso.arrow_mk_iso_iff (Scheme.arrowStalkMapSpecIso φ x)]
  exact finite_localRingHom_of_injective_comap φ.hom
    ((IsFinite.SpecMap_iff φ).mp inferInstance) hf x

set_option backward.isDefEq.respectTransparency false in
/-- A finite local-ring map is surjective if its residue-field map is surjective
and the source maximal ideal generates the target maximal ideal. -/
theorem surjective_of_finite_of_map_maximalIdeal_eq_of_residueFieldMap_surjective
    {R S : Type*} [CommRing R] [CommRing S] [IsLocalRing R] [IsLocalRing S]
    (f : R →+* S) [IsLocalHom f] (hfin : f.Finite)
    (hmax : Ideal.map f (IsLocalRing.maximalIdeal R) = IsLocalRing.maximalIdeal S)
    (hres : Function.Surjective (IsLocalRing.ResidueField.map f)) :
    Function.Surjective f := by
  letI := f.toAlgebra
  letI : Module.Finite R S := hfin
  change Ideal.map (algebraMap R S) (IsLocalRing.maximalIdeal R) =
    IsLocalRing.maximalIdeal S at hmax
  change Function.Surjective (Algebra.linearMap R S)
  rw [← LinearMap.range_eq_top, ← top_le_iff]
  refine Submodule.le_of_le_smul_of_le_jacobson_bot (R := R) (M := S)
    (I := IsLocalRing.maximalIdeal R) (Module.Finite.fg_top (R := R) (M := S))
    (IsLocalRing.maximalIdeal_le_jacobson _) ?_
  rw [Ideal.smul_top_eq_map, hmax]
  rintro x -
  obtain ⟨a, ha⟩ := hres (IsLocalRing.residue S x)
  obtain ⟨a, rfl⟩ := IsLocalRing.residue_surjective a
  rw [IsLocalRing.ResidueField.map_residue, ← sub_eq_zero, ← map_sub,
    IsLocalRing.residue_eq_zero_iff] at ha
  rw [← sub_sub_self (f a) x]
  exact sub_mem (Submodule.mem_sup_left ⟨a, rfl⟩) (Submodule.mem_sup_right ha)

end Hartshorne
