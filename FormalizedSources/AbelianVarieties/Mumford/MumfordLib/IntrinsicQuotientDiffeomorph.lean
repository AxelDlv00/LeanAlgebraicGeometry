/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.CanonicalQuotientDiffeomorph
import MumfordLib.LatticeQuotientDiffeomorph

/-!
# Intrinsic exponential quotient diffeomorphism

The identity tangent fibre, equipped with the norm and topology induced from
the manifold model, parametrizes the canonical exponential by a complex linear
equivalence. Its period quotient with the lattice branch atlas is therefore
complex `C¹` diffeomorphic to the original Lie group.
-/

set_option autoImplicit false

noncomputable section

open scoped Topology Manifold ContDiff

namespace Mumford.Analytic

open Uniformization ComplexVectorLatticeExponentialData

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [CommGroup G]
  [LieGroup I ω G]
  [CompleteSpace E] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G]

omit [LieGroup I ω G] [CompleteSpace E] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G] in
/-- The norm induced from the manifold model gives exactly the existing
topology on the identity tangent fibre. -/
theorem intrinsicComplexLieAlgebra_inducedTopology_eq :
    let native : TopologicalSpace (GroupLieAlgebra I G) := inferInstance
    let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
      complexLieAlgebraEquiv (G := G) I
    letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
      NormedAddCommGroup.induced _ _
        e.symm.toLinearMap.toAddMonoidHom e.symm.injective
    letI : UniformSpace (GroupLieAlgebra I G) :=
      @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
    @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance = native := by
  dsimp only
  change TopologicalSpace.induced (id : E → E)
    (inferInstance : TopologicalSpace E) = _
  exact induced_id

/-- The intrinsic exponential is the time-one value of every complex
one-parameter subgroup with the prescribed identity tangent vector. -/
theorem complexLieExponential_time_one_eq_intrinsic
    {phi : ℂ → G} {v : GroupLieAlgebra I G}
    (hzero : phi 0 = 1)
    (hadd : ∀ z w : ℂ, phi (z + w) = phi z * phi w)
    (hphi : HasMFDerivAt 𝓘(ℂ) I phi 0
      ((ContinuousLinearMap.id ℂ ℂ).smulRight v)) :
    phi 1 = intrinsicComplexExponential (G := G) I v := by
  have h := complexLieExponential_eq_canonical (G := G) I hzero hadd hphi 1
  simpa only [canonicalComplexFlow_eq_exponential_smul, one_smul,
    intrinsicComplexExponential, complexLieAlgebraEquiv_symm_apply] using h

/-- The intrinsic exponential is a local complex `C¹` diffeomorphism for the
model-induced norm and topology on the identity tangent fibre. -/
theorem intrinsicComplexExponential_isLocalDiffeomorph :
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
    IsLocalDiffeomorph (𝓘(ℂ, GroupLieAlgebra I G)) I 1
      (intrinsicComplexExponential (G := G) I) := by
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
  let t : Diffeomorph (𝓘(ℂ, GroupLieAlgebra I G)) (𝓘(ℂ, E))
      (GroupLieAlgebra I G) E 1 := {
    toEquiv := tangentToModel.toDiffeomorph.toEquiv
    contMDiff_toFun := tangentToModel.contDiff.contMDiff
    contMDiff_invFun := tangentToModel.symm.contDiff.contMDiff }
  change IsLocalDiffeomorph (𝓘(ℂ, GroupLieAlgebra I G)) I 1
    (intrinsicComplexExponential (G := G) I)
  intro v
  exact (t.isLocalDiffeomorph v).comp I G
    (canonicalComplexExponential_isLocalDiffeomorph (G := G) I (t v))

/-- The intrinsic period quotient, with its lattice branch atlas, is complex
`C¹` diffeomorphic to the original Lie group. -/
def intrinsicComplexExponentialQuotientDiffeomorph
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
    let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
    letI : ChartedSpace (GroupLieAlgebra I G)
        (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) :=
      analyticQuotientChartedSpace d
    Diffeomorph (𝓘(ℂ, GroupLieAlgebra I G)) I
      (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) G 1 := by
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
  exact d.quotientDiffeomorph I
    (intrinsicComplexExponential_isLocalDiffeomorph (G := G) I)

/-- The intrinsic quotient diffeomorphism sends the class of a tangent vector
to its intrinsic exponential. -/
@[simp]
theorem intrinsicComplexExponentialQuotientDiffeomorph_mk
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
    let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
    intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate
        (QuotientAddGroup.mk' d.ambientPeriodLattice v) =
      intrinsicComplexExponential (G := G) I v := by
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
  change Additive.toMul
      (d.quotientAddEquiv (QuotientAddGroup.mk' d.ambientPeriodLattice v)) = _
  rw [d.quotientAddEquiv_mk]
  rfl

/-- The intrinsic quotient diffeomorphism preserves the group law. -/
theorem intrinsicComplexExponentialQuotientDiffeomorph_add
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
    let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
    ∀ q r : GroupLieAlgebra I G ⧸ d.ambientPeriodLattice,
      intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate (q + r) =
        intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate q *
          intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate r := by
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
  change ∀ q r : GroupLieAlgebra I G ⧸ d.ambientPeriodLattice,
    Additive.toMul (d.quotientAddEquiv (q + r)) =
      Additive.toMul (d.quotientAddEquiv q) * Additive.toMul (d.quotientAddEquiv r)
  intro q r
  rw [map_add]
  rfl

/- The quotient identification preserves the identity element. -/
theorem intrinsicComplexExponentialQuotientDiffeomorph_zero
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
    intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate 0 = 1 := by
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
  have h := intrinsicComplexExponentialQuotientDiffeomorph_mk
    (G := G) I coordinate (0 : GroupLieAlgebra I G)
  simpa using h

/- The quotient identification preserves inversion. -/
theorem intrinsicComplexExponentialQuotientDiffeomorph_neg
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
    ∀ q : GroupLieAlgebra I G ⧸ d.ambientPeriodLattice,
      intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate (-q) =
        (intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate q)⁻¹ := by
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
  change ∀ q : GroupLieAlgebra I G ⧸ d.ambientPeriodLattice, _
  intro q
  obtain ⟨v, hv⟩ := QuotientAddGroup.mk'_surjective d.ambientPeriodLattice q
  rw [← hv]
  change intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate
      (QuotientAddGroup.mk' d.ambientPeriodLattice (-v)) =
    (intrinsicComplexExponentialQuotientDiffeomorph (G := G) I coordinate
      (QuotientAddGroup.mk' d.ambientPeriodLattice v))⁻¹
  rw [intrinsicComplexExponentialQuotientDiffeomorph_mk,
    intrinsicComplexExponentialQuotientDiffeomorph_mk,
    intrinsicComplexExponential_neg]

end Mumford.Analytic
