/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.RealLieOneParameter
import Mathlib.Analysis.Calculus.FDeriv.RestrictScalars
import Mathlib.Geometry.Manifold.Complex

/-!
# Realification of complex manifold models

The integral-curve API in Mathlib is formulated for real manifolds. This file
forgets the complex scalar structure of a model with corners while retaining
the same partial equivalence and charts. Complex differentiability then
implies real differentiability, so manifold and Lie-group structures transfer
to the realified model.
-/

set_option autoImplicit false

noncomputable section

open scoped Manifold ContDiff

namespace Mumford
namespace Analytic

variable {E H : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H]

/-- The real model with corners obtained from a complex model by restricting
scalars and keeping its partial equivalence unchanged. -/
def complexToRealModel (I : ModelWithCorners ℂ E H) :
    ModelWithCorners ℝ E H :=
  ModelWithCorners.ofConvexRange I.toPartialEquiv I.source_eq
    (by simpa only [I.target_eq] using I.convex_range)
    I.continuous I.continuous_symm
    (by simpa only [I.target_eq] using I.nonempty_interior)

/-! The tangent fibre at the identity is a non-reducible type synonym in
    Mathlib.  This named equivalence records the underlying real-vector
    identification once, so flow and local-generation arguments can consume
    it without rebuilding identity maps at each use site. -/

/-- The identity-on-vectors map from the complex model to the tangent space of
the realified group at the identity, regarded as a real-linear map. -/
def complexToRealLieAlgebraMap
    {G : Type*} (I : ModelWithCorners ℂ E H)
    [TopologicalSpace G] [ChartedSpace H G] [Group G] :
    E →ₗ[ℝ] GroupLieAlgebra (complexToRealModel I) G :=
  { toFun := fun v => v
    map_add' := by
      intro v w
      rfl
    map_smul' := by
      intro c v
      rfl }

/-- Real-linear identification of the complex model with the tangent space at
the identity of the realified group.

This is a representation bridge only; it does not equip the tangent fibre
with a new norm or a complex-manifold structure. -/
def complexToRealLieAlgebraEquiv
    {G : Type*} (I : ModelWithCorners ℂ E H)
    [TopologicalSpace G] [ChartedSpace H G] [Group G] :
    E ≃ₗ[ℝ] GroupLieAlgebra (complexToRealModel I) G :=
  { toFun := complexToRealLieAlgebraMap I
    invFun := fun v => v
    left_inv := by
      intro v
      rfl
    right_inv := by
      intro v
      rfl
    map_add' := by
      intro v w
      exact (complexToRealLieAlgebraMap I).map_add v w
    map_smul' := by
      intro c v
      exact (complexToRealLieAlgebraMap I).map_smul c v }

@[simp]
theorem complexToRealLieAlgebraEquiv_apply
    {G : Type*} [TopologicalSpace G] [ChartedSpace H G] [Group G]
    (I : ModelWithCorners ℂ E H) (v : E) :
    complexToRealLieAlgebraEquiv (G := G) I v =
      complexToRealLieAlgebraMap I v :=
  rfl

@[simp]
theorem complexToRealLieAlgebraEquiv_symm_apply
    {G : Type*} [TopologicalSpace G] [ChartedSpace H G] [Group G]
    (I : ModelWithCorners ℂ E H)
    (v : GroupLieAlgebra (complexToRealModel I) G) :
    (complexToRealLieAlgebraEquiv (G := G) I).symm v = v :=
  rfl

/-! The corresponding bridge for the original complex model is useful when a
    theorem is stated with the intrinsic tangent fibre but its analytic proof
    is carried out in the chosen model coordinates. -/

/-- Identity-on-vectors complex-linear identification of the chosen model with
the tangent fibre at the identity.

This is a representation bridge only.  In particular, it does not add a
normed or manifold structure to `GroupLieAlgebra I G`; holomorphic statements
with an intrinsic tangent parameter below are phrased by pulling that
parameter back along this equivalence. -/
def complexLieAlgebraEquiv
    {G : Type*} (I : ModelWithCorners ℂ E H)
    [TopologicalSpace G] [ChartedSpace H G] [Group G] :
    E ≃ₗ[ℂ] GroupLieAlgebra I G :=
  { toFun := fun v => v
    invFun := fun v => v
    left_inv := by
      intro v
      rfl
    right_inv := by
      intro v
      rfl
    map_add' := by
      intro v w
      rfl
    map_smul' := by
      intro c v
      rfl }

@[simp]
theorem complexLieAlgebraEquiv_apply
    {G : Type*} [TopologicalSpace G] [ChartedSpace H G] [Group G]
    (I : ModelWithCorners ℂ E H) (v : E) :
    complexLieAlgebraEquiv (G := G) I v = (v : GroupLieAlgebra I G) :=
  rfl

@[simp]
theorem complexLieAlgebraEquiv_symm_apply
    {G : Type*} [TopologicalSpace G] [ChartedSpace H G] [Group G]
    (I : ModelWithCorners ℂ E H) (v : GroupLieAlgebra I G) :
    (complexLieAlgebraEquiv (G := G) I).symm v = (v : E) :=
  rfl

/-- Every complex-smooth coordinate change is smooth for the realified model. -/
theorem contDiffGroupoid_complex_le_real
    (I : ModelWithCorners ℂ E H) (n : ℕ∞ω) :
    contDiffGroupoid n I ≤ contDiffGroupoid n (complexToRealModel I) := by
  intro e he
  change
    ContDiffOn ℂ n (I ∘ e ∘ I.symm)
        (I.symm ⁻¹' e.source ∩ Set.range I) ∧
      ContDiffOn ℂ n (I ∘ e.symm ∘ I.symm)
        (I.symm ⁻¹' e.target ∩ Set.range I) at he
  change
    ContDiffOn ℝ n
        (complexToRealModel I ∘ e ∘ (complexToRealModel I).symm)
        ((complexToRealModel I).symm ⁻¹' e.source ∩
          Set.range (complexToRealModel I)) ∧
      ContDiffOn ℝ n
        (complexToRealModel I ∘ e.symm ∘ (complexToRealModel I).symm)
        ((complexToRealModel I).symm ⁻¹' e.target ∩
          Set.range (complexToRealModel I))
  exact ⟨he.1.restrict_scalars ℝ, he.2.restrict_scalars ℝ⟩

/-- A complex manifold is a real manifold for the realified model and the
same charted-space structure. -/
instance complexToRealModel_isManifold
    {M : Type*} [TopologicalSpace M] [ChartedSpace H M]
    (I : ModelWithCorners ℂ E H) (n : ℕ∞ω) [IsManifold I n M] :
    IsManifold (complexToRealModel I) n M := by
  letI : HasGroupoid M (contDiffGroupoid n (complexToRealModel I)) :=
    hasGroupoid_of_le
      (inferInstance : HasGroupoid M (contDiffGroupoid n I))
      (contDiffGroupoid_complex_le_real I n)
  exact IsManifold.mk' (complexToRealModel I) n M

/-- Boundarylessness is unchanged by realification. -/
instance complexToRealModel_boundaryless
    (I : ModelWithCorners ℂ E H) [I.Boundaryless] :
    (complexToRealModel I).Boundaryless where
  range_eq_univ := by
    change Set.range I = Set.univ
    exact I.range_eq_univ

/-- A complex manifold derivative remains a manifold derivative after
restricting scalars to `ℝ`. -/
theorem HasMFDerivAt.restrict_scalars_complex
    {E' H' M M' : Type*}
    [NormedAddCommGroup E'] [NormedSpace ℂ E'] [TopologicalSpace H']
    (I : ModelWithCorners ℂ E H) (J : ModelWithCorners ℂ E' H')
    [TopologicalSpace M] [ChartedSpace H M]
    [TopologicalSpace M'] [ChartedSpace H' M']
    {f : M → M'} {x : M}
    {f' : TangentSpace I x →L[ℂ] TangentSpace J (f x)}
    (hf : HasMFDerivAt I J f x f') :
    HasMFDerivAt (complexToRealModel I) (complexToRealModel J) f x
      (f'.restrictScalars ℝ) := by
  rw [HasMFDerivAt] at hf ⊢
  exact ⟨hf.1, hf.2.restrictScalars ℝ⟩

/-- A realified manifold derivative whose continuous-linear-map witness is the
    scalar restriction of a complex-linear map can be lifted back to the
    complex model. -/
theorem HasMFDerivAt.of_restrict_scalars_complex
    {E' H' M M' : Type*}
    [NormedAddCommGroup E'] [NormedSpace ℂ E'] [TopologicalSpace H']
    (I : ModelWithCorners ℂ E H) (J : ModelWithCorners ℂ E' H')
    [TopologicalSpace M] [ChartedSpace H M]
    [TopologicalSpace M'] [ChartedSpace H' M']
    {f : M → M'} {x : M}
    {f' : TangentSpace I x →L[ℂ] TangentSpace J (f x)}
    (hf : HasMFDerivAt (complexToRealModel I) (complexToRealModel J) f x
      (f'.restrictScalars ℝ)) :
    HasMFDerivAt I J f x f' := by
  rw [HasMFDerivAt] at hf ⊢
  exact ⟨hf.1, hf.2.of_restrictScalars ℝ rfl⟩

/-- Realifying the standard complex model gives the standard real model. -/
theorem complexToRealModel_self :
    complexToRealModel (𝓘(ℂ, E)) = 𝓘(ℝ, E) := by
  apply ModelWithCorners.ext <;> rfl

/-- Complex manifold differentiability implies differentiability for the
underlying realified models. -/
theorem MDifferentiableAt.restrict_scalars_complex
    {E' H' M M' : Type*}
    [NormedAddCommGroup E'] [NormedSpace ℂ E'] [TopologicalSpace H']
    (I : ModelWithCorners ℂ E H) (J : ModelWithCorners ℂ E' H')
    [TopologicalSpace M] [ChartedSpace H M]
    [TopologicalSpace M'] [ChartedSpace H' M']
    {f : M → M'} {x : M} (hf : MDifferentiableAt I J f x) :
    MDifferentiableAt (complexToRealModel I) (complexToRealModel J) f x := by
  rw [mdifferentiableAt_iff] at hf ⊢
  exact ⟨hf.1, hf.2.restrictScalars ℝ⟩

/-- The manifold derivative for a realified complex manifold is the scalar
restriction of its complex manifold derivative. -/
theorem mfderiv_complexToRealModel
    {E' H' M M' : Type*}
    [NormedAddCommGroup E'] [NormedSpace ℂ E'] [TopologicalSpace H']
    (I : ModelWithCorners ℂ E H) (J : ModelWithCorners ℂ E' H')
    [TopologicalSpace M] [ChartedSpace H M]
    [TopologicalSpace M'] [ChartedSpace H' M']
    {f : M → M'} {x : M} (hf : MDifferentiableAt I J f x) :
    mfderiv (complexToRealModel I) (complexToRealModel J) f x =
      (mfderiv I J f x).restrictScalars ℝ :=
  (HasMFDerivAt.restrict_scalars_complex I J hf.hasMFDerivAt).mfderiv

/-- A complex-smooth map is smooth between the corresponding realified
manifolds. -/
theorem ContMDiff.restrict_scalars_complex
    {E' H' M M' : Type*}
    [NormedAddCommGroup E'] [NormedSpace ℂ E'] [TopologicalSpace H']
    (I : ModelWithCorners ℂ E H) (J : ModelWithCorners ℂ E' H')
    {n : ℕ∞ω}
    [TopologicalSpace M] [ChartedSpace H M] [IsManifold I n M]
    [TopologicalSpace M'] [ChartedSpace H' M'] [IsManifold J n M']
    {f : M → M'} (hf : ContMDiff I J n f) :
    ContMDiff (complexToRealModel I) (complexToRealModel J) n f := by
  rw [contMDiff_iff] at hf ⊢
  exact ⟨hf.1, fun x y => (hf.2 x y).restrict_scalars ℝ⟩

/-- Realification commutes with products of complex models. -/
theorem complexToRealModel_prod
    {E' H' : Type*}
    [NormedAddCommGroup E'] [NormedSpace ℂ E'] [TopologicalSpace H']
    (I : ModelWithCorners ℂ E H) (J : ModelWithCorners ℂ E' H') :
    complexToRealModel (I.prod J) =
      (complexToRealModel I).prod (complexToRealModel J) := by
  apply ModelWithCorners.ext <;> rfl

/-- A complex Lie group is a real Lie group for the realified model. -/
instance complexToRealModel_lieGroup
    {G : Type*} (I : ModelWithCorners ℂ E H) (n : ℕ∞ω)
    [TopologicalSpace G] [ChartedSpace H G] [Group G] [LieGroup I n G] :
    LieGroup (complexToRealModel I) n G := by
  have hmul := ContMDiff.restrict_scalars_complex (I.prod I) I
    (contMDiff_mul I n (G := G))
  rw [complexToRealModel_prod] at hmul
  have hinv := ContMDiff.restrict_scalars_complex I I
    (contMDiff_inv I n (G := G))
  exact { contMDiff_mul := hmul, contMDiff_inv := hinv }

/-- Every tangent vector of the underlying real Lie group of a complex Lie
group integrates to a global real one-parameter subgroup. -/
theorem exists_real_oneParameterSubgroup_of_complexLieGroup
    {G : Type*}
    (I : ModelWithCorners ℂ E H)
    [TopologicalSpace G] [ChartedSpace H G] [Group G]
    [LieGroup I (minSmoothness ℂ 3) G]
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    (v : GroupLieAlgebra (complexToRealModel I) G) :
    ∃ γ : ℝ → G, γ 0 = 1 ∧
      IsMIntegralCurve γ
        (mulInvariantVectorField (I := complexToRealModel I) v) ∧
      ∀ s t : ℝ, γ (s + t) = γ s * γ t :=
  let h : minSmoothness ℝ 3 = minSmoothness ℂ 3 := by
    simp only [minSmoothness_of_isRCLikeNormedField]
  letI : LieGroup I (minSmoothness ℝ 3) G :=
    h ▸ (inferInstance : LieGroup I (minSmoothness ℂ 3) G)
  exists_oneParameterSubgroup (I := complexToRealModel I) v

end Analytic
end Mumford
