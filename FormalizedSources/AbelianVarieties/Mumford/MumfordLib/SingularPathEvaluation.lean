/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCochains
import Mathlib.Topology.Path

/-!
# Evaluating integral singular cochains on paths

Paths determine singular one-simplices through the canonical homeomorphism
between the standard one-simplex and the unit interval. Their boundaries are
the endpoint difference, so a coboundary evaluates to the difference of its
primitive at the endpoints.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat} {x y z : X}

/-- Regard a continuous map from a standard simplex as a singular simplex. -/
def singularSimplexOfContinuousMap {n : ℕ}
    (f : C(stdSimplex ℝ (Fin (n + 1)), X)) :
    (TopCat.toSSet.obj X).obj (op ⦋n⦌) :=
  (X.toSSetObjEquiv (op ⦋n⦌)).symm f

/-- The constant singular simplex at a point. -/
def constantSingularSimplex (n : ℕ) (x : X) :
    (TopCat.toSSet.obj X).obj (op ⦋n⦌) :=
  singularSimplexOfContinuousMap (ContinuousMap.const _ x)

/-- The singular one-simplex parametrized by a path. -/
def pathSingularSimplex (p : Path x y) :
    (TopCat.toSSet.obj X).obj (op ⦋1⦌) :=
  singularSimplexOfContinuousMap
    (p.toContinuousMap.comp (stdSimplexHomeomorphUnitInterval : C(_, _)))

@[simp]
theorem singularSimplexOfContinuousMap_face {n : ℕ}
    (f : C(stdSimplex ℝ (Fin (n + 2)), X)) (i : Fin (n + 2)) :
    (TopCat.toSSet.obj X).δ i (singularSimplexOfContinuousMap f) =
      singularSimplexOfContinuousMap
        (f.comp ⟨stdSimplex.map (SimplexCategory.δ i), stdSimplex.continuous_map _⟩) := by
  rfl

@[simp]
theorem constantSingularSimplex_face {n : ℕ} (x : X) (i : Fin (n + 2)) :
    (TopCat.toSSet.obj X).δ i (constantSingularSimplex (n + 1) x) =
      constantSingularSimplex n x := by
  rfl

@[simp]
theorem pathSingularSimplex_refl (x : X) :
    pathSingularSimplex (Path.refl x) = constantSingularSimplex 1 x := by
  rfl

@[simp]
theorem pathSingularSimplex_face_zero (p : Path x y) :
    (TopCat.toSSet.obj X).δ 0 (pathSingularSimplex p) =
      constantSingularSimplex 0 y := by
  apply (X.toSSetObjEquiv (op ⦋0⦌)).injective
  ext t
  change p (stdSimplexHomeomorphUnitInterval
    (stdSimplex.map (SimplexCategory.δ 0) t)) = y
  have ht : t = stdSimplex.vertex (S := ℝ) 0 :=
    @Subsingleton.elim (stdSimplex ℝ (Fin 1)) inferInstance _ _
  rw [ht, stdSimplex.map_vertex]
  change p (stdSimplexHomeomorphUnitInterval (stdSimplex.vertex (1 : Fin 2))) = y
  simp

@[simp]
theorem pathSingularSimplex_face_one (p : Path x y) :
    (TopCat.toSSet.obj X).δ 1 (pathSingularSimplex p) =
      constantSingularSimplex 0 x := by
  apply (X.toSSetObjEquiv (op ⦋0⦌)).injective
  ext t
  change p (stdSimplexHomeomorphUnitInterval
    (stdSimplex.map (SimplexCategory.δ 1) t)) = x
  have ht : t = stdSimplex.vertex (S := ℝ) 0 :=
    @Subsingleton.elim (stdSimplex ℝ (Fin 1)) inferInstance _ _
  rw [ht, stdSimplex.map_vertex]
  change p (stdSimplexHomeomorphUnitInterval (stdSimplex.vertex (0 : Fin 2))) = x
  simp

/-- Evaluation of a one-cochain on the singular simplex of a path. -/
def singularCochainPathEval (φ : IntegralSingularCochain X 1) (p : Path x y) : ℤ :=
  (singularSimplexChain (pathSingularSimplex p) ≫ φ).hom 1

/-- Evaluation of a zero-cochain on a point. -/
def singularCochainPointEval (φ : IntegralSingularCochain X 0) (x : X) : ℤ :=
  (singularSimplexChain (constantSingularSimplex 0 x) ≫ φ).hom 1

theorem singularCochainPathEval_coboundary
    (φ : IntegralSingularCochain X 0) (p : Path x y) :
    singularCochainPathEval (singularCochainCoboundary φ) p =
      singularCochainPointEval φ y - singularCochainPointEval φ x := by
  simp [singularCochainPathEval, singularCochainPointEval, singularCochainCoboundary,
    ← Category.assoc]

@[simp]
theorem IntegralSingularCocycle.pathEval_refl
    (φ : IntegralSingularCocycle X 1) (x : X) :
    singularCochainPathEval φ.1 (Path.refl x) = 0 := by
  have h := φ.annihilates_two_simplex_boundary (constantSingularSimplex 2 x)
  simp only [constantSingularSimplex_face, sub_self, zero_add] at h
  simp [singularCochainPathEval, h]

theorem stdSimplex_face_two_apply (t : stdSimplex ℝ (Fin 2)) (i j : Fin 3) :
    (stdSimplex.map (SimplexCategory.δ i) t) j =
      (if i.succAbove 0 = j then t 0 else 0) +
        (if i.succAbove 1 = j then t 1 else 0) := by
  change (FunOnFinite.linearMap ℝ ℝ i.succAbove t) j = _
  simp [FunOnFinite.linearMap_apply_apply, Finset.sum_filter, Fin.sum_univ_two]

/-- The affine coordinate on a triangle taking values `0`, `1/2`, and `1`
at its three vertices. -/
def concatenationTriangleParameter : C(stdSimplex ℝ (Fin 3), unitInterval) where
  toFun s := ⟨s 1 / 2 + s 2, by
    have hs := stdSimplex.sum_eq_one s
    rw [Fin.sum_univ_three] at hs
    constructor <;>
      linarith [stdSimplex.zero_le s 0, stdSimplex.zero_le s 1, stdSimplex.zero_le s 2]⟩
  continuous_toFun := by
    apply Continuous.subtype_mk
    exact (((continuous_apply 1).comp continuous_subtype_val).div_const 2).add
      ((continuous_apply 2).comp continuous_subtype_val)

/-- A singular triangle whose ordered boundary is the concatenation relation
for the two paths. -/
def pathConcatenationTriangle (p : Path x y) (q : Path y z) :
    (TopCat.toSSet.obj X).obj (op ⦋2⦌) :=
  singularSimplexOfContinuousMap
    ((p.trans q).toContinuousMap.comp concatenationTriangleParameter)

@[simp]
theorem pathConcatenationTriangle_face_zero (p : Path x y) (q : Path y z) :
    (TopCat.toSSet.obj X).δ 0 (pathConcatenationTriangle p q) =
      pathSingularSimplex q := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change (p.trans q) (concatenationTriangleParameter
    (stdSimplex.map (SimplexCategory.δ 0) t)) = q (stdSimplexHomeomorphUnitInterval t)
  have hval : (concatenationTriangleParameter
      (stdSimplex.map (SimplexCategory.δ 0) t) : ℝ) = t 0 / 2 + t 1 := by
    change (stdSimplex.map (SimplexCategory.δ 0) t) 1 / 2 +
      (stdSimplex.map (SimplexCategory.δ 0) t) 2 = _
    simp [stdSimplex_face_two_apply, Fin.succAbove, Fin.ext_iff]
  rw [← Path.extend_apply, hval, Path.extend_trans_of_half_le]
  · have ht : 2 * (t 0 / 2 + t 1) - 1 = t 1 := by
      linarith [stdSimplex.add_eq_one t]
    rw [ht]
    exact Path.extend_apply q (mem_Icc_of_mem_stdSimplex t.property 1)
  · linarith [stdSimplex.add_eq_one t, stdSimplex.zero_le t 1]

@[simp]
theorem pathConcatenationTriangle_face_one (p : Path x y) (q : Path y z) :
    (TopCat.toSSet.obj X).δ 1 (pathConcatenationTriangle p q) =
      pathSingularSimplex (p.trans q) := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change (p.trans q) (concatenationTriangleParameter
    (stdSimplex.map (SimplexCategory.δ 1) t)) =
      (p.trans q) (stdSimplexHomeomorphUnitInterval t)
  congr 1
  apply Subtype.ext
  change (stdSimplex.map (SimplexCategory.δ 1) t) 1 / 2 +
    (stdSimplex.map (SimplexCategory.δ 1) t) 2 = t 1
  simp [stdSimplex_face_two_apply, Fin.succAbove, Fin.lt_def, Fin.ext_iff]

@[simp]
theorem pathConcatenationTriangle_face_two (p : Path x y) (q : Path y z) :
    (TopCat.toSSet.obj X).δ 2 (pathConcatenationTriangle p q) =
      pathSingularSimplex p := by
  apply (X.toSSetObjEquiv (op ⦋1⦌)).injective
  ext t
  change (p.trans q) (concatenationTriangleParameter
    (stdSimplex.map (SimplexCategory.δ 2) t)) = p (stdSimplexHomeomorphUnitInterval t)
  have hval : (concatenationTriangleParameter
      (stdSimplex.map (SimplexCategory.δ 2) t) : ℝ) = t 1 / 2 := by
    change (stdSimplex.map (SimplexCategory.δ 2) t) 1 / 2 +
      (stdSimplex.map (SimplexCategory.δ 2) t) 2 = _
    simp [stdSimplex_face_two_apply, Fin.succAbove, Fin.lt_def, Fin.ext_iff]
  rw [← Path.extend_apply, hval, Path.extend_trans_of_le_half]
  · have ht : 2 * (t 1 / 2) = t 1 := by ring
    rw [ht]
    exact Path.extend_apply p (mem_Icc_of_mem_stdSimplex t.property 1)
  · linarith [stdSimplex.le_one t 1]

/-- Evaluating a singular cocycle is additive under path concatenation. -/
theorem IntegralSingularCocycle.pathEval_trans
    (φ : IntegralSingularCocycle X 1) (p : Path x y) (q : Path y z) :
    singularCochainPathEval φ.1 (p.trans q) =
      singularCochainPathEval φ.1 p + singularCochainPathEval φ.1 q := by
  have h := φ.annihilates_two_simplex_boundary (pathConcatenationTriangle p q)
  simp only [pathConcatenationTriangle_face_zero, pathConcatenationTriangle_face_one,
    pathConcatenationTriangle_face_two] at h
  have he := congrArg (fun f : ModuleCat.of ℤ ℤ ⟶ ModuleCat.of ℤ ℤ => f.hom 1) h
  change singularCochainPathEval φ.1 q - singularCochainPathEval φ.1 (p.trans q) +
    singularCochainPathEval φ.1 p = 0 at he
  omega

end Mumford.Analytic
