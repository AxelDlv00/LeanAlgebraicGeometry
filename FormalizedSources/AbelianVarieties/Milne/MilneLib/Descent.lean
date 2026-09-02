/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.RingTheory.Finiteness.Descent
import Mathlib.RingTheory.Noetherian.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Basic

/-!
# Algebraic descent interfaces

This file isolates the algebraic input used by descent arguments in Milne's
discussion of Jacobians.  The faithfully-flat finiteness theorems are imported
from Mathlib and exposed with source-oriented names.  `ModuleDescentDatum`
records the action-side part of a descent datum and its invariant submodule;
effectivity for quasi-projective schemes and coherent sheaves is intentionally
left as a separate geometric obligation.
-/

set_option autoImplicit false

open TensorProduct

namespace MilneLib

/-! ## Finiteness detected after faithfully flat base change -/

/-- Finite generation of a module descends from a faithfully flat tensor
base change.  This is the affine module finiteness step in coherent-sheaf
descent. -/
theorem moduleFinite_of_faithfullyFlat_tensorProduct
    {R T M : Type*} [CommRing R] [CommRing T] [Algebra R T]
    [AddCommGroup M] [Module R M] [Module.FaithfullyFlat R T]
    [Module.Finite T (T ⊗[R] M)] :
    Module.Finite R M := by
  exact Module.Finite.of_finite_tensorProduct_of_faithfullyFlat T

/-- For a faithfully flat scalar extension, finite generation is equivalent
to finite generation after tensoring. -/
theorem moduleFinite_tensorProduct_iff_faithfullyFlat
    {R T M : Type*} [CommRing R] [CommRing T] [Algebra R T]
    [AddCommGroup M] [Module R M] [Module.FaithfullyFlat R T] :
    Module.Finite R M ↔ Module.Finite T (T ⊗[R] M) := by
  constructor
  · intro hM
    letI : Module.Finite R M := hM
    infer_instance
  · intro hT
    letI : Module.Finite T (T ⊗[R] M) := hT
    exact moduleFinite_of_faithfullyFlat_tensorProduct (R := R) (T := T) (M := M)

/-- The preceding affine descent step, specialized to vector spaces.  A
finite-dimensional module after scalar extension is already finite-dimensional
before extension; no Galois action is needed for this implication. -/
theorem finiteDimensional_of_faithfullyFlat_tensorProduct
    {K L V : Type*} [Field K] [Field L] [Algebra K L]
    [AddCommGroup V] [Module K V]
    [FiniteDimensional L (L ⊗[K] V)] :
    FiniteDimensional K V := by
  exact moduleFinite_of_faithfullyFlat_tensorProduct (R := K) (T := L) (M := V)

/-- Finite type descends from a faithfully flat tensor-product base change of
an algebra. -/
theorem algebraFiniteType_of_faithfullyFlat_tensorProduct
    {R S T : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [CommRing T] [Algebra R T] [Module.FaithfullyFlat R T]
    [Algebra.FiniteType T (T ⊗[R] S)] :
    Algebra.FiniteType R S := by
  exact Algebra.FiniteType.of_finiteType_tensorProduct_of_faithfullyFlat T

/-- Finite type is invariant under a faithfully flat tensor-product base
change. -/
theorem algebraFiniteType_tensorProduct_iff_faithfullyFlat
    {R S T : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [CommRing T] [Algebra R T] [Module.FaithfullyFlat R T] :
    Algebra.FiniteType R S ↔ Algebra.FiniteType T (T ⊗[R] S) := by
  constructor
  · intro hS
    letI : Algebra.FiniteType R S := hS
    infer_instance
  · intro hT
    letI : Algebra.FiniteType T (T ⊗[R] S) := hT
    exact algebraFiniteType_of_faithfullyFlat_tensorProduct (R := R) (S := S) (T := T)

/-- Finite presentation descends from a faithfully flat tensor-product base
change of an algebra. -/
theorem algebraFinitePresentation_of_faithfullyFlat_tensorProduct
    {R S T : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [CommRing T] [Algebra R T] [Module.FaithfullyFlat R T]
    [Algebra.FinitePresentation T (T ⊗[R] S)] :
    Algebra.FinitePresentation R S := by
  exact Algebra.FinitePresentation.of_finitePresentation_tensorProduct_of_faithfullyFlat T

/-- Finite presentation is invariant under a faithfully flat tensor-product
base change. -/
theorem algebraFinitePresentation_tensorProduct_iff_faithfullyFlat
    {R S T : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [CommRing T] [Algebra R T] [Module.FaithfullyFlat R T] :
    Algebra.FinitePresentation R S ↔
      Algebra.FinitePresentation T (T ⊗[R] S) := by
  constructor
  · intro hS
    letI : Algebra.FinitePresentation R S := hS
    infer_instance
  · intro hT
    letI : Algebra.FinitePresentation T (T ⊗[R] S) := hT
    exact algebraFinitePresentation_of_faithfullyFlat_tensorProduct
      (R := R) (S := S) (T := T)

/-! ## The invariant part of an action-side descent datum -/

/-- An action-side linear descent datum.  The maps are required to satisfy
the unit and multiplication laws; scalar twisting and effectiveness are
additional structure and are deliberately not inferred here. -/
structure ModuleDescentDatum
    (R M G : Type*) [Semiring R] [AddCommMonoid M] [Module R M]
    [Monoid G] where
  action : G → M →ₗ[R] M
  action_one : ∀ m, action 1 m = m
  action_mul : ∀ (g h : G) (m : M), action (g * h) m = action g (action h m)

namespace ModuleDescentDatum

variable {R M G : Type*} [Semiring R] [AddCommMonoid M] [Module R M]
  [Monoid G]

/-- Elements fixed by every map in a descent datum. -/
def invariants (D : ModuleDescentDatum R M G) : Submodule R M where
  carrier := {m | ∀ g, D.action g m = m}
  zero_mem' := by
    intro g
    exact (D.action g).map_zero
  add_mem' := by
    intro x y hx hy g
    rw [(D.action g).map_add, hx g, hy g]
  smul_mem' := by
    intro c x hx g
    rw [(D.action g).map_smul, hx g]

@[simp]
theorem mem_invariants_iff (D : ModuleDescentDatum R M G) (m : M) :
    m ∈ D.invariants ↔ ∀ g, D.action g m = m :=
  Iff.rfl

theorem action_one_apply (D : ModuleDescentDatum R M G) (m : M) :
    D.action 1 m = m :=
  D.action_one m

theorem action_mul_apply (D : ModuleDescentDatum R M G)
    (g h : G) (m : M) :
    D.action (g * h) m = D.action g (D.action h m) :=
  D.action_mul g h m

/-- A map whose image is fixed factors canonically through the invariant
submodule. -/
def factorThroughInvariants
    {N : Type*} [AddCommMonoid N] [Module R N]
    (D : ModuleDescentDatum R M G) (f : N →ₗ[R] M)
    (hf : ∀ n g, D.action g (f n) = f n) :
    N →ₗ[R] D.invariants :=
  { toFun := fun n => ⟨f n, hf n⟩
    map_add' := by
      intro x y
      apply Subtype.ext
      exact f.map_add x y
    map_smul' := by
      intro c x
      apply Subtype.ext
      exact f.map_smul c x }

@[simp]
theorem subtype_comp_factorThroughInvariants
    {N : Type*} [AddCommMonoid N] [Module R N]
    (D : ModuleDescentDatum R M G) (f : N →ₗ[R] M)
    (hf : ∀ n g, D.action g (f n) = f n) :
    (D.invariants.subtype).comp (D.factorThroughInvariants f hf) = f := by
  ext n
  rfl

theorem factorThroughInvariants_unique
    {N : Type*} [AddCommMonoid N] [Module R N]
    (D : ModuleDescentDatum R M G) (f : N →ₗ[R] M)
    (hf : ∀ n g, D.action g (f n) = f n)
    (u : N →ₗ[R] D.invariants)
    (hu : (D.invariants.subtype).comp u = f) :
    u = D.factorThroughInvariants f hf := by
  ext n
  exact LinearMap.congr_fun hu n

/-- Over a Noetherian ring, the invariant part of a finite module is finite.
This is the finiteness statement available before an effective geometric
descent theorem is supplied. -/
theorem invariants_finite
    {R M G : Type*} [Ring R] [AddCommGroup M] [Module R M] [Monoid G]
    (D : ModuleDescentDatum R M G)
    [IsNoetherianRing R] [Module.Finite R M] :
    Module.Finite R D.invariants := by
  letI : IsNoetherian R M := isNoetherian_of_isNoetherianRing_of_finite R M
  exact Module.Finite.of_fg (IsNoetherian.noetherian D.invariants)

/-- The trivial action has all of `M` as its invariant part. -/
def trivial (R M G : Type*) [Semiring R] [AddCommMonoid M] [Module R M]
    [Monoid G] : ModuleDescentDatum R M G where
  action _ := LinearMap.id
  action_one := by
    intro m
    rfl
  action_mul := by
    intro g h m
    rfl

@[simp]
theorem trivial_invariants (R M G : Type*) [Semiring R] [AddCommMonoid M]
    [Module R M] [Monoid G] :
    (trivial R M G).invariants = (⊤ : Submodule R M) := by
  apply le_antisymm
  · exact le_top
  · intro m _ g
    rfl

end ModuleDescentDatum

end MilneLib
