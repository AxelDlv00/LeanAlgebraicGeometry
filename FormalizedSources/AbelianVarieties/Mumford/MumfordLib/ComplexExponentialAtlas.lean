/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexQuotientAtlas

/-!
# Local exponential branches

The quotient atlas gives local inverses of the ambient quotient projection.  We
transport these branches across the quotient homeomorphism to obtain local
inverse branches of the exponential itself.  All assertions here are
topological and additive; no holomorphic structure is used.
-/

set_option autoImplicit false

namespace Mumford
namespace Uniformization

noncomputable section

namespace ComplexVectorLatticeExponentialData

/-- The local inverse branch of the exponential at a chosen representative. -/
noncomputable def exponentialBranch
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] [T2Space X] [ContinuousAdd X]
    {g : ℕ} (d : ComplexVectorLatticeExponentialData V X g) (v : V) :
    OpenPartialHomeomorph X V :=
  d.quotientHomeomorph.symm.toOpenPartialHomeomorph.trans
    (d.quotientLocalBranchAt v)

@[simp]
theorem exponential_source_mem
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] [T2Space X] [ContinuousAdd X]
    {g : ℕ} (d : ComplexVectorLatticeExponentialData V X g) (v : V) :
    d.exponential v ∈ (d.exponentialBranch v).source := by
  rw [exponentialBranch, OpenPartialHomeomorph.trans_source]
  constructor
  · simp
  · rw [Set.mem_preimage]
    change d.quotientHomeomorph.symm (d.exponential v) ∈
      (d.quotientLocalBranchAt v).source
    rw [d.quotientHomeomorph_symm_exponential]
    exact d.quotientLocalBranchAt_quotient_mk_mem_source v

@[simp]
theorem exponential_apply_exponential
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] [T2Space X] [ContinuousAdd X]
    {g : ℕ} (d : ComplexVectorLatticeExponentialData V X g) (v : V) :
    d.exponentialBranch v (d.exponential v) = v := by
  rw [exponentialBranch, OpenPartialHomeomorph.trans_apply]
  change d.quotientLocalBranchAt v
    (d.quotientHomeomorph.symm (d.exponential v)) = v
  rw [d.quotientHomeomorph_symm_exponential]
  exact d.quotientLocalBranchAt_apply_quotient_mk v

/-- On a branch target, the inverse branch recovers the original exponential. -/
theorem exponential_symm_apply_eq_exponential
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] [T2Space X] [ContinuousAdd X]
    {g : ℕ} (d : ComplexVectorLatticeExponentialData V X g) (v : V)
    {y : V} (hy : y ∈ (d.exponentialBranch v).target) :
    (d.exponentialBranch v).symm y = d.exponential y := by
  have hy' : y ∈ (d.quotientLocalBranchAt v).target := by
    rw [exponentialBranch, OpenPartialHomeomorph.trans_target] at hy
    exact hy.1
  rw [exponentialBranch]
  change d.quotientHomeomorph
      ((d.quotientLocalBranchAt v).symm y) = d.exponential y
  have hsource : (d.quotientLocalBranchAt v).symm y ∈
      (d.quotientLocalBranchAt v).source :=
    (d.quotientLocalBranchAt v).map_target hy'
  have hmk : (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice) y =
      (d.quotientLocalBranchAt v).symm y := by
    rw [← d.quotient_mk_apply_quotientLocalBranchAt v hsource]
    rw [(d.quotientLocalBranchAt v).right_inv hy']
  rw [← hmk]
  change d.quotientHomeomorph
      (QuotientAddGroup.mk' d.ambientPeriodLattice y) = d.exponential y
  rw [d.quotientHomeomorph_mk]

/-- Applying the exponential after a branch returns the original source point. -/
theorem exponential_apply_exponential_apply
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] [T2Space X] [ContinuousAdd X]
    {g : ℕ} (d : ComplexVectorLatticeExponentialData V X g) (v : V)
    {x : X} (hx : x ∈ (d.exponentialBranch v).source) :
    d.exponential ((d.exponentialBranch v) x) = x := by
  have hxt : (d.exponentialBranch v) x ∈ (d.exponentialBranch v).target :=
    (d.exponentialBranch v).map_source hx
  rw [← d.exponential_symm_apply_eq_exponential v hxt]
  exact (d.exponentialBranch v).left_inv hx

/-- Two local quotient representatives differ by an ambient period. -/
theorem quotientLocalBranchAt_sub_mem_ambientPeriodLattice
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] [T2Space X] [ContinuousAdd X]
    {g : ℕ} (d : ComplexVectorLatticeExponentialData V X g)
    (v w : V) {q : V ⧸ d.ambientPeriodLattice}
    (hqv : q ∈ (d.quotientLocalBranchAt v).source)
    (hqw : q ∈ (d.quotientLocalBranchAt w).source) :
    d.quotientLocalBranchAt v q - d.quotientLocalBranchAt w q ∈
      d.ambientPeriodLattice := by
  apply (PeriodLatticeQuotient.quotientAddEquiv_mk_eq_iff
    d.toPeriodLatticeQuotient
    (d.quotientLocalBranchAt v q)
    (d.quotientLocalBranchAt w q)).mp
  change d.quotientAddEquiv
      (QuotientAddGroup.mk' d.ambientPeriodLattice
        (d.quotientLocalBranchAt v q)) =
    d.quotientAddEquiv
      (QuotientAddGroup.mk' d.ambientPeriodLattice
        (d.quotientLocalBranchAt w q))
  exact congrArg d.quotientAddEquiv
    ((d.quotient_mk_apply_quotientLocalBranchAt v hqv).trans
      (d.quotient_mk_apply_quotientLocalBranchAt w hqw).symm)

end ComplexVectorLatticeExponentialData

end
end Uniformization
end Mumford
