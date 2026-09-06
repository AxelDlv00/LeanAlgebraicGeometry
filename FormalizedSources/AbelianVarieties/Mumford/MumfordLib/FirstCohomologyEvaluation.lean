/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomology
import MumfordLib.SingularPathEvaluation

/-!
# Evaluation of first singular cohomology on loops

Evaluation of a one-cocycle on based loops vanishes on coboundaries, so it
descends to the homology of the integral singular cochain complex.

Reference: Mumford, *Abelian Varieties*, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Analytic

variable {X : TopCat}

/-- Simultaneous evaluation of one-cocycles on all loops at a basepoint. -/
def singularCocycleLoopEval (x : X) : singularOneCocycles X →ₗ[ℤ] (Path x x → ℤ) where
  toFun φ p := singularCochainPathEval φ.1 p
  map_add' φ ψ := by
    funext p
    simp [singularCochainPathEval]
  map_smul' c φ := by
    funext p
    simp [singularCochainPathEval]

/-- Coboundaries vanish on loops because their two endpoints agree. -/
theorem singularCocycleLoopEval_coboundary (x : X) :
    (singularCocycleLoopEval x).comp (singularCoboundaryToOneCocycles X) = 0 := by
  apply LinearMap.ext
  intro φ
  funext p
  change singularCochainPathEval (singularCochainCoboundary φ) p = 0
  rw [singularCochainPathEval_coboundary, sub_self]

/-- Evaluation of an actual singular cohomology class on based loops. -/
def singularFirstCohomologyLoopEval (x : X) :
    IntegralSingularCohomology X 1 →ₗ[ℤ] (Path x x → ℤ) :=
  singularFirstCohomologyDesc X (singularCocycleLoopEval x)
    (singularCocycleLoopEval_coboundary x)

@[simp]
theorem singularFirstCohomologyLoopEval_class (x : X) (φ : singularOneCocycles X)
    (p : Path x x) :
    singularFirstCohomologyLoopEval x (singularFirstCohomologyClass X φ) p =
      singularCochainPathEval φ.1 p := by
  rw [singularFirstCohomologyLoopEval, singularFirstCohomologyDesc_class]
  rfl

@[simp]
theorem singularFirstCohomologyLoopEval_refl (x : X)
    (c : IntegralSingularCohomology X 1) :
    singularFirstCohomologyLoopEval x c (Path.refl x) = 0 := by
  obtain ⟨φ, rfl⟩ := singularFirstCohomologyClass_surjective X c
  rw [singularFirstCohomologyLoopEval_class]
  exact IntegralSingularCocycle.pathEval_refl ⟨φ.1, φ.2⟩ x

/-- Loop concatenation is additive on singular cohomology classes. -/
theorem singularFirstCohomologyLoopEval_trans (x : X)
    (c : IntegralSingularCohomology X 1) (p q : Path x x) :
    singularFirstCohomologyLoopEval x c (p.trans q) =
      singularFirstCohomologyLoopEval x c p + singularFirstCohomologyLoopEval x c q := by
  obtain ⟨φ, rfl⟩ := singularFirstCohomologyClass_surjective X c
  simp only [singularFirstCohomologyLoopEval_class]
  exact IntegralSingularCocycle.pathEval_trans ⟨φ.1, φ.2⟩ p q

end Mumford.Analytic
