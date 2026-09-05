/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexLieCommutativity
import MumfordLib.ComplexLieFlowRegularity
import MumfordLib.ComplexUniformization
import Mathlib.Algebra.Module.ZLattice.Basic
import Mathlib.Topology.ContinuousMap.Basic
import Mathlib.Topology.Algebra.Module.ContinuousLinearMap.Quotient

/-!
# Compact targets and the canonical period kernel

This file advances the analytic candidate without identifying it with Mumford's
source-level holomorphic exponential.  A finite-dimensional real vector group
which maps continuously and surjectively onto a compact Hausdorff additive
group has a kernel spanning the whole vector space.  Applying this observation
to the real-flow candidate upgrades its previously proved discrete kernel to a
full `ℤ`-lattice.  The open-quotient and lattice consequences are
topological and additive; the missing jointly holomorphic one-parameter-family
theorem remains external.
-/

set_option autoImplicit false

noncomputable section

open Function Set
open scoped Topology Manifold ContDiff

namespace Mumford
namespace Analytic

/-! ### A compact-target span lemma -/

/-- A continuous surjective additive map from a finite-dimensional real vector
space onto a compact Hausdorff additive group has a full real kernel span.

The proof descends the quotient by the real span of the kernel through the open
quotient map.  A proper span would make this quotient a nontrivial finite-
dimensional real vector space, contradicting compactness of its continuous
surjective image.
-/
theorem span_ker_toIntSubmodule_eq_top_of_compact_target
    {E X : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    [AddCommGroup X] [TopologicalSpace X] [CompactSpace X]
    [T2Space X] [IsTopologicalAddGroup X]
    (f : E →+ X) (hcont : Continuous f) (hsurj : Function.Surjective f) :
    Submodule.span ℝ
        ((AddSubgroup.toIntSubmodule f.ker : Submodule ℤ E) : Set E) = ⊤ := by
  let L : Submodule ℤ E := AddSubgroup.toIntSubmodule f.ker
  let S : Submodule ℝ E := Submodule.span ℝ (L : Set E)
  letI : IsClosed (S : Set E) := S.closed_of_finiteDimensional
  have hopen : IsOpenQuotientMap f := by
    rw [isOpenQuotientMap_iff]
    exact ⟨hsurj, hcont,
      AddMonoidHom.isOpenMap_of_sigmaCompact f hsurj hcont⟩
  let fc : C(E, X) := ⟨f, hcont⟩
  let q : C(E, E ⧸ S) := ⟨S.mkQ, S.continuous_mkQ⟩
  have hfac : Function.FactorsThrough (q : E → E ⧸ S) (fc : E → X) := by
    intro x y hxy
    change f x = f y at hxy
    apply (Submodule.Quotient.eq S).2
    apply Submodule.subset_span
    change x - y ∈ f.ker
    rw [AddMonoidHom.mem_ker, map_sub, hxy, sub_self]
  let descended : C(X, E ⧸ S) :=
    (show Topology.IsQuotientMap (fc : E → X) from hopen.isQuotientMap).lift q hfac
  have hdescended_apply (x : E) :
      descended (f x) = S.mkQ x := by
    have htriangle :=
      (show Topology.IsQuotientMap (fc : E → X) from hopen.isQuotientMap).lift_comp q hfac
    exact DFunLike.congr_fun htriangle x
  have hdescended_surjective : Function.Surjective descended := by
    intro z
    obtain ⟨x, rfl⟩ := S.mkQ_surjective z
    exact ⟨f x, hdescended_apply x⟩
  have hcompact : IsCompact (Set.univ : Set (E ⧸ S)) := by
    have himage := isCompact_univ.image descended.continuous
    rw [Set.image_univ, hdescended_surjective.range_eq] at himage
    exact himage
  have hS : S = ⊤ := by
    by_contra hne
    letI : Nontrivial (E ⧸ S) :=
      Submodule.Quotient.nontrivial_iff.mpr hne
    exact noncompact_univ (E ⧸ S) hcompact
  exact hS

/-! ### The canonical candidate and its period kernel -/

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ω G]
  [CompleteSpace E] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G]

/-- The integer submodule underlying the kernel of the canonical exponential
candidate.  This is a candidate-level period lattice, before the source
holomorphic exponential is identified. -/
def canonicalComplexExponentialPeriodLattice : Submodule ℤ E :=
  AddSubgroup.toIntSubmodule
    (canonicalComplexExponentialAddHom (G := G) I).ker

/-- The previously established discreteness of the canonical kernel, expressed
for its integer-submodule presentation. -/
theorem canonicalComplexExponentialPeriodLattice_discreteTopology :
    DiscreteTopology (canonicalComplexExponentialPeriodLattice (G := G) I) := by
  apply isDiscrete_iff_discreteTopology.mp
  exact canonicalComplexExponential_kernel_isDiscrete (G := G) I

/-- The canonical complex exponential candidate is continuous as a map to the
underlying group.  This follows from its already proved manifold
`MDifferentiable` regularity; no source-level holomorphic identification is
asserted here. -/
theorem canonicalComplexExponential_continuous :
    Continuous (canonicalComplexExponential (G := G) I) :=
  (canonicalComplexExponential_mdifferentiable (G := G) I).continuous

/-- Continuity of the additive-target presentation of the canonical candidate. -/
theorem canonicalComplexExponentialAddHom_continuous :
    Continuous (canonicalComplexExponentialAddHom (G := G) I) :=
  continuous_ofMul.comp (canonicalComplexExponential_continuous (G := G) I)

/-- Surjectivity of the additive-target presentation of the canonical candidate. -/
theorem canonicalComplexExponentialAddHom_surjective :
    Function.Surjective (canonicalComplexExponentialAddHom (G := G) I) := by
  intro x
  obtain ⟨v, hv⟩ :=
    canonicalComplexExponential_surjective (G := G) I (Additive.toMul x)
  refine ⟨v, ?_⟩
  change canonicalComplexExponential (G := G) I v = Additive.toMul x
  exact hv

/-- The canonical additive exponential is an open quotient map.  The
commutativity instance is installed locally from the verified compact-flow
theorem so that the `Additive` type synonym has its expected group structure. -/
theorem canonicalComplexExponential_isOpenQuotientMap :
    IsOpenQuotientMap (canonicalComplexExponentialAddHom (G := G) I) := by
  letI : IsTopologicalGroup G := topologicalGroup_of_lieGroup I ⊤
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : FiniteDimensional ℝ E := FiniteDimensional.complexToReal E
  letI : IsMulCommutative G :=
    complexLieGroup_isMulCommutative (G := G) I
  letI : CommGroup G := CommGroup.mk (fun a b =>
    (isMulCommutative_iff.mp (inferInstance : IsMulCommutative G)) a b)
  letI : T2Space (Additive G) := by
    change T2Space G
    infer_instance
  rw [isOpenQuotientMap_iff]
  exact ⟨canonicalComplexExponentialAddHom_surjective (G := G) I,
    canonicalComplexExponentialAddHom_continuous (G := G) I,
    AddMonoidHom.isOpenMap_of_sigmaCompact
      (canonicalComplexExponentialAddHom (G := G) I)
      (canonicalComplexExponentialAddHom_surjective (G := G) I)
      (canonicalComplexExponentialAddHom_continuous (G := G) I)⟩

/-- The canonical period kernel is a full real `ℤ`-lattice in the tangent
model.  This is the compact-target lattice theorem applied to the verified
real-flow candidate; it is intentionally not attached to the frozen source
uniformization node. -/
theorem canonicalComplexExponentialPeriodLattice_isZLattice
    :
    @IsZLattice ℝ inferInstance E inferInstance inferInstance
      (canonicalComplexExponentialPeriodLattice (G := G) I)
      (canonicalComplexExponentialPeriodLattice_discreteTopology (G := G) I) := by
  letI : IsTopologicalGroup G := topologicalGroup_of_lieGroup I ⊤
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : FiniteDimensional ℝ E := FiniteDimensional.complexToReal E
  letI : IsMulCommutative G :=
    complexLieGroup_isMulCommutative (G := G) I
  letI : CommGroup G := CommGroup.mk (fun a b =>
    (isMulCommutative_iff.mp (inferInstance : IsMulCommutative G)) a b)
  letI : T2Space (Additive G) := by
    change T2Space G
    infer_instance
  letI : DiscreteTopology
      (canonicalComplexExponentialPeriodLattice (G := G) I) :=
    canonicalComplexExponentialPeriodLattice_discreteTopology (G := G) I
  apply IsZLattice.mk
  exact span_ker_toIntSubmodule_eq_top_of_compact_target
    (f := canonicalComplexExponentialAddHom (G := G) I)
    (canonicalComplexExponentialAddHom_continuous (G := G) I)
    (canonicalComplexExponentialAddHom_surjective (G := G) I)

/-- The integral rank of the canonical period lattice is the real dimension of
the tangent model. -/
theorem canonicalComplexExponentialPeriodLattice_finrank
    :
    Module.finrank ℤ (canonicalComplexExponentialPeriodLattice (G := G) I) =
      Module.finrank ℝ E := by
  letI : DiscreteTopology
      (canonicalComplexExponentialPeriodLattice (G := G) I) :=
    canonicalComplexExponentialPeriodLattice_discreteTopology (G := G) I
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : FiniteDimensional ℝ E := FiniteDimensional.complexToReal E
  letI : IsZLattice ℝ
      (canonicalComplexExponentialPeriodLattice (G := G) I) :=
    canonicalComplexExponentialPeriodLattice_isZLattice (G := G) I
  exact ZLattice.rank ℝ
    (canonicalComplexExponentialPeriodLattice (G := G) I)

end Analytic
end Mumford
