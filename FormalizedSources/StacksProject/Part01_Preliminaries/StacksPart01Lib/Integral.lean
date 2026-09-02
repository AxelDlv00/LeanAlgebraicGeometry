/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.RingTheory.IntegralClosure.IsIntegral.Basic
import Mathlib.RingTheory.IntegralClosure.IsIntegralClosure.Basic
import Mathlib.RingTheory.IntegralClosure.IntegrallyClosed

/-!
# Integral elements and towers

This file packages the element-level transport statements used throughout the
finite and integral extension sections of the Stacks Project.  The underlying
predicates are Mathlib's `RingHom.IsIntegralElem` and `IsIntegral`.
-/

namespace StacksPart01

/-! ### Transport of integral elements -/

/-- Integral elements remain integral after applying a ring homomorphism. -/
theorem integralElem_map
    {R S T : Type*} [CommRing R] [Ring S] [Ring T]
    (f : R →+* S) (g : S →+* T) {x : S}
    (hx : f.IsIntegralElem x) :
    (g.comp f).IsIntegralElem (g x) := by
  exact hx.map g

/-- Along an injective ring map, integrality of an image is equivalent to
integrality of the original element. -/
theorem integralElem_map_iff_of_injective
    {R S T : Type*} [CommRing R] [Ring S] [Ring T]
    (f : R →+* S) (g : S →+* T) (hg : Function.Injective g) {x : S} :
    (g.comp f).IsIntegralElem (g x) ↔ f.IsIntegralElem x := by
  exact RingHom.IsIntegralElem.map_iff hg

/-- If an element is integral for a composite map, it is integral for the
second map. -/
theorem integralElem_of_comp
    {R S T : Type*} [CommRing R] [CommRing S] [Ring T]
    (f : R →+* S) (g : S →+* T) {x : T}
    (hx : (g.comp f).IsIntegralElem x) :
    g.IsIntegralElem x := by
  exact RingHom.IsIntegralElem.of_comp hx

/-! ### Cancellation in towers -/

/-- If a composite ring map is integral, then its second factor is integral
(Stacks, Tag 02JM). -/
theorem ringHom_isIntegral_of_comp
    {R S T : Type*} [CommRing R] [CommRing S] [CommRing T]
    (f : R →+* S) (g : S →+* T)
    (h : (g.comp f).IsIntegral) : g.IsIntegral := by
  exact RingHom.IsIntegral.tower_top f g h

/-- If the second map is injective and a composite is integral, then the first
map is integral. -/
theorem ringHom_isIntegral_of_comp_injective
    {R S T : Type*} [CommRing R] [CommRing S] [CommRing T]
    (f : R →+* S) (g : S →+* T) (hg : Function.Injective g)
    (h : (g.comp f).IsIntegral) : f.IsIntegral := by
  exact RingHom.IsIntegral.tower_bot f g hg h

/-! ### Towers and integral closures -/

/-- Integrality is transitive in an algebra tower. -/
theorem isIntegral_tower
    {R A B : Type*} [CommRing R] [CommRing A] [Ring B]
    [Algebra A B] [Algebra R B] [Algebra R A]
    [IsScalarTower R A B] [Algebra.IsIntegral R A]
    (x : B) (hx : IsIntegral A x) : IsIntegral R x := by
  exact isIntegral_trans x hx

/-- For an injective algebra map, an element of the lower algebra is integral
over the base exactly when its image in the upper algebra is. -/
theorem isIntegral_algebraMap_iff_of_injective
    {R A B : Type*} [CommRing R] [CommRing A] [Ring B]
    [Algebra R A] [Algebra R B] [Algebra A B]
    [IsScalarTower R A B] (hAB : Function.Injective (algebraMap A B))
    {x : A} :
    IsIntegral R ((algebraMap A B) x) ↔ IsIntegral R x := by
  exact isIntegral_algebraMap_iff hAB

/-- An integral element in an integrally closed extension comes from the base
ring. -/
theorem exists_algebraMap_eq_of_integral
    {R A : Type*} [CommRing R] [CommRing A] [Algebra R A]
    [IsIntegrallyClosedIn R A] {x : A} (hx : IsIntegral R x) :
    ∃ y : R, algebraMap R A y = x := by
  exact IsIntegrallyClosedIn.algebraMap_eq_of_integral hx

/-! ### Integral closure and localization -/

/-- The integral closure commutes with localization (Stacks, Tag `0307`).

The `IsLocalization` conclusion records the canonical localized-ring model,
which is the type-correct Lean form of the source's equality of subrings. -/
theorem integralClosure_isLocalization
    {R S Rm Sm : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [CommRing Rm] [CommRing Sm] [Algebra R Rm] [Algebra S Sm]
    [Algebra Rm Sm] [Algebra R Sm] [IsScalarTower R S Sm]
    [IsScalarTower R Rm Sm] (M : Submonoid R)
    [IsLocalization M Rm]
    [IsLocalization (Algebra.algebraMapSubmonoid S M) Sm]
    [Algebra (integralClosure R S) (integralClosure Rm Sm)]
    [IsScalarTower (integralClosure R S) (integralClosure Rm Sm) Sm]
    [IsScalarTower R (integralClosure R S) (integralClosure Rm Sm)] :
    IsLocalization (Algebra.algebraMapSubmonoid (integralClosure R S) M)
      (integralClosure Rm Sm) := by
  exact IsLocalization.integralClosure (S := S) (Rf := Rm) (Sf := Sm) M

/-- An element is integral over the base ring exactly when its image is
integral after localization at every prime of the base
(Stacks, Tag `034K`). -/
theorem isIntegral_iff_isIntegral_localizationAtPrime
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S] (x : S) :
    IsIntegral R x ↔ ∀ p : PrimeSpectrum R,
      IsIntegral (Localization.AtPrime p.asIdeal)
        (algebraMap S
          (Localization (Algebra.algebraMapSubmonoid S p.asIdeal.primeCompl)) x) := by
  constructor
  · intro hx p
    obtain ⟨q, hq, hqx⟩ := hx
    change (algebraMap (Localization.AtPrime p.asIdeal)
      (Localization (Algebra.algebraMapSubmonoid S p.asIdeal.primeCompl))).IsIntegralElem _
    rw [localizationAlgebraMap_def]
    apply is_integral_localization_at_leadingCoeff q hqx
    simp [hq.leadingCoeff]
  · intro hlocal
    let t : Set R := {r | IsIntegral R (r • x)}
    have ht : Ideal.span t = ⊤ := by
      by_contra hne
      obtain ⟨P, hPmax, hspanP⟩ := Ideal.ne_top_iff_exists_maximal.mp hne
      letI : P.IsMaximal := hPmax
      letI : P.IsPrime := hPmax.isPrime
      let Rp := Localization.AtPrime P
      let Sp := Localization (Algebra.algebraMapSubmonoid S P.primeCompl)
      have hp : IsIntegral Rp (algebraMap S Sp x) := by
        simpa only [Rp, Sp] using
          hlocal (⟨P, inferInstance⟩ : PrimeSpectrum R)
      obtain ⟨m, hm⟩ := IsIntegral.exists_multiple_integral_of_isLocalization
        (M := P.primeCompl) (algebraMap S Sp x) hp
      have hm' : IsIntegral R (algebraMap S Sp ((m : R) • x)) := by
        have heq : algebraMap S Sp ((m : R) • x) =
            (m : R) • algebraMap S Sp x := by
          simp only [Algebra.smul_def, map_mul,
            ← IsScalarTower.algebraMap_apply R S Sp]
        rw [heq]
        exact hm
      obtain ⟨n, hnM, hn⟩ := IsLocalization.exists_isIntegral_smul_of_isIntegral_map
        (Sₘ := Sp) P.primeCompl hm'
      have hgood : n * (m : R) ∈ t := by
        change IsIntegral R ((n * (m : R)) • x)
        simpa only [mul_smul] using hn
      have hcomp : n * (m : R) ∈ P.primeCompl := mul_mem hnM m.property
      exact hcomp (hspanP (Ideal.subset_span hgood))
    rw [← mem_integralClosure_iff]
    refine Submodule.mem_of_span_eq_top_of_smul_pow_mem
      (integralClosure R S).toSubmodule t ht x ?_
    rintro ⟨r, hr⟩
    refine ⟨1, (mem_integralClosure_iff R S).2 ?_⟩
    change IsIntegral R (r • x) at hr
    simpa only [pow_one] using hr

/-! ### Transitivity of integral closure -/

/-- Taking the integral closure first in an intermediate ring and then in the
top ring produces an integral closure over the original base
(Stacks, Tag `0308`). -/
theorem integralClosure_transitive
    {A B C : Type*} [CommRing A] [CommRing B] [CommRing C]
    [Algebra A B] [Algebra B C] [Algebra A C] [IsScalarTower A B C] :
    IsIntegralClosure
      (integralClosure (integralClosure A B) C) A C := by
  constructor
  · exact Subtype.coe_injective
  · intro x
    exact (show IsIntegral A x ↔ IsIntegral (integralClosure A B) x from
      ⟨fun hx => hx.tower_top, fun hx => isIntegral_trans x hx⟩).trans
        IsIntegralClosure.isIntegral_iff

/-- The iterated and direct integral closures have the same underlying subring
of the top ring (Stacks, Tag `0308`). -/
theorem integralClosure_transitive_toSubring
    {A B C : Type*} [CommRing A] [CommRing B] [CommRing C]
    [Algebra A B] [Algebra B C] [Algebra A C] [IsScalarTower A B C] :
    (integralClosure (integralClosure A B) C).toSubring =
      (integralClosure A C).toSubring := by
  ext x
  exact ⟨fun hx => isIntegral_trans x hx, fun hx => hx.tower_top⟩

end StacksPart01
