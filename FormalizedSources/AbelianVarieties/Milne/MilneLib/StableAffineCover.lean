/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.AffineScheme

/-!
# Finite affine refinements

This file supplies the finite basic-open refinement used when constructing
quotients by finite groups.  It is deliberately independent of a particular
group action: the non-affine quotient and its gluing data still require
additional hypotheses and are not claimed here.
-/

set_option autoImplicit false

universe w u

open CategoryTheory AlgebraicGeometry TopologicalSpace

namespace MilneLib

/-! ## Finite intersections and products of basic opens -/

/-- Membership in a finite infimum of opens is membership in every member. -/
lemma mem_finset_inf {α : Type*} [TopologicalSpace α] {ι : Type*} {s : Finset ι}
    {F : ι → Opens α} {x : α} :
    x ∈ s.inf F ↔ ∀ i ∈ s, x ∈ F i := by
  classical
  induction s using Finset.cons_induction with
  | empty => simp
  | cons a t ha ih => simp [Opens.mem_inf, ih]

/-- The preimage of a finite infimum of opens is the finite infimum of the
preimages. -/
lemma preimage_finset_inf {X Y : Scheme.{u}} (h : X ⟶ Y) {ι : Type*} (s : Finset ι)
    (F : ι → Y.Opens) :
    h ⁻¹ᵁ s.inf F = s.inf fun i => h ⁻¹ᵁ F i := by
  classical
  induction s using Finset.cons_induction with
  | empty => simp
  | cons a t ha ih => rw [Finset.inf_cons, Finset.inf_cons, h.preimage_inf, ih]

/-- The basic open of a nonempty finite product is the finite infimum of the
basic opens of its factors. -/
lemma basicOpen_finset_prod {X : Scheme.{u}} {V : X.Opens} {ι : Type*} {s : Finset ι}
    (hs : s.Nonempty) (g : ι → Γ(X, V)) :
    X.basicOpen (∏ i ∈ s, g i) = s.inf fun i => X.basicOpen (g i) := by
  induction hs using Finset.Nonempty.cons_induction with
  | singleton a => simp
  | cons a t ha ht ih => rw [Finset.prod_cons, Scheme.basicOpen_mul, ih, Finset.inf_cons]

/-! ## Finite prime avoidance -/

/-- **Finite prime avoidance in `Spec R`**: finitely many points of an open
lie in a common basic open contained in that open. -/
theorem exists_mem_basicOpen_le_of_finite {R : Type*} [CommRing R]
    (W : Opens (PrimeSpectrum R)) {ι : Type*} [Finite ι]
    (p : ι → PrimeSpectrum R) (hp : ∀ i, p i ∈ W) :
    ∃ f : R, (∀ i, p i ∈ PrimeSpectrum.basicOpen f) ∧ PrimeSpectrum.basicOpen f ≤ W := by
  classical
  obtain ⟨c, hc⟩ := (PrimeSpectrum.isOpen_iff (W : Set (PrimeSpectrum R))).mp W.2
  have hWc : (W : Set (PrimeSpectrum R)) = (PrimeSpectrum.zeroLocus c)ᶜ := by
    rw [← hc, compl_compl]
  cases isEmpty_or_nonempty ι with
  | inl h =>
    refine ⟨0, fun i => (h.false i).elim, ?_⟩
    rw [PrimeSpectrum.basicOpen_zero]
    exact bot_le
  | inr h =>
    cases nonempty_fintype ι
    have hnle : ∀ i, ¬Ideal.span c ≤ (p i).asIdeal := by
      intro i hle
      have hpi : p i ∈ (PrimeSpectrum.zeroLocus c)ᶜ := by
        rw [← hWc]
        exact hp i
      exact hpi ((PrimeSpectrum.mem_zeroLocus _ _).mpr (Ideal.span_le.mp hle))
    obtain ⟨f, hfc, hf⟩ : ∃ f ∈ Ideal.span c, ∀ i, f ∉ (p i).asIdeal := by
      by_contra habs
      push Not at habs
      have hsub : (Ideal.span c : Set R) ⊆
          ⋃ i ∈ ((Finset.univ : Finset ι) : Set ι), ((p i).asIdeal : Set R) := by
        intro f hf
        obtain ⟨i, hi⟩ := habs f hf
        exact Set.mem_biUnion (Finset.mem_coe.mpr (Finset.mem_univ i)) hi
      obtain ⟨i, -, hle⟩ := (Ideal.subset_union_prime h.some h.some
        fun i _ _ _ => (p i).isPrime).mp hsub
      exact hnle i hle
    refine ⟨f, fun i => (PrimeSpectrum.mem_basicOpen f (p i)).mpr (hf i), fun q hq => ?_⟩
    have hq' : f ∉ q.asIdeal := (PrimeSpectrum.mem_basicOpen f q).mp hq
    rw [← SetLike.mem_coe, hWc]
    intro hzl
    exact hq' (Ideal.span_le.mpr ((PrimeSpectrum.mem_zeroLocus _ _).mp hzl) hfc)

/-- **Finite prime avoidance in an affine open of a scheme**: finitely many
points lying in an affine open `U` and an open `V` admit a common basic open
of `U` contained in `V`. -/
theorem exists_basicOpen_le_of_finite {X : Scheme.{u}} {U : X.Opens}
    (hU : IsAffineOpen U) {V : X.Opens} {ι : Type*} [Finite ι]
    (y : ι → X) (hyU : ∀ i, y i ∈ U) (hyV : ∀ i, y i ∈ V) :
    ∃ s : Γ(X, U), (∀ i, y i ∈ X.basicOpen s) ∧ X.basicOpen s ≤ V := by
  obtain ⟨s, hmem, hle⟩ := exists_mem_basicOpen_le_of_finite (hU.fromSpec ⁻¹ᵁ V)
    (fun i => hU.primeIdealOf ⟨y i, hyU i⟩)
    (fun i => by
      change hU.fromSpec (hU.primeIdealOf ⟨y i, hyU i⟩) ∈ V
      rw [hU.fromSpec_primeIdealOf]
      exact hyV i)
  refine ⟨s, fun i => ?_, ?_⟩
  · have h := hmem i
    rw [← hU.fromSpec_preimage_basicOpen] at h
    have h2 : hU.fromSpec (hU.primeIdealOf ⟨y i, hyU i⟩) ∈ X.basicOpen s := h
    rwa [hU.fromSpec_primeIdealOf] at h2
  · rw [← hU.fromSpec_image_basicOpen]
    exact (hU.fromSpec.image_mono hle).trans (hU.fromSpec.image_preimage_le V)

/-! ## Stable affine neighborhoods for finite group actions -/

namespace StableGroupAction

variable {G : Type w} [Group G] [Finite G] {X : Scheme.{u}} (act : G →* Aut X)

/-- The orbit-in-affine hypothesis for a finite group acting on a scheme. -/
def OrbitsInAffineOpen : Prop :=
  ∀ x : X, ∃ U : X.affineOpens, ∀ g : G, (act g).hom.base x ∈ U.1

/-- An open subscheme preserved by every element of the action. -/
def IsStableOpen (U : X.Opens) : Prop :=
  ∀ g : G, (act g).hom ⁻¹ᵁ U = U

omit [Finite G] in
lemma act_one_hom : (act 1).hom = 𝟙 X := by
  rw [map_one]
  rfl

omit [Finite G] in
lemma act_mul_hom (g t : G) :
    (act (g * t)).hom = (act t).hom ≫ (act g).hom := by
  rw [map_mul]
  rfl

/-- If every orbit of a finite group action lies in an affine open, then every
point has an affine open neighborhood preserved by the whole group. -/
theorem exists_stable_affineOpen_of_orbits (h : OrbitsInAffineOpen act) (x : X) :
    ∃ U : X.Opens, IsAffineOpen U ∧ x ∈ U ∧ IsStableOpen act U := by
  classical
  letI : Fintype G := Fintype.ofFinite G
  obtain ⟨U, hxU⟩ := h x
  have horb : ∀ t g : G, (act g).hom.base ((act t).hom.base x) ∈ U.1 := by
    intro t g
    have hh : (act g).hom.base ((act t).hom.base x) =
        (act (g * t)).hom.base x := by
      rw [act_mul_hom act g t]
      rfl
    rw [hh]
    exact hxU (g * t)
  obtain ⟨s, hs_mem, hs_le⟩ := exists_basicOpen_le_of_finite U.2
    (fun g : G => (act g).hom.base x) hxU
    (V := Finset.univ.inf fun g : G => (act g).hom ⁻¹ᵁ U.1)
    (fun t => mem_finset_inf.mpr fun g _ => horb t g)
  have hWle : ∀ g : G,
      (Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) ≤
        (act g).hom ⁻¹ᵁ U.1 :=
    fun g => Finset.inf_le (Finset.mem_univ g)
  set t : G → Γ(X, Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) :=
    fun g => X.presheaf.map (homOfLE (hWle g)).op ((act g).hom.app U.1 s) with ht
  set N : Γ(X, Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) :=
    ∏ g : G, t g with hN
  have hbo_t : ∀ g : G, X.basicOpen (t g) =
      (Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) ⊓
        (act g).hom ⁻¹ᵁ X.basicOpen s := by
    intro g
    rw [ht, Scheme.basicOpen_res, ← Scheme.preimage_basicOpen]
  have hP1 : (act (1 : G)).hom ⁻¹ᵁ X.basicOpen s = X.basicOpen s := by
    rw [act_one_hom act]
    rfl
  have hbo_N : X.basicOpen N =
      Finset.univ.inf fun g : G => (act g).hom ⁻¹ᵁ X.basicOpen s := by
    rw [hN, basicOpen_finset_prod ⟨1, Finset.mem_univ 1⟩,
      Finset.inf_congr rfl fun g _ => hbo_t g]
    refine le_antisymm
      (Finset.le_inf fun g _ => (Finset.inf_le (Finset.mem_univ g)).trans inf_le_right)
      (Finset.le_inf fun g _ => le_inf (le_trans ?_ hs_le)
        (Finset.inf_le (Finset.mem_univ g)))
    exact le_of_le_of_eq (Finset.inf_le (Finset.mem_univ 1)) hP1
  have hNs : X.basicOpen N ≤ X.basicOpen s := by
    rw [hbo_N]
    exact le_of_le_of_eq (Finset.inf_le (Finset.mem_univ 1)) hP1
  refine ⟨X.basicOpen N, ?_, ?_, ?_⟩
  · have heq : X.basicOpen (X.presheaf.map (homOfLE hs_le).op N) =
        X.basicOpen N := by
      rw [Scheme.basicOpen_res]
      exact inf_eq_right.mpr hNs
    rw [← heq]
    exact (U.2.basicOpen s).basicOpen _
  · rw [hbo_N, mem_finset_inf]
    intro g _
    change (act g).hom.base x ∈ X.basicOpen s
    exact hs_mem g
  · intro a
    rw [hbo_N, preimage_finset_inf]
    have hPa : ∀ g : G,
        (act a).hom ⁻¹ᵁ ((act g).hom ⁻¹ᵁ X.basicOpen s) =
          (act (g * a)).hom ⁻¹ᵁ X.basicOpen s := by
      intro g
      rw [act_mul_hom act]
      rfl
    rw [Finset.inf_congr rfl fun g _ => hPa g]
    refine le_antisymm (Finset.le_inf fun d _ => ?_) (Finset.le_inf fun d _ => ?_)
    · have hh := Finset.inf_le (s := Finset.univ)
          (f := fun g : G => (act (g * a)).hom ⁻¹ᵁ X.basicOpen s)
          (Finset.mem_univ (d * a⁻¹))
      rwa [inv_mul_cancel_right] at hh
    · exact Finset.inf_le (Finset.mem_univ (d * a))

end StableGroupAction

end MilneLib
