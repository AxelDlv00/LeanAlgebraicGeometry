/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.FiniteProduct
import Mathlib.RingTheory.Finiteness.Basic

/-!
# Finite maps and finite products

The component projections of a finite product map retain finite generation.
This is a downstream finiteness consumer for the varying-base product map
used in the integral-closure results.
-/

namespace StacksPart01

/-- Finiteness of a varying-base product map descends to every component. -/
theorem finite_component_of_piMap
    {ι : Type*} {R S : ι → Type*} [Finite ι]
    [∀ i, CommRing (R i)] [∀ i, CommRing (S i)]
    (f : ∀ i, R i →+* S i)
    (hf : (RingHom.piMap f).Finite) (i : ι) :
    (f i).Finite := by
  classical
  letI : Algebra (∀ j, R j) (∀ j, S j) := (RingHom.piMap f).toAlgebra
  letI : Algebra (R i) (S i) := (f i).toAlgebra
  have hfin : Module.Finite (∀ j, R j) (∀ j, S j) := by
    exact hf
  let proj : (∀ j, S j) →ₛₗ[Pi.evalRingHom R i] S i :=
    LinearMap.mk (Pi.evalAddMonoidHom S i).toAddHom (by
      intro r x
      rfl)
  have hproj : Function.Surjective proj := by
    intro x
    refine ⟨fun j => if hij : j = i then hij ▸ x else 0, ?_⟩
    simp [proj]
  exact Module.Finite.of_surjective proj hproj

/-- A finite dependent product map with varying source rings is finite exactly
when every component map is finite. -/
theorem ringHom_finite_piMap_iff
    {ι : Type*} {R S : ι → Type*} [Finite ι]
    [∀ i, CommRing (R i)] [∀ i, CommRing (S i)]
    (f : ∀ i, R i →+* S i) :
    (RingHom.piMap f).Finite ↔ ∀ i, (f i).Finite := by
  classical
  constructor
  · intro hf i
    exact finite_component_of_piMap f hf i
  · intro hf
    letI : ∀ i, Algebra (R i) (S i) := fun i => (f i).toAlgebra
    letI : ∀ i, Algebra (∀ j, R j) (S i) := fun i =>
      ((f i).comp (Pi.evalRingHom R i)).toAlgebra
    have hcomponent : ∀ i, Module.Finite (∀ j, R j) (S i) := by
      intro i
      let proj : S i →ₛₗ[Pi.evalRingHom R i] S i :=
        LinearMap.mk (AddMonoidHom.id (S i)) (by
          intro r x
          rfl)
      exact (LinearMap.finite_iff_of_bijective proj
        ⟨fun _ _ h => h, fun x => ⟨x, rfl⟩⟩).mpr (hf i)
    letI : ∀ i, Module.Finite (∀ j, R j) (S i) := hcomponent
    letI : Algebra (∀ j, R j) (∀ j, S j) := (RingHom.piMap f).toAlgebra
    exact Module.Finite.pi

end StacksPart01
