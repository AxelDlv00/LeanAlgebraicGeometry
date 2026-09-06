/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularPathEvaluation
import Mathlib.AlgebraicTopology.FundamentalGroupoid.Basic

/-!
# Homotopy invariance of singular cocycle path evaluation

A path homotopy is divided into two singular triangles. Their cocycle
identities cancel the common diagonal and the constant endpoint edges.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite
open scoped Simplicial

namespace Mumford.Analytic

private def triangleLast (t : stdSimplex ℝ (Fin 3)) : unitInterval :=
  ⟨t 2, stdSimplex.zero_le t 2, stdSimplex.le_one t 2⟩

private def triangleLastTwo (t : stdSimplex ℝ (Fin 3)) : unitInterval :=
  ⟨t 1 + t 2, add_nonneg (stdSimplex.zero_le t 1) (stdSimplex.zero_le t 2), by
    have h := stdSimplex.sum_eq_one t
    simp only [Fin.sum_univ_three] at h
    linarith [stdSimplex.zero_le t 0]⟩

private theorem continuous_triangleLast : Continuous triangleLast :=
  ((continuous_apply 2).comp continuous_subtype_val).subtype_mk _

private theorem continuous_triangleLastTwo : Continuous triangleLastTwo :=
  (((continuous_apply 1).comp continuous_subtype_val).add
    ((continuous_apply 2).comp continuous_subtype_val)).subtype_mk _

private theorem triangleLast_face_zero (t : stdSimplex ℝ (Fin 2)) :
    triangleLast (stdSimplex.map (SimplexCategory.δ 0) t) =
      stdSimplexHomeomorphUnitInterval t := by
  apply Subtype.ext
  change (stdSimplex.map (SimplexCategory.δ 0) t) 2 = t 1
  simp [stdSimplex_face_two_apply, Fin.succAbove, Fin.ext_iff]

private theorem triangleLast_face_one (t : stdSimplex ℝ (Fin 2)) :
    triangleLast (stdSimplex.map (SimplexCategory.δ 1) t) =
      stdSimplexHomeomorphUnitInterval t := by
  apply Subtype.ext
  change (stdSimplex.map (SimplexCategory.δ 1) t) 2 = t 1
  simp [stdSimplex_face_two_apply, Fin.succAbove, Fin.lt_def, Fin.ext_iff]

private theorem triangleLast_face_two (t : stdSimplex ℝ (Fin 2)) :
    triangleLast (stdSimplex.map (SimplexCategory.δ 2) t) = 0 := by
  apply Subtype.ext
  change (stdSimplex.map (SimplexCategory.δ 2) t) 2 = 0
  simp [stdSimplex_face_two_apply, Fin.succAbove, Fin.lt_def, Fin.ext_iff]

private theorem triangleLastTwo_face_zero (t : stdSimplex ℝ (Fin 2)) :
    triangleLastTwo (stdSimplex.map (SimplexCategory.δ 0) t) = 1 := by
  apply Subtype.ext
  change (stdSimplex.map (SimplexCategory.δ 0) t) 1 +
    (stdSimplex.map (SimplexCategory.δ 0) t) 2 = 1
  simpa [stdSimplex_face_two_apply, Fin.succAbove, Fin.ext_iff] using stdSimplex.add_eq_one t

private theorem triangleLastTwo_face_one (t : stdSimplex ℝ (Fin 2)) :
    triangleLastTwo (stdSimplex.map (SimplexCategory.δ 1) t) =
      stdSimplexHomeomorphUnitInterval t := by
  apply Subtype.ext
  change (stdSimplex.map (SimplexCategory.δ 1) t) 1 +
    (stdSimplex.map (SimplexCategory.δ 1) t) 2 = t 1
  simp [stdSimplex_face_two_apply, Fin.succAbove, Fin.lt_def, Fin.ext_iff]

private theorem triangleLastTwo_face_two (t : stdSimplex ℝ (Fin 2)) :
    triangleLastTwo (stdSimplex.map (SimplexCategory.δ 2) t) =
      stdSimplexHomeomorphUnitInterval t := by
  apply Subtype.ext
  change (stdSimplex.map (SimplexCategory.δ 2) t) 1 +
    (stdSimplex.map (SimplexCategory.δ 2) t) 2 = t 1
  simp [stdSimplex_face_two_apply, Fin.succAbove, Fin.lt_def, Fin.ext_iff]

variable {X : TopCat} {x y : X} {p q : Path x y}

/-- The triangle with vertices `(0,0)`, `(0,1)`, `(1,1)` in a path homotopy. -/
def pathHomotopyLowerTriangle (H : p.Homotopy q) :
    C(stdSimplex ℝ (Fin 3), X) where
  toFun t := H (triangleLast t, triangleLastTwo t)
  continuous_toFun := H.continuous.comp
    (continuous_triangleLast.prodMk continuous_triangleLastTwo)

/-- The triangle with vertices `(0,0)`, `(1,0)`, `(1,1)` in a path homotopy. -/
def pathHomotopyUpperTriangle (H : p.Homotopy q) :
    C(stdSimplex ℝ (Fin 3), X) where
  toFun t := H (triangleLastTwo t, triangleLast t)
  continuous_toFun := H.continuous.comp
    (continuous_triangleLastTwo.prodMk continuous_triangleLast)

/-- The common diagonal of the two triangles of a path homotopy. -/
def pathHomotopyDiagonal (H : p.Homotopy q) : Path x y where
  toFun t := H (t, t)
  continuous_toFun := H.continuous.comp (continuous_id.prodMk continuous_id)
  source' := by simp
  target' := by simp

@[simp]
theorem pathHomotopyLowerTriangle_face_zero (H : p.Homotopy q) :
    (TopCat.toSSet.obj X).δ 0
        (singularSimplexOfContinuousMap (pathHomotopyLowerTriangle H)) =
      constantSingularSimplex 1 y := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change H (triangleLast (stdSimplex.map (SimplexCategory.δ 0) t),
    triangleLastTwo (stdSimplex.map (SimplexCategory.δ 0) t)) = y
  simp [triangleLastTwo_face_zero]

@[simp]
theorem pathHomotopyLowerTriangle_face_one (H : p.Homotopy q) :
    (TopCat.toSSet.obj X).δ 1
        (singularSimplexOfContinuousMap (pathHomotopyLowerTriangle H)) =
      pathSingularSimplex (pathHomotopyDiagonal H) := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change H (triangleLast (stdSimplex.map (SimplexCategory.δ 1) t),
    triangleLastTwo (stdSimplex.map (SimplexCategory.δ 1) t)) =
      H (stdSimplexHomeomorphUnitInterval t, stdSimplexHomeomorphUnitInterval t)
  rw [triangleLast_face_one, triangleLastTwo_face_one]

@[simp]
theorem pathHomotopyLowerTriangle_face_two (H : p.Homotopy q) :
    (TopCat.toSSet.obj X).δ 2
        (singularSimplexOfContinuousMap (pathHomotopyLowerTriangle H)) =
      pathSingularSimplex p := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change H (triangleLast (stdSimplex.map (SimplexCategory.δ 2) t),
    triangleLastTwo (stdSimplex.map (SimplexCategory.δ 2) t)) =
      p (stdSimplexHomeomorphUnitInterval t)
  simp [triangleLast_face_two, triangleLastTwo_face_two]

@[simp]
theorem pathHomotopyUpperTriangle_face_zero (H : p.Homotopy q) :
    (TopCat.toSSet.obj X).δ 0
        (singularSimplexOfContinuousMap (pathHomotopyUpperTriangle H)) =
      pathSingularSimplex q := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change H (triangleLastTwo (stdSimplex.map (SimplexCategory.δ 0) t),
    triangleLast (stdSimplex.map (SimplexCategory.δ 0) t)) =
      q (stdSimplexHomeomorphUnitInterval t)
  simp [triangleLastTwo_face_zero, triangleLast_face_zero]

@[simp]
theorem pathHomotopyUpperTriangle_face_one (H : p.Homotopy q) :
    (TopCat.toSSet.obj X).δ 1
        (singularSimplexOfContinuousMap (pathHomotopyUpperTriangle H)) =
      pathSingularSimplex (pathHomotopyDiagonal H) := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change H (triangleLastTwo (stdSimplex.map (SimplexCategory.δ 1) t),
    triangleLast (stdSimplex.map (SimplexCategory.δ 1) t)) =
      H (stdSimplexHomeomorphUnitInterval t, stdSimplexHomeomorphUnitInterval t)
  rw [triangleLastTwo_face_one, triangleLast_face_one]

@[simp]
theorem pathHomotopyUpperTriangle_face_two (H : p.Homotopy q) :
    (TopCat.toSSet.obj X).δ 2
        (singularSimplexOfContinuousMap (pathHomotopyUpperTriangle H)) =
      constantSingularSimplex 1 x := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change H (triangleLastTwo (stdSimplex.map (SimplexCategory.δ 2) t),
    triangleLast (stdSimplex.map (SimplexCategory.δ 2) t)) = x
  simp [triangleLast_face_two]

/-- A singular one-cocycle has the same value on endpoint-preserving homotopic paths. -/
theorem IntegralSingularCocycle.pathEval_homotopy
    (φ : IntegralSingularCocycle X 1) (H : p.Homotopy q) :
    singularCochainPathEval φ.1 p = singularCochainPathEval φ.1 q := by
  have hl := φ.annihilates_two_simplex_boundary
    (singularSimplexOfContinuousMap (pathHomotopyLowerTriangle H))
  have hu := φ.annihilates_two_simplex_boundary
    (singularSimplexOfContinuousMap (pathHomotopyUpperTriangle H))
  simp only [pathHomotopyLowerTriangle_face_zero, pathHomotopyLowerTriangle_face_one,
    pathHomotopyLowerTriangle_face_two] at hl
  simp only [pathHomotopyUpperTriangle_face_zero, pathHomotopyUpperTriangle_face_one,
    pathHomotopyUpperTriangle_face_two] at hu
  have hl' := congrArg (fun f : ModuleCat.of ℤ ℤ ⟶ ModuleCat.of ℤ ℤ => f.hom 1) hl
  have hu' := congrArg (fun f : ModuleCat.of ℤ ℤ ⟶ ModuleCat.of ℤ ℤ => f.hom 1) hu
  change singularCochainPathEval φ.1 (Path.refl y) -
    singularCochainPathEval φ.1 (pathHomotopyDiagonal H) +
      singularCochainPathEval φ.1 p = 0 at hl'
  change singularCochainPathEval φ.1 q -
    singularCochainPathEval φ.1 (pathHomotopyDiagonal H) +
      singularCochainPathEval φ.1 (Path.refl x) = 0 at hu'
  rw [φ.pathEval_refl] at hl' hu'
  omega

/-- Cocycle path evaluation descends through the path homotopy relation. -/
theorem IntegralSingularCocycle.pathEval_homotopic
    (φ : IntegralSingularCocycle X 1) (h : p.Homotopic q) :
    singularCochainPathEval φ.1 p = singularCochainPathEval φ.1 q := by
  rcases h with ⟨H⟩
  exact φ.pathEval_homotopy H

/-- Reversing a path negates the value of a singular one-cocycle. -/
theorem IntegralSingularCocycle.pathEval_symm
    (φ : IntegralSingularCocycle X 1) (p : Path x y) :
    singularCochainPathEval φ.1 p.symm = -singularCochainPathEval φ.1 p := by
  have h := φ.pathEval_homotopic (Path.Homotopic.trans_symm p)
  rw [φ.pathEval_trans, φ.pathEval_refl] at h
  omega

end Mumford.Analytic
