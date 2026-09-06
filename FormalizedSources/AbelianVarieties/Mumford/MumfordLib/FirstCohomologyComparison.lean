/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.FirstCohomologyEvaluation
import MumfordLib.SingularCochainExtension
import MumfordLib.SingularSimplexPaths
import MumfordLib.SingularCocycleOfCharacter

/-!
# First cohomology and characters of the fundamental group

On a path-connected space, a singular one-cocycle that vanishes on all based
loops is a coboundary: its primitive at a point is evaluation on a connecting
path from the basepoint.
Conversely, connecting paths extend every fundamental group character to a
singular cocycle. Loop evaluation therefore identifies first cohomology with
the integral characters of the fundamental group.

Reference: Mumford, *Abelian Varieties*, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Analytic

variable {X : TopCat} [PathConnectedSpace X]

private theorem pathEval_eq_primitive_sub (x : X) (φ : IntegralSingularCocycle X 1)
    (hφ : ∀ p : Path x x, singularCochainPathEval φ.1 p = 0)
    {a b : X} (p : Path a b) :
    singularCochainPathEval φ.1 p =
      singularCochainPathEval φ.1 (PathConnectedSpace.somePath x b) -
        singularCochainPathEval φ.1 (PathConnectedSpace.somePath x a) := by
  have h := hφ (((PathConnectedSpace.somePath x a).trans p).trans
    (PathConnectedSpace.somePath x b).symm)
  rw [φ.pathEval_trans, φ.pathEval_trans, φ.pathEval_symm] at h
  omega

/-- A singular cocycle vanishing on all loops is the coboundary of its
evaluation along paths from the basepoint. -/
theorem IntegralSingularCocycle.exists_primitive_of_loopEval_eq_zero
    (x : X) (φ : IntegralSingularCocycle X 1)
    (hφ : ∀ p : Path x x, singularCochainPathEval φ.1 p = 0) :
    ∃ ψ : IntegralSingularCochain X 0, singularCochainCoboundary ψ = φ.1 := by
  let f : X → ℤ := fun y => singularCochainPathEval φ.1 (PathConnectedSpace.somePath x y)
  refine ⟨singularCochainOfPointFunction f, ?_⟩
  apply integralSingularCochain_ext
  intro σ
  rw [← singularCochainPathEval_singularSimplexPath,
    ← singularCochainPathEval_singularSimplexPath,
    singularCochainOfPointFunction_coboundary_pathEval]
  exact (pathEval_eq_primitive_sub x φ hφ (singularSimplexPath σ)).symm

/-- Integral first cohomology is detected by evaluation on the fundamental group. -/
theorem singularFirstCohomologyToCharacters_injective (x : X) :
    Function.Injective (singularFirstCohomologyToCharacters x) := by
  apply LinearMap.ker_eq_bot.mp
  apply LinearMap.ker_eq_bot'.mpr
  intro c hc
  obtain ⟨φ, rfl⟩ := singularFirstCohomologyClass_surjective X c
  have hφ : ∀ p : Path x x, singularCochainPathEval φ.1 p = 0 := by
    intro p
    have h := DFunLike.congr_fun hc
      (Additive.ofMul (FundamentalGroup.fromPath (Path.Homotopic.Quotient.mk p)))
    change singularFirstCohomologyLoopEval x (singularFirstCohomologyClass X φ) p = 0 at h
    rwa [singularFirstCohomologyLoopEval_class] at h
  obtain ⟨ψ, hψ⟩ :=
    IntegralSingularCocycle.exists_primitive_of_loopEval_eq_zero x ⟨φ.1, φ.2⟩ hφ
  apply (singularFirstCohomologyClass_eq_zero_iff X φ).mpr
  exact ⟨ψ, Subtype.ext hψ⟩

/-- Every integral character of the fundamental group comes from a singular
cohomology class. -/
theorem singularFirstCohomologyToCharacters_surjective (x : X) :
    Function.Surjective (singularFirstCohomologyToCharacters x) := by
  intro χ
  let φ := singularCocycleOfCharacter χ
  refine ⟨singularFirstCohomologyClass X ⟨φ.1, φ.2⟩, ?_⟩
  apply AddMonoidHom.ext
  intro p
  induction p using Path.Homotopic.Quotient.ind with
  | mk p =>
    change singularFirstCohomologyLoopEval x
      (singularFirstCohomologyClass X ⟨φ.1, φ.2⟩) p = _
    rw [singularFirstCohomologyLoopEval_class]
    exact singularCocycleOfCharacter_loopEval χ p

/-- First integral singular cohomology of a path-connected space is the
module of integral characters of its fundamental group. -/
def singularFirstCohomologyEquivCharacters (x : X) :
    IntegralSingularCohomology X 1 ≃ₗ[ℤ] (Additive (FundamentalGroup X x) →+ ℤ) :=
  LinearEquiv.ofBijective (singularFirstCohomologyToCharacters x)
    ⟨singularFirstCohomologyToCharacters_injective x,
      singularFirstCohomologyToCharacters_surjective x⟩

/-- The comparison is evaluation of a cocycle representative on a loop. -/
@[simp]
theorem singularFirstCohomologyEquivCharacters_apply_class_path (x : X)
    (φ : singularOneCocycles X) (p : Path x x) :
    singularFirstCohomologyEquivCharacters x (singularFirstCohomologyClass X φ)
        (Additive.ofMul (FundamentalGroup.fromPath (Path.Homotopic.Quotient.mk p))) =
      singularCochainPathEval φ.1 p := by
  exact singularFirstCohomologyLoopEval_class x φ p

end Mumford.Analytic
