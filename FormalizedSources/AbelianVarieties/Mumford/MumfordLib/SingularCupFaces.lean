/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.AlgebraicTopology.SimplexCategory.Basic

/-!
# Simplex interval identities for the singular cup product

Restricting a face to an interval either shifts the interval, leaves it fixed,
or takes the corresponding face of the longer interval. These identities
provide the simplex combinatorics for the Alexander--Whitney Leibniz rule.
-/

set_option autoImplicit false

open CategoryTheory
open scoped Simplicial

namespace Mumford.Analytic

open SimplexCategory

/-- Deleting a vertex before an interval shifts its initial vertex by one. -/
theorem subinterval_comp_face_before {n j l : ℕ} (hjl : j + l ≤ n)
    (i : Fin (n + 2)) (hi : i.val ≤ j) :
    subinterval j l hjl ≫ δ i =
      subinterval (j + 1) l (by omega) := by
  ext k
  have hk : k.val < l + 1 := k.isLt
  change (i.succAbove ⟨k.val + j, by omega⟩).val = k.val + (j + 1)
  simp only [Fin.succAbove, Fin.lt_def]
  split_ifs <;> simp_all <;> omega

/-- Deleting a vertex after an interval leaves the interval unchanged. -/
theorem subinterval_comp_face_after {n j l : ℕ} (hjl : j + l ≤ n)
    (i : Fin (n + 2)) (hi : j + l < i.val) :
    subinterval j l hjl ≫ δ i =
      subinterval j l (by omega) := by
  ext k
  have hk : k.val < l + 1 := k.isLt
  change (i.succAbove ⟨k.val + j, by omega⟩).val = k.val + j
  simp only [Fin.succAbove, Fin.lt_def]
  split_ifs <;> simp_all
  omega

/-- A deleted vertex within an interval gives a face of the longer interval. -/
theorem subinterval_comp_face_inside {n j l : ℕ} (hjl : j + l ≤ n)
    (i : Fin (n + 2)) (hi : j ≤ i.val) (hi' : i.val ≤ j + l + 1) :
    subinterval j l hjl ≫ δ i =
      δ (⟨i.val - j, by omega⟩ : Fin (l + 2)) ≫
        subinterval j (l + 1) (by omega) := by
  ext k
  have hk : k.val < l + 1 := k.isLt
  change (i.succAbove ⟨k.val + j, by omega⟩).val =
    ((⟨i.val - j, by omega⟩ : Fin (l + 2)).succAbove k).val + j
  simp only [Fin.succAbove, Fin.lt_def]
  split_ifs <;> simp_all <;> omega

/-- The last face of a longer interval omits its final vertex. -/
theorem face_last_comp_subinterval {n j l : ℕ} (hjl : j + (l + 1) ≤ n) :
    δ (Fin.last (l + 1)) ≫ subinterval j (l + 1) hjl =
      subinterval j l (by omega) := by
  ext k
  have hk : k.val < l + 1 := k.isLt
  change ((Fin.last (l + 1)).succAbove k).val + j = k.val + j
  simp only [Fin.succAbove, Fin.lt_def]
  split_ifs <;> simp_all

/-- The first face of a longer interval omits its initial vertex. -/
theorem face_zero_comp_subinterval {n j l : ℕ} (hjl : j + (l + 1) ≤ n) :
    δ (0 : Fin (l + 2)) ≫ subinterval j (l + 1) hjl =
      subinterval (j + 1) l (by omega) := by
  ext k
  change ((0 : Fin (l + 2)).succAbove k).val + j = k.val + (j + 1)
  simp only [Fin.succAbove, Fin.lt_def]
  split_ifs <;> simp_all
  omega

end Mumford.Analytic
