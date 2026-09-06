/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyRing
import Mathlib.Topology.Connected.PathConnected

/-!
# Degree-zero cohomology of a path-connected space

The boundary of a path forces a zero-cocycle to have equal values at its
endpoints. Hence, on a path-connected space, evaluation at any point identifies
integral singular cohomology in degree zero with the integers. The constant-one
cohomology class corresponds to one.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat}

/-- Every singular zero-simplex is constant at its unique vertex. -/
theorem singularZeroSimplex_eq_constant
    (σ : (TopCat.toSSet.obj X).obj (op ⦋0⦌)) :
    σ = constantSingularSimplex 0
      ((X.toSSetObjEquiv (op ⦋0⦌) σ) (stdSimplex.vertex 0)) := by
  apply (X.toSSetObjEquiv (op ⦋0⦌)).injective
  ext t
  change (X.toSSetObjEquiv (op ⦋0⦌) σ) t =
    (X.toSSetObjEquiv (op ⦋0⦌) σ) (stdSimplex.vertex 0)
  congr 1
  exact @Subsingleton.elim (stdSimplex ℝ (Fin 1)) inferInstance _ _

/-- Point evaluations determine a singular zero-cochain. -/
theorem integralSingularZeroCochain_ext {φ ψ : IntegralSingularCochain X 0}
    (h : ∀ x : X, singularCochainPointEval φ x = singularCochainPointEval ψ x) :
    φ = ψ := by
  apply integralSingularCochain_ext
  intro σ
  rw [singularZeroSimplex_eq_constant σ]
  exact h _

@[simp]
theorem singularCochainPointEval_smul (z : ℤ)
    (φ : IntegralSingularCochain X 0) (x : X) :
    singularCochainPointEval (z • φ) x = z * singularCochainPointEval φ x := by
  simp [singularCochainPointEval]

@[simp]
theorem singularCochainPointEval_one (x : X) :
    singularCochainPointEval (singularCochainOne X) x = 1 :=
  singularCochainOne_eval _

/-- A zero-cocycle has equal values at the endpoints of a path. -/
theorem singularZeroCocycle_pointEval_eq_of_path
    (φ : singularCocycles X 0) {x y : X} (p : Path x y) :
    singularCochainPointEval φ.1 x = singularCochainPointEval φ.1 y := by
  have h := singularCochainPathEval_coboundary φ.1 p
  have hφ : singularCochainCoboundary φ.1 = 0 := φ.property
  rw [hφ] at h
  have hz : singularCochainPointEval φ.1 y - singularCochainPointEval φ.1 x = 0 := by
    simpa [singularCochainPathEval] using h.symm
  exact (sub_eq_zero.mp hz).symm

/-- A zero-cocycle on a path-connected space is constant. -/
theorem singularZeroCocycle_pointEval_eq [PathConnectedSpace X]
    (φ : singularCocycles X 0) (x y : X) :
    singularCochainPointEval φ.1 x = singularCochainPointEval φ.1 y :=
  singularZeroCocycle_pointEval_eq_of_path φ (PathConnectedSpace.somePath x y)

/-- A zero-cocycle is the integer multiple of the constant-one cocycle given
by evaluation at any point. -/
theorem singularZeroCocycle_eq_smul_one [PathConnectedSpace X]
    (φ : singularCocycles X 0) (x : X) :
    φ = singularCochainPointEval φ.1 x • singularCocycleOne X := by
  apply Subtype.ext
  apply integralSingularZeroCochain_ext
  intro y
  rw [singularZeroCocycle_pointEval_eq φ y x]
  simp [singularCocycleOne]

/-- Evaluation at a point identifies the zero-cocycles of a path-connected
space with the integers. -/
def singularZeroCocyclesEquivInt (X : TopCat) [PathConnectedSpace X] (x : X) :
    singularCocycles X 0 ≃ₗ[ℤ] ℤ where
  toFun φ := singularCochainPointEval φ.1 x
  invFun z := z • singularCocycleOne X
  left_inv φ := (singularZeroCocycle_eq_smul_one φ x).symm
  right_inv z := by
    simp [singularCocycleOne]
  map_add' φ ψ := by simp [singularCochainPointEval]
  map_smul' z φ := by simp [singularCochainPointEval]

/-- Integral singular cohomology in degree zero of a path-connected space is
the free rank-one integer module, with its isomorphism given by evaluation. -/
def singularZeroCohomologyEquivInt (X : TopCat) [PathConnectedSpace X] (x : X) :
    IntegralSingularCohomology X 0 ≃ₗ[ℤ] ℤ :=
  (singularZeroCohomologyIso X).toLinearEquiv.trans (singularZeroCocyclesEquivInt X x)

@[simp]
theorem singularZeroCohomologyEquivInt_class [PathConnectedSpace X] (x : X)
    (φ : singularCocycles X 0) :
    singularZeroCohomologyEquivInt X x (singularCohomologyClass X 0 φ) =
      singularCochainPointEval φ.1 x := by
  change singularCochainPointEval
    ((singularZeroCohomologyIso X).hom ((singularZeroCohomologyIso X).inv φ)).1 x = _
  exact congrArg (fun ψ : singularCocycles X 0 => singularCochainPointEval ψ.1 x)
    (ConcreteCategory.congr_hom (singularZeroCohomologyIso X).inv_hom_id φ)

/-- The constant-one cohomology class is the positive generator of degree zero. -/
@[simp]
theorem singularZeroCohomologyEquivInt_one [PathConnectedSpace X] (x : X) :
    singularZeroCohomologyEquivInt X x (singularCohomologyOne X) = 1 := by
  rw [singularCohomologyOne, singularZeroCohomologyEquivInt_class]
  exact singularCochainOne_eval _

/-- The identification of degree-zero cohomology is independent of the
point used for evaluation. -/
theorem singularZeroCohomologyEquivInt_eq [PathConnectedSpace X] (x y : X) :
    singularZeroCohomologyEquivInt X x = singularZeroCohomologyEquivInt X y := by
  apply LinearEquiv.ext
  intro c
  obtain ⟨φ, rfl⟩ := singularCohomologyClass_surjective X 0 c
  simp only [singularZeroCohomologyEquivInt_class]
  exact singularZeroCocycle_pointEval_eq φ x y

end Mumford.Analytic
