/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexLieFlowParameter

/-!
# Real regularity of complex-parameterized flows

The complex parameter is used only as a real parameter here.  For a fixed
tangent vector, scalar multiplication is a real-smooth map, so the existing
real time-one regularity theorem gives a genuine `C¹` parameterized flow.
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

/-- For a fixed tangent vector, the complex-parameterized flow is `C¹` as a
real map from the underlying real complex line to the realified Lie group.
This makes no holomorphicity claim. -/
theorem canonicalComplexFlow_contMDiff_of_vector
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] (v : E) :
    ContMDiff 𝓘(ℝ, ℂ) (complexToRealModel I) 1
      (fun z : ℂ => canonicalComplexFlow (G := G) I v z) := by
  have hsmul : ContDiff ℝ 1 (fun z : ℂ => z • v) :=
    contDiff_smul_const v
  have hsmul' : ContMDiff 𝓘(ℝ, ℂ) 𝓘(ℝ, E) 1
      (fun z : ℂ => z • v) :=
    hsmul.contMDiff
  have hflow := canonicalRealFlow_time_one_contMDiff (G := G) I
  have hcomp := hflow.comp hsmul'
  change ContMDiff 𝓘(ℝ, ℂ) (complexToRealModel I) 1
    (fun z : ℂ => canonicalRealFlow (G := G) I (z • v) 1) at hcomp
  simpa [canonicalComplexFlow, complexToRealLieAlgebraMap] using hcomp

/-! The next results promote the real time-one flow to the complex model.  The
    promotion uses the reverse scalar bridge and the additive flow law; it is
    a proved regularity producer, not the source's separate uniqueness or
    uniformization assertion. -/

/-- The time-one exponential candidate has identity complex derivative at the
origin. -/
theorem canonicalComplexExponential_hasMFDerivAt_zero
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] :
    HasMFDerivAt 𝓘(ℂ, E) I
      (canonicalComplexExponential (G := G) I) 0
      (ContinuousLinearMap.id ℂ E) := by
  have hdiff : MDifferentiableAt 𝓘(ℝ, E) (complexToRealModel I)
      (fun v : E => canonicalRealFlow (G := G) I v 1) 0 :=
    (canonicalRealFlow_time_one_contMDiff (G := G) I).mdifferentiableAt one_ne_zero
  have hreal : HasMFDerivAt 𝓘(ℝ, E) (complexToRealModel I)
      (fun v : E => canonicalRealFlow (G := G) I v 1) 0
      (ContinuousLinearMap.id ℝ E) := by
    have h := hdiff.hasMFDerivAt
    rw [mfderiv_canonicalRealFlow_time_one_eq_id (G := G) I hdiff] at h
    exact h
  apply HasMFDerivAt.of_restrict_scalars_complex 𝓘(ℂ, E) I
  rw [complexToRealModel_self]
  change HasMFDerivAt 𝓘(ℝ, E) (complexToRealModel I)
    (fun v : E => canonicalRealFlow (G := G) I v 1) 0
    ((ContinuousLinearMap.id ℂ E).restrictScalars ℝ)
  convert hreal using 1
  apply ContinuousLinearMap.ext
  intro v
  rfl

/-- The time-one exponential candidate is complex-differentiable everywhere.
The proof translates the identity derivative at zero using the additive flow
law. -/
theorem canonicalComplexExponential_mdifferentiable
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] :
    MDifferentiable 𝓘(ℂ, E) I
      (canonicalComplexExponential (G := G) I) := by
  intro x
  have hzero : MDifferentiableAt 𝓘(ℂ, E) I
      (canonicalComplexExponential (G := G) I) 0 :=
    (canonicalComplexExponential_hasMFDerivAt_zero (G := G) I).mdifferentiableAt
  have hshift : MDifferentiableAt 𝓘(ℂ, E) 𝓘(ℂ, E)
      (fun y : E => y - x) x :=
    mdifferentiableAt_id.sub mdifferentiableAt_const
  have hzero' : MDifferentiableAt 𝓘(ℂ, E) I
      (canonicalComplexExponential (G := G) I)
      ((fun y : E => y - x) x) := by
    simpa using hzero
  have hinner : MDifferentiableAt 𝓘(ℂ, E) I
      ((canonicalComplexExponential (G := G) I) ∘ fun y : E => y - x) x := by
    have hh := MDifferentiableAt.comp (x := x) (f := fun y : E => y - x)
      (g := canonicalComplexExponential (G := G) I) hzero' hshift
    simpa only [Function.comp_def] using hh
  have hleft : MDifferentiableAt I I
      (fun y : G => canonicalComplexExponential (G := G) I x * y)
      (((canonicalComplexExponential (G := G) I) ∘ fun y : E => y - x) x) := by
    exact (contMDiff_const.mul contMDiff_id).mdifferentiableAt one_ne_zero
  have hcomp := hleft.comp x hinner
  have heq :
      (fun y : G => canonicalComplexExponential (G := G) I x * y) ∘
          ((canonicalComplexExponential (G := G) I) ∘ fun y : E => y - x) =
        canonicalComplexExponential (G := G) I := by
    funext y
    dsimp [canonicalComplexExponential, Function.comp_def]
    rw [← canonicalRealFlow_add (G := G) I]
    congr 2
    rw [map_sub]
    abel
  rw [heq] at hcomp
  exact hcomp

/-- For a fixed vector, the complex-parameterized flow is
`MDifferentiable` in its complex parameter. -/
theorem canonicalComplexFlow_mdifferentiable_of_vector
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] (v : E) :
    MDifferentiable 𝓘(ℂ) I
      (fun z : ℂ => canonicalComplexFlow (G := G) I v z) := by
  intro z
  have hscalar : MDifferentiableAt 𝓘(ℂ) 𝓘(ℂ, E)
      (fun w : ℂ => w • v) z := by
    exact mdifferentiableAt_id.smul mdifferentiableAt_const
  have hcomp := MDifferentiableAt.comp (x := z)
    (f := fun w : ℂ => w • v)
    (g := canonicalComplexExponential (G := G) I)
    (canonicalComplexExponential_mdifferentiable (G := G) I (z • v)) hscalar
  simpa only [Function.comp_def, canonicalComplexFlow_eq_exponential_smul] using hcomp

/-- The complex scalar and vector parameters are jointly
`MDifferentiable` for the canonical flow. -/
theorem canonicalComplexFlow_mdifferentiable_joint
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] :
    MDifferentiable (𝓘(ℂ).prod 𝓘(ℂ, E)) I
      (fun p : ℂ × E => canonicalComplexFlow (G := G) I p.2 p.1) := by
  intro p
  have hsmul : MDifferentiableAt (𝓘(ℂ).prod 𝓘(ℂ, E)) 𝓘(ℂ, E)
      (fun q : ℂ × E => q.1 • q.2) p := by
    exact mdifferentiableAt_fst.smul mdifferentiableAt_snd
  have hcomp := MDifferentiableAt.comp (x := p)
    (f := fun q : ℂ × E => q.1 • q.2)
    (g := canonicalComplexExponential (G := G) I)
    (canonicalComplexExponential_mdifferentiable (G := G) I (p.1 • p.2)) hsmul
  simpa only [Function.comp_def, canonicalComplexFlow_eq_exponential_smul] using hcomp

end Analytic
end Mumford
