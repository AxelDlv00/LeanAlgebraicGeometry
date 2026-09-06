/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyPullback
import Mathlib.AlgebraicTopology.SingularHomology.HomotopyInvariance
import Mathlib.Topology.Homotopy.Equiv

/-!
# Homotopy invariance of integral singular cohomology

A homotopy of continuous maps supplies an explicit primitive for the difference
of the pullbacks of a positive-degree cocycle. Consequently homotopic maps
induce the same pullback on the cohomology of the integral singular cochain
complex. This is a prerequisite for the circle and product computations in
Mumford, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Limits AlgebraicTopology

namespace Mumford.Analytic

variable {X Y : TopCat} {f g : X ⟶ Y}

/-- The degree-lowering cochain operator dual to a singular chain homotopy. -/
def singularCochainHomotopy (H : TopCat.Homotopy f g) (n : ℕ)
    (φ : IntegralSingularCochain Y (n + 1)) : IntegralSingularCochain X n :=
  (H.singularChainComplexFunctorObjMap (ModuleCat.of ℤ ℤ)).hom n (n + 1) ≫ φ

/-- The difference of homotopic pullbacks of a cocycle is a coboundary. -/
theorem singularCochainHomotopy_coboundary (H : TopCat.Homotopy f g) (n : ℕ)
    (φ : singularCocycles Y (n + 1)) :
    singularCochainCoboundary (singularCochainHomotopy H n φ.1) =
      singularCochainPullback f (n + 1) φ.1 -
        singularCochainPullback g (n + 1) φ.1 := by
  let K := H.singularChainComplexFunctorObjMap (ModuleCat.of ℤ ℤ)
  have h := congrArg (fun k => k ≫ φ.1) (K.comm (n + 1))
  rw [dNext_eq _ (show (ComplexShape.down ℕ).Rel (n + 1) n from rfl),
    prevD_eq _ (show (ComplexShape.down ℕ).Rel (n + 2) (n + 1) from rfl)] at h
  have hφ : (IntegralSingularChainComplex Y).d (n + 2) (n + 1) ≫ φ.1 = 0 := φ.2
  simp only [Preadditive.add_comp, Category.assoc, hφ, comp_zero,
    add_zero] at h
  exact (eq_sub_iff_add_eq).mpr h.symm

/-- Homotopic maps agree already on degree-zero cocycles. -/
theorem singularCocyclePullback_zero_homotopy (H : TopCat.Homotopy f g)
    (φ : singularCocycles Y 0) :
    singularCocyclePullback f 0 φ = singularCocyclePullback g 0 φ := by
  apply Subtype.ext
  let K := H.singularChainComplexFunctorObjMap (ModuleCat.of ℤ ℤ)
  have h := congrArg (fun k => k ≫ φ.1) (K.comm 0)
  rw [dNext_eq_zero _ 0 (by simp),
    prevD_eq _ (show (ComplexShape.down ℕ).Rel 1 0 from rfl)] at h
  have hφ : (IntegralSingularChainComplex Y).d 1 0 ≫ φ.1 = 0 := φ.2
  simp only [Preadditive.add_comp, Category.assoc, hφ, comp_zero, zero_add] at h
  exact h

/-- Homotopic continuous maps induce equal pullbacks in every cohomological degree. -/
theorem singularCohomologyPullback_homotopy (H : TopCat.Homotopy f g) (n : ℕ) :
    singularCohomologyPullback f n = singularCohomologyPullback g n := by
  apply singularCohomology_hom_ext Y n
  intro φ
  rw [singularCohomologyPullback_class, singularCohomologyPullback_class]
  cases n with
  | zero => rw [singularCocyclePullback_zero_homotopy H φ]
  | succ n =>
    apply (singularPositiveCohomologyClass_eq_iff X n _ _).mpr
    refine ⟨singularCochainHomotopy H n φ.1, ?_⟩
    apply Subtype.ext
    exact singularCochainHomotopy_coboundary H n φ

/-- Homotopy of continuous maps suffices for equality of cohomology pullbacks. -/
theorem singularCohomologyPullback_homotopic (h : f.hom.Homotopic g.hom) (n : ℕ) :
    singularCohomologyPullback f n = singularCohomologyPullback g n := by
  obtain ⟨H⟩ := h
  exact singularCohomologyPullback_homotopy H n

/-- Pullback along a homotopy equivalence is a linear equivalence on actual
integral singular cohomology. -/
def singularCohomologyHomotopyEquiv (e : ContinuousMap.HomotopyEquiv X Y) (n : ℕ) :
    IntegralSingularCohomology Y n ≃ₗ[ℤ] IntegralSingularCohomology X n where
  __ := singularCohomologyPullback (TopCat.ofHom e.toFun) n
  invFun := singularCohomologyPullback (TopCat.ofHom e.invFun) n
  left_inv c := by
    have h : singularCohomologyPullback
        (TopCat.ofHom e.invFun ≫ TopCat.ofHom e.toFun) n =
        singularCohomologyPullback (𝟙 Y) n :=
      singularCohomologyPullback_homotopic e.right_inv n
    rw [singularCohomologyPullback_comp, singularCohomologyPullback_id] at h
    exact LinearMap.congr_fun h c
  right_inv c := by
    have h : singularCohomologyPullback
        (TopCat.ofHom e.toFun ≫ TopCat.ofHom e.invFun) n =
        singularCohomologyPullback (𝟙 X) n :=
      singularCohomologyPullback_homotopic e.left_inv n
    rw [singularCohomologyPullback_comp, singularCohomologyPullback_id] at h
    exact LinearMap.congr_fun h c

@[simp]
theorem singularCohomologyHomotopyEquiv_apply
    (e : ContinuousMap.HomotopyEquiv X Y) (n : ℕ)
    (c : IntegralSingularCohomology Y n) :
    singularCohomologyHomotopyEquiv e n c =
      singularCohomologyPullback (TopCat.ofHom e.toFun) n c := rfl

@[simp]
theorem singularCohomologyHomotopyEquiv_symm_apply
    (e : ContinuousMap.HomotopyEquiv X Y) (n : ℕ)
    (c : IntegralSingularCohomology X n) :
    (singularCohomologyHomotopyEquiv e n).symm c =
      singularCohomologyPullback (TopCat.ofHom e.invFun) n c := rfl

end Mumford.Analytic
