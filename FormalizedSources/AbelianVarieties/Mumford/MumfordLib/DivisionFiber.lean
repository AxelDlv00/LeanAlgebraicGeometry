/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.Uniformization
import MumfordLib.ComplexUniformization

/-!
# Fibres of multiplication by a nonzero integer

For a divisible additive group, every nonempty fibre of the map `[n]` is a
torsor under the subgroup killed by `n`.  This is the elementary group-theory
form of the finite-division-point statement used by the analytic theory.
-/

namespace Mumford
namespace Uniformization

noncomputable section

/-- The fibre of multiplication by `n` over `x`, as a subtype. -/
abbrev zsmulDivisionFiber (X : Type*) [AddCommGroup X] (n : ℤ) (x : X) :=
  {y : X // n • y = x}

/-- Translation by a chosen divided point identifies torsion with a division
fibre. -/
noncomputable def zsmulDivisionFiberEquiv
    {X : Type*} [AddCommGroup X] [DivisibleBy X ℤ]
    (n : ℤ) (x : X) (hn : n ≠ 0) :
    zsmulTorsionSubgroup X n ≃ zsmulDivisionFiber X n x := by
  let d : X := DivisibleBy.div x n
  let f : zsmulTorsionSubgroup X n → zsmulDivisionFiber X n x := fun t =>
    ⟨(t : X) + d, by
      rw [zsmul_add, t.property, zero_add, DivisibleBy.div_cancel x hn]⟩
  let g : zsmulDivisionFiber X n x → zsmulTorsionSubgroup X n := fun y =>
    ⟨(y : X) - d, by
      change n • ((y : X) - d) = 0
      rw [zsmul_sub, y.property, DivisibleBy.div_cancel x hn, sub_self]⟩
  exact
    { toFun := f
      invFun := g
      left_inv := by
        intro t
        apply Subtype.ext
        dsimp [f, g, d]
        exact add_sub_cancel_right (t : X) (DivisibleBy.div x n)
      right_inv := by
        intro y
        apply Subtype.ext
        dsimp [f, g, d]
        exact sub_add_cancel (y : X) (DivisibleBy.div x n) }

@[simp]
theorem zsmulDivisionFiberEquiv_apply
    {X : Type*} [AddCommGroup X] [DivisibleBy X ℤ]
    (n : ℤ) (x : X) (hn : n ≠ 0) (t : zsmulTorsionSubgroup X n) :
    ((zsmulDivisionFiberEquiv n x hn) t : X) =
      (t : X) + DivisibleBy.div x n := by
  rfl

@[simp]
theorem zsmulDivisionFiberEquiv_symm_apply
    {X : Type*} [AddCommGroup X] [DivisibleBy X ℤ]
    (n : ℤ) (x : X) (hn : n ≠ 0) (y : zsmulDivisionFiber X n x) :
    ((zsmulDivisionFiberEquiv n x hn).symm y : X) =
      (y : X) - DivisibleBy.div x n := by
  rfl

/-- All nonzero-integer division fibres have the cardinality of torsion. -/
theorem zsmulDivisionFiber_card
    {X : Type*} [AddCommGroup X] [DivisibleBy X ℤ]
    (n : ℤ) (x : X) (hn : n ≠ 0) :
    Nat.card (zsmulDivisionFiber X n x) =
      Nat.card (zsmulTorsionSubgroup X n) := by
  exact Nat.card_congr (zsmulDivisionFiberEquiv n x hn).symm

/-- Under a genus-torus uniformization, every nonzero-integer division fibre
has cardinality `|n|^(2g)`. -/
theorem zsmulDivisionFiber_card_of_uniformization
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : GenusTorusUniformization X g) (n : ℤ) (x : X) (hn : n ≠ 0) :
    Nat.card (zsmulDivisionFiber X n x) = n.natAbs ^ (2 * g) := by
  letI : DivisibleBy X ℤ := divisibleBy_of_uniformization u
  rw [zsmulDivisionFiber_card n x hn]
  exact zsmulTorsion_card_of_uniformization u hn

/-- The same division-fibre cardinality for a complex uniformization witness. -/
theorem zsmulDivisionFiber_card_of_complex_uniformization
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : ComplexTorusUniformization X g) (n : ℤ) (x : X) (hn : n ≠ 0) :
    Nat.card (zsmulDivisionFiber X n x) = n.natAbs ^ (2 * g) := by
  exact zsmulDivisionFiber_card_of_uniformization
    u.toGenusTorusUniformization n x hn

end
end Uniformization
end Mumford
