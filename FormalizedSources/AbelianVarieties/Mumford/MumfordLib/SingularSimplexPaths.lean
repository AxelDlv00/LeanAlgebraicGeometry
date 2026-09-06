/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularPathHomotopy

/-!
# Paths along singular simplex edges

Singular one-simplices give paths between their two vertices. This
conversion is inverse to the singular simplex associated with a path.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat}

/-- A vertex of a singular simplex, regarded as a point of the space. -/
def singularSimplexVertex {n : ℕ}
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌)) (i : Fin (n + 1)) : X :=
  (X.toSSetObjEquiv (op ⦋n⦌) σ) (stdSimplex.vertex i)

/-- A singular one-simplex, parametrized as a path from its zeroth to first vertex. -/
def singularSimplexPath (σ : (TopCat.toSSet.obj X).obj (op ⦋1⦌)) :
    Path (singularSimplexVertex σ 0) (singularSimplexVertex σ 1) where
  toFun t := (X.toSSetObjEquiv (op ⦋1⦌) σ) (stdSimplexHomeomorphUnitInterval.symm t)
  continuous_toFun := (X.toSSetObjEquiv (op ⦋1⦌) σ).continuous.comp
    stdSimplexHomeomorphUnitInterval.symm.continuous
  source' := by
    change (X.toSSetObjEquiv (op ⦋1⦌) σ) (stdSimplexHomeomorphUnitInterval.symm 0) =
      (X.toSSetObjEquiv (op ⦋1⦌) σ) (stdSimplex.vertex 0)
    congr 1
    apply stdSimplexHomeomorphUnitInterval.injective
    simp
  target' := by
    change (X.toSSetObjEquiv (op ⦋1⦌) σ) (stdSimplexHomeomorphUnitInterval.symm 1) =
      (X.toSSetObjEquiv (op ⦋1⦌) σ) (stdSimplex.vertex 1)
    congr 1
    apply stdSimplexHomeomorphUnitInterval.injective
    simp

@[simp]
theorem pathSingularSimplex_singularSimplexPath
    (σ : (TopCat.toSSet.obj X).obj (op ⦋1⦌)) :
    pathSingularSimplex (singularSimplexPath σ) = σ := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change (X.toSSetObjEquiv (op ⦋1⦌) σ)
    (stdSimplexHomeomorphUnitInterval.symm (stdSimplexHomeomorphUnitInterval t)) = _
  simp

@[simp]
theorem singularCochainPathEval_singularSimplexPath
    (φ : IntegralSingularCochain X 1) (σ : (TopCat.toSSet.obj X).obj (op ⦋1⦌)) :
    singularCochainPathEval φ (singularSimplexPath σ) =
      (singularSimplexChain σ ≫ φ).hom 1 := by
  simp [singularCochainPathEval]

@[simp]
theorem singularSimplexVertex_face {n : ℕ}
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n + 1⦌))
    (i : Fin (n + 2)) (j : Fin (n + 1)) :
    singularSimplexVertex ((TopCat.toSSet.obj X).δ i σ) j =
      singularSimplexVertex σ (i.succAbove j) := by
  change (X.toSSetObjEquiv (op ⦋n + 1⦌) σ)
      (stdSimplex.map (SimplexCategory.δ i) (stdSimplex.vertex j)) = _
  rw [stdSimplex.map_vertex]
  rfl

@[simp]
theorem singularSimplexVertex_pathSingularSimplex_zero {x y : X} (p : Path x y) :
    singularSimplexVertex (pathSingularSimplex p) 0 = x := by
  change p (stdSimplexHomeomorphUnitInterval (stdSimplex.vertex 0)) = x
  simp

@[simp]
theorem singularSimplexVertex_pathSingularSimplex_one {x y : X} (p : Path x y) :
    singularSimplexVertex (pathSingularSimplex p) 1 = y := by
  change p (stdSimplexHomeomorphUnitInterval (stdSimplex.vertex 1)) = y
  simp

/-- Converting a path to a singular simplex and back only casts its endpoints. -/
theorem singularSimplexPath_pathSingularSimplex {x y : X} (p : Path x y) :
    singularSimplexPath (pathSingularSimplex p) =
      p.cast (singularSimplexVertex_pathSingularSimplex_zero p)
        (singularSimplexVertex_pathSingularSimplex_one p) := by
  ext t
  change p (stdSimplexHomeomorphUnitInterval
    (stdSimplexHomeomorphUnitInterval.symm t)) = p t
  simp

end Mumford.Analytic
