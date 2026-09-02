/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.GroupTheory.Descent
import Mathlib.Tactic.Ring

/-!
# The formal Mordell--Weil descent criterion

A nonnegative bilinear height has an exact parallelogram law.  Combined with
finite multiplication quotients and finite height sublevel sets, Mathlib's
general descent theorem gives finite generation of the underlying group.
-/

set_option autoImplicit false

namespace Mumford

/-- Mumford's formal finite-generation criterion for an abelian group.

The finite-index hypothesis says that `Γ / n • Γ` is finite for every
`n > 1`.  The last hypothesis is the strict-sublevel form of the Northcott
property used in the source.  Symmetry of the pairing is unnecessary for this
conclusion: bilinearity alone gives the parallelogram identity for its diagonal.
-/
theorem finiteGeneration_of_finite_quotients_and_pairing
    {Γ : Type*} [AddCommGroup Γ]
    (pairing : Γ →+ Γ →+ ℝ)
    (hquotient : ∀ n : ℕ, 1 < n →
      (nsmulAddMonoidHom n : Γ →+ Γ).range.FiniteIndex)
    (hnonneg : ∀ x : Γ, 0 ≤ pairing x x)
    (hfinite : ∀ C : ℝ, 0 < C →
      {x : Γ | pairing x x < C}.Finite) :
    AddGroup.FG Γ := by
  let height : Γ → ℝ := fun x => pairing x x
  letI : Northcott height :=
    { finite_le := fun B => by
        by_cases hB : B < 0
        · have hempty : {x : Γ | height x ≤ B} = ∅ := by
            ext x
            simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false]
            exact not_le_of_gt (lt_of_lt_of_le hB (hnonneg x))
          rw [hempty]
          exact Set.finite_empty
        · have hpos : 0 < B + 1 := by linarith
          exact (hfinite (B + 1) hpos).subset fun _ hx =>
            lt_of_le_of_lt hx (lt_add_one B) }
  apply AddCommGroup.fg_of_descent' (h := height) (C := 0)
  · exact hquotient 2 (by norm_num)
  · exact hnonneg
  · intro x y
    have hparallelogram :
        height (x + y) + height (x - y) -
            2 * (height x + height y) = 0 := by
      simp only [height, map_add, map_sub, AddMonoidHom.add_apply,
        AddMonoidHom.sub_apply]
      ring
    simp [hparallelogram]

end Mumford
