/-
Copyright (c) 2026 The StacksPart08Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart08Lib Contributors

-/

import Mathlib.Topology.Clopen
import Mathlib.Topology.LocallyConstant.Basic

/-!
# Numerical invariants on a moduli base

The Stacks Project packages Euler characteristics of perfect complexes into
integer-valued locally constant functions on the base.  This file records the
topological part of that construction: a finite list of such invariants cuts
out an open-and-closed locus, and the construction is stable under base
change.
-/

namespace StacksPart08

/-- An integer-valued locally constant function on a moduli base.

The `value` field stands for the fibrewise Euler characteristic appearing in
the source's numerical-invariant situation. -/
structure NumericalInvariant (X : Type*) [TopologicalSpace X] where
  value : X → ℤ
  locallyConstant : IsLocallyConstant value

namespace NumericalInvariant

/-- Pull a numerical invariant back along a continuous map of bases. -/
def pullback {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (ν : NumericalInvariant X) (f : Y → X) (hf : Continuous f) :
    NumericalInvariant Y where
  value := ν.value ∘ f
  locallyConstant := ν.locallyConstant.comp_continuous hf

@[simp]
theorem pullback_value {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (ν : NumericalInvariant X) (f : Y → X) (hf : Continuous f) (y : Y) :
    (ν.pullback f hf).value y = ν.value (f y) := rfl

theorem fiber_isClopen {X : Type*} [TopologicalSpace X]
    (ν : NumericalInvariant X) (n : ℤ) :
    IsClopen {x | ν.value x = n} :=
  ν.locallyConstant.isClopen_fiber n

end NumericalInvariant

/-- A finite or infinite profile of numerical invariants with prescribed
values.  The index type `I` is the set of perfect objects in the source
situation, while `prescribed` is the function called `P` there. -/
structure NumericalSituation (X : Type*) [TopologicalSpace X] (I : Type*) where
  invariant : I → NumericalInvariant X
  prescribed : I → ℤ

namespace NumericalSituation

/-- The locus where every numerical invariant has its prescribed value. -/
def locus {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) : Set X :=
  {x | ∀ i, (s.invariant i).value x = s.prescribed i}

theorem mem_locus_iff {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (x : X) :
    x ∈ s.locus ↔ ∀ i, (s.invariant i).value x = s.prescribed i :=
  Iff.rfl

theorem locus_eq_iInter {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) :
    s.locus = ⋂ i, {x | (s.invariant i).value x = s.prescribed i} := by
  ext x
  simp [NumericalSituation.locus]

/-- A finite numerical profile defines an open-and-closed subspace. -/
theorem locus_isClopen {X I : Type*} [TopologicalSpace X]
    [Finite I] (s : NumericalSituation X I) : IsClopen s.locus := by
  rw [s.locus_eq_iInter]
  apply isClopen_iInter_of_finite
  intro i
  exact (s.invariant i).fiber_isClopen (s.prescribed i)

theorem locus_isOpen {X I : Type*} [TopologicalSpace X]
    [Finite I] (s : NumericalSituation X I) : IsOpen s.locus :=
  (s.locus_isClopen).isOpen

theorem locus_isClosed {X I : Type*} [TopologicalSpace X]
    [Finite I] (s : NumericalSituation X I) : IsClosed s.locus :=
  (s.locus_isClopen).isClosed

/-- Pull a numerical situation back along a continuous map of bases. -/
def pullback {X Y I : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (s : NumericalSituation X I) (f : Y → X) (hf : Continuous f) :
    NumericalSituation Y I where
  invariant := fun i => (s.invariant i).pullback f hf
  prescribed := s.prescribed

theorem pullback_locus {X Y I : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (s : NumericalSituation X I) (f : Y → X) (hf : Continuous f) :
    (s.pullback f hf).locus = f ⁻¹' s.locus := by
  ext y
  simp [NumericalSituation.locus, NumericalSituation.pullback]

theorem mem_pullback_locus_iff {X Y I : Type*} [TopologicalSpace X]
    [TopologicalSpace Y] (s : NumericalSituation X I) (f : Y → X)
    (hf : Continuous f) (y : Y) :
    y ∈ (s.pullback f hf).locus ↔ f y ∈ s.locus := by
  rw [s.pullback_locus f hf]
  rfl

end NumericalSituation

end StacksPart08
