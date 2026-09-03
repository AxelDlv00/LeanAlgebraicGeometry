/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.Geometry.Manifold.GroupLieAlgebra
import Mathlib.Geometry.Manifold.IntegralCurve.UniformTime

/-!
# One-parameter subgroups of real Lie groups

This file constructs the one-parameter subgroup through an arbitrary tangent
vector of a real Lie group. It is the ODE producer needed before constructing
Mumford's complex Lie exponential. Transferring the construction to the
underlying real manifold of a complex Lie group, and proving parameter
dependence and holomorphicity, are separate obligations.
-/

set_option autoImplicit false

noncomputable section

open Function Set
open scoped Manifold

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℝ E]
  [TopologicalSpace H] {I : ModelWithCorners ℝ E H}
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I (minSmoothness ℝ 3) G]

set_option backward.isDefEq.respectTransparency false in
/-- Left translation carries a left-invariant vector to the corresponding
left-invariant vector at the translated point. -/
theorem mfderiv_mul_left_mulInvariantVectorField
    (g x : G) (v : GroupLieAlgebra I G) :
    mfderiv I I (g * ·) x (mulInvariantVectorField v x) =
      mulInvariantVectorField v (g * x) := by
  simp only [mulInvariantVectorField]
  have M : minSmoothness ℝ 3 ≠ 0 :=
    lt_of_lt_of_le (by simp) le_minSmoothness |>.ne'
  have hg : MDifferentiableAt I I (fun y : G => g * y) (x * 1) :=
    (contMDiffAt_mul_left
      (n := minSmoothness ℝ 3)).mdifferentiableAt M
  have hx : MDifferentiableAt I I (fun y : G => x * y) 1 :=
    (contMDiffAt_mul_left
      (n := minSmoothness ℝ 3)).mdifferentiableAt M
  have h := mfderiv_comp_apply (I' := I) (x := (1 : G))
    (g := fun y : G => g * y) (f := fun y : G => x * y) hg hx v
  have hcomp :
      (fun y : G => g * y) ∘ (fun y : G => x * y) =
        fun y : G => (g * x) * y := by
    funext y
    exact (mul_assoc g x y).symm
  rw [hcomp, mul_one] at h
  exact h.symm

set_option backward.isDefEq.respectTransparency false in
/-- Left translation preserves integral curves of a left-invariant vector
field on the same time set. -/
theorem IsMIntegralCurveOn.mul_left_mulInvariantVectorField
    {v : GroupLieAlgebra I G} {γ : ℝ → G} {s : Set ℝ}
    (hγ : IsMIntegralCurveOn γ (mulInvariantVectorField v) s) (g : G) :
    IsMIntegralCurveOn (fun t => g * γ t) (mulInvariantVectorField v) s := by
  intro t ht
  have M : minSmoothness ℝ 3 ≠ 0 :=
    lt_of_lt_of_le (by simp) le_minSmoothness |>.ne'
  have hleft :
      HasMFDerivAt I I (g * ·) (γ t) (mfderiv I I (g * ·) (γ t)) :=
    (contMDiff_mul_left.contMDiffAt.mdifferentiableAt M).hasMFDerivAt
  have hcomp :=
    HasMFDerivAt.comp_hasMFDerivWithinAt (x := t) hleft (hγ t ht)
  have hderiv :
      (mfderiv I I (g * ·) (γ t)).comp
          ((1 : ℝ →L[ℝ] ℝ).smulRight (mulInvariantVectorField v (γ t))) =
        (1 : ℝ →L[ℝ] ℝ).smulRight
          (mulInvariantVectorField v (g * γ t)) := by
    ext
    simp only [ContinuousLinearMap.comp_apply, ContinuousLinearMap.smulRight_apply,
      one_apply_eq_self, one_smul]
    exact mfderiv_mul_left_mulInvariantVectorField g (γ t) v
  simpa only [Function.comp_def] using hcomp.congr_mfderiv hderiv

set_option backward.isDefEq.respectTransparency false in
/-- Left translation preserves a global integral curve of a left-invariant
vector field. -/
theorem IsMIntegralCurve.mul_left_mulInvariantVectorField
    {v : GroupLieAlgebra I G} {γ : ℝ → G}
    (hγ : IsMIntegralCurve γ (mulInvariantVectorField v)) (g : G) :
    IsMIntegralCurve (fun t => g * γ t) (mulInvariantVectorField v) := by
  intro t
  have M : minSmoothness ℝ 3 ≠ 0 :=
    lt_of_lt_of_le (by simp) le_minSmoothness |>.ne'
  have hleft :
      HasMFDerivAt I I (g * ·) (γ t) (mfderiv I I (g * ·) (γ t)) :=
    (contMDiff_mul_left.contMDiffAt.mdifferentiableAt M).hasMFDerivAt
  have hcomp := HasMFDerivAt.comp (x := t) hleft (hγ t)
  have hderiv :
      (mfderiv I I (g * ·) (γ t)).comp
          ((1 : ℝ →L[ℝ] ℝ).smulRight (mulInvariantVectorField v (γ t))) =
        (1 : ℝ →L[ℝ] ℝ).smulRight
          (mulInvariantVectorField v (g * γ t)) := by
    ext
    simp only [ContinuousLinearMap.comp_apply, ContinuousLinearMap.smulRight_apply,
      one_apply_eq_self, one_smul]
    exact mfderiv_mul_left_mulInvariantVectorField g (γ t) v
  simpa only [Function.comp_def] using hcomp.congr_mfderiv hderiv

omit [LieGroup I (minSmoothness ℝ 3) G] in
set_option backward.isDefEq.respectTransparency false in
/-- A smooth map preserving a left-invariant vector field transports its
global integral curves. -/
theorem IsMIntegralCurve.comp_of_mfderiv
    {v : GroupLieAlgebra I G} {γ : ℝ → G} {f : G → G}
    (hγ : IsMIntegralCurve γ (mulInvariantVectorField v))
    (hf : ContMDiff I I (minSmoothness ℝ 3) f)
    (hderiv : ∀ t : ℝ,
      (mfderiv I I f (γ t)).comp
          ((1 : ℝ →L[ℝ] ℝ).smulRight (mulInvariantVectorField v (γ t))) =
        (1 : ℝ →L[ℝ] ℝ).smulRight (mulInvariantVectorField v (f (γ t)))) :
    IsMIntegralCurve (f ∘ γ) (mulInvariantVectorField v) := by
  intro t
  have M : minSmoothness ℝ 3 ≠ 0 :=
    lt_of_lt_of_le (by simp) le_minSmoothness |>.ne'
  have hf' : HasMFDerivAt I I f (γ t) (mfderiv I I f (γ t)) :=
    (hf.contMDiffAt.mdifferentiableAt M).hasMFDerivAt
  have hcomp := HasMFDerivAt.comp (x := t) hf' (hγ t)
  simpa only [Function.comp_def] using hcomp.congr_mfderiv (hderiv t)

set_option backward.isDefEq.respectTransparency false in
/-- Every left-invariant vector field on a real Lie group has a global integral
curve through the identity. The common local existence time is transported to
every point by left multiplication before applying the uniform-time theorem. -/
theorem exists_global_mulInvariant_integralCurve
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    (v : GroupLieAlgebra I G) :
    ∃ γ : ℝ → G, γ 0 = 1 ∧ IsMIntegralCurve γ (mulInvariantVectorField v) := by
  have hv : CMDiff 1
      (fun x : G => (mulInvariantVectorField v x : TangentBundle I G)) :=
    (contMDiff_mulInvariantVectorField v).of_le
      (one_le_two.trans le_minSmoothness)
  obtain ⟨γ, hγ0, hγ⟩ :=
    exists_isMIntegralCurveAt_of_contMDiffAt_boundaryless
      (I := I) (t₀ := 0) (x₀ := (1 : G)) hv.contMDiffAt
  rw [isMIntegralCurveAt_iff'] at hγ
  obtain ⟨ε, hε, hγ⟩ := hγ
  rw [Real.ball_zero_eq_Ioo] at hγ
  apply exists_isMIntegralCurve_of_isMIntegralCurveOn hv hε ?_ 1
  intro x
  refine ⟨fun t => x * γ t, ?_,
    IsMIntegralCurveOn.mul_left_mulInvariantVectorField hγ x⟩
  simp only [hγ0, mul_one]

set_option backward.isDefEq.respectTransparency false in
/-- A global integral curve of a left-invariant vector field through the
identity respects addition of its time parameter. -/
theorem IsMIntegralCurve.map_add_eq_mul
    [T2Space G] [I.Boundaryless]
    {v : GroupLieAlgebra I G} {γ : ℝ → G}
    (hγ : IsMIntegralCurve γ (mulInvariantVectorField v))
    (hγ0 : γ 0 = 1) (s t : ℝ) :
    γ (s + t) = γ s * γ t := by
  have hv : CMDiff 1
      (fun x : G => (mulInvariantVectorField v x : TangentBundle I G)) :=
    (contMDiff_mulInvariantVectorField v).of_le
      (one_le_two.trans le_minSmoothness)
  have hshift :
      IsMIntegralCurve (γ ∘ (· + s)) (mulInvariantVectorField v) :=
    hγ.comp_add s
  have hleft :
      IsMIntegralCurve (fun u => γ s * γ u) (mulInvariantVectorField v) :=
    IsMIntegralCurve.mul_left_mulInvariantVectorField hγ (γ s)
  have heq : γ ∘ (· + s) = fun u => γ s * γ u :=
    isMIntegralCurve_Ioo_eq_of_contMDiff_boundaryless
      (I := I) (t₀ := 0) hv hshift hleft
      (by simp only [comp_apply, zero_add, hγ0, mul_one])
  have ht := congrFun heq t
  simpa only [comp_apply, add_comm] using ht

set_option backward.isDefEq.respectTransparency false in
/-- Global integral curves of a left-invariant vector field are determined by
their value at one time. -/
theorem isMIntegralCurve_eq_of_eq_at
    [T2Space G] [I.Boundaryless]
    {v : GroupLieAlgebra I G} {γ γ' : ℝ → G}
    (hγ : IsMIntegralCurve γ (mulInvariantVectorField v))
    (hγ' : IsMIntegralCurve γ' (mulInvariantVectorField v))
    (t₀ : ℝ) (h : γ t₀ = γ' t₀) :
    γ = γ' := by
  have hv : CMDiff 1
      (fun x : G => (mulInvariantVectorField v x : TangentBundle I G)) :=
    (contMDiff_mulInvariantVectorField v).of_le
      (one_le_two.trans le_minSmoothness)
  exact isMIntegralCurve_Ioo_eq_of_contMDiff_boundaryless hv hγ hγ' h

set_option backward.isDefEq.respectTransparency false in
/-- A one-parameter subgroup evaluated at opposite times gives the group
inverse. -/
theorem IsMIntegralCurve.map_neg_eq_inv
    [T2Space G] [I.Boundaryless]
    {v : GroupLieAlgebra I G} {γ : ℝ → G}
    (hγ : IsMIntegralCurve γ (mulInvariantVectorField v))
    (hγ0 : γ 0 = 1) (t : ℝ) :
    γ (-t) = (γ t)⁻¹ := by
  have h := IsMIntegralCurve.map_add_eq_mul (I := I) hγ hγ0 (-t) t
  rw [neg_add_cancel, hγ0] at h
  exact eq_inv_of_mul_eq_one_left h.symm

set_option backward.isDefEq.respectTransparency false in
/-- Values of one global left-invariant flow commute with one another. -/
theorem IsMIntegralCurve.map_commute
    [T2Space G] [I.Boundaryless]
    {v : GroupLieAlgebra I G} {γ : ℝ → G}
    (hγ : IsMIntegralCurve γ (mulInvariantVectorField v))
    (hγ0 : γ 0 = 1) (s t : ℝ) :
    Commute (γ s) (γ t) := by
  rw [Commute]
  calc
    γ s * γ t = γ (s + t) :=
      (IsMIntegralCurve.map_add_eq_mul (I := I) hγ hγ0 s t).symm
    _ = γ (t + s) := by rw [add_comm]
    _ = γ t * γ s := IsMIntegralCurve.map_add_eq_mul (I := I) hγ hγ0 t s

omit [LieGroup I (minSmoothness ℝ 3) G] in
set_option backward.isDefEq.respectTransparency false in
/-- Reparameterizing a left-invariant flow by a scalar integrates the scaled
Lie-algebra vector. -/
theorem IsMIntegralCurve.comp_mul_mulInvariantVectorField
    [T2Space G] [I.Boundaryless]
    {v : GroupLieAlgebra I G} {γ : ℝ → G}
    (hγ : IsMIntegralCurve γ (mulInvariantVectorField v)) (c : ℝ) :
    IsMIntegralCurve (fun t => γ (t * c))
      (mulInvariantVectorField (c • v)) := by
  simpa only [Function.comp_def, mulInvariantVectorField_smul] using hγ.comp_mul c

set_option backward.isDefEq.respectTransparency false in
/-- Scalar-time compatibility is independent of the chosen global integral
curve through the identity. -/
theorem oneParameterSubgroup_smul_eq
    [T2Space G] [I.Boundaryless]
    {v : GroupLieAlgebra I G} {γ δ : ℝ → G}
    (hγ : IsMIntegralCurve γ (mulInvariantVectorField v))
    (hγ0 : γ 0 = 1)
    {c : ℝ}
    (hδ : IsMIntegralCurve δ (mulInvariantVectorField (c • v)))
    (hδ0 : δ 0 = 1) (t : ℝ) :
    γ (t * c) = δ t := by
  have hscaled :=
    IsMIntegralCurve.comp_mul_mulInvariantVectorField (I := I) hγ c
  have hscaled0 : (fun t : ℝ => γ (t * c)) 0 = 1 := by
    simp only [zero_mul, hγ0]
  have heq := isMIntegralCurve_eq_of_eq_at (I := I)
    hscaled hδ 0 (hscaled0.trans hδ0.symm)
  exact congrFun heq t

set_option backward.isDefEq.respectTransparency false in
/-- Every tangent vector of a real Lie group integrates to a global
one-parameter subgroup. -/
theorem exists_oneParameterSubgroup
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    (v : GroupLieAlgebra I G) :
    ∃ γ : ℝ → G, γ 0 = 1 ∧
      IsMIntegralCurve γ (mulInvariantVectorField v) ∧
      ∀ s t : ℝ, γ (s + t) = γ s * γ t := by
  obtain ⟨γ, hγ0, hγ⟩ :=
    exists_global_mulInvariant_integralCurve (I := I) v
  exact ⟨γ, hγ0, hγ, IsMIntegralCurve.map_add_eq_mul hγ hγ0⟩

end Analytic
end Mumford
