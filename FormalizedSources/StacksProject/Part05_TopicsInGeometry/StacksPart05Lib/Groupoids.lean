/-
Copyright (c) 2026 The StacksPart05Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart05Lib Contributors
-/

/-!
# StacksPart05Lib.Groupoids

The invariant-map factorization property for a quotient, in the elementary
set-theoretic form underlying Stacks, Tag 048F.
-/

namespace StacksPart05Lib

/-- A map is invariant for a setoid when it is constant on related points. -/
def Invariant {U X : Type _} (r : Setoid U) (φ : U → X) : Prop :=
  ∀ ⦃a b : U⦄, r.r a b → φ a = φ b

/-- An invariant map factors through the quotient by the relation. -/
theorem invariant_iff_factors_through_quotient {U X : Type _} (r : Setoid U)
    (φ : U → X) :
    Invariant r φ ↔ ∃ ψ : Quotient r → X, ψ ∘ Quotient.mk r = φ := by
  constructor
  · intro h
    refine ⟨Quotient.lift φ (fun a b hab => h hab), ?_⟩
    funext a
    rfl
  · rintro ⟨ψ, hψ⟩ a b hab
    rw [← hψ]
    exact congrArg ψ (Quotient.sound hab)

end StacksPart05Lib
