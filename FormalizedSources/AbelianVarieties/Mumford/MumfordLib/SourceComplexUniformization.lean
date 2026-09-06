/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.IntrinsicQuotientDiffeomorph

/-!
# Uniformization from compact connected complex Lie groups

The original Lie-group assumptions imply commutativity, finite dimensionality,
and completeness. A finite basis then supplies genus coordinates for the
already constructed intrinsic exponential. The resulting quotient is complex
`C¹` diffeomorphic to the group by the map induced by that same exponential.

The norm on the actual identity tangent fibre is induced from the manifold
model and scoped to the theorem. Its topology agrees with the native tangent
topology by `intrinsicComplexLieAlgebra_inducedTopology_eq`.

Reference: Mumford, *Abelian Varieties*, Chapter I, Section 1, pp. 1--2.
-/

set_option autoImplicit false

noncomputable section

open scoped Topology Manifold ContDiff IsMulCommutative

namespace Mumford.Analytic

open Uniformization ComplexVectorLatticeExponentialData

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ω G] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G]

/-- The intrinsic exponential of a compact connected complex Lie group is
surjective and additive, its kernel is a discrete full lattice of rank twice
the complex dimension, and its quotient map is a complex `C¹` group
diffeomorphism. All auxiliary completeness, commutativity, and coordinate
data are derived from the original Lie-group assumptions. -/
theorem compactComplexLieGroup_uniformization :
    letI : FiniteDimensional ℂ E :=
      FiniteDimensional.of_locallyCompact_manifold G I
    letI : CompleteSpace E := FiniteDimensional.complete ℂ E
    letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
    letI : CommGroup G := inferInstance
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
    ∃ coordinate : E ≃L[ℂ] GenusComplexVector (Module.finrank ℂ E),
      let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
      letI : ChartedSpace (GroupLieAlgebra I G)
          (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) :=
        analyticQuotientChartedSpace d
      d.ambientPeriodLattice =
          (intrinsicComplexExponentialPeriodLattice (G := G) I).toAddSubgroup ∧
        (∀ v : GroupLieAlgebra I G,
          intrinsicComplexExponential (G := G) I v = 1 ↔
            v ∈ intrinsicComplexExponentialPeriodLattice (G := G) I) ∧
        DiscreteTopology (intrinsicComplexExponentialPeriodLattice (G := G) I) ∧
        Submodule.span ℝ
            (intrinsicComplexExponentialPeriodLattice (G := G) I :
              Set (GroupLieAlgebra I G)) = ⊤ ∧
        Module.finrank ℤ (intrinsicComplexExponentialPeriodLattice (G := G) I) =
          2 * Module.finrank ℂ E ∧
        Function.Surjective (intrinsicComplexExponential (G := G) I) ∧
        ContMDiff (𝓘(ℂ, GroupLieAlgebra I G)) I 1
          (intrinsicComplexExponential (G := G) I) ∧
        (∀ v w : GroupLieAlgebra I G,
          intrinsicComplexExponential (G := G) I (v + w) =
            intrinsicComplexExponential (G := G) I v *
              intrinsicComplexExponential (G := G) I w) ∧
        LieAddGroup (𝓘(ℂ, GroupLieAlgebra I G)) ω
          (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) ∧
        ∃ f : Diffeomorph (𝓘(ℂ, GroupLieAlgebra I G)) I
            (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) G 1,
          (∀ v : GroupLieAlgebra I G,
            f (QuotientAddGroup.mk' d.ambientPeriodLattice v) =
              intrinsicComplexExponential (G := G) I v) ∧
          ∀ q r : GroupLieAlgebra I G ⧸ d.ambientPeriodLattice,
            f (q + r) = f q * f r := by
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : CompleteSpace E := FiniteDimensional.complete ℂ E
  letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
  letI : CommGroup G := inferInstance
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
  let coordinate : E ≃L[ℂ] GenusComplexVector (Module.finrank ℂ E) :=
    (Module.finBasisOfFinrankEq ℂ E rfl).equivFunL
  refine ⟨coordinate, ?_⟩
  let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
  have hperiod := intrinsicComplexVectorLatticeExponentialData_ambientPeriodLattice
    (G := G) I coordinate
  have hsubmodule : d.ambientPeriodLatticeSubmodule =
      intrinsicComplexExponentialPeriodLattice (G := G) I := by
    ext v
    exact SetLike.ext_iff.mp hperiod v
  have hdiscrete :
      DiscreteTopology (intrinsicComplexExponentialPeriodLattice (G := G) I) := by
    rw [← hsubmodule]
    infer_instance
  refine ⟨hperiod,
    intrinsicComplexExponential_eq_one_iff_mem_periodLattice (G := G) I,
    hdiscrete,
    intrinsicComplexExponentialPeriodLattice_span_eq_top (G := G) I, ?_,
    intrinsicComplexExponential_surjective (G := G) I,
    (intrinsicComplexExponential_isLocalDiffeomorph (G := G) I).contMDiff,
    intrinsicComplexExponential_add (G := G) I,
    intrinsicComplexVectorLatticeExponentialData_quotient_isLieAddGroup
      (G := G) I coordinate, ?_⟩
  · rw [← hsubmodule]
    exact d.ambientPeriodLattice_finrank
  · refine ⟨intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate,
      ?_, ?_⟩
    · exact intrinsicComplexExponentialQuotientDiffeomorph_mk (G := G) I coordinate
    · exact intrinsicComplexExponentialQuotientDiffeomorph_add (G := G) I coordinate

end Mumford.Analytic
