/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SourceComplexFundamentalGroup
import MumfordLib.FirstCohomologyComparison

/-!
# First cohomology of the original compact complex Lie group

The degree-one singular cohomology comparison identifies integral cohomology
classes with characters of the fundamental group. The source uniformization
then transports these characters to the intrinsic exponential period lattice.

Reference: Mumford, *Abelian Varieties*, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

open scoped Topology Manifold ContDiff IsMulCommutative

namespace Mumford.Analytic

variable {E H : Type*} {G : Type}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ω G] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G]

include I in
omit [LieGroup I ω G] [T2Space G] [CompactSpace G] in
private theorem complexChartedGroup_pathConnectedSpace : PathConnectedSpace G := by
  letI : NormedSpace ℝ E := NormedSpace.restrictScalars ℝ ℂ E
  letI : LocPathConnectedSpace H := I.toHomeomorph.isOpenEmbedding.locPathConnectedSpace
  letI : LocPathConnectedSpace G := ChartedSpace.locPathConnectedSpace H G
  letI : ConnectedSpace G := { toNonempty := ⟨1⟩ }
  exact PathConnectedSpace.of_locPathConnectedSpace

private def fundamentalGroupCharactersPeriodDualEquiv :
    letI : FiniteDimensional ℂ E :=
      FiniteDimensional.of_locallyCompact_manifold G I
    letI : CompleteSpace E := FiniteDimensional.complete ℂ E
    letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
    letI : CommGroup G := inferInstance
    (Additive (FundamentalGroup G 1) →+ ℤ) ≃ₗ[ℤ]
      (intrinsicComplexExponentialPeriodLattice (G := G) I →ₗ[ℤ] ℤ) := by
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : CompleteSpace E := FiniteDimensional.complete ℂ E
  letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
  letI : CommGroup G := inferInstance
  let e := compactComplexLieGroupFundamentalGroupPeriodAddEquiv (G := G) I
  exact e.addMonoidHomCongrLeft.toIntLinearEquiv.trans (addMonoidHomLequivInt ℤ)

/-- The first integral singular cohomology of the original compact connected
complex Lie group is the integral dual of its intrinsic exponential period lattice. -/
def compactComplexLieGroupFirstCohomologyPeriodDualEquiv :
    letI : FiniteDimensional ℂ E :=
      FiniteDimensional.of_locallyCompact_manifold G I
    letI : CompleteSpace E := FiniteDimensional.complete ℂ E
    letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
    letI : CommGroup G := inferInstance
    IntegralSingularCohomology (TopCat.of G) 1 ≃ₗ[ℤ]
      (intrinsicComplexExponentialPeriodLattice (G := G) I →ₗ[ℤ] ℤ) := by
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : CompleteSpace E := FiniteDimensional.complete ℂ E
  letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
  letI : CommGroup G := inferInstance
  letI : PathConnectedSpace G := complexChartedGroup_pathConnectedSpace (G := G) I
  exact (singularFirstCohomologyEquivCharacters (X := TopCat.of G) 1).trans
    (fundamentalGroupCharactersPeriodDualEquiv (G := G) I)

/-- The period-dual comparison evaluates on the corresponding fundamental-group element. -/
@[simp]
theorem compactComplexLieGroupFirstCohomologyPeriodDualEquiv_apply_period
    (c : IntegralSingularCohomology (TopCat.of G) 1)
    (γ : Additive (FundamentalGroup G 1)) :
    compactComplexLieGroupFirstCohomologyPeriodDualEquiv (G := G) I c
        (compactComplexLieGroupFundamentalGroupPeriodAddEquiv (G := G) I γ) =
      singularFirstCohomologyCharacter (X := TopCat.of G) 1 c γ := by
  change singularFirstCohomologyCharacter (X := TopCat.of G) 1 c
    ((compactComplexLieGroupFundamentalGroupPeriodAddEquiv (G := G) I).symm
      (compactComplexLieGroupFundamentalGroupPeriodAddEquiv (G := G) I γ)) = _
  rw [AddEquiv.symm_apply_apply]

end Mumford.Analytic
