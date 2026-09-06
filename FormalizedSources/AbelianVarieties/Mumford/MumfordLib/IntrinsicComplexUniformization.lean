/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.CanonicalComplexQuotient
import MumfordLib.ComplexExponentialAtlas
import MumfordLib.ComplexLatticeLieGroup

/-!
# The intrinsic quotient of the canonical exponential candidate

This file places the canonical real-flow exponential candidate and its full
period lattice in the arbitrary-vector quotient atlas.  A caller-supplied
complex coordinate identifies the tangent model with the standard genus
space.  The resulting data can then be reparametrized by
`complexLieAlgebraEquiv` onto the actual identity tangent fibre.

The norm and metric topology on that fibre are installed only inside the
resulting declarations.  They are induced from the chosen manifold model and
are not global instances.  The conclusions concern the canonical candidate;
they do not yet identify it with Mumford's holomorphic exponential or prove
that the quotient equivalence to the group is holomorphic.

Reference: Mumford, *Abelian Varieties*, Chapter I, Section 1, pp. 1--2.
-/

set_option autoImplicit false

noncomputable section

open Function Set
open scoped Topology Manifold ContDiff

namespace Mumford
namespace Analytic

open Uniformization

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [CommGroup G]
  [LieGroup I ω G]
  [CompleteSpace E] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G]

/-- The canonical candidate's period lattice after applying a complex-linear
coordinate on its tangent model. -/
def canonicalComplexExponentialCoordinatePeriodLattice
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    Submodule ℤ (GenusComplexVector g) :=
  ZLattice.comap ℝ (canonicalComplexExponentialPeriodLattice (G := G) I)
    (coordinate.symm.toLinearEquiv.restrictScalars ℝ).toLinearMap

/-- The coordinate image of the canonical period lattice is discrete. -/
theorem canonicalComplexExponentialCoordinatePeriodLattice_discreteTopology
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    DiscreteTopology
      (canonicalComplexExponentialCoordinatePeriodLattice (G := G) I coordinate) := by
  letI : DiscreteTopology
      (canonicalComplexExponentialPeriodLattice (G := G) I) :=
    canonicalComplexExponentialPeriodLattice_discreteTopology (G := G) I
  exact ZLattice.comap_discreteTopology ℝ
    (canonicalComplexExponentialPeriodLattice (G := G) I)
    coordinate.symm.continuous coordinate.symm.injective

/-- The coordinate image of the canonical period lattice remains a full real
`ℤ`-lattice. -/
theorem canonicalComplexExponentialCoordinatePeriodLattice_isZLattice
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    letI : DiscreteTopology
        (canonicalComplexExponentialCoordinatePeriodLattice
          (G := G) I coordinate) :=
      canonicalComplexExponentialCoordinatePeriodLattice_discreteTopology
        (G := G) I coordinate
    IsZLattice ℝ
      (canonicalComplexExponentialCoordinatePeriodLattice
        (G := G) I coordinate) := by
  letI : DiscreteTopology
      (canonicalComplexExponentialPeriodLattice (G := G) I) :=
    canonicalComplexExponentialPeriodLattice_discreteTopology (G := G) I
  letI : IsZLattice ℝ
      (canonicalComplexExponentialPeriodLattice (G := G) I) :=
    canonicalComplexExponentialPeriodLattice_isZLattice (G := G) I
  letI : DiscreteTopology
      (canonicalComplexExponentialCoordinatePeriodLattice
        (G := G) I coordinate) :=
    canonicalComplexExponentialCoordinatePeriodLattice_discreteTopology
      (G := G) I coordinate
  let coordinateReal : GenusComplexVector g ≃L[ℝ] E :=
    ContinuousLinearEquiv.mk
      (coordinate.symm.toLinearEquiv.restrictScalars ℝ)
      coordinate.symm.continuous coordinate.continuous
  exact instIsZLatticeComap ℝ
    (canonicalComplexExponentialPeriodLattice (G := G) I) coordinateReal

/-- The canonical exponential candidate as arbitrary-vector lattice
exponential data in a supplied genus coordinate. -/
def canonicalComplexVectorLatticeExponentialData
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    ComplexVectorLatticeExponentialData E (Additive G) g where
  coordinate := coordinate
  periodLattice :=
    canonicalComplexExponentialCoordinatePeriodLattice (G := G) I coordinate
  periodLatticeDiscrete :=
    canonicalComplexExponentialCoordinatePeriodLattice_discreteTopology
      (G := G) I coordinate
  periodLatticeFull :=
    canonicalComplexExponentialCoordinatePeriodLattice_isZLattice
      (G := G) I coordinate
  exponential := canonicalComplexExponentialAddHom (G := G) I
  surjective := canonicalComplexExponentialAddHom_surjective (G := G) I
  continuous := canonicalComplexExponentialAddHom_continuous (G := G) I
  kernel := by
    rw [← canonicalComplexExponentialPeriodLattice_toAddSubgroup (G := G) I]
    ext v
    simp only [Submodule.mem_toAddSubgroup, Submodule.mem_comap]
    change v ∈ canonicalComplexExponentialPeriodLattice (G := G) I ↔
      coordinate.symm (coordinate v) ∈
        canonicalComplexExponentialPeriodLattice (G := G) I
    rw [coordinate.symm_apply_apply]

/-- The ambient lattice recovered from the coordinate package is exactly the
canonical candidate's kernel lattice in the original model. -/
theorem canonicalComplexVectorLatticeExponentialData_ambientPeriodLattice
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    (canonicalComplexVectorLatticeExponentialData (G := G) I coordinate).ambientPeriodLattice =
      (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup := by
  rw [← (canonicalComplexVectorLatticeExponentialData
    (G := G) I coordinate).exponential_ker]
  exact
    (canonicalComplexExponentialPeriodLattice_toAddSubgroup (G := G) I).symm

/-! ### Intrinsic tangent-fibre data

The tangent fibre already carries its manifold topology, but Mathlib does not
give it a global normed-space instance.  The following definition therefore
binds the normed and metric-topological structures induced from `E` in its
result type.  This makes the choice explicit and prevents instance leakage.
-/

/-- Reparametrize the canonical lattice exponential data onto the identity
tangent fibre, using only locally bound model-induced structures there. -/
noncomputable def intrinsicComplexVectorLatticeExponentialData
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
      complexLieAlgebraEquiv (G := G) I
    letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
      NormedAddCommGroup.induced _ _
        e.symm.toLinearMap.toAddMonoidHom e.symm.injective
    letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
      NormedSpace.induced ℂ _ _ e.symm.toLinearMap
    letI : UniformSpace (GroupLieAlgebra I G) :=
      @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
    letI : TopologicalSpace (GroupLieAlgebra I G) :=
      @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
    ComplexVectorLatticeExponentialData
      (GroupLieAlgebra I G) (Additive G) g := by
  let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
    complexLieAlgebraEquiv (G := G) I
  letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
    NormedAddCommGroup.induced _ _
      e.symm.toLinearMap.toAddMonoidHom e.symm.injective
  letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
    NormedSpace.induced ℂ _ _ e.symm.toLinearMap
  letI : UniformSpace (GroupLieAlgebra I G) :=
    @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
  letI : TopologicalSpace (GroupLieAlgebra I G) :=
    @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
  let tangentToModel : GroupLieAlgebra I G ≃L[ℂ] E :=
    ContinuousLinearEquiv.mk e.symm
      (continuous_induced_dom : Continuous
        (e.symm : GroupLieAlgebra I G → E))
      (by
        apply continuous_induced_rng.mpr
        change Continuous (id : E → E)
        exact continuous_id)
  exact
    (canonicalComplexVectorLatticeExponentialData (G := G) I coordinate).reparam
      tangentToModel

@[simp]
theorem intrinsicComplexVectorLatticeExponentialData_exponential_apply
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g)
    (v : GroupLieAlgebra I G) :
    let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
      complexLieAlgebraEquiv (G := G) I
    letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
      NormedAddCommGroup.induced _ _
        e.symm.toLinearMap.toAddMonoidHom e.symm.injective
    letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
      NormedSpace.induced ℂ _ _ e.symm.toLinearMap
    letI : UniformSpace (GroupLieAlgebra I G) :=
      @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
    letI : TopologicalSpace (GroupLieAlgebra I G) :=
      @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
    (intrinsicComplexVectorLatticeExponentialData
      (G := G) I coordinate).exponential v =
      intrinsicComplexExponentialAddHom (G := G) I v := by
  let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
    complexLieAlgebraEquiv (G := G) I
  letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
    NormedAddCommGroup.induced _ _
      e.symm.toLinearMap.toAddMonoidHom e.symm.injective
  letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
    NormedSpace.induced ℂ _ _ e.symm.toLinearMap
  letI : UniformSpace (GroupLieAlgebra I G) :=
    @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
  letI : TopologicalSpace (GroupLieAlgebra I G) :=
    @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
  rfl

/-- The reparametrized data recovers exactly the named intrinsic period
lattice, not merely an abstract isomorphic copy. -/
theorem intrinsicComplexVectorLatticeExponentialData_ambientPeriodLattice
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
      complexLieAlgebraEquiv (G := G) I
    letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
      NormedAddCommGroup.induced _ _
        e.symm.toLinearMap.toAddMonoidHom e.symm.injective
    letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
      NormedSpace.induced ℂ _ _ e.symm.toLinearMap
    letI : UniformSpace (GroupLieAlgebra I G) :=
      @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
    letI : TopologicalSpace (GroupLieAlgebra I G) :=
      @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
    (intrinsicComplexVectorLatticeExponentialData
        (G := G) I coordinate).ambientPeriodLattice =
      (intrinsicComplexExponentialPeriodLattice
        (G := G) I).toAddSubgroup := by
  let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
    complexLieAlgebraEquiv (G := G) I
  letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
    NormedAddCommGroup.induced _ _
      e.symm.toLinearMap.toAddMonoidHom e.symm.injective
  letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
    NormedSpace.induced ℂ _ _ e.symm.toLinearMap
  letI : UniformSpace (GroupLieAlgebra I G) :=
    @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
  letI : TopologicalSpace (GroupLieAlgebra I G) :=
    @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
  let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
  ext v
  rw [← d.exponential_ker]
  change d.exponential v = 0 ↔
    v ∈ intrinsicComplexExponentialPeriodLattice (G := G) I
  rw [intrinsicComplexVectorLatticeExponentialData_exponential_apply]
  rw [← AddMonoidHom.mem_ker]
  rfl

/-- The scoped intrinsic candidate carries the explicit analytic manifold atlas
on its lattice quotient.  This is the quotient-side part of uniformization;
the holomorphic identification of this quotient with `G` remains separate. -/
theorem intrinsicComplexVectorLatticeExponentialData_quotient_isManifold
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
      complexLieAlgebraEquiv (G := G) I
    letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
      NormedAddCommGroup.induced _ _
        e.symm.toLinearMap.toAddMonoidHom e.symm.injective
    letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
      NormedSpace.induced ℂ _ _ e.symm.toLinearMap
    letI : UniformSpace (GroupLieAlgebra I G) :=
      @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
    letI : TopologicalSpace (GroupLieAlgebra I G) :=
      @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
    let d := intrinsicComplexVectorLatticeExponentialData
      (G := G) I coordinate
    @IsManifold ℂ _ (GroupLieAlgebra I G) _ _ (GroupLieAlgebra I G) _
      (𝓘(ℂ, GroupLieAlgebra I G)) ω
      (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) _
      (ComplexVectorLatticeExponentialData.analyticQuotientChartedSpace d) := by
  let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
    complexLieAlgebraEquiv (G := G) I
  letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
    NormedAddCommGroup.induced _ _
      e.symm.toLinearMap.toAddMonoidHom e.symm.injective
  letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
    NormedSpace.induced ℂ _ _ e.symm.toLinearMap
  letI : UniformSpace (GroupLieAlgebra I G) :=
    @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
  letI : TopologicalSpace (GroupLieAlgebra I G) :=
    @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
  let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
  exact ComplexVectorLatticeExponentialData.analyticQuotient_isManifold d

/- The same intrinsic quotient carries the explicit smooth additive-group
   structure supplied by the branch atlas.  The charted-space value remains
   local to the declaration, so this does not install a global instance. -/
theorem intrinsicComplexVectorLatticeExponentialData_quotient_isLieAddGroup
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
      complexLieAlgebraEquiv (G := G) I
    letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
      NormedAddCommGroup.induced _ _
        e.symm.toLinearMap.toAddMonoidHom e.symm.injective
    letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
      NormedSpace.induced ℂ _ _ e.symm.toLinearMap
    letI : UniformSpace (GroupLieAlgebra I G) :=
      @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
    letI : TopologicalSpace (GroupLieAlgebra I G) :=
      @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
    let d := intrinsicComplexVectorLatticeExponentialData
      (G := G) I coordinate
    letI : ChartedSpace (GroupLieAlgebra I G)
        (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) :=
      ComplexVectorLatticeExponentialData.analyticQuotientChartedSpace d
    LieAddGroup (𝓘(ℂ, GroupLieAlgebra I G)) ω
      (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) := by
  let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
    complexLieAlgebraEquiv (G := G) I
  letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
    NormedAddCommGroup.induced _ _
      e.symm.toLinearMap.toAddMonoidHom e.symm.injective
  letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
    NormedSpace.induced ℂ _ _ e.symm.toLinearMap
  letI : UniformSpace (GroupLieAlgebra I G) :=
    @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
  letI : TopologicalSpace (GroupLieAlgebra I G) :=
    @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
  let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
  letI : ChartedSpace (GroupLieAlgebra I G)
      (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) :=
    ComplexVectorLatticeExponentialData.analyticQuotientChartedSpace d
  exact ComplexVectorLatticeExponentialData.analyticQuotientLieAddGroup d

end Analytic
end Mumford
