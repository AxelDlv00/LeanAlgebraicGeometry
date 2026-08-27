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

@[simp]
theorem pullback_id {X : Type*} [TopologicalSpace X]
    (ν : NumericalInvariant X) :
    ν.pullback id continuous_id = ν := by
  cases ν
  rfl

theorem pullback_comp {X Y Z : Type*} [TopologicalSpace X]
    [TopologicalSpace Y] [TopologicalSpace Z]
    (ν : NumericalInvariant X) (f : Y → X) (g : Z → Y)
    (hf : Continuous f) (hg : Continuous g) :
    (ν.pullback f hf).pullback g hg =
      ν.pullback (f ∘ g) (hf.comp hg) := by
  cases ν
  rfl

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

/-! ### Reindexing profiles -/

/-- Reindex a numerical situation along a map of profile indices. -/
def reindex {X I J : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (f : J → I) : NumericalSituation X J where
  invariant := fun j => s.invariant (f j)
  prescribed := fun j => s.prescribed (f j)

@[simp]
theorem reindex_invariant {X I J : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (f : J → I) (j : J) :
    (s.reindex f).invariant j = s.invariant (f j) := rfl

@[simp]
theorem reindex_prescribed {X I J : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (f : J → I) (j : J) :
    (s.reindex f).prescribed j = s.prescribed (f j) := rfl

@[simp]
theorem reindex_id {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) : s.reindex id = s := by
  cases s
  rfl

theorem reindex_comp {X I J K : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (f : J → I) (g : K → J) :
    (s.reindex f).reindex g = s.reindex (f ∘ g) := by
  cases s
  rfl

/-- The full locus is contained in every reindexed locus. -/
theorem locus_subset_reindex {X I J : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (f : J → I) :
    s.locus ⊆ (s.reindex f).locus := by
  intro x hx j
  exact hx (f j)

/-- A surjective reindexing does not change the full numerical locus. -/
theorem locus_reindex_eq {X I J : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (f : J → I) (hf : Function.Surjective f) :
    (s.reindex f).locus = s.locus := by
  ext x
  constructor
  · intro hx i
    obtain ⟨j, rfl⟩ := hf i
    exact hx j
  · intro hx
    exact s.locus_subset_reindex f hx

/-! ### Finite subprofiles -/

/-- The locus cut out by the invariants whose indices lie in `J`. -/
def locusOn {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (J : Set I) : Set X :=
  {x | ∀ i, i ∈ J → (s.invariant i).value x = s.prescribed i}

theorem mem_locusOn_iff {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (J : Set I) (x : X) :
    x ∈ s.locusOn J ↔
      ∀ i, i ∈ J → (s.invariant i).value x = s.prescribed i :=
  Iff.rfl

theorem locusOn_eq_biInter {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (J : Set I) :
    s.locusOn J =
      ⋂ i ∈ J, {x | (s.invariant i).value x = s.prescribed i} := by
  ext x
  simp [NumericalSituation.locusOn]

theorem locusOn_isClosed {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (J : Set I) :
    IsClosed (s.locusOn J) := by
  rw [s.locusOn_eq_biInter J]
  apply isClosed_iInter
  intro i
  apply isClosed_iInter
  intro hi
  exact ((s.invariant i).fiber_isClopen (s.prescribed i)).isClosed

/-- A finite subprofile defines an open-and-closed locus, even when the full
index type is infinite. -/
theorem locusOn_isClopen {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (J : Set I) (hJ : J.Finite) :
    IsClopen (s.locusOn J) := by
  rw [s.locusOn_eq_biInter J]
  apply hJ.isClopen_biInter
  intro i hi
  exact (s.invariant i).fiber_isClopen (s.prescribed i)

theorem locusOn_isOpen {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (J : Set I) (hJ : J.Finite) :
    IsOpen (s.locusOn J) :=
  (s.locusOn_isClopen J hJ).isOpen

theorem locusOn_mono {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) {J K : Set I} (hJK : J ⊆ K) :
    s.locusOn K ⊆ s.locusOn J := by
  intro x hx i hi
  exact hx i (hJK hi)

theorem locusOn_union {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (J K : Set I) :
    s.locusOn (J ∪ K) = s.locusOn J ∩ s.locusOn K := by
  ext x
  constructor
  · intro hx
    constructor
    · intro i hi
      exact hx i (Or.inl hi)
    · intro i hi
      exact hx i (Or.inr hi)
  · rintro ⟨hxJ, hxK⟩ i hi
    rcases hi with hi | hi
    · exact hxJ i hi
    · exact hxK i hi

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
    (s : NumericalSituation X I) : IsClosed s.locus := by
  rw [s.locus_eq_iInter]
  apply isClosed_iInter
  intro i
  exact ((s.invariant i).fiber_isClopen (s.prescribed i)).isClosed

/-- Pull a numerical situation back along a continuous map of bases. -/
def pullback {X Y I : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (s : NumericalSituation X I) (f : Y → X) (hf : Continuous f) :
    NumericalSituation Y I where
  invariant := fun i => (s.invariant i).pullback f hf
  prescribed := s.prescribed

@[simp]
theorem pullback_id {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) :
    s.pullback id continuous_id = s := by
  cases s
  rfl

theorem pullback_comp {X Y Z I : Type*} [TopologicalSpace X]
    [TopologicalSpace Y] [TopologicalSpace Z]
    (s : NumericalSituation X I) (f : Y → X) (g : Z → Y)
    (hf : Continuous f) (hg : Continuous g) :
    (s.pullback f hf).pullback g hg =
      s.pullback (f ∘ g) (hf.comp hg) := by
  cases s
  rfl

theorem pullback_locus {X Y I : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (s : NumericalSituation X I) (f : Y → X) (hf : Continuous f) :
    (s.pullback f hf).locus = f ⁻¹' s.locus := by
  ext y
  simp [NumericalSituation.locus, NumericalSituation.pullback]

theorem pullback_locusOn {X Y I : Type*} [TopologicalSpace X]
    [TopologicalSpace Y] (s : NumericalSituation X I) (J : Set I)
    (f : Y → X) (hf : Continuous f) :
    (s.pullback f hf).locusOn J = f ⁻¹' s.locusOn J := by
  ext y
  simp [NumericalSituation.locusOn, NumericalSituation.pullback]

theorem mem_pullback_locus_iff {X Y I : Type*} [TopologicalSpace X]
    [TopologicalSpace Y] (s : NumericalSituation X I) (f : Y → X)
    (hf : Continuous f) (y : Y) :
    y ∈ (s.pullback f hf).locus ↔ f y ∈ s.locus := by
  rw [s.pullback_locus f hf]
  rfl

end NumericalSituation

end StacksPart08
