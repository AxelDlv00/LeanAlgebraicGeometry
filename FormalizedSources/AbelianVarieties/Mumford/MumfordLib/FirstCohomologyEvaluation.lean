/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomology
import MumfordLib.SingularPathHomotopy
import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup

/-!
# Evaluation of first singular cohomology on loops

Evaluation of a one-cocycle on based loops vanishes on coboundaries, so it
descends to the homology of the integral singular cochain complex. Homotopy
invariance and concatenation yield an integer character of the fundamental group.

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

/-- Homotopic loops have equal evaluations on every singular cohomology class. -/
theorem singularFirstCohomologyLoopEval_homotopic (x : X)
    (c : IntegralSingularCohomology X 1) {p q : Path x x} (h : p.Homotopic q) :
    singularFirstCohomologyLoopEval x c p = singularFirstCohomologyLoopEval x c q := by
  obtain ⟨φ, rfl⟩ := singularFirstCohomologyClass_surjective X c
  simp only [singularFirstCohomologyLoopEval_class]
  exact IntegralSingularCocycle.pathEval_homotopic ⟨φ.1, φ.2⟩ h

/-- A first singular cohomology class defines an integral character of the
fundamental group by evaluating loop representatives. -/
def singularFirstCohomologyCharacter (x : X) (c : IntegralSingularCohomology X 1) :
    Additive (FundamentalGroup X x) →+ ℤ where
  toFun p := Quotient.lift (singularFirstCohomologyLoopEval x c)
    (fun _ _ h => singularFirstCohomologyLoopEval_homotopic x c h) p.toMul
  map_zero' := singularFirstCohomologyLoopEval_refl x c
  map_add' p q := by
    induction p using Path.Homotopic.Quotient.ind with
    | mk p =>
      induction q using Path.Homotopic.Quotient.ind with
      | mk q =>
        change singularFirstCohomologyLoopEval x c (q.trans p) =
          singularFirstCohomologyLoopEval x c p + singularFirstCohomologyLoopEval x c q
        rw [singularFirstCohomologyLoopEval_trans, add_comm]

@[simp]
theorem singularFirstCohomologyCharacter_apply_path (x : X)
    (c : IntegralSingularCohomology X 1) (p : Path x x) :
    singularFirstCohomologyCharacter x c
        (Additive.ofMul (FundamentalGroup.fromPath (.mk p))) =
      singularFirstCohomologyLoopEval x c p := rfl

/-- The integral linear map from singular first cohomology to characters of
the fundamental group. -/
def singularFirstCohomologyToCharacters (x : X) :
    IntegralSingularCohomology X 1 →ₗ[ℤ] (Additive (FundamentalGroup X x) →+ ℤ) where
  toFun := singularFirstCohomologyCharacter x
  map_add' c d := by
    apply AddMonoidHom.ext
    intro p
    induction p using Path.Homotopic.Quotient.ind with
    | mk p =>
      exact congrFun (map_add (singularFirstCohomologyLoopEval x) c d) p
  map_smul' n c := by
    apply AddMonoidHom.ext
    intro p
    induction p using Path.Homotopic.Quotient.ind with
    | mk p =>
      exact congrFun ((singularFirstCohomologyLoopEval x).map_smul' n c) p

end Mumford.Analytic
