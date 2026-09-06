/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SourceComplexUniformization
import MumfordLib.FundamentalGroupEquivalence
import MumfordLib.FundamentalGroupTransport

/-!
# The fundamental group and the intrinsic period lattice

The source uniformization supplies a based homeomorphism from the full-lattice
quotient to the original compact connected complex Lie group. Transporting the
lifted-endpoint isomorphism along it identifies the fundamental group with the
kernel of the intrinsic exponential.

Reference: Mumford, *Abelian Varieties*, Chapter I, Section 1, p. 3, the first
step in the proof of the integral-cohomology assertion.
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

/-- The fundamental group at the identity is the intrinsic exponential period lattice.
All uniformization data are derived from the original complex Lie-group hypotheses. -/
def compactComplexLieGroupFundamentalGroupPeriodEquiv :
    letI : FiniteDimensional ℂ E :=
      FiniteDimensional.of_locallyCompact_manifold G I
    letI : CompleteSpace E := FiniteDimensional.complete ℂ E
    letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
    letI : CommGroup G := inferInstance
    FundamentalGroup G 1 ≃*
      Multiplicative (intrinsicComplexExponentialPeriodLattice (G := G) I) := by
  apply Classical.choice
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : CompleteSpace E := FiniteDimensional.complete ℂ E
  letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
  letI : CommGroup G := inferInstance
  let e : E ≃ₗ[ℂ] GroupLieAlgebra I G := complexLieAlgebraEquiv (G := G) I
  letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
    NormedAddCommGroup.induced _ _
      e.symm.toLinearMap.toAddMonoidHom e.symm.injective
  letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
    NormedSpace.induced ℂ _ _ e.symm.toLinearMap
  letI : UniformSpace (GroupLieAlgebra I G) :=
    @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
  letI : TopologicalSpace (GroupLieAlgebra I G) :=
    @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
  obtain ⟨coordinate, hperiod, _, _, _, _, _, _, _, _, f, _, hadd⟩ :=
    compactComplexLieGroup_uniformization (G := G) I
  let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
  letI : ChartedSpace (GroupLieAlgebra I G)
      (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) := analyticQuotientChartedSpace d
  have hf : f 0 = 1 := by
    apply mul_left_cancel (a := f 0)
    simpa using (hadd 0 0).symm
  have h : Nonempty (FundamentalGroup G 1 ≃* Multiplicative d.ambientPeriodLattice) :=
    ⟨(fundamentalGroupHomeomorphEquiv f.toHomeomorph hf).symm.trans
      (quotientFundamentalGroupPeriodEquiv d)⟩
  rw [hperiod] at h
  exact h

end Mumford.Analytic
