/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyCupAll

/-!
# Pullback in integral singular cohomology

A continuous map induces a pullback on integral singular cochains by
precomposition with the singular chain functor. Pullback commutes with the
coboundary and the Alexander--Whitney cup and therefore induces a functorial
linear map on cohomology preserving cup products.

This gives naturality infrastructure for the integral cohomology comparison
in Mumford, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X Y Z : TopCat}

/-- Pullback of integral singular cochains along a continuous map. -/
def singularCochainPullback (f : X ⟶ Y) (n : ℕ) :
    IntegralSingularCochain Y n →ₗ[ℤ] IntegralSingularCochain X n where
  toFun φ := (((singularChainComplexFunctor (ModuleCat ℤ)).obj
    (ModuleCat.of ℤ ℤ)).map f).f n ≫ φ
  map_add' φ ψ := by simp
  map_smul' c φ := by simp

/-- Pullback commutes with the singular coboundary. -/
theorem singularCochainPullback_coboundary (f : X ⟶ Y) (n : ℕ)
    (φ : IntegralSingularCochain Y n) :
    singularCochainPullback f (n + 1) (singularCochainCoboundary φ) =
      singularCochainCoboundary (singularCochainPullback f n φ) := by
  dsimp [singularCochainPullback, singularCochainCoboundary]
  rw [← Category.assoc, HomologicalComplex.Hom.comm, Category.assoc]

/-- The morphism of singular cochain complexes induced by a continuous map. -/
def integralSingularCochainPullback (f : X ⟶ Y) :
    integralSingularCochainComplex Y ⟶ integralSingularCochainComplex X :=
  CochainComplex.ofHom (fun n => ModuleCat.ofHom (singularCochainPullback f n)) (by
    intro n
    simp only [integralSingularCochainComplex, CochainComplex.of_d]
    apply ModuleCat.hom_ext
    apply LinearMap.ext
    intro φ
    exact (singularCochainPullback_coboundary f n φ).symm)

@[simp]
theorem integralSingularCochainPullback_f (f : X ⟶ Y) (n : ℕ) :
    (integralSingularCochainPullback f).f n = ModuleCat.ofHom (singularCochainPullback f n) := rfl

@[simp]
theorem singularCochainPullback_id (n : ℕ) (φ : IntegralSingularCochain X n) :
    singularCochainPullback (𝟙 X) n φ = φ := by
  simp [singularCochainPullback]

@[simp]
theorem singularCochainPullback_comp (f : X ⟶ Y) (g : Y ⟶ Z) (n : ℕ)
    (φ : IntegralSingularCochain Z n) :
    singularCochainPullback (f ≫ g) n φ =
      singularCochainPullback f n (singularCochainPullback g n φ) := by
  simp [singularCochainPullback]

/-- Pullback evaluated on a simplex equals evaluation on its image simplex. -/
@[simp]
theorem singularCochainPullback_eval (f : X ⟶ Y) (n : ℕ)
    (φ : IntegralSingularCochain Y n) (σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌)) :
    (singularSimplexChain σ ≫ singularCochainPullback f n φ).hom 1 =
      (singularSimplexChain ((TopCat.toSSet.map f).app _ σ) ≫ φ).hom 1 := by
  change (singularSimplexChain σ ≫
    (((singularChainComplexFunctor (ModuleCat ℤ)).obj (ModuleCat.of ℤ ℤ)).map f).f n ≫ φ).hom 1 = _
  rw [← Category.assoc]
  exact congrArg (fun k : ModuleCat.of ℤ ℤ ⟶ (IntegralSingularChainComplex Y).X n =>
    (k ≫ φ).hom 1)
    (SSet.ι_chainComplexMap_f (TopCat.toSSet.obj X) (TopCat.toSSet.obj Y)
      (TopCat.toSSet.map f) (ModuleCat.of ℤ ℤ) σ)

@[simp]
theorem singularCochainPullback_one (f : X ⟶ Y) :
    singularCochainPullback f 0 (singularCochainOne Y) = singularCochainOne X := by
  apply integralSingularCochain_ext
  intro σ
  rw [singularCochainPullback_eval, singularCochainOne_eval, singularCochainOne_eval]

/-- Pullback commutes with the Alexander--Whitney cup on cochains. -/
theorem singularCochainPullback_cup (f : X ⟶ Y) {p q n : ℕ}
    (φ : IntegralSingularCochain Y p) (ψ : IntegralSingularCochain Y q) (h : p + q = n) :
    singularCochainPullback f n (singularCochainCup φ ψ h) =
      singularCochainCup (singularCochainPullback f p φ) (singularCochainPullback f q ψ) h := by
  apply integralSingularCochain_ext
  intro σ
  rw [singularCochainPullback_eval, singularCochainCup_eval, singularCochainCup_eval,
    singularCochainPullback_eval, singularCochainPullback_eval]
  congr 3

/-- The restriction of pullback to integral singular cocycles. -/
def singularCocyclePullback (f : X ⟶ Y) (n : ℕ) :
    singularCocycles Y n →ₗ[ℤ] singularCocycles X n :=
  ((singularCochainPullback f n).comp (singularCocycles Y n).subtype).codRestrict _ (by
    intro φ
    change singularCochainCoboundary (singularCochainPullback f n φ.1) = 0
    have hφ : singularCochainCoboundary φ.1 = 0 := φ.2
    rw [← singularCochainPullback_coboundary, hφ, map_zero])

@[simp]
theorem singularCocyclePullback_coe (f : X ⟶ Y) (n : ℕ) (φ : singularCocycles Y n) :
    (singularCocyclePullback f n φ).1 = singularCochainPullback f n φ.1 := rfl

@[simp]
theorem singularCocyclePullback_one (f : X ⟶ Y) :
    singularCocyclePullback f 0 (singularCocycleOne Y) = singularCocycleOne X := by
  apply Subtype.ext
  exact singularCochainPullback_one f

@[simp]
theorem singularCocyclePullback_coboundary (f : X ⟶ Y) (n : ℕ)
    (φ : IntegralSingularCochain Y n) :
    singularCocyclePullback f (n + 1) (singularCoboundaryToCocycles Y n φ) =
      singularCoboundaryToCocycles X n (singularCochainPullback f n φ) := by
  apply Subtype.ext
  exact singularCochainPullback_coboundary f n φ

@[simp]
theorem singularCocyclePullback_id (n : ℕ) (φ : singularCocycles X n) :
    singularCocyclePullback (𝟙 X) n φ = φ := by
  apply Subtype.ext
  exact singularCochainPullback_id n φ.1

@[simp]
theorem singularCocyclePullback_comp (f : X ⟶ Y) (g : Y ⟶ Z) (n : ℕ)
    (φ : singularCocycles Z n) :
    singularCocyclePullback (f ≫ g) n φ =
      singularCocyclePullback f n (singularCocyclePullback g n φ) := by
  apply Subtype.ext
  exact singularCochainPullback_comp f g n φ.1

@[simp]
theorem singularCocyclePullback_cup (f : X ⟶ Y) {p q n : ℕ}
    (φ : singularCocycles Y p) (ψ : singularCocycles Y q) (h : p + q = n) :
    singularCocyclePullback f n (singularCocycleCup φ ψ h) =
      singularCocycleCup (singularCocyclePullback f p φ) (singularCocyclePullback f q ψ) h := by
  apply Subtype.ext
  exact singularCochainPullback_cup f φ.1 ψ.1 h

private theorem singularCocyclePullback_boundary (f : X ⟶ Y) (n : ℕ) :
    singularCoboundaries Y n ≤ LinearMap.ker
      ((singularCohomologyClass X n).comp (singularCocyclePullback f n)) := by
  cases n with
  | zero => exact bot_le
  | succ n =>
    rintro φ ⟨ψ, rfl⟩
    change singularCohomologyClass X (n + 1)
      (singularCocyclePullback f (n + 1) (singularCoboundaryToCocycles Y n ψ)) = 0
    rw [singularCocyclePullback_coboundary, singularCohomologyClass_coboundary]

/-- The induced linear pullback on integral singular cohomology. -/
def singularCohomologyPullback (f : X ⟶ Y) (n : ℕ) :
    IntegralSingularCohomology Y n →ₗ[ℤ] IntegralSingularCohomology X n :=
  singularCohomologyDesc Y n
    ((singularCohomologyClass X n).comp (singularCocyclePullback f n))
    (singularCocyclePullback_boundary f n)

@[simp]
theorem singularCohomologyPullback_class (f : X ⟶ Y) (n : ℕ) (φ : singularCocycles Y n) :
    singularCohomologyPullback f n (singularCohomologyClass Y n φ) =
      singularCohomologyClass X n (singularCocyclePullback f n φ) := by
  exact singularCohomologyDesc_class Y n _ (singularCocyclePullback_boundary f n) φ

@[simp]
theorem singularCohomologyPullback_id (n : ℕ) :
    singularCohomologyPullback (𝟙 X) n = LinearMap.id := by
  apply singularCohomology_hom_ext X n
  intro φ
  simp

@[simp]
theorem singularCohomologyPullback_comp (f : X ⟶ Y) (g : Y ⟶ Z) (n : ℕ) :
    singularCohomologyPullback (f ≫ g) n =
      (singularCohomologyPullback f n).comp (singularCohomologyPullback g n) := by
  apply singularCohomology_hom_ext Z n
  intro φ
  simp

/-- Pullback preserves the integral singular cup product in every bidegree. -/
theorem singularCohomologyPullback_cup (f : X ⟶ Y) {p q n : ℕ}
    (c : IntegralSingularCohomology Y p) (d : IntegralSingularCohomology Y q)
    (h : p + q = n) :
    singularCohomologyPullback f n (singularCohomologyCup Y p q n h c d) =
      singularCohomologyCup X p q n h
        (singularCohomologyPullback f p c) (singularCohomologyPullback f q d) := by
  obtain ⟨φ, rfl⟩ := singularCohomologyClass_surjective Y p c
  obtain ⟨ψ, rfl⟩ := singularCohomologyClass_surjective Y q d
  simp only [singularCohomologyCup_class, singularCohomologyPullback_class,
    singularCocyclePullback_cup]

end Mumford.Analytic
