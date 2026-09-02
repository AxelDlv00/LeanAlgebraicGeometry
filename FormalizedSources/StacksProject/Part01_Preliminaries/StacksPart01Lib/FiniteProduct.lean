/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.IntegralProduct
import Mathlib.Algebra.Algebra.Pi
import Mathlib.Algebra.Ring.Equiv

/-!
# Integrality in finite products

For a finite family of algebras over one commutative base, integrality is
checked componentwise.  The element-level statement below is the common-base
specialization of the finite-product criterion.
-/

namespace StacksPart01

universe u v w

open scoped BigOperators
open Polynomial

/-- The product of a family of ring maps with possibly different source rings.
The component map is composed with the corresponding projection from the
product source. -/
def _root_.RingHom.piMap {ι : Type*} {R S : ι → Type*}
    [∀ i, NonAssocSemiring (R i)] [∀ i, NonAssocSemiring (S i)]
    (f : ∀ i, R i →+* S i) : (∀ i, R i) →+* (∀ i, S i) :=
  RingHom.pi (fun i => (f i).comp (Pi.evalRingHom R i))

/-- A finite dependent product of integral algebras is integral. -/
theorem algebra_isIntegral_pi_of_finite
    {R : Type u} [CommRing R] {ι : Type v} [Finite ι]
    (S : ι → Type w) [∀ i, Ring (S i)] [∀ i, Algebra R (S i)]
    (hS : ∀ i, Algebra.IsIntegral R (S i)) :
    Algebra.IsIntegral R (∀ i, S i) := by
  let P : Type v → Prop := fun α =>
    ∀ (T : α → Type w) [∀ i, Ring (T i)] [∀ i, Algebra R (T i)],
      (∀ i, Algebra.IsIntegral R (T i)) →
        Algebra.IsIntegral R (∀ i, T i)
  have hP : P ι := by
    apply Finite.induction_empty_option (P := P)
    · intro α β e ih T _ _ hT
      letI : ∀ i, Ring (T (e i)) := fun i => inferInstance
      letI : ∀ i, Algebra R (T (e i)) := fun i => inferInstance
      let U : α → Type w := fun i => T (e i)
      have hU : ∀ i, Algebra.IsIntegral R (U i) := fun i => hT (e i)
      have hi := ih U hU
      let eAlg : (∀ i, U i) ≃ₐ[R] (∀ i, T i) := AlgEquiv.piCongrLeft R T e
      rw [Algebra.isIntegral_def] at hi ⊢
      intro x
      have hx : IsIntegral R (eAlg.symm x) := hi (eAlg.symm x)
      simpa using hx.map eAlg.toAlgHom
    · intro T _ _ hT
      rw [Algebra.isIntegral_def]
      intro x
      have hx0 : x = 0 := Subsingleton.elim _ _
      rw [hx0]
      exact isIntegral_zero
    · intro α _ ih T _ _ hT
      let U : α → Type w := fun i => T (some i)
      let B := (∀ i, U i)
      let eRing : (∀ i, T i) ≃+* T none × B := RingEquiv.piOptionEquivProd
      let e : (∀ i, T i) ≃ₐ[R] T none × B :=
        AlgEquiv.ofRingEquiv (f := eRing) (by
          intro r
          ext <;> rfl)
      have hB : Algebra.IsIntegral R B := ih U (fun i => hT (some i))
      letI : Algebra.IsIntegral R (T none) := hT none
      letI : Algebra.IsIntegral R B := hB
      letI : Algebra.IsIntegral R (T none × B) := inferInstance
      rw [Algebra.isIntegral_def]
      intro x
      have hx : IsIntegral R (e x) :=
        Algebra.isIntegral_def.mp
          (inferInstance : Algebra.IsIntegral R (T none × B)) (e x)
      simpa using hx.map e.symm.toAlgHom
  exact hP S hS

/-- An element of a finite dependent product is integral exactly when each
coordinate is integral over the common base. -/
theorem isIntegral_pi_iff
    {R : Type u} [CommRing R] {ι : Type v} [Finite ι]
    (S : ι → Type w) [∀ i, Ring (S i)] [∀ i, Algebra R (S i)]
    (x : ∀ i, S i) :
    IsIntegral R x ↔ ∀ i, IsIntegral R (x i) := by
  classical
  letI := Fintype.ofFinite ι
  constructor
  · intro hx i
    exact IsIntegral.map (Pi.evalAlgHom R S i) hx
  · intro h
    choose p hpmonic hproot using fun i => h i
    let s : Finset ι := Finset.univ
    refine ⟨∏ i ∈ s, p i, ?_, ?_⟩
    · exact Polynomial.monic_prod_of_monic s p (fun i _ => hpmonic i)
    · apply _root_.funext
      intro j
      change (Pi.evalRingHom S j)
          (eval₂ (algebraMap R (∀ i, S i)) x (∏ i ∈ s, p i)) = 0
      rw [Polynomial.hom_eval₂]
      have hcomp :
          (Pi.evalRingHom S j).comp (algebraMap R (∀ i, S i)) =
            algebraMap R (S j) := by
        ext r
        rfl
      rw [hcomp]
      rw [← Finset.prod_map_toList]
      rw [Polynomial.eval₂_list_prod_noncomm]
      · apply List.prod_eq_zero
        have hj : j ∈ s.toList :=
          Finset.mem_toList.mpr (by simpa only [s] using (Finset.mem_univ j))
        have hpj : p j ∈ s.toList.map p := by
          exact List.mem_map.mpr ⟨j, hj, rfl⟩
        have heval : eval₂ (algebraMap R (S j)) (x j) (p j) ∈
            (s.toList.map p).map (eval₂ (algebraMap R (S j)) (x j)) :=
          by exact List.mem_map.mpr ⟨p j, hpj, rfl⟩
        rw [hproot j] at heval
        exact heval
      · intro q _ k
        exact Algebra.commutes _ _

/-- A finite dependent product algebra is integral exactly when all component
algebras are integral over the same commutative base. -/
theorem algebra_isIntegral_pi_iff
    {R : Type u} [CommRing R] {ι : Type v} [Finite ι]
    (S : ι → Type w) [∀ i, Ring (S i)] [∀ i, Algebra R (S i)] :
    Algebra.IsIntegral R (∀ i, S i) ↔ ∀ i, Algebra.IsIntegral R (S i) := by
  classical
  letI := Fintype.ofFinite ι
  constructor
  · intro h i
    rw [Algebra.isIntegral_def] at h ⊢
    intro y
    let x : ∀ j, S j := fun j => if hij : j = i then hij ▸ y else 0
    have hx : IsIntegral R x := h x
    have hy : IsIntegral R (x i) := (isIntegral_pi_iff S x).mp hx i
    simpa [x] using hy
  · intro h
    rw [Algebra.isIntegral_def]
    intro x
    apply (isIntegral_pi_iff S x).mpr
    intro i
    exact Algebra.isIntegral_def.mp (h i) (x i)

/-! The same criterion stated directly for a family of ring homomorphisms. -/

/-- A finite dependent product map is integral exactly when every component map
is integral.  This is the map-level wrapper around `isIntegral_pi_iff`; each
map is used as the corresponding algebra structure. -/
theorem ringHom_isIntegral_pi_iff
    {R : Type u} [CommRing R] {ι : Type v} [Finite ι]
    (S : ι → Type w) [∀ i, CommRing (S i)]
    (f : ∀ i, R →+* S i) :
    (RingHom.pi f).IsIntegral ↔ ∀ i, (f i).IsIntegral := by
  classical
  letI := Fintype.ofFinite ι
  letI : ∀ i, Algebra R (S i) := fun i => (f i).toAlgebra
  letI : Algebra R (∀ i, S i) := (RingHom.pi f).toAlgebra
  constructor
  · intro h i x
    let y : ∀ j, S j := fun j => if hij : j = i then hij ▸ x else 0
    have hy : (RingHom.pi f).IsIntegralElem y := h y
    have hyi : IsIntegral R (y i) := (isIntegral_pi_iff S y).mp hy i
    change (f i).IsIntegralElem (y i) at hyi
    simpa [y] using hyi
  · intro h y
    apply (isIntegral_pi_iff S y).mpr
    intro i
    exact h i (y i)

/-! [Stacks tag 0CY8] in its genuinely varying-base form. -/

/-- For finite families of component maps with different source rings, an
element of the product is integral over the product source exactly when each
component is integral over its own source. -/
theorem isIntegralElem_piMap_iff
    {ι : Type v} {R S : ι → Type*} [Finite ι]
    [∀ i, CommRing (R i)] [∀ i, CommRing (S i)]
    (f : ∀ i, R i →+* S i) (x : ∀ i, S i) :
    (RingHom.piMap f).IsIntegralElem x ↔
      ∀ i, (f i).IsIntegralElem (x i) := by
  classical
  letI := Fintype.ofFinite ι
  let g : (∀ i, R i) →+* (∀ i, S i) := RingHom.piMap f
  letI : ∀ i, Algebra (∀ j, R j) (S i) := fun i =>
    ((f i).comp (Pi.evalRingHom R i)).toAlgebra
  letI : Algebra (∀ i, R i) (∀ i, S i) := g.toAlgebra
  have hcommon :
      IsIntegral (∀ i, R i) x ↔
        ∀ i, IsIntegral (∀ j, R j) (x i) :=
    isIntegral_pi_iff S x
  have hmap :
      g.IsIntegralElem x ↔
        ∀ i, ((f i).comp (Pi.evalRingHom R i)).IsIntegralElem (x i) := by
    change IsIntegral (∀ i, R i) x ↔
      ∀ i, IsIntegral (∀ j, R j) (x i)
    exact hcommon
  rw [show RingHom.piMap f = g by rfl, hmap]
  constructor
  · intro h i
    have hproj : Function.Surjective (Pi.evalRingHom R i) := by
      intro r
      exact ⟨fun j => if hij : j = i then hij ▸ r else 0, by simp⟩
    exact (integralElem_comp_surjective_iff (Pi.evalRingHom R i) hproj (f i)).mp (h i)
  · intro h i
    have hproj : Function.Surjective (Pi.evalRingHom R i) := by
      intro r
      exact ⟨fun j => if hij : j = i then hij ▸ r else 0, by simp⟩
    exact (integralElem_comp_surjective_iff (Pi.evalRingHom R i) hproj (f i)).mpr (h i)

/-- Alias with the shorter criterion name used for the binary product API. -/
theorem isIntegralElem_pi_iff
    {ι : Type v} {R S : ι → Type*} [Finite ι]
    [∀ i, CommRing (R i)] [∀ i, CommRing (S i)]
    (f : ∀ i, R i →+* S i) (x : ∀ i, S i) :
    (RingHom.piMap f).IsIntegralElem x ↔
      ∀ i, (f i).IsIntegralElem (x i) :=
  isIntegralElem_piMap_iff f x

/-- The corresponding map-level varying-base criterion. -/
theorem ringHom_isIntegral_piMap_iff
    {ι : Type v} {R S : ι → Type*} [Finite ι]
    [∀ i, CommRing (R i)] [∀ i, CommRing (S i)]
    (f : ∀ i, R i →+* S i) :
    (RingHom.piMap f).IsIntegral ↔ ∀ i, (f i).IsIntegral := by
  classical
  letI := Fintype.ofFinite ι
  constructor
  · intro h i x
    let y : ∀ j, S j := fun j => if hij : j = i then hij ▸ x else 0
    simpa [y] using (isIntegralElem_piMap_iff f y).mp (h y) i
  · intro h x
    apply (isIntegralElem_piMap_iff f x).mpr
    intro i
    exact h i (x i)

end StacksPart01
