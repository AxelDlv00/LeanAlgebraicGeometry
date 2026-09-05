/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.RealLieOneParameter

/-!
# The differential equation of a one-parameter subgroup

The subgroup law reduces the differential equation at an arbitrary time to
the derivative at zero.  This bridge is useful when a flow is obtained by a
separate construction and its initial tangent is the available datum.
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

set_option backward.isDefEq.respectTransparency false in
/-- A one-parameter subgroup with the prescribed tangent at zero is an
integral curve of the corresponding left-invariant vector field. -/
theorem isMIntegralCurve_of_oneParameterSubgroup_of_hasMFDerivAt
    [T2Space G] [I.Boundaryless]
    {v : GroupLieAlgebra I G} {γ : ℝ → G}
    (hγ0 : γ 0 = 1)
    (hadd : ∀ s t : ℝ, γ (s + t) = γ s * γ t)
    (hderiv0 : HasMFDerivAt 𝓘(ℝ, ℝ) I γ 0
      ((1 : ℝ →L[ℝ] ℝ).smulRight v)) :
    IsMIntegralCurve γ (mulInvariantVectorField v) := by
  intro t
  let L : G → G := fun y => γ t * y
  have hL :
      HasMFDerivAt I I L (γ 0) (mfderiv I I L (γ 0)) :=
    (contMDiffAt_mul_left
      (n := minSmoothness ℝ 3)).mdifferentiableAt
      (lt_of_lt_of_le (by simp) le_minSmoothness |>.ne') |>.hasMFDerivAt
  have hvone :
      mulInvariantVectorField (I := I) v (1 : G) = v := by
    rw [mulInvariantVectorField]
    have hone : (fun x : G => (1 : G) * x) = id := by
      funext x
      simp
    rw [hone, mfderiv_id]
    rfl
  have hLcomp :
      HasMFDerivAt 𝓘(ℝ, ℝ) I (L ∘ γ) 0
        ((1 : ℝ →L[ℝ] ℝ).smulRight
          (mulInvariantVectorField v (γ t))) := by
    have _hc := HasMFDerivAt.comp (x := (0 : ℝ))
      (f := γ) (g := L) hL hderiv0
    change HasMFDerivAt 𝓘(ℝ, ℝ) I (L ∘ γ) 0
      ((mfderiv I I (fun y : G => γ t * y) (γ 0)).comp
        ((1 : ℝ →L[ℝ] ℝ).smulRight v)) at _hc
    have hh :
        (mfderiv I I (fun y : G => γ t * y) (γ 0)).comp
            ((1 : ℝ →L[ℝ] ℝ).smulRight
              (mulInvariantVectorField v (γ 0))) =
          (1 : ℝ →L[ℝ] ℝ).smulRight
            (mulInvariantVectorField v (γ t * γ 0)) := by
      apply ContinuousLinearMap.ext
      intro c
      simp only [ContinuousLinearMap.comp_apply,
        ContinuousLinearMap.smulRight_apply, one_apply_eq_self]
      rw [map_smul]
      exact congrArg (fun z => c • z)
        (mfderiv_mul_left_mulInvariantVectorField
          (I := I) (γ t) (γ 0) v)
    rw [hγ0, hvone, mul_one] at hh
    have hc := _hc
    with_reducible_and_instances rw [hγ0] at hc
    rw [hh] at hc
    with_reducible_and_instances exact hc
  have hq :
      HasMFDerivAt 𝓘(ℝ, ℝ) 𝓘(ℝ, ℝ) (fun u : ℝ => u - t) t
        (ContinuousLinearMap.id ℝ ℝ) := by
    convert ((hasFDerivAt_id t).sub_const t).hasMFDerivAt using 1; simp
  have hc0_at :
      HasMFDerivAt 𝓘(ℝ, ℝ) I (L ∘ γ) ((fun u : ℝ => u - t) t)
        ((1 : ℝ →L[ℝ] ℝ).smulRight
          (mulInvariantVectorField v (γ t))) := by
    convert hLcomp using 1; simp
  have hct := HasMFDerivAt.comp (x := t)
    (f := fun u : ℝ => u - t) (g := L ∘ γ) hc0_at hq
  have heq : (L ∘ γ) ∘ (fun u : ℝ => u - t) = γ := by
    funext u
    dsimp [L, Function.comp_def]
    rw [← hadd t (u - t)]
    congr 1
    abel
  rw [heq] at hct
  convert hct using 1
  · apply NormedSpace.ext
    rfl
  · apply ContinuousLinearMap.ext
    intro c
    rfl

end Analytic
end Mumford
