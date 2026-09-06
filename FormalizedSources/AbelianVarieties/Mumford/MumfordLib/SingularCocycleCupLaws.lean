/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyCupGeneral
import MumfordLib.SingularCupAssociativity

/-!
# Associativity and units for singular cocycle cups

The Alexander--Whitney cochain laws restrict to cocycles. The constant-one
cochain is a cocycle, giving the degree-zero unit for the cohomology ring.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat}

/-- The constant-one cochain has zero coboundary. -/
@[simp]
theorem singularCochainOne_coboundary (X : TopCat) :
    singularCochainCoboundary (singularCochainOne X) = 0 := by
  apply integralSingularCochain_ext
  intro σ
  rw [singularCochainCoboundary_eval]
  have he (i : Fin 2) :=
    singularCochainOne_eval (X := X) ((TopCat.toSSet.obj X).δ i σ)
  conv_lhs => arg 2; ext i; rw [he i]
  change (∑ i : Fin 2, (-1 : ℤ) ^ i.val * 1) = 0
  decide

/-- The constant-one integral singular cocycle. -/
def singularCocycleOne (X : TopCat) : singularCocycles X 0 :=
  ⟨singularCochainOne X, singularCochainOne_coboundary X⟩

/-- The singular cocycle cup is associative in all degrees. -/
theorem singularCocycleCup_assoc {p q r a b n : ℕ}
    (φ : singularCocycles X p) (ψ : singularCocycles X q)
    (χ : singularCocycles X r)
    (hpq : p + q = a) (hqr : q + r = b) (har : a + r = n) :
    singularCocycleCup (singularCocycleCup φ ψ hpq) χ har =
      singularCocycleCup φ (singularCocycleCup ψ χ hqr) (by omega) := by
  apply Subtype.ext
  exact singularCochainCup_assoc φ.1 ψ.1 χ.1 hpq hqr har

@[simp]
theorem singularCocycleCup_one_left {p : ℕ} (φ : singularCocycles X p) :
    singularCocycleCup (singularCocycleOne X) φ (Nat.zero_add p) = φ := by
  apply Subtype.ext
  exact singularCochainCup_one_left φ.1

@[simp]
theorem singularCocycleCup_one_right {p : ℕ} (φ : singularCocycles X p) :
    singularCocycleCup φ (singularCocycleOne X) rfl = φ := by
  apply Subtype.ext
  exact singularCochainCup_one_right φ.1

end Mumford.Analytic
