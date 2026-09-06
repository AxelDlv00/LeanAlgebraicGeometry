/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexVectorLattice
import MumfordLib.LatticeTransport
import MumfordLib.ZLattice
import Mathlib.Algebra.Module.ZLattice.Basic

/-!
# Torus coordinates for a full period lattice

A full discrete integral lattice in a finite-dimensional complex vector space
admits real coordinates in which it is the standard integer lattice.  This
file packages that elementary change of coordinates and the induced quotient
equivalence to `GenusTorus`.
-/

set_option autoImplicit false

namespace Mumford
namespace Uniformization

noncomputable section

namespace ComplexVectorLatticeExponentialData

private def latticeBasis
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g) :
    Module.Basis (Fin (2 * g)) ℤ d.periodLattice := by
  letI : DiscreteTopology d.periodLattice := d.periodLatticeDiscrete
  letI : IsZLattice ℝ d.periodLattice := d.periodLatticeFull
  exact Module.finBasisOfFinrankEq ℤ d.periodLattice d.toCanonical.periodLattice_finrank

private def latticeRealBasis
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g) :
    Module.Basis (Fin (2 * g)) ℝ (GenusComplexVector g) := by
  letI : DiscreteTopology d.periodLattice := d.periodLatticeDiscrete
  letI : IsZLattice ℝ d.periodLattice := d.periodLatticeFull
  exact Module.Basis.ofZLatticeBasis ℝ d.periodLattice (latticeBasis d)

/-- Real coordinates obtained from an integral basis of the period lattice. -/
noncomputable def latticeCoordinate
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g) :
    V ≃ₗ[ℝ] GenusRealVector g :=
  d.coordinate.toLinearEquiv.restrictScalars ℝ |>.trans (latticeRealBasis d).equivFun

private theorem map_lattice_periodLattice
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g) :
    Submodule.map ((latticeRealBasis d).equivFun.toLinearMap.restrictScalars ℤ)
        d.periodLattice = integerPeriodLatticeSubmodule g := by
  letI : DiscreteTopology d.periodLattice := d.periodLatticeDiscrete
  letI : IsZLattice ℝ d.periodLattice := d.periodLatticeFull
  let b := latticeBasis d
  let bR := latticeRealBasis d
  have hspan : Submodule.span ℤ (Set.range (bR : Fin (2 * g) → GenusComplexVector g)) =
      d.periodLattice := by
    exact Module.Basis.ofZLatticeBasis_span ℝ d.periodLattice b
  have htarget : integerPeriodLatticeSubmodule g =
      Submodule.span ℤ (Set.range (Pi.basisFun ℝ (Fin (2 * g)))) :=
    integerPeriodLatticeSubmodule_eq_span g
  rw [← hspan, Submodule.map_span, htarget]
  congr 1
  ext y
  constructor
  · rintro ⟨x, ⟨i, rfl⟩, rfl⟩
    refine ⟨i, ?_⟩
    ext j
    classical
    by_cases h : i = j <;> simp [h, bR]
  · rintro ⟨i, rfl⟩
    refine ⟨bR i, ⟨i, rfl⟩, ?_⟩
    ext j
    classical
    by_cases h : i = j <;> simp [h, bR]

/-- The quotient of the tangent model by its ambient period lattice is the
standard genus torus. -/
noncomputable def quotientGenusTorusAddEquiv
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g) :
    (V ⧸ d.ambientPeriodLattice) ≃+ GenusTorus g := by
  let e := d.latticeCoordinate
  let h : AddSubgroup.map (e.toAddEquiv : V →+ GenusRealVector g)
      d.ambientPeriodLattice = integerPeriodLattice g := by
    ext y
    constructor
    · rintro ⟨v, hv, rfl⟩
      have hv' : v ∈ d.ambientPeriodLatticeSubmodule := hv
      have hc : d.coordinate v ∈ d.periodLattice :=
        (d.ambientPeriodLattice_mem_iff v).1 hv
      have hm : (latticeRealBasis d).equivFun (d.coordinate v) ∈
          integerPeriodLatticeSubmodule g := by
        rw [← map_lattice_periodLattice d]
        exact Submodule.mem_map_of_mem hc
      exact hm
    · intro hy
      have hy' : y ∈ integerPeriodLatticeSubmodule g := hy
      have hm : y ∈ Submodule.map
          ((latticeRealBasis d).equivFun.toLinearMap.restrictScalars ℤ)
            d.periodLattice := by
        rw [map_lattice_periodLattice d]
        exact hy'
      rcases Submodule.mem_map.mp hm with ⟨z, hz, hzy⟩
      refine ⟨d.coordinate.symm z, ?_, ?_⟩
      · apply (d.ambientPeriodLattice_mem_iff _).2
        simpa using hz
      · change e (d.coordinate.symm z) = y
        simpa [e, latticeCoordinate] using hzy
  exact (periodLatticeQuotientAddEquivOfLinearEquiv
    d.ambientPeriodLattice (integerPeriodLattice g) e h).trans
    (genusRealVectorQuotientAddEquiv g)

end ComplexVectorLatticeExponentialData

end
end Uniformization
end Mumford
