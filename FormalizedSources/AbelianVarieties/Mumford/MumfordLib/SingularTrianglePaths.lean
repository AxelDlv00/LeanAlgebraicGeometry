/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularSimplexPaths
import Mathlib.Analysis.Convex.Contractible
import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected

/-!
# The path relation around a singular triangle

The standard simplex is contractible. Its edge concatenation is therefore
homotopic to its remaining edge, and a singular simplex preserves this relation.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite
open scoped Simplicial

namespace Mumford.Analytic

private theorem intervalSimplex_zero :
    stdSimplexHomeomorphUnitInterval.symm 0 = stdSimplex.vertex 0 := by
  apply stdSimplexHomeomorphUnitInterval.injective
  simp

private theorem intervalSimplex_one :
    stdSimplexHomeomorphUnitInterval.symm 1 = stdSimplex.vertex 1 := by
  apply stdSimplexHomeomorphUnitInterval.injective
  simp

/-- The oriented affine edge joining two vertices of a standard simplex. -/
def stdSimplexEdge {n : ℕ} (i j : Fin (n + 1)) :
    Path (stdSimplex.vertex (S := ℝ) i) (stdSimplex.vertex j) where
  toFun t := stdSimplex.map ![i, j] (stdSimplexHomeomorphUnitInterval.symm t)
  continuous_toFun := (stdSimplex.continuous_map ![i, j]).comp
    stdSimplexHomeomorphUnitInterval.symm.continuous
  source' := by simp [intervalSimplex_zero]
  target' := by simp [intervalSimplex_one]

variable {X : TopCat}

/-- The path along an oriented edge of a singular simplex. -/
def singularSimplexEdge {n : ℕ} (σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌))
    (i j : Fin (n + 1)) : Path (singularSimplexVertex σ i) (singularSimplexVertex σ j) :=
  (stdSimplexEdge i j).map (X.toSSetObjEquiv (op ⦋n⦌) σ).continuous

/-- A face of a singular triangle parametrizes the corresponding oriented edge. -/
theorem singularSimplexPath_face (σ : (TopCat.toSSet.obj X).obj (op ⦋2⦌))
    (i : Fin 3) :
    singularSimplexPath ((TopCat.toSSet.obj X).δ i σ) =
      (singularSimplexEdge σ (i.succAbove 0) (i.succAbove 1)).cast
        (singularSimplexVertex_face σ i 0) (singularSimplexVertex_face σ i 1) := by
  ext t
  change (X.toSSetObjEquiv (op ⦋2⦌) σ)
      (stdSimplex.map (SimplexCategory.δ i) (stdSimplexHomeomorphUnitInterval.symm t)) =
    (X.toSSetObjEquiv (op ⦋2⦌) σ)
      (stdSimplex.map ![i.succAbove 0, i.succAbove 1]
        (stdSimplexHomeomorphUnitInterval.symm t))
  have hf : (SimplexCategory.δ i : Fin 2 → Fin 3) =
      ![i.succAbove 0, i.succAbove 1] := by
    ext j
    fin_cases j <;> rfl
  rw [hf]

/-- The first two oriented edges of a singular triangle concatenate to its
remaining edge up to path homotopy. -/
theorem singularSimplexEdge_triangle
    (σ : (TopCat.toSSet.obj X).obj (op ⦋2⦌)) :
    ((singularSimplexEdge σ 0 1).trans (singularSimplexEdge σ 1 2)).Homotopic
      (singularSimplexEdge σ 0 2) := by
  letI : ContractibleSpace (stdSimplex ℝ (Fin 3)) :=
    (convex_stdSimplex ℝ (Fin 3)).contractibleSpace
      ⟨_, (stdSimplex.vertex (S := ℝ) (0 : Fin 3)).property⟩
  have h := SimplyConnectedSpace.paths_homotopic
    ((stdSimplexEdge (0 : Fin 3) 1).trans (stdSimplexEdge 1 2)) (stdSimplexEdge 0 2)
  simpa [singularSimplexEdge, singularSimplexVertex, Path.map_trans] using
    h.map (X.toSSetObjEquiv (op ⦋2⦌) σ)

end Mumford.Analytic
