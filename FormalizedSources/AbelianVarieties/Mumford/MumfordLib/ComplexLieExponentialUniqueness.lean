/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexLieFlowRegularity
import MumfordLib.RealLieFlowSubgroup

/-!
# Uniqueness of the complex one-parameter exponential

The canonical exponential is defined from real invariant flows.  This module
proves that it is also the unique additive complex-parameter map with the
prescribed identity derivative.  The proof restricts a competing map to the
real axis and the imaginary axis, applies real integral-curve uniqueness, and
then uses the decomposition `z = z.re + z.im * I`.  The statements use the
explicit manifold model `I`; they are a source-proximate producer and do not
identify the intrinsic tangent space or the jointly parameterized source
family.
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

variable [CompleteSpace E] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G]

/-! ### Restriction to the two real coordinate axes -/

omit [Group G] [LieGroup I ω G] [CompleteSpace E] [T2Space G]
  [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] in
private theorem realAxis_hasMFDerivAt
    {phi : ℂ → G} {v : E}
    (hphi : HasMFDerivAt 𝓘(ℂ, ℂ) I phi 0
      ((ContinuousLinearMap.id ℂ ℂ).smulRight v)) :
    HasMFDerivAt 𝓘(ℝ, ℝ) (complexToRealModel I)
      (fun t : ℝ => phi (t : ℂ)) 0
      ((1 : ℝ →L[ℝ] ℝ).smulRight v) := by
  have hphi_real := HasMFDerivAt.restrict_scalars_complex
    (𝓘(ℂ, ℂ)) I hphi
  rw [complexToRealModel_self] at hphi_real
  have hcast : HasMFDerivAt 𝓘(ℝ, ℝ) 𝓘(ℝ, ℂ)
      (fun t : ℝ => (t : ℂ)) 0 Complex.ofRealCLM := by
    convert Complex.ofRealCLM.hasFDerivAt.hasMFDerivAt using 1
    funext t
    simp [Complex.ofRealCLM_apply]
  have hcomp := HasMFDerivAt.comp (x := (0 : ℝ))
    (f := fun t : ℝ => (t : ℂ)) (g := phi)
    (by simpa [Complex.ofRealCLM_apply] using hphi_real) hcast
  convert hcomp using 1
  · rfl
  · apply ContinuousLinearMap.ext
    intro t
    change (ContinuousLinearMap.id ℂ ℂ).smulRight v
        (Complex.ofRealCLM t) = t • v
    simp [Complex.ofRealCLM_apply]

omit [Group G] [LieGroup I ω G] [CompleteSpace E] [T2Space G]
  [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] in
private theorem imaginaryAxis_hasMFDerivAt
    {phi : ℂ → G} {v : E}
    (hphi : HasMFDerivAt 𝓘(ℂ, ℂ) I phi 0
      ((ContinuousLinearMap.id ℂ ℂ).smulRight v)) :
    HasMFDerivAt 𝓘(ℝ, ℝ) (complexToRealModel I)
      (fun t : ℝ => phi ((t : ℂ) * Complex.I)) 0
      ((1 : ℝ →L[ℝ] ℝ).smulRight (Complex.I • v)) := by
  have hphi_real := HasMFDerivAt.restrict_scalars_complex
    (𝓘(ℂ, ℂ)) I hphi
  rw [complexToRealModel_self] at hphi_real
  have hline : HasMFDerivAt 𝓘(ℝ, ℝ) 𝓘(ℝ, ℂ)
      (fun t : ℝ => Complex.ofRealCLM t * Complex.I) 0
      (Complex.I • Complex.ofRealCLM) :=
    (Complex.ofRealCLM.hasFDerivAt.mul_const Complex.I).hasMFDerivAt
  have hcomp := HasMFDerivAt.comp
    (I := 𝓘(ℝ, ℝ)) (I' := 𝓘(ℝ, ℂ)) (I'' := complexToRealModel I)
    (x := (0 : ℝ))
    (f := fun t : ℝ => Complex.ofRealCLM t * Complex.I) (g := phi)
    (by
      rw [map_zero, zero_mul]
      exact hphi_real) hline
  have hcomp' := hcomp
  simp only [Complex.ofRealCLM_apply] at hcomp'
  convert hcomp' using 1
  · funext t
    rfl
  · apply ContinuousLinearMap.ext
    intro t
    change t • (Complex.I • v) =
      ((ContinuousLinearMap.id ℂ ℂ).smulRight v)
        ((Complex.I • Complex.ofRealCLM) t)
    rw [← smul_assoc, Complex.real_smul, mul_comm]
    change (Complex.I * (t : ℂ)) • v =
      ((Complex.I • Complex.ofRealCLM) t) • v
    simp [Complex.ofRealCLM_apply, smul_eq_mul]
private theorem realAxis_eq_canonical
    {phi : ℂ → G} {v : E}
    (hzero : phi 0 = 1)
    (hadd : ∀ z w : ℂ, phi (z + w) = phi z * phi w)
    (hphi : HasMFDerivAt 𝓘(ℂ, ℂ) I phi 0
      ((ContinuousLinearMap.id ℂ ℂ).smulRight v)) :
    (fun t : ℝ => phi (t : ℂ)) =
      canonicalRealFlow (G := G) I
        (complexToRealLieAlgebraMap I v) := by
  apply canonicalRealFlow_eq_of_isMIntegralCurve
  · apply isMIntegralCurve_of_oneParameterSubgroup_of_hasMFDerivAt
    · simpa using hzero
    · intro s t
      simpa only [Complex.ofReal_add] using hadd (s : ℂ) (t : ℂ)
    · exact realAxis_hasMFDerivAt I hphi
  · simpa using hzero

private theorem imaginaryAxis_eq_canonical
    {phi : ℂ → G} {v : E}
    (hzero : phi 0 = 1)
    (hadd : ∀ z w : ℂ, phi (z + w) = phi z * phi w)
    (hphi : HasMFDerivAt 𝓘(ℂ, ℂ) I phi 0
      ((ContinuousLinearMap.id ℂ ℂ).smulRight v)) :
    (fun t : ℝ => phi ((t : ℂ) * Complex.I)) =
      canonicalRealFlow (G := G) I
        (complexToRealLieAlgebraMap I (Complex.I • v)) := by
  apply canonicalRealFlow_eq_of_isMIntegralCurve
  · apply isMIntegralCurve_of_oneParameterSubgroup_of_hasMFDerivAt
    · simpa using hzero
    · intro s t
      have h := hadd ((s : ℂ) * Complex.I) ((t : ℂ) * Complex.I)
      simpa [Complex.ofReal_add, add_mul] using h
    · exact imaginaryAxis_hasMFDerivAt I hphi
  · simpa using hzero

/-! ### The model-level uniqueness statement -/

/-- In the chosen manifold model, an additive complex-parameter map with the
prescribed identity derivative is uniquely determined by that derivative. -/
theorem complexLieExponential_eq_canonical
    {phi : ℂ → G} {v : E}
    (hzero : phi 0 = 1)
    (hadd : ∀ z w : ℂ, phi (z + w) = phi z * phi w)
    (hphi : HasMFDerivAt 𝓘(ℂ, ℂ) I phi 0
      ((ContinuousLinearMap.id ℂ ℂ).smulRight v)) (z : ℂ) :
    phi z = canonicalComplexFlow (G := G) I v z := by
  have hreal := realAxis_eq_canonical I hzero hadd hphi
  have himag := imaginaryAxis_eq_canonical I hzero hadd hphi
  have hz : z = (z.re : ℂ) + (z.im : ℂ) * Complex.I := by
    apply Complex.ext <;> simp
  rw [hz, hadd]
  have hreal_z := congrFun hreal z.re
  have himag_z := congrFun himag z.im
  have hreal_z' : phi (z.re : ℂ) =
      canonicalComplexFlow (G := G) I v (z.re : ℂ) := by
    rw [canonicalComplexFlow_ofReal (G := G) I v z.re]
    exact hreal_z
  have himag_z' : phi ((z.im : ℂ) * Complex.I) =
      canonicalComplexFlow (G := G) I v ((z.im : ℂ) * Complex.I) := by
    calc
      phi ((z.im : ℂ) * Complex.I) =
          canonicalRealFlow (G := G) I
            (complexToRealLieAlgebraMap I (Complex.I • v)) z.im := himag_z
      _ = canonicalComplexFlow (G := G) I (Complex.I • v) (z.im : ℂ) := by
        rw [canonicalComplexFlow_ofReal (G := G) I (Complex.I • v) z.im]
      _ = canonicalComplexFlow (G := G) I v ((z.im : ℂ) * Complex.I) := by
        rw [canonicalComplexFlow_eq_exponential_smul,
          canonicalComplexFlow_eq_exponential_smul]
        congr 1
        simp [smul_smul, mul_comm]
  rw [hreal_z', himag_z']
  exact (canonicalComplexFlow_add_parameter (G := G) I v
    (z.re : ℂ) ((z.im : ℂ) * Complex.I)).symm

/-- For each vector in the chosen model, the canonical complex flow is the
unique holomorphic additive one-parameter map with that prescribed tangent
vector. -/
theorem existsUnique_complexLieExponential
    (v : E) :
    ∃! phi : ℂ → G,
      phi 0 = 1 ∧
      (∀ z w : ℂ, phi (z + w) = phi z * phi w) ∧
      MDifferentiable 𝓘(ℂ, ℂ) I phi ∧
      HasMFDerivAt 𝓘(ℂ, ℂ) I phi 0
        ((ContinuousLinearMap.id ℂ ℂ).smulRight v) := by
  refine ⟨canonicalComplexFlow (G := G) I v, ?_, ?_⟩
  · refine ⟨canonicalComplexFlow_zero_parameter (G := G) I v,
      ?_, canonicalComplexFlow_mdifferentiable_of_vector (G := G) I v,
      canonicalComplexFlow_hasMFDerivAt_zero (G := G) I v⟩
    exact canonicalComplexFlow_add_parameter (G := G) I v
  · intro phi hphi
    exact funext (complexLieExponential_eq_canonical I hphi.1 hphi.2.1 hphi.2.2.2)

/-! ### The jointly parameterized model family -/

/-- In fixed model coordinates, the canonical flow is the unique jointly
`MDifferentiable` family whose slices are additive complex one-parameter maps
with the prescribed tangent vectors.  This is a model-level family statement:
it does not identify `E` with an intrinsic tangent space or supply the source's
finite-dimensional genus package. -/
theorem existsUnique_complexLieExponentialFamily :
    ∃! Φ : ℂ × E → G,
      (∀ v : E, Φ (0, v) = 1) ∧
      (∀ (v : E) (z w : ℂ),
        Φ (z + w, v) = Φ (z, v) * Φ (w, v)) ∧
      MDifferentiable (𝓘(ℂ).prod 𝓘(ℂ, E)) I Φ ∧
      (∀ v : E, HasMFDerivAt 𝓘(ℂ) I (fun z : ℂ => Φ (z, v)) 0
        ((ContinuousLinearMap.id ℂ ℂ).smulRight v)) := by
  refine ⟨(fun p : ℂ × E => canonicalComplexFlow (G := G) I p.2 p.1), ?_, ?_⟩
  · refine ⟨?_, ?_, canonicalComplexFlow_mdifferentiable_joint (G := G) I, ?_⟩
    · intro v
      exact canonicalComplexFlow_zero_parameter (G := G) I v
    · intro v z w
      exact canonicalComplexFlow_add_parameter (G := G) I v z w
    · intro v
      exact canonicalComplexFlow_hasMFDerivAt_zero (G := G) I v
  · intro Φ hΦ
    funext p
    exact complexLieExponential_eq_canonical (G := G) I
      (hΦ.1 p.2) (hΦ.2.1 p.2) (hΦ.2.2.2 p.2) p.1

end Analytic
end Mumford
