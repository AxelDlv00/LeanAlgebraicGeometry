/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexManifoldRealification
import MumfordLib.ComplexLieAdjoint

/-!
# Central real one-parameter subgroups of compact complex Lie groups

The compact-holomorphic adjoint calculation says that conjugation has identity
derivative at the identity. After restricting scalars to the underlying real
manifold, naturality of left-invariant integral curves therefore shows that
every real one-parameter subgroup is fixed by conjugation and has central
image.

This file does not package these individual curves into an exponential map on
the whole tangent space, nor prove regularity in that tangent parameter.
-/

set_option autoImplicit false

noncomputable section

open Function Set
open scoped Manifold ContDiff

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ω G]

/-- Conjugation by a complex Lie-group element is smooth on the realified
manifold. -/
theorem contMDiff_complexLieConjugation_real (x : G) :
    ContMDiff (complexToRealModel I) (complexToRealModel I)
      (minSmoothness ℝ 3) (complexLieConjugation x) := by
  apply ContMDiff.restrict_scalars_complex I I
  change ContMDiff I I (minSmoothness ℝ 3)
    (fun y : G => x * y * x⁻¹)
  exact (contMDiff_const.mul contMDiff_id).mul contMDiff_const.inv

/-- On the realified tangent space, conjugation also has identity derivative
at the identity. -/
theorem mfderiv_real_complexLieConjugation_one_eq_id
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] (x : G) :
    mfderiv (complexToRealModel I) (complexToRealModel I)
        (complexLieConjugation x) 1 =
      ContinuousLinearMap.id ℝ E := by
  have hf : MDifferentiableAt I I (complexLieConjugation x) 1 := by
    change MDifferentiableAt I I (fun y : G => x * y * x⁻¹) 1
    exact ((contMDiff_const.mul contMDiff_id).mul
      contMDiff_const.inv).mdifferentiableAt one_ne_zero
  rw [mfderiv_complexToRealModel I I hf,
    mfderiv_complexLieConjugation_one_eq_id I x]
  ext v
  rfl

set_option backward.isDefEq.respectTransparency false in
/-- A real integral curve through the identity is fixed pointwise by complex
conjugation. -/
theorem complexLieConjugation_comp_integralCurve_eq
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] [T2Space G]
    {v : GroupLieAlgebra (complexToRealModel I) G} {γ : ℝ → G}
    (hγ : IsMIntegralCurve γ
      (mulInvariantVectorField (I := complexToRealModel I) v))
    (hγ0 : γ 0 = 1) (x : G) :
    complexLieConjugation x ∘ γ = γ := by
  have htransport :
      IsMIntegralCurve (complexLieConjugation x ∘ γ)
        (mulInvariantVectorField (I := complexToRealModel I) v) := by
    apply IsMIntegralCurve.comp_of_map_mul (I := complexToRealModel I) hγ
      (contMDiff_complexLieConjugation_real I x)
      (complexLieConjugation_one x)
    · intro y z
      simp [complexLieConjugation, mul_assoc]
    · rw [mfderiv_real_complexLieConjugation_one_eq_id I x]
      rfl
  apply isMIntegralCurve_eq_of_eq_at (I := complexToRealModel I)
    htransport hγ 0
  simp only [Function.comp_apply, hγ0, complexLieConjugation_one]

set_option backward.isDefEq.respectTransparency false in
/-- Every value of a real one-parameter flow through the identity commutes with
every element of the compact connected complex Lie group. -/
theorem isMIntegralCurve_commute_complexLieGroup
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] [T2Space G]
    {v : GroupLieAlgebra (complexToRealModel I) G} {γ : ℝ → G}
    (hγ : IsMIntegralCurve γ
      (mulInvariantVectorField (I := complexToRealModel I) v))
    (hγ0 : γ 0 = 1) (x : G) (t : ℝ) :
    Commute x (γ t) := by
  have hfixed := congrFun
    (complexLieConjugation_comp_integralCurve_eq I hγ hγ0 x) t
  change x * γ t * x⁻¹ = γ t at hfixed
  rw [Commute]
  calc
    x * γ t = (x * γ t * x⁻¹) * x := by simp [mul_assoc]
    _ = γ t * x := by rw [hfixed]

/-- Every tangent vector of the underlying real Lie group integrates to a
one-parameter subgroup whose image is central. -/
theorem exists_central_real_oneParameterSubgroup_of_complexLieGroup
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) :
    ∃ γ : ℝ → G, γ 0 = 1 ∧
      IsMIntegralCurve γ
        (mulInvariantVectorField (I := complexToRealModel I) v) ∧
      (∀ s t : ℝ, γ (s + t) = γ s * γ t) ∧
      ∀ x : G, ∀ t : ℝ, Commute x (γ t) := by
  obtain ⟨γ, hγ0, hγ, hadd⟩ :=
    exists_real_oneParameterSubgroup_of_complexLieGroup I v
  refine ⟨γ, hγ0, hγ, hadd, ?_⟩
  intro x t
  exact isMIntegralCurve_commute_complexLieGroup I hγ hγ0 x t

end Analytic
end Mumford
