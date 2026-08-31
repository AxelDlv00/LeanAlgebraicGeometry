/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Morphisms.Finite
import Mathlib.AlgebraicGeometry.Morphisms.SchemeTheoreticallyDominant
import Mathlib.AlgebraicGeometry.AffineSpace
import Mathlib.Algebra.Module.SpanRankOperations
import Mathlib.Order.CompletePartialOrder
import Mathlib.RingTheory.KrullDimension.Basic
import Mathlib.RingTheory.Ideal.GoingUp
import Mathlib.RingTheory.Ideal.KrullsHeightTheorem
import Mathlib.RingTheory.Spectrum.Prime.Topology

/-!
# Dimension infrastructure

These lemmas isolate the commutative-algebra part of Milne's dimension
arguments.  The affine-scheme adapter is deliberately conditional; the
proper abelian-variety case still needs a separate global dimension theorem.
-/

set_option autoImplicit false

universe v u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj
  MorphismProperty
open AlgebraicGeometry

namespace MilneLib

/-- Passing to an open neighbourhood does not change the coheight of a point. -/
theorem coheight_eq_of_isOpenEmbedding
    {X : Type*} [TopologicalSpace X] {U : Set X} (hU : IsOpen U)
    (z : X) (hz : z ∈ U) :
    @Order.coheight X (specializationPreorder X) z =
      @Order.coheight U (specializationPreorder U) ⟨z, hz⟩ := by
  letI : Preorder X := specializationPreorder X
  letI : Preorder U := specializationPreorder U
  have hmono : Monotone (Subtype.val : U → X) :=
    continuous_subtype_val.specialization_monotone
  have hstrict : StrictMono (Subtype.val : U → X) := by
    intro a b hab
    refine ⟨hmono hab.le, fun h => ?_⟩
    apply hab.not_ge
    change a ⤳ b
    exact (subtype_specializes_iff a b).mpr h
  apply le_antisymm
  · refine Order.coheight_le_iff'.mpr ?_
    intro p hphead
    have hmem : ∀ i, p i ∈ U := by
      intro i
      have hle : z ≤ p i := by
        have := p.head_le i
        rwa [hphead] at this
      exact Specializes.mem_open (show p i ⤳ z from hle) hU hz
    let q : LTSeries U :=
      { length := p.length
        toFun := fun i => ⟨p i, hmem i⟩
        step := by
          intro i
          have hlt : p i.castSucc < p i.succ := p.step i
          have hspec : p i.succ ⤳ p i.castSucc := hlt.le
          have hsub : (⟨p i.succ, hmem _⟩ : U) ⤳ ⟨p i.castSucc, hmem _⟩ :=
            (subtype_specializes_iff _ _).mpr hspec
          refine ⟨hsub, fun hbad => ?_⟩
          apply hlt.not_ge
          exact (subtype_specializes_iff _ _).mp hbad }
    have hqhead : q.head = ⟨z, hz⟩ := by
      apply Subtype.ext
      exact hphead
    have hbound := Order.length_le_coheight
      (x := (⟨z, hz⟩ : U)) (p := q) (by rw [hqhead])
    simpa using hbound
  · simpa using Order.coheight_le_coheight_apply_of_strictMono
      (Subtype.val : U → X) hstrict ⟨z, hz⟩

/-- Coheight in an affine scheme is height in its prime spectrum. -/
theorem coheight_spec_eq_height_primeSpectrum
    {R : CommRingCat} (p : Spec R) :
    Order.coheight (α := Spec R) p =
      Order.height (α := PrimeSpectrum R) ⟨p.asIdeal, p.isPrime⟩ := by
  let e : Spec R ≃o (PrimeSpectrum R)ᵒᵈ :=
    { toFun := fun q => OrderDual.toDual ⟨q.asIdeal, q.isPrime⟩
      invFun := fun q => (OrderDual.ofDual q : PrimeSpectrum R)
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl
      map_rel_iff' := by
        intro a b
        exact (AlgebraicGeometry.AffineSpace.spec_le_iff R a b).symm }
  have h : Order.coheight (α := (PrimeSpectrum R)ᵒᵈ) (e p) =
      Order.coheight (α := Spec R) p :=
    Order.coheight_orderIso e p
  rw [← h]
  rfl

/-- The Krull dimension of a scheme stalk is the coheight of its point. -/
theorem ringKrullDim_stalk_eq_coheight (X : Scheme.{u}) (z : X) :
    ringKrullDim (X.presheaf.stalk z) = Order.coheight z := by
  obtain ⟨U, hU, hzU, _⟩ :=
    exists_isAffineOpen_mem_and_subset (X := X) (x := z) (U := ⊤) (by trivial)
  set p : PrimeSpectrum Γ(X, U) := hU.primeIdealOf ⟨z, hzU⟩ with hp
  letI : Algebra Γ(X, U) (X.presheaf.stalk z) :=
    TopCat.Presheaf.algebra_section_stalk X.presheaf ⟨z, hzU⟩
  haveI hloc : IsLocalization.AtPrime (X.presheaf.stalk z) p.asIdeal :=
    hU.isLocalization_stalk ⟨z, hzU⟩
  have hdim : ringKrullDim (X.presheaf.stalk z) =
      (Order.height (α := PrimeSpectrum Γ(X, U)) p : WithBot ℕ∞) := by
    rw [IsLocalization.AtPrime.ringKrullDim_eq_height
          (R := Γ(X, U)) p.asIdeal (X.presheaf.stalk z),
      PrimeSpectrum.height_eq_orderHeight p]
  have hopen : Order.coheight (α := X) z =
      Order.coheight (α := U.toScheme) ⟨z, hzU⟩ :=
    coheight_eq_of_isOpenEmbedding (X := X) (U := U.1) U.isOpen z hzU
  let hHomeo : U.toScheme ≃ₜ Spec Γ(X, U) :=
    TopCat.homeoOfIso (Scheme.forgetToTop.mapIso hU.isoSpec)
  let eOrder : U.toScheme ≃o Spec Γ(X, U) :=
    { toEquiv := hHomeo.toEquiv
      map_rel_iff' := by
        intro a b
        constructor
        · intro h
          have hsp : hHomeo b ⤳ hHomeo a := h
          have hsp' := hsp.map hHomeo.symm.continuous
          change hHomeo.symm (hHomeo b) ⤳ hHomeo.symm (hHomeo a) at hsp'
          rw [hHomeo.symm_apply_apply, hHomeo.symm_apply_apply] at hsp'
          exact (hsp' : a ≤ b)
        · intro h
          have hsp : b ⤳ a := h
          exact (hsp.map hHomeo.continuous : hHomeo a ≤ hHomeo b) }
  have hiso : Order.coheight (α := U.toScheme) ⟨z, hzU⟩ =
      Order.coheight (α := Spec Γ(X, U)) (eOrder ⟨z, hzU⟩) :=
    (Order.coheight_orderIso eOrder ⟨z, hzU⟩).symm
  have heq : eOrder ⟨z, hzU⟩ = p := rfl
  have haff : Order.coheight (α := Spec Γ(X, U)) p =
      Order.height (α := PrimeSpectrum Γ(X, U))
        ⟨p.asIdeal, p.isPrime⟩ :=
    coheight_spec_eq_height_primeSpectrum p
  have hp' : (⟨p.asIdeal, p.isPrime⟩ : PrimeSpectrum Γ(X, U)) = p := rfl
  rw [hdim, hopen, hiso, heq, haff, hp']

/-- The dimension of a scheme is the supremum of the dimensions of its stalks. -/
theorem topologicalKrullDim_eq_iSup_ringKrullDim_stalk (X : Scheme.{u}) :
    topologicalKrullDim X = ⨆ z : X, ringKrullDim (X.presheaf.stalk z) := by
  have h : topologicalKrullDim X =
      ⨆ z : X, (Order.coheight z : WithBot ℕ∞) := by
    unfold topologicalKrullDim
    rw [Order.krullDim_eq_of_orderIso (irreducibleSetEquivPoints (α := X))]
    exact Order.krullDim_eq_iSup_coheight
  rw [h]
  exact iSup_congr fun z => (ringKrullDim_stalk_eq_coheight X z).symm

/-- Uniform upper bounds on stalk dimensions bound the scheme dimension. -/
theorem topologicalKrullDim_le_of_forall_ringKrullDim_stalk_le
    (X : Scheme.{u}) (d : WithBot ℕ∞)
    (h : ∀ z : X, ringKrullDim (X.presheaf.stalk z) ≤ d) :
    topologicalKrullDim X ≤ d := by
  rw [topologicalKrullDim_eq_iSup_ringKrullDim_stalk X]
  exact iSup_le h

/-- The dimension of any stalk is bounded by the dimension of the scheme. -/
theorem ringKrullDim_stalk_le_topologicalKrullDim
    (X : Scheme.{u}) (z : X) :
    ringKrullDim (X.presheaf.stalk z) ≤ topologicalKrullDim X := by
  rw [topologicalKrullDim_eq_iSup_ringKrullDim_stalk X]
  exact le_iSup (fun z : X => ringKrullDim (X.presheaf.stalk z)) z

/-- A uniform upper bound and a matching stalk witness determine dimension. -/
theorem topologicalKrullDim_eq_of_le_of_exists_ge
    (X : Scheme.{u}) (d : WithBot ℕ∞)
    (hle : ∀ z : X, ringKrullDim (X.presheaf.stalk z) ≤ d)
    (z₀ : X) (hz₀ : d ≤ ringKrullDim (X.presheaf.stalk z₀)) :
    topologicalKrullDim X = d :=
  le_antisymm (topologicalKrullDim_le_of_forall_ringKrullDim_stalk_le X d hle)
    (hz₀.trans (ringKrullDim_stalk_le_topologicalKrullDim X z₀))

/-- The Krull dimension of a Noetherian local ring is bounded by the dimension
of its cotangent space over the residue field. -/
theorem ringKrullDim_le_finrank_cotangentSpace
    (R : Type u) [CommRing R] [IsLocalRing R] [IsNoetherianRing R] :
    ringKrullDim R ≤
      ((Module.finrank (IsLocalRing.ResidueField R)
        (IsLocalRing.CotangentSpace R) : ℕ) : WithBot ℕ∞) := by
  rw [← IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace R]
  exact ringKrullDim_le_spanFinrank_maximalIdeal R

/-- At a point of a locally Noetherian scheme, the stalk dimension is bounded
by the dimension of its cotangent space. -/
theorem ringKrullDim_stalk_le_finrank_cotangentSpace
    (X : Scheme.{u}) [IsLocallyNoetherian X] (z : X) :
    ringKrullDim (X.presheaf.stalk z) ≤
      ((Module.finrank (IsLocalRing.ResidueField (X.presheaf.stalk z))
        (IsLocalRing.CotangentSpace (X.presheaf.stalk z)) : ℕ) :
          WithBot ℕ∞) :=
  ringKrullDim_le_finrank_cotangentSpace _

/-- A uniform upper bound on cotangent-space dimensions bounds the dimension
of a locally Noetherian scheme. -/
theorem topologicalKrullDim_le_of_forall_finrank_cotangentSpace_le
    (X : Scheme.{u}) [IsLocallyNoetherian X] (d : ℕ)
    (h : ∀ z : X,
      Module.finrank (IsLocalRing.ResidueField (X.presheaf.stalk z))
        (IsLocalRing.CotangentSpace (X.presheaf.stalk z)) ≤ d) :
    topologicalKrullDim X ≤ (d : WithBot ℕ∞) :=
  topologicalKrullDim_le_of_forall_ringKrullDim_stalk_le X _ fun z =>
    le_trans (ringKrullDim_stalk_le_finrank_cotangentSpace X z)
      (by exact_mod_cast Nat.cast_le.mpr (h z))

/-- An injective integral extension preserves Krull dimension. -/
theorem ringKrullDim_eq_of_isIntegral_of_injective
    {R : Type u} {S : Type v} [CommRing R] [CommRing S]
    (f : R →+* S) (hfin : f.IsIntegral)
    (hinj : Function.Injective f) :
    ringKrullDim S = ringKrullDim R := by
  letI : Algebra R S := f.toAlgebra
  haveI : Algebra.IsIntegral R S := ⟨hfin⟩
  let c : PrimeSpectrum S → PrimeSpectrum R := PrimeSpectrum.comap f
  have hc_strict : StrictMono c := by
    intro I J hIJ
    change I.asIdeal < J.asIdeal at hIJ
    change Ideal.comap f I.asIdeal < Ideal.comap f J.asIdeal
    exact Ideal.IsIntegral.comap_lt_comap hIJ
  have hcoheight (I : PrimeSpectrum S) :
      Order.coheight I = Order.coheight (c I) := by
    apply Order.coheight_eq_of_strictMono c hc_strict
    intro a b hab
    obtain ⟨Q, haQ, hQprime, hQcomap⟩ :=
      Ideal.exists_ideal_over_prime_of_isIntegral_of_isPrime
        b.asIdeal a.asIdeal hab.le
    let q : PrimeSpectrum S := ⟨Q, hQprime⟩
    refine ⟨q, ?_, ?_⟩
    · change a.asIdeal < Q
      refine lt_of_le_of_ne haQ ?_
      intro hEq
      have hcEq : c a = b := by
        apply PrimeSpectrum.ext
        change Ideal.comap f a.asIdeal = b.asIdeal
        simpa [hEq, RingHom.algebraMap_toAlgebra] using hQcomap
      exact (ne_of_lt hab) hcEq
    · apply PrimeSpectrum.ext
      change Ideal.comap f Q = b.asIdeal
      simpa only [RingHom.algebraMap_toAlgebra] using hQcomap
  change Order.krullDim (PrimeSpectrum S) =
    Order.krullDim (PrimeSpectrum R)
  apply le_antisymm
  · exact Order.krullDim_le_of_strictMono c hc_strict
  · rw [Order.krullDim_eq_iSup_coheight,
        Order.krullDim_eq_iSup_coheight]
    apply iSup_le
    intro p
    obtain ⟨q, hq⟩ := hfin.comap_surjective hinj p
    rw [← hq, ← hcoheight q]
    exact le_iSup
      (fun q : PrimeSpectrum S =>
        (Order.coheight q : WithBot ℕ∞)) q

/-- A finite surjective morphism to an affine reduced scheme preserves
Krull dimension.  Finiteness makes the source affine, so the assertion is
reduced to the integral injective map on global sections. -/
theorem topologicalKrullDim_eq_of_isFinite_surjective_of_isAffineTarget
    {X Y : Scheme.{u}} [IsAffine Y]
    (f : X ⟶ Y) [IsFinite f] [Surjective f] [IsReduced Y] :
    topologicalKrullDim X = topologicalKrullDim Y := by
  letI : IsAffine X := isAffine_of_isAffineHom f
  letI : IsSchemeTheoreticallyDominant f :=
    IsSchemeTheoreticallyDominant.of_isDominant f
  rw [IsHomeomorph.topologicalKrullDim_eq X.isoSpec.hom
        X.isoSpec.hom.homeomorph.isHomeomorph,
      IsHomeomorph.topologicalKrullDim_eq Y.isoSpec.hom
        Y.isoSpec.hom.homeomorph.isHomeomorph]
  change topologicalKrullDim (PrimeSpectrum Γ(X, ⊤)) =
    topologicalKrullDim (PrimeSpectrum Γ(Y, ⊤))
  rw [PrimeSpectrum.topologicalKrullDim_eq_ringKrullDim,
      PrimeSpectrum.topologicalKrullDim_eq_ringKrullDim]
  exact ringKrullDim_eq_of_isIntegral_of_injective
    (f.appTop).hom f.finite_appTop.to_isIntegral (f.app_injective ⊤)

end MilneLib
