/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.RealLieFlow

/-!
# Addition of central real Lie flows

The product of two central integral curves supplies the additive tangent
parameter law needed by the analytic exponential construction.
-/

set_option autoImplicit false
noncomputable section
open Function Set
open scoped Manifold ContDiff

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℝ E]
  [TopologicalSpace H] {I : ModelWithCorners ℝ E H}
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I (minSmoothness ℝ 3) G]

/-- Product differentiation is the local analytic input needed to combine the
central real flows produced by the complex Lie-group construction. -/
theorem isMIntegralCurve_mul_of_central
    {v w : GroupLieAlgebra I G} {γ δ : ℝ → G}
    (hγ : IsMIntegralCurve γ (mulInvariantVectorField v))
    (hδ : IsMIntegralCurve δ (mulInvariantVectorField w))
    (hδcentral : ∀ t : ℝ, ∀ x : G, Commute x (δ t)) :
    IsMIntegralCurve (fun t => γ t * δ t)
      (mulInvariantVectorField (v + w)) := by
  intro t
  have M : minSmoothness ℝ 3 ≠ 0 :=
    lt_of_lt_of_le (by simp) le_minSmoothness |>.ne'
  have hmul : MDifferentiableAt (I.prod I) I
      (fun p : G × G => p.1 * p.2) (γ t, δ t) :=
    (contMDiff_mul (I := I) (minSmoothness ℝ 3)).mdifferentiableAt M
  have hp := (hγ t).prodMk (hδ t)
  have hc := hmul.hasMFDerivAt.comp (x := t) hp
  have hright (a x : G) (u : GroupLieAlgebra I G)
      (ha : ∀ z : G, Commute z a) :
      mfderiv I I (fun z : G => z * a) x (mulInvariantVectorField u x) =
        mulInvariantVectorField u (x * a) := by
    have hfun : (fun z : G => z * a) = (fun z : G => a * z) := by
      funext z
      exact (ha z).eq
    rw [hfun]
    calc
      _ = mulInvariantVectorField u (a * x) :=
        mfderiv_mul_left_mulInvariantVectorField a x u
      _ = _ := by rw [(ha x).eq.symm]
  have hderiv :
      (mfderiv (I.prod I) I (fun p : G × G => p.1 * p.2) (γ t, δ t)).comp
          (((1 : ℝ →L[ℝ] ℝ).smulRight
            (mulInvariantVectorField v (γ t))).prod
          ((1 : ℝ →L[ℝ] ℝ).smulRight
            (mulInvariantVectorField w (δ t)))) =
        (1 : ℝ →L[ℝ] ℝ).smulRight
          (mulInvariantVectorField (v + w) (γ t * δ t)) := by
    apply ContinuousLinearMap.ext
    intro c
    rw [ContinuousLinearMap.comp_apply]
    rw [mfderiv_prod_eq_add_apply hmul]
    change
      mfderiv I I (fun z : G => z * δ t) (γ t)
          (c • mulInvariantVectorField v (γ t)) +
        mfderiv I I (fun z : G => γ t * z) (δ t)
          (c • mulInvariantVectorField w (δ t)) =
      c • mulInvariantVectorField (v + w) (γ t * δ t)
    rw [map_smul, map_smul]
    rw [hright (δ t) (γ t) v (hδcentral t)]
    rw [mfderiv_mul_left_mulInvariantVectorField (γ t) (δ t) w]
    rw [← smul_add]
    congr 1
    simpa only [Pi.add_apply] using
      (congrFun (mulInvariantVectorField_add v w) (γ t * δ t)).symm
  have hc' := hc.congr_mfderiv hderiv
  with_reducible_and_instances
    simpa only [Function.comp_def] using hc'

/-- The choice-valued flows therefore add after the centrality bridge. -/
theorem canonicalRealFlow_add
    {E H G : Type*} [NormedAddCommGroup E] [NormedSpace ℂ E]
    [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
    [TopologicalSpace G] [ChartedSpace H G] [Group G]
    [LieGroup I ω G]
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v w : GroupLieAlgebra (complexToRealModel I) G) (t : ℝ) :
    canonicalRealFlow I (v + w) t =
      canonicalRealFlow I v t * canonicalRealFlow I w t := by
  have hv := canonicalRealFlow_spec I v
  have hw := canonicalRealFlow_spec I w
  have hprod := isMIntegralCurve_mul_of_central
    (I := complexToRealModel I) hv.2.1 hw.2.1
      (by
        intro s x
        exact hw.2.2.2 x s)
  have hprod0 : (fun s : ℝ =>
      canonicalRealFlow I v s * canonicalRealFlow I w s) 0 = 1 := by
    change canonicalRealFlow I v 0 * canonicalRealFlow I w 0 = 1
    rw [hv.1, hw.1, one_mul]
  have heq := canonicalRealFlow_eq_of_isMIntegralCurve I hprod hprod0
  exact (congrFun heq t).symm

end Analytic
end Mumford
