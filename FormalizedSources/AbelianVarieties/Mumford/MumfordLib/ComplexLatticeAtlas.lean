/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexLattice
import Mathlib.Analysis.Normed.Module.Connected
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Geometry.Manifold.LocalDiffeomorph
import Mathlib.Geometry.Manifold.ContMDiff.Atlas

/-!
# Local branches for an arbitrary complex period lattice

`ComplexLatticeExponentialData` records a full integral lattice together with
the continuous, surjective additive exponential having that lattice as kernel.
This file packages the resulting local quotient and exponential branches.
The assertions are topological; holomorphicity and complex-manifold existence
remain explicit hypotheses outside this interface.
-/

set_option autoImplicit false

namespace Mumford
namespace Uniformization

noncomputable section

open scoped Manifold ContDiff

namespace ComplexLatticeExponentialData

/-- The local inverse branch of the arbitrary lattice quotient projection at a
chosen representative. -/
noncomputable def quotientLocalBranchAt
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (z : GenusComplexVector g) :
    OpenPartialHomeomorph
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup)
      (GenusComplexVector g) :=
  d.quotient_mk_isLocalHomeomorph.localInverseAt z

/-- The selected representative belongs to the target of its quotient branch. -/
@[simp]
theorem quotientLocalBranchAt_mem_target
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (z : GenusComplexVector g) :
    z ∈ (d.quotientLocalBranchAt z).target := by
  simp [quotientLocalBranchAt]

/-- A branch sends the quotient point of its selected representative back to it. -/
@[simp]
theorem quotientLocalBranchAt_apply_quotient_mk
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (z : GenusComplexVector g) :
    d.quotientLocalBranchAt z
        ((QuotientAddGroup.mk : GenusComplexVector g →
          GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) z) = z := by
  simp [quotientLocalBranchAt]

/-- The quotient point of the selected representative lies in the branch source. -/
@[simp]
theorem quotientLocalBranchAt_quotient_mk_mem_source
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (z : GenusComplexVector g) :
    (QuotientAddGroup.mk : GenusComplexVector g →
      GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) z ∈
      (d.quotientLocalBranchAt z).source := by
  simp [quotientLocalBranchAt]

/-- The inverse of a local quotient branch is the quotient projection. -/
@[simp]
theorem quotientLocalBranchAt_symm
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (z : GenusComplexVector g) :
    (d.quotientLocalBranchAt z).symm =
      (QuotientAddGroup.mk : GenusComplexVector g →
        GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
  simp [quotientLocalBranchAt]

/-- Projection after a local branch is the identity on the branch source. -/
theorem quotient_mk_apply_quotientLocalBranchAt
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (z : GenusComplexVector g)
    {q : GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup}
    (hq : q ∈ (d.quotientLocalBranchAt z).source) :
    (QuotientAddGroup.mk : GenusComplexVector g →
        GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup)
        (d.quotientLocalBranchAt z q) = q := by
  exact d.quotient_mk_isLocalHomeomorph.apply_localInverseAt_of_mem hq

/-- The local quotient branch is continuous on its open source. -/
theorem quotientLocalBranchAt_continuousOn
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (z : GenusComplexVector g) :
    ContinuousOn (d.quotientLocalBranchAt z)
      (d.quotientLocalBranchAt z).source :=
  (d.quotientLocalBranchAt z).continuousOn

/-- The inverse branch, viewed on its target, is the quotient projection. -/
theorem quotientLocalBranchAt_symm_continuousOn
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (z : GenusComplexVector g) :
    ContinuousOn (d.quotientLocalBranchAt z).symm
      (d.quotientLocalBranchAt z).target := by
  rw [d.quotientLocalBranchAt_symm]
  exact QuotientAddGroup.continuous_mk.continuousOn

/-- The local quotient branch covers its entire open target. -/
theorem quotientLocalBranchAt_image_source_eq_target
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (z : GenusComplexVector g) :
    d.quotientLocalBranchAt z '' (d.quotientLocalBranchAt z).source =
      (d.quotientLocalBranchAt z).target :=
  (d.quotientLocalBranchAt z).image_source_eq_target

/-- The local inverse branch of the exponential at a chosen representative. -/
noncomputable def exponentialBranch
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    OpenPartialHomeomorph X (GenusComplexVector g) :=
  d.quotientHomeomorph.symm.toOpenPartialHomeomorph.trans
    (d.quotientLocalBranchAt z)

/-- The exponential image of a chosen representative belongs to its branch
source. -/
@[simp]
theorem exponential_source_mem
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    d.exponential z ∈ (d.exponentialBranch z).source := by
  rw [exponentialBranch, OpenPartialHomeomorph.trans_source]
  constructor
  · simp
  · rw [Set.mem_preimage]
    change d.quotientHomeomorph.symm (d.exponential z) ∈
      (d.quotientLocalBranchAt z).source
    rw [d.quotientHomeomorph_symm_exponential]
    exact d.quotientLocalBranchAt_quotient_mk_mem_source z

/-- The source of a transported branch is the inverse image of the quotient
branch source under the quotient homeomorphism. -/
theorem exponentialBranch_source_eq_preimage
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    (d.exponentialBranch z).source =
      d.quotientHomeomorph.symm ⁻¹' (d.quotientLocalBranchAt z).source := by
  rw [exponentialBranch, OpenPartialHomeomorph.trans_source]
  simp

/-- Applying a branch to the exponential of its representative recovers that
representative. -/
@[simp]
theorem exponential_apply_exponential
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    d.exponentialBranch z (d.exponential z) = z := by
  rw [exponentialBranch, OpenPartialHomeomorph.trans_apply]
  change d.quotientLocalBranchAt z
    (d.quotientHomeomorph.symm (d.exponential z)) = z
  rw [d.quotientHomeomorph_symm_exponential]
  exact d.quotientLocalBranchAt_apply_quotient_mk z

/-- The target of a transported branch is the target of the quotient branch. -/
theorem exponentialBranch_target_eq_quotientLocalBranchAt_target
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    (d.exponentialBranch z).target =
      (d.quotientLocalBranchAt z).target := by
  rw [exponentialBranch, OpenPartialHomeomorph.trans_target]
  simp

/-- The selected representative belongs to the target of its exponential
branch. -/
theorem exponentialBranch_mem_target
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    z ∈ (d.exponentialBranch z).target := by
  have h := (d.exponentialBranch z).map_source
    (d.exponential_source_mem z)
  simpa using h

/-- The transported branch covers its open target. -/
theorem exponentialBranch_image_source_eq_target
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    d.exponentialBranch z '' (d.exponentialBranch z).source =
      (d.exponentialBranch z).target :=
  (d.exponentialBranch z).image_source_eq_target

/-- On a branch target, the inverse branch recovers the original exponential. -/
theorem exponential_symm_apply_eq_exponential
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) {y : GenusComplexVector g}
    (hy : y ∈ (d.exponentialBranch z).target) :
    (d.exponentialBranch z).symm y = d.exponential y := by
  have hy' : y ∈ (d.quotientLocalBranchAt z).target := by
    rw [exponentialBranch, OpenPartialHomeomorph.trans_target] at hy
    exact hy.1
  rw [exponentialBranch]
  change d.quotientHomeomorph
      ((d.quotientLocalBranchAt z).symm y) = d.exponential y
  have hsource : (d.quotientLocalBranchAt z).symm y ∈
      (d.quotientLocalBranchAt z).source :=
    (d.quotientLocalBranchAt z).map_target hy'
  have hmk : (QuotientAddGroup.mk : GenusComplexVector g →
      GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) y =
      (d.quotientLocalBranchAt z).symm y := by
    rw [← d.quotient_mk_apply_quotientLocalBranchAt z hsource]
    rw [(d.quotientLocalBranchAt z).right_inv hy']
  rw [← hmk]
  change d.quotientHomeomorph
      (QuotientAddGroup.mk' d.periodLattice.toAddSubgroup y) = d.exponential y
  rw [d.quotientHomeomorph_mk]

/-- Applying the exponential after a branch returns the original source point. -/
theorem exponential_apply_exponential_apply
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) {x : X}
    (hx : x ∈ (d.exponentialBranch z).source) :
    d.exponential (d.exponentialBranch z x) = x := by
  have hxt : (d.exponentialBranch z) x ∈
      (d.exponentialBranch z).target :=
    (d.exponentialBranch z).map_source hx
  rw [← d.exponential_symm_apply_eq_exponential z hxt]
  exact (d.exponentialBranch z).left_inv hx

/- The transported branch and its inverse are continuous on their respective
open sets. -/
theorem exponentialBranch_continuousOn
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    ContinuousOn (d.exponentialBranch z)
      (d.exponentialBranch z).source :=
  (d.exponentialBranch z).continuousOn

theorem exponentialBranch_symm_continuousOn
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    ContinuousOn (d.exponentialBranch z).symm
      (d.exponentialBranch z).target :=
  (d.exponentialBranch z).symm.continuousOn

/-- Two local quotient representatives differ by a period of the lattice. -/
theorem quotientLocalBranchAt_sub_mem_periodLattice
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) {q :
      GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup}
    (hqz : q ∈ (d.quotientLocalBranchAt z).source)
    (hqw : q ∈ (d.quotientLocalBranchAt w).source) :
    d.quotientLocalBranchAt z q - d.quotientLocalBranchAt w q ∈
      d.periodLattice := by
  apply (d.quotientAddEquiv_mk_eq_iff
    (d.quotientLocalBranchAt z q)
    (d.quotientLocalBranchAt w q)).mp
  exact congrArg d.quotientAddEquiv
    ((d.quotient_mk_apply_quotientLocalBranchAt z hqz).trans
      (d.quotient_mk_apply_quotientLocalBranchAt w hqw).symm)

/- Branches that are simultaneously defined at a point differ by a lattice
period. -/
theorem exponentialBranch_sub_mem_periodLattice
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) {x : X}
    (hxz : x ∈ (d.exponentialBranch z).source)
    (hxw : x ∈ (d.exponentialBranch w).source) :
    d.exponentialBranch z x - d.exponentialBranch w x ∈
      d.periodLattice := by
  rw [exponentialBranch, OpenPartialHomeomorph.trans_source] at hxz hxw
  have hqz : d.quotientHomeomorph.symm x ∈
      (d.quotientLocalBranchAt z).source := hxz.2
  have hqw : d.quotientHomeomorph.symm x ∈
      (d.quotientLocalBranchAt w).source := hxw.2
  have hdiff := d.quotientLocalBranchAt_sub_mem_periodLattice z w hqz hqw
  simpa [exponentialBranch, OpenPartialHomeomorph.trans_apply] using hdiff

/-- Surjectivity makes the transported branch sources cover the target. -/
theorem exists_exponentialBranch_source
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (x : X) :
    ∃ z : GenusComplexVector g, x ∈ (d.exponentialBranch z).source := by
  obtain ⟨z, hz⟩ := d.surjective x
  refine ⟨z, ?_⟩
  rw [← hz]
  exact d.exponential_source_mem z

/-- Every point has a branch representative that inverts the exponential at
that point. -/
theorem exists_exponentialBranch_apply_eq
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (x : X) :
    ∃ z : GenusComplexVector g, x ∈ (d.exponentialBranch z).source ∧
      d.exponentialBranch z x = z := by
  obtain ⟨z, hz⟩ := d.surjective x
  refine ⟨z, ?_, ?_⟩
  · rw [← hz]
    exact d.exponential_source_mem z
  · rw [← hz]
    exact d.exponential_apply_exponential z

/-- The exponential branch sources form an open cover of the target. -/
theorem exponentialBranch_source_iUnion_eq_univ
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) :
    (⋃ z : GenusComplexVector g, (d.exponentialBranch z).source) =
      Set.univ := by
  apply Set.eq_univ_of_forall
  intro x
  obtain ⟨z, hx⟩ := d.exists_exponentialBranch_source x
  exact Set.mem_iUnion.2 ⟨z, hx⟩

/- The overlap transition between two transported inverse branches.  Its source
consists precisely of those tangent representatives whose image under the
first branch lands in the second branch source. -/
noncomputable def exponentialBranchTransition
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    OpenPartialHomeomorph (GenusComplexVector g) (GenusComplexVector g) :=
  (d.exponentialBranch z).symm.trans (d.exponentialBranch w)

@[simp]
theorem exponentialBranchTransition_apply
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w y : GenusComplexVector g) :
    d.exponentialBranchTransition z w y =
      d.exponentialBranch w ((d.exponentialBranch z).symm y) := by
  rw [exponentialBranchTransition, OpenPartialHomeomorph.trans_apply]

theorem exponentialBranchTransition_source_isOpen
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    IsOpen (d.exponentialBranchTransition z w).source := by
  exact (d.exponentialBranchTransition z w).open_source

theorem exponentialBranchTransition_target_isOpen
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    IsOpen (d.exponentialBranchTransition z w).target := by
  exact (d.exponentialBranchTransition z w).open_target

/- On an overlap, the transition has pointwise difference in the period
   subgroup (the sign is immaterial for membership in that subgroup). -/
theorem exponentialBranchTransition_sub_mem_periodLattice
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) {y : GenusComplexVector g}
    (hy : y ∈ (d.exponentialBranchTransition z w).source) :
    d.exponentialBranchTransition z w y - y ∈ d.periodLattice := by
  rw [exponentialBranchTransition, OpenPartialHomeomorph.trans_source] at hy
  have hyz : y ∈ (d.exponentialBranch z).target := hy.1
  let x : X := (d.exponentialBranch z).symm y
  have hxz : x ∈ (d.exponentialBranch z).source :=
    (d.exponentialBranch z).map_target hyz
  have hxw : x ∈ (d.exponentialBranch w).source := hy.2
  have hdiff := d.exponentialBranch_sub_mem_periodLattice z w hxz hxw
  have hrep : d.exponentialBranch z x = y :=
    (d.exponentialBranch z).right_inv hyz
  change d.exponentialBranch w x - y ∈ d.periodLattice
  simpa only [hrep, neg_sub] using (neg_mem hdiff)

/- The period-valued form is convenient when treating overlap maps as deck
translations rather than merely comparing their differences. -/
theorem exponentialBranchTransition_exists_period
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) {y : GenusComplexVector g}
    (hy : y ∈ (d.exponentialBranchTransition z w).source) :
    ∃ period : d.periodLattice,
      d.exponentialBranchTransition z w y = y + (period : GenusComplexVector g) := by
  have hdiff := d.exponentialBranchTransition_sub_mem_periodLattice z w hy
  refine ⟨⟨d.exponentialBranchTransition z w y - y, hdiff⟩, ?_⟩
  change d.exponentialBranchTransition z w y =
    y + (d.exponentialBranchTransition z w y - y)
  exact (add_sub_cancel y (d.exponentialBranchTransition z w y)).symm

/- On a preconnected overlap, the period relating two branches is independent
   of the point.  This is the deck-translation form of the local transition
   law; the discreteness of the period lattice is the essential input. -/
theorem exponentialBranchTransition_eq_add_of_isPreconnected
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) {s : Set (GenusComplexVector g)}
    (hs : IsPreconnected s)
    (hsub : s ⊆ (d.exponentialBranchTransition z w).source)
    {y₀ : GenusComplexVector g} (hy₀ : y₀ ∈ s) :
    ∃ period : d.periodLattice,
      ∀ y ∈ s,
        d.exponentialBranchTransition z w y = y + (period : GenusComplexVector g) := by
  let f : GenusComplexVector g → GenusComplexVector g :=
    fun y => d.exponentialBranchTransition z w y - y
  have hf : ContinuousOn f s := by
    exact
      (((d.exponentialBranchTransition z w).continuousOn).mono hsub).sub
        continuousOn_id
  have hmaps : Set.MapsTo f s
      (d.periodLattice.toAddSubgroup : Set (GenusComplexVector g)) := by
    intro y hy
    exact d.exponentialBranchTransition_sub_mem_periodLattice z w (hsub hy)
  have hconst : ∀ y ∈ s, f y = f y₀ := by
    intro y hy
    exact IsPreconnected.constant_of_mapsTo hs d.periodLattice_isDiscrete
      hf hmaps hy hy₀
  let period : d.periodLattice := ⟨f y₀, hmaps hy₀⟩
  refine ⟨period, ?_⟩
  intro y hy
  have hyconst : f y = f y₀ := hconst y hy
  dsimp [f, period] at hyconst ⊢
  calc
    d.exponentialBranchTransition z w y =
        (d.exponentialBranchTransition z w y - y) + y := by abel
    _ = (d.exponentialBranchTransition z w y₀ - y₀) + y := by
      rw [hyconst]
    _ = y + (d.exponentialBranchTransition z w y₀ - y₀) := by abel

theorem exponentialBranchTransition_self_apply
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) {y : GenusComplexVector g}
    (hy : y ∈ (d.exponentialBranchTransition z z).source) :
    d.exponentialBranchTransition z z y = y := by
  rw [exponentialBranchTransition, OpenPartialHomeomorph.trans_source] at hy
  rw [exponentialBranchTransition, OpenPartialHomeomorph.trans_apply]
  exact (d.exponentialBranch z).right_inv hy.1

/- Every overlap transition preserves the exponential, as expected for a deck
transformation of the quotient map. -/
theorem exponentialBranchTransition_exponential_eq
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) {y : GenusComplexVector g}
    (hy : y ∈ (d.exponentialBranchTransition z w).source) :
    d.exponential (d.exponentialBranchTransition z w y) =
      d.exponential y := by
  rw [d.exponentialBranchTransition_apply z w y]
  have hyz : y ∈ (d.exponentialBranch z).target := by
    rw [exponentialBranchTransition, OpenPartialHomeomorph.trans_source] at hy
    exact hy.1
  let x : X := (d.exponentialBranch z).symm y
  have hxw : x ∈ (d.exponentialBranch w).source := by
    rw [exponentialBranchTransition, OpenPartialHomeomorph.trans_source] at hy
    exact hy.2
  have hleft : d.exponential (d.exponentialBranch w x) = x :=
    d.exponential_apply_exponential_apply w hxw
  have hright : d.exponential y = x :=
    (d.exponential_symm_apply_eq_exponential z hyz).symm
  rw [hleft, hright]

/- The overlap maps inherit the local-homeomorphism structure of their two
   constituent branches. -/
theorem exponentialBranchTransition_continuousOn
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    ContinuousOn (d.exponentialBranchTransition z w)
      (d.exponentialBranchTransition z w).source :=
  (d.exponentialBranchTransition z w).continuousOn

/- The period-valued transition law makes each overlap map locally a
   translation.  Consequently the explicit vector-model atlas has analytic
   (`ContDiff` order `ω`) overlap transitions.  This is a model-level result;
   it does not choose a quotient `ChartedSpace` or prove source uniformization.
-/
theorem exponentialBranchTransition_contDiffOn
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    ContDiffOn ℂ ω (d.exponentialBranchTransition z w)
      (d.exponentialBranchTransition z w).source := by
  apply contDiffOn_of_locally_contDiffOn
  intro y hy
  obtain ⟨r, hr, hball⟩ := Metric.mem_nhds_iff.mp
    ((d.exponentialBranchTransition_source_isOpen z w).mem_nhds hy)
  obtain ⟨period, hperiod⟩ :=
    d.exponentialBranchTransition_eq_add_of_isPreconnected z w
      Metric.isPreconnected_ball hball (Metric.mem_ball_self hr)
  refine ⟨Metric.ball y r, Metric.isOpen_ball, Metric.mem_ball_self hr, ?_⟩
  have htrans : ContDiffOn ℂ ω
      (fun x : GenusComplexVector g => x + (period : GenusComplexVector g))
      ((d.exponentialBranchTransition z w).source ∩ Metric.ball y r) :=
    contDiffOn_id.add contDiffOn_const
  exact htrans.congr (by intro x hx; exact hperiod x hx.2)

/- Bundling the overlap as a partial diffeomorphism makes its smooth inverse
   available to a future quotient-manifold atlas construction. -/
noncomputable def exponentialBranchTransitionPartialDiffeomorph
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    PartialDiffeomorph (𝓘(ℂ, GenusComplexVector g))
      (𝓘(ℂ, GenusComplexVector g)) (GenusComplexVector g)
      (GenusComplexVector g) ω where
  toPartialEquiv := (d.exponentialBranchTransition z w).toPartialEquiv
  open_source := d.exponentialBranchTransition_source_isOpen z w
  open_target := d.exponentialBranchTransition_target_isOpen z w
  contMDiffOn_toFun := (d.exponentialBranchTransition_contDiffOn z w).contMDiffOn
  contMDiffOn_invFun := by
    rw [OpenPartialHomeomorph.invFun_eq_coe]
    have hsymm :
        (d.exponentialBranchTransition z w).symm =
          d.exponentialBranchTransition w z := by
      rw [exponentialBranchTransition,
        OpenPartialHomeomorph.trans_symm_eq_symm_trans_symm]
      rfl
    rw [hsymm]
    exact (d.exponentialBranchTransition_contDiffOn w z).contMDiffOn

theorem exponentialBranchTransition_symm_continuousOn
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    ContinuousOn (d.exponentialBranchTransition z w).symm
      (d.exponentialBranchTransition z w).target :=
  (d.exponentialBranchTransition z w).continuousOn_symm

theorem exponentialBranchTransition_image_source_eq_target
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    d.exponentialBranchTransition z w ''
        (d.exponentialBranchTransition z w).source =
      (d.exponentialBranchTransition z w).target :=
  (d.exponentialBranchTransition z w).image_source_eq_target

/- Exchanging the two branch labels reverses the transition. -/
@[simp]
theorem exponentialBranchTransition_symm_eq
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    (d.exponentialBranchTransition z w).symm =
      d.exponentialBranchTransition w z := by
  rw [exponentialBranchTransition,
    OpenPartialHomeomorph.trans_symm_eq_symm_trans_symm]
  rfl

/- The transition maps satisfy the usual Cech cocycle law whenever the two
   successive transitions are defined.  The explicit source hypotheses keep
   the statement honest for partial homeomorphisms. -/
theorem exponentialBranchTransition_cocycle
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w u : GenusComplexVector g) {y : GenusComplexVector g}
    (hyzw : y ∈ (d.exponentialBranchTransition z w).source)
    (hwzu : d.exponentialBranchTransition z w y ∈
      (d.exponentialBranchTransition w u).source) :
    y ∈ (d.exponentialBranchTransition z u).source ∧
      d.exponentialBranchTransition z u y =
        d.exponentialBranchTransition w u
          (d.exponentialBranchTransition z w y) := by
  have hyzw' := hyzw
  rw [exponentialBranchTransition, OpenPartialHomeomorph.trans_source] at hyzw'
  have ztarget : y ∈ (d.exponentialBranch z).target := by
    simpa only [OpenPartialHomeomorph.symm_source] using hyzw'.1
  let x : X := (d.exponentialBranch z).symm y
  have hxw : x ∈ (d.exponentialBranch w).source := by
    exact hyzw'.2
  have htw : d.exponentialBranchTransition z w y =
      d.exponentialBranch w x := by
    change d.exponentialBranch w
      ((d.exponentialBranch z).symm y) = d.exponentialBranch w x
    rfl
  have hwzu' := hwzu
  rw [exponentialBranchTransition, OpenPartialHomeomorph.trans_source] at hwzu'
  have hxu : x ∈ (d.exponentialBranch u).source := by
    have hz := hwzu'.2
    change (d.exponentialBranch w).symm
      (d.exponentialBranchTransition z w y) ∈
        (d.exponentialBranch u).source at hz
    rw [htw, (d.exponentialBranch w).left_inv hxw] at hz
    exact hz
  have hzu : y ∈ (d.exponentialBranchTransition z u).source := by
    rw [exponentialBranchTransition, OpenPartialHomeomorph.trans_source]
    exact ⟨ztarget, hxu⟩
  refine ⟨hzu, ?_⟩
  have htz_u : d.exponentialBranchTransition z u y =
      d.exponentialBranch u x := by
    change d.exponentialBranch u
      ((d.exponentialBranch z).symm y) = d.exponentialBranch u x
    rfl
  have htw_u : d.exponentialBranchTransition w u
      (d.exponentialBranchTransition z w y) =
      d.exponentialBranch u x := by
    change d.exponentialBranch u
      ((d.exponentialBranch w).symm
        (d.exponentialBranchTransition z w y)) =
      d.exponentialBranch u x
    rw [htw, (d.exponentialBranch w).left_inv hxw]
  exact htz_u.trans htw_u.symm

/-! ### An explicit analytic atlas on the lattice quotient

The generic quotient `ChartedSpace` supplied by Mathlib deliberately stops
short of a manifold instance.  The following declarations use the local
inverse branches already constructed above to provide that missing, explicit
atlas for a full complex lattice.  This remains a certificate for the model
quotient: it does not identify an external abelian variety with this quotient
or prove the source-level holomorphic exponential theorem.
-/

theorem quotientBranchTransition_sub_mem_periodLattice
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) {y : GenusComplexVector g}
    (hy : y ∈ ((d.quotientLocalBranchAt z).symm.trans
      (d.quotientLocalBranchAt w)).source) :
    ((d.quotientLocalBranchAt z).symm.trans
      (d.quotientLocalBranchAt w)) y - y ∈ d.periodLattice := by
  rw [OpenPartialHomeomorph.trans_source] at hy
  have hyz : y ∈ (d.quotientLocalBranchAt z).target := hy.1
  let q : GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup :=
    (d.quotientLocalBranchAt z).symm y
  have hqz : q ∈ (d.quotientLocalBranchAt z).source :=
    (d.quotientLocalBranchAt z).map_target hyz
  have hqw : q ∈ (d.quotientLocalBranchAt w).source := hy.2
  have hdiff := d.quotientLocalBranchAt_sub_mem_periodLattice z w hqz hqw
  have hrep : d.quotientLocalBranchAt z q = y :=
    (d.quotientLocalBranchAt z).right_inv hyz
  change d.quotientLocalBranchAt w q - y ∈ d.periodLattice
  simpa only [hrep, neg_sub] using (neg_mem hdiff)

theorem quotientBranchTransition_eq_add_of_isPreconnected
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g)
    {s : Set (GenusComplexVector g)}
    (hs : IsPreconnected s)
    (hsub : s ⊆ ((d.quotientLocalBranchAt z).symm.trans
      (d.quotientLocalBranchAt w)).source)
    {y₀ : GenusComplexVector g} (hy₀ : y₀ ∈ s) :
    ∃ period : d.periodLattice, ∀ y ∈ s,
      ((d.quotientLocalBranchAt z).symm.trans
        (d.quotientLocalBranchAt w)) y = y + (period : GenusComplexVector g) := by
  let f : GenusComplexVector g → GenusComplexVector g :=
    fun y => ((d.quotientLocalBranchAt z).symm.trans
      (d.quotientLocalBranchAt w)) y - y
  have hf : ContinuousOn f s := by
    exact ((((d.quotientLocalBranchAt z).symm.trans
      (d.quotientLocalBranchAt w)).continuousOn).mono hsub).sub
      continuousOn_id
  have hmaps : Set.MapsTo f s
      (d.periodLattice.toAddSubgroup : Set (GenusComplexVector g)) := by
    intro y hy
    exact quotientBranchTransition_sub_mem_periodLattice d z w (hsub hy)
  have hconst : ∀ y ∈ s, f y = f y₀ := by
    intro y hy
    exact IsPreconnected.constant_of_mapsTo hs d.periodLattice_isDiscrete
      hf hmaps hy hy₀
  let period : d.periodLattice := ⟨f y₀, hmaps hy₀⟩
  refine ⟨period, ?_⟩
  intro y hy
  have hyconst : f y = f y₀ := hconst y hy
  dsimp [f, period] at hyconst ⊢
  simpa only [OpenPartialHomeomorph.trans_apply] using (show
    ((d.quotientLocalBranchAt z).symm.trans
      (d.quotientLocalBranchAt w)) y = y +
        (((d.quotientLocalBranchAt z).symm.trans
          (d.quotientLocalBranchAt w)) y₀ - y₀) by
    rw [OpenPartialHomeomorph.trans_apply]
    calc
      d.quotientLocalBranchAt w
          ((d.quotientLocalBranchAt z).symm y) =
          (d.quotientLocalBranchAt w
            ((d.quotientLocalBranchAt z).symm y) - y) + y := by abel
      _ = (d.quotientLocalBranchAt w
            ((d.quotientLocalBranchAt z).symm y₀) - y₀) + y := by
        rw [hyconst]
      _ = y + (d.quotientLocalBranchAt w
            ((d.quotientLocalBranchAt z).symm y₀) - y₀) := by abel)

theorem quotientBranchTransition_contDiffOn
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z w : GenusComplexVector g) :
    ContDiffOn ℂ ω
      ((d.quotientLocalBranchAt z).symm.trans
        (d.quotientLocalBranchAt w))
      ((d.quotientLocalBranchAt z).symm.trans
        (d.quotientLocalBranchAt w)).source := by
  apply contDiffOn_of_locally_contDiffOn
  intro y hy
  obtain ⟨r, hr, hball⟩ := Metric.mem_nhds_iff.mp
    (((d.quotientLocalBranchAt z).symm.trans
      (d.quotientLocalBranchAt w)).open_source.mem_nhds hy)
  obtain ⟨period, hperiod⟩ :=
    quotientBranchTransition_eq_add_of_isPreconnected d z w
      Metric.isPreconnected_ball hball (Metric.mem_ball_self hr)
  refine ⟨Metric.ball y r, Metric.isOpen_ball, Metric.mem_ball_self hr, ?_⟩
  have htrans : ContDiffOn ℂ ω
      (fun x : GenusComplexVector g => x + (period : GenusComplexVector g))
      (((d.quotientLocalBranchAt z).symm.trans
        (d.quotientLocalBranchAt w)).source ∩ Metric.ball y r) :=
    contDiffOn_id.add contDiffOn_const
  exact htrans.congr (by
    intro x hx
    exact hperiod x hx.2)

/- This atlas is an explicit analytic refinement of the generic topological
   quotient charted space.  It is kept as a value, rather than an instance,
   so callers must choose which quotient atlas they want to use. -/
@[reducible]
noncomputable def analyticQuotientChartedSpace
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) :
    ChartedSpace (GenusComplexVector g)
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) where
  atlas := Set.range d.quotientLocalBranchAt
  chartAt q := d.quotientLocalBranchAt
    (Classical.choose (QuotientAddGroup.mk'_surjective
      d.periodLattice.toAddSubgroup q))
  mem_chart_source q := by
    let z := Classical.choose (QuotientAddGroup.mk'_surjective
      d.periodLattice.toAddSubgroup q)
    have hz : QuotientAddGroup.mk' d.periodLattice.toAddSubgroup z = q :=
      Classical.choose_spec (QuotientAddGroup.mk'_surjective
        d.periodLattice.toAddSubgroup q)
    change q ∈ (d.quotientLocalBranchAt z).source
    rw [← hz]
    exact d.quotientLocalBranchAt_quotient_mk_mem_source z
  chart_mem_atlas q := by
    exact ⟨Classical.choose (QuotientAddGroup.mk'_surjective
      d.periodLattice.toAddSubgroup q), rfl⟩

/-- The explicit branch atlas is a complex analytic manifold atlas on the
lattice quotient.  The theorem concerns only this model quotient and its
chosen charts; it is not the missing source-level uniformization theorem. -/
theorem analyticQuotient_isManifold
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) :
    @IsManifold ℂ _ (GenusComplexVector g) _ _ (GenusComplexVector g) _
      (𝓘(ℂ, GenusComplexVector g)) ω
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) _
      (analyticQuotientChartedSpace d) := by
  letI : ChartedSpace (GenusComplexVector g)
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
    analyticQuotientChartedSpace d
  apply isManifold_of_contDiffOn (𝓘(ℂ, GenusComplexVector g)) ω _
  intro e e' he he'
  rcases he with ⟨z, rfl⟩
  rcases he' with ⟨w, rfl⟩
  simpa using quotientBranchTransition_contDiffOn d z w

/-- The quotient projection is complex-analytic for the explicit branch atlas.
This is an analytic statement about the model lattice quotient; it does not
assert that a separately supplied abelian variety is this quotient. -/
theorem analyticQuotient_mk_contMDiff
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) :
    letI : ChartedSpace (GenusComplexVector g)
        (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
      analyticQuotientChartedSpace d
    letI : IsManifold (𝓘(ℂ, GenusComplexVector g)) ω
        (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
      exact analyticQuotient_isManifold d
    ContMDiff (𝓘(ℂ, GenusComplexVector g))
      (𝓘(ℂ, GenusComplexVector g)) ω
      (QuotientAddGroup.mk : GenusComplexVector g →
        GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
  letI : ChartedSpace (GenusComplexVector g)
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
    analyticQuotientChartedSpace d
  letI : IsManifold (𝓘(ℂ, GenusComplexVector g)) ω
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
    exact analyticQuotient_isManifold d
  apply contMDiff_of_contMDiffOn_iUnion_of_isOpen
    (s := fun z : GenusComplexVector g =>
      (d.quotientLocalBranchAt z).target)
  · intro z
    have hbranch : d.quotientLocalBranchAt z ∈
        IsManifold.maximalAtlas (𝓘(ℂ, GenusComplexVector g)) ω
          (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
      IsManifold.subset_maximalAtlas (I := 𝓘(ℂ, GenusComplexVector g))
        (n := ω) (M := GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup)
        ⟨z, rfl⟩
    have hsmooth := contMDiffOn_symm_of_mem_maximalAtlas hbranch
    exact hsmooth.congr (by
      intro y hy
      rw [d.quotientLocalBranchAt_symm])
  · intro z
    exact (d.quotientLocalBranchAt z).open_target
  · apply Set.eq_univ_of_forall
    intro y
    exact Set.mem_iUnion.2 ⟨y, d.quotientLocalBranchAt_mem_target y⟩

/- The same atlas packages each local inverse branch as a partial
   diffeomorphism, making the local-diffeomorphism property of the quotient
   projection available to later covering arguments. -/
noncomputable def analyticQuotient_mk_partialDiffeomorph
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g)
    (z : GenusComplexVector g) :
    letI : ChartedSpace (GenusComplexVector g)
        (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
      analyticQuotientChartedSpace d
    letI : IsManifold (𝓘(ℂ, GenusComplexVector g)) ω
        (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
      exact analyticQuotient_isManifold d
    PartialDiffeomorph (𝓘(ℂ, GenusComplexVector g))
      (𝓘(ℂ, GenusComplexVector g))
      (GenusComplexVector g)
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) ω := by
  letI : ChartedSpace (GenusComplexVector g)
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
    analyticQuotientChartedSpace d
  letI : IsManifold (𝓘(ℂ, GenusComplexVector g)) ω
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
    exact analyticQuotient_isManifold d
  have hbranch : d.quotientLocalBranchAt z ∈
      IsManifold.maximalAtlas (𝓘(ℂ, GenusComplexVector g)) ω
        (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
    IsManifold.subset_maximalAtlas (I := 𝓘(ℂ, GenusComplexVector g))
      (n := ω) (M := GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup)
      ⟨z, rfl⟩
  let branch := d.quotientLocalBranchAt z
  exact {
    toPartialEquiv := branch.symm.toPartialEquiv
    open_source := branch.open_target
    open_target := branch.open_source
    contMDiffOn_toFun := contMDiffOn_symm_of_mem_maximalAtlas hbranch
    contMDiffOn_invFun := contMDiffOn_of_mem_maximalAtlas hbranch }

theorem analyticQuotient_mk_isLocalDiffeomorphAt
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) (x : GenusComplexVector g) :
    letI : ChartedSpace (GenusComplexVector g)
        (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
      analyticQuotientChartedSpace d
    letI : IsManifold (𝓘(ℂ, GenusComplexVector g)) ω
        (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
      exact analyticQuotient_isManifold d
    IsLocalDiffeomorphAt (𝓘(ℂ, GenusComplexVector g))
      (𝓘(ℂ, GenusComplexVector g)) ω
      (QuotientAddGroup.mk : GenusComplexVector g →
        GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) x := by
  letI : ChartedSpace (GenusComplexVector g)
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
    analyticQuotientChartedSpace d
  letI : IsManifold (𝓘(ℂ, GenusComplexVector g)) ω
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
    exact analyticQuotient_isManifold d
  let φ := analyticQuotient_mk_partialDiffeomorph d x
  refine ⟨φ, ?_, ?_⟩
  · exact d.quotientLocalBranchAt_mem_target x
  · intro y hy
    change (QuotientAddGroup.mk : GenusComplexVector g →
        GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) y =
      (d.quotientLocalBranchAt x).symm y
    rw [d.quotientLocalBranchAt_symm]

theorem analyticQuotient_mk_isLocalDiffeomorph
    {X : Type*} [AddCommGroup X] [TopologicalSpace X]
    [T2Space X] [ContinuousAdd X] {g : ℕ}
    (d : ComplexLatticeExponentialData X g) :
    letI : ChartedSpace (GenusComplexVector g)
        (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
      analyticQuotientChartedSpace d
    letI : IsManifold (𝓘(ℂ, GenusComplexVector g)) ω
        (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
      exact analyticQuotient_isManifold d
    IsLocalDiffeomorph (𝓘(ℂ, GenusComplexVector g))
      (𝓘(ℂ, GenusComplexVector g)) ω
      (QuotientAddGroup.mk : GenusComplexVector g →
        GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
  letI : ChartedSpace (GenusComplexVector g)
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) :=
    analyticQuotientChartedSpace d
  letI : IsManifold (𝓘(ℂ, GenusComplexVector g)) ω
      (GenusComplexVector g ⧸ d.periodLattice.toAddSubgroup) := by
    exact analyticQuotient_isManifold d
  intro x
  exact analyticQuotient_mk_isLocalDiffeomorphAt d x

end ComplexLatticeExponentialData

end
end Uniformization
end Mumford
