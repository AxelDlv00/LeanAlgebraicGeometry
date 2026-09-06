/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexVectorLatticeTopology
import Mathlib.Analysis.Convex.Contractible
import Mathlib.Topology.Homotopy.Lifting

/-!
# The simply connected cover and lifted periods

The complex vector model is contractible, hence simply connected.  For an
explicit full-lattice quotient, lifting a based loop through the quotient
covering map therefore ends at a period of the lattice.  This is the first
topological producer needed for the fundamental-group identification.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford
namespace Uniformization

open ComplexVectorLatticeExponentialData

theorem genusComplexVector_simplyConnected (g : ℕ) :
    SimplyConnectedSpace (GenusComplexVector g) := by
  infer_instance

theorem quotient_liftPath_endpoint_mem_ambientPeriodLattice
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g)
    {γ : Path (0 : V ⧸ d.ambientPeriodLattice) 0} :
    let cov := d.quotient_mk_isCoveringMap
    let hstart : γ 0 = QuotientAddGroup.mk' d.ambientPeriodLattice 0 := by
      simpa using γ.source
    let Γ := cov.liftPath γ 0 hstart
    Γ 1 ∈ d.ambientPeriodLattice := by
  let cov := d.quotient_mk_isCoveringMap
  let hstart : γ 0 = QuotientAddGroup.mk' d.ambientPeriodLattice 0 := by
    simpa using γ.source
  let Γ := cov.liftPath γ 0 hstart
  have hlift :
      (QuotientAddGroup.mk' d.ambientPeriodLattice) (Γ 1) = γ 1 := by
    exact congr_fun (cov.liftPath_lifts γ 0 hstart) 1
  have hzero :
      (QuotientAddGroup.mk' d.ambientPeriodLattice) (Γ 1) = 0 := by
    rw [hlift]
    exact γ.target
  exact (QuotientAddGroup.eq_zero_iff (Γ 1)).mp hzero

/- The monodromy endpoint of a based loop lies in the period lattice.  This is
   the quotient-level form of the preceding lift endpoint statement and is the
   interface used by the fundamental-group bridge. -/
theorem quotient_monodromy_endpoint_mem_ambientPeriodLattice
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g)
    {γ : Path.Homotopic.Quotient
      (0 : V ⧸ d.ambientPeriodLattice)
      0} :
    (d.quotient_mk_isCoveringMap.monodromy γ
      ⟨0, by simp⟩).1 ∈ d.ambientPeriodLattice := by
  induction γ using Path.Homotopic.Quotient.ind with
  | _ p =>
      change (d.quotient_mk_isCoveringMap.liftPath p 0
        p.source 1) ∈ d.ambientPeriodLattice
      exact quotient_liftPath_endpoint_mem_ambientPeriodLattice d

/- Every period is realized by a based loop: lift the straight segment from
   the origin to that period and project it to the quotient. -/
theorem quotient_liftPath_endpoint_surjective
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g) :
    ∀ u : d.ambientPeriodLattice,
      ∃ γ : Path.Homotopic.Quotient
          (0 : V ⧸ d.ambientPeriodLattice) 0,
        (d.quotient_mk_isCoveringMap.monodromy γ
          ⟨0, by simp⟩).1 = u := by
  intro u
  let Γ : Path (0 : V) (u : V) :=
    { toFun := fun t => (t : ℝ) • (u : V)
      source' := by simp
      target' := by simp }
  let γ : Path (0 : V ⧸ d.ambientPeriodLattice) 0 :=
    { toFun := fun t => QuotientAddGroup.mk'
          d.ambientPeriodLattice ((Γ t : V))
      continuous_toFun := QuotientAddGroup.continuous_mk.comp Γ.continuous
      source' := by simp [Γ]
      target' := by
        simp [Γ, QuotientAddGroup.eq_zero_iff, u.property] }
  refine ⟨Path.Homotopic.Quotient.mk γ, ?_⟩
  let hstart : (γ : C(unitInterval, V ⧸ d.ambientPeriodLattice)) 0 = 0 := by
    simpa using γ.source
  change (d.quotient_mk_isCoveringMap.monodromy
      (Path.Homotopic.Quotient.mk γ) ⟨0, by simp⟩).1 = u
  change (d.quotient_mk_isCoveringMap.liftPath (γ : C(unitInterval, V ⧸
      d.ambientPeriodLattice)) 0 hstart 1) = u
  have hproj : (fun v : V => QuotientAddGroup.mk'
      d.ambientPeriodLattice v) ∘ Γ.toContinuousMap = γ.toContinuousMap := by
    ext t
    rfl
  have hlift := (d.quotient_mk_isCoveringMap.eq_liftPath_iff'
      hstart).mpr ⟨hproj, by simp [Γ]⟩
  rw [← hlift]
  simp [Γ]

end Uniformization
end Mumford
