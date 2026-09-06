/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCupProductGeneral

/-!
# Associativity and units for the singular cup product

Successive interval restrictions compose by adding their initial vertices.
Thus the Alexander--Whitney product is associative on cochains, and the
constant-one degree-zero cochain is its two-sided unit.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

/-- Successive simplex interval restrictions add their initial vertices. -/
theorem subinterval_comp_subinterval {n m j k l : ℕ}
    (hjl : j + l ≤ m) (hkm : k + m ≤ n) :
    SimplexCategory.subinterval j l hjl ≫ SimplexCategory.subinterval k m hkm =
      SimplexCategory.subinterval (k + j) l (by omega) := by
  ext i
  change (i.val + j) + k = i.val + (k + j)
  omega

/-- Restricting to the whole simplex is the identity. -/
@[simp]
theorem subinterval_zero_self (n : ℕ) :
    SimplexCategory.subinterval 0 n (by omega : 0 + n ≤ n) = 𝟙 ⦋n⦌ := by
  ext i
  change i.val + 0 = i.val
  omega

variable {X : TopCat}

/-- The Alexander--Whitney cup product is associative in all degrees. -/
theorem singularCochainCup_assoc {p q r a b n : ℕ}
    (φ : IntegralSingularCochain X p) (ψ : IntegralSingularCochain X q)
    (χ : IntegralSingularCochain X r)
    (hpq : p + q = a) (hqr : q + r = b) (har : a + r = n) :
    singularCochainCup (singularCochainCup φ ψ hpq) χ har =
      singularCochainCup φ (singularCochainCup ψ χ hqr) (by omega) := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCup, ← Functor.map_comp_apply, ← op_comp,
    subinterval_comp_subinterval, hpq, mul_assoc]

/-- The constant-one degree-zero cochain is a left cup unit. -/
@[simp]
theorem singularCochainCup_one_left {p : ℕ} (φ : IntegralSingularCochain X p) :
    singularCochainCup (singularCochainOne X) φ (Nat.zero_add p) = φ := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCup, singularCochainOne]

/-- The constant-one degree-zero cochain is a right cup unit. -/
@[simp]
theorem singularCochainCup_one_right {p : ℕ} (φ : IntegralSingularCochain X p) :
    singularCochainCup φ (singularCochainOne X) rfl = φ := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCup, singularCochainOne]

/-- The general cup agrees with pointwise multiplication in degree zero. -/
@[simp]
theorem singularCochainCup_zero_zero (φ ψ : IntegralSingularCochain X 0) :
    singularCochainCup φ ψ rfl = singularCochainCupZero φ ψ := by
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCup, singularCochainCupZero]

/-- The general cup agrees with the existing left mixed-degree cup. -/
@[simp]
theorem singularCochainCup_zero_one (φ : IntegralSingularCochain X 0)
    (ψ : IntegralSingularCochain X 1) :
    singularCochainCup φ ψ rfl = singularCochainCupZeroOne φ ψ := by
  have hf : SimplexCategory.subinterval 0 0 (by decide : 0 + 0 ≤ 1) =
      SimplexCategory.δ (1 : Fin 2) := by decide
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCup, singularCochainCupZeroOne, hf, SimplicialObject.δ]

/-- The general cup agrees with the existing right mixed-degree cup. -/
@[simp]
theorem singularCochainCup_one_zero (φ : IntegralSingularCochain X 1)
    (ψ : IntegralSingularCochain X 0) :
    singularCochainCup φ ψ rfl = singularCochainCupOneZero φ ψ := by
  have hb : SimplexCategory.subinterval 1 0 (by decide : 1 + 0 ≤ 1) =
      SimplexCategory.δ (0 : Fin 2) := by decide
  apply integralSingularCochain_ext
  intro σ
  simp [singularCochainCup, singularCochainCupOneZero, hb, SimplicialObject.δ]

end Mumford.Analytic
