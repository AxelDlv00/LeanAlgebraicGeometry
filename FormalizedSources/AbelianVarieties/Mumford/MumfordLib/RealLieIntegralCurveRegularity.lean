/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.RealLieFlow
import Mathlib.Analysis.Calculus.ContDiff.Deriv

/-!
# Regularity of real manifold integral curves

An integral curve is defined in Mathlib by a pointwise manifold derivative.  If
the vector field is continuous, those derivatives vary continuously in a local
tangent trivialization, so the curve is `C¹`.  This file records that bridge
explicitly; it is useful for the real one-parameter subgroups used in the
analytic Lie-group construction.
-/

set_option autoImplicit false

noncomputable section

open Function Set Filter
open scoped Manifold ContDiff Topology

namespace Mumford
namespace Analytic

variable {E H M : Type*}
  [NormedAddCommGroup E] [NormedSpace ℝ E]
  [TopologicalSpace H] {I : ModelWithCorners ℝ E H}
  [TopologicalSpace M] [ChartedSpace H M] [IsManifold I 1 M]

/-- A global integral curve of a continuous vector field is a `C¹` manifold
curve.  The continuity hypothesis is on the tangent-bundle-valued vector
field, rather than on the curve itself. -/
theorem contMDiff_one_of_isMIntegralCurve
    {γ : ℝ → M} {v : (x : M) → TangentSpace I x}
    (hγ : IsMIntegralCurve γ v)
    (hv : Continuous (fun x => (v x : TangentBundle I M))) :
    ContMDiff 𝓘(ℝ, ℝ) I 1 γ := by
  intro t₀
  rw [contMDiffAt_iff_target]
  refine ⟨hγ.continuous.continuousAt, ?_⟩
  apply ContDiffAt.contMDiffAt
  rw [contDiffAt_one_iff]
  let e := FiberBundle.trivializationAt E (TangentSpace I) (γ t₀)
  let q : ℝ → TangentBundle I M := fun t => (v (γ t) : TangentBundle I M)
  let d : ℝ → E := fun t => (e (q t)).2
  let f' : ℝ → ℝ →L[ℝ] E :=
    fun t => ContinuousLinearMap.toSpanSingleton ℝ (d t)
  have hq : Continuous q := hv.comp hγ.continuous
  have hq0 : q t₀ ∈ e.source := by
    simp [q, e]
  have hpre : q ⁻¹' e.source ∈ 𝓝 t₀ :=
    hq.continuousAt.preimage_mem_nhds (e.open_source.mem_nhds hq0)
  have heq : ContinuousOn (fun t => e (q t)) (q ⁻¹' e.source) :=
    e.continuousOn.comp hq.continuousOn (mapsTo_preimage q e.source)
  have hd : ContinuousOn d (q ⁻¹' e.source) := by
    simpa [d] using heq.snd
  have hf' : ContinuousOn f' (q ⁻¹' e.source) := by
    exact (ContinuousLinearMap.toSpanSingletonCLE (𝕜 := ℝ) (E := E)).continuous.comp_continuousOn hd
  obtain ⟨w, hw_nhds, hw⟩ := Filter.eventually_iff_exists_mem.mp
    (hγ.isMIntegralCurveAt t₀).eventually_hasDerivAt
  refine ⟨f', q ⁻¹' e.source ∩ w, inter_mem hpre hw_nhds,
    hf'.mono inter_subset_left, ?_⟩
  intro t ht
  have hd_eq :
      d t = tangentCoordChange I (γ t) (γ t₀) (γ t) (v (γ t)) := by
    rfl
  have hderiv := hw t ht.2
  rw [hasDerivAt_iff_hasFDerivAt] at hderiv
  simpa [f', hd_eq, ContinuousLinearMap.smulRight_one_eq_toSpanSingleton] using hderiv

/-- The chosen real flow is a `C¹` curve. -/
theorem canonicalRealFlow_contMDiff_one
    {E H G : Type*} [NormedAddCommGroup E] [NormedSpace ℂ E]
    [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
    [TopologicalSpace G] [ChartedSpace H G] [Group G]
    [LieGroup I ω G]
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) :
    ContMDiff 𝓘(ℝ, ℝ) (complexToRealModel I) 1
      (canonicalRealFlow I v) := by
  apply contMDiff_one_of_isMIntegralCurve
  · exact (canonicalRealFlow_spec I v).2.1
  · exact (contMDiff_mulInvariantVectorField (I := complexToRealModel I) v).continuous

end Analytic
end Mumford
