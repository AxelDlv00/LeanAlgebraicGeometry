/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.Analytic

/-!
# Uniformization interfaces

The analytic uniformization of a complex torus of dimension `g` has a real
`2 * g`-dimensional torus as its underlying additive group.  This file records
the algebraic consequences of a chosen additive equivalence to that model.
-/

namespace Mumford
namespace Uniformization

noncomputable section

/-- The real torus with `2 * g` circle factors. -/
abbrev GenusTorus (g : ℕ) := ProductTorus (Fin (2 * g))

/-- A chosen additive uniformization of a group by the real `2g`-torus model. -/
structure GenusTorusUniformization (X : Type*) [AddCommGroup X] (g : ℕ) where
  equiv : X ≃+ GenusTorus g

/-- The subgroup annihilated by a (possibly negative) integer scalar. -/
def zsmulTorsionSubgroup (X : Type*) [AddCommGroup X] (n : ℤ) : AddSubgroup X where
  carrier := {x : X | n • x = 0}
  zero_mem' := by simp
  add_mem' := by
    intro a b ha hb
    simp only [Set.mem_setOf_eq] at ha hb ⊢
    rw [zsmul_add, ha, hb, add_zero]
  neg_mem' := by
    intro a ha
    simp only [Set.mem_setOf_eq] at ha ⊢
    rw [zsmul_neg, ha, neg_zero]

/-- An additive equivalence transports the corresponding integer torsion subgroups. -/
def zsmulTorsion_addEquiv_of_addEquiv {X Y : Type*} [AddCommGroup X] [AddCommGroup Y]
    (e : X ≃+ Y) (n : ℤ) :
    zsmulTorsionSubgroup X n ≃+ zsmulTorsionSubgroup Y n := by
  have hpres (x : X) : n • x = 0 ↔ n • e x = 0 := by
    constructor
    · intro hx
      have h := congrArg e hx
      simpa only [map_zsmul, map_zero] using h
    · intro hx
      apply e.injective
      simpa only [map_zsmul, map_zero] using hx
  let q : zsmulTorsionSubgroup X n ≃ zsmulTorsionSubgroup Y n :=
    e.toEquiv.subtypeEquiv (fun x => by
      change n • (x : X) = 0 ↔ n • e (x : X) = 0
      exact hpres (x : X))
  exact
    { toFun := q
      invFun := q.symm
      left_inv := q.left_inv
      right_inv := q.right_inv
      map_add' := by
        intro a b
        apply Subtype.ext
        exact e.map_add (a : X) (b : X) }

/-- Nonzero integer division exists on the genus torus model. -/
theorem genusTorus_exists_division (g : ℕ) (x : GenusTorus g) {n : ℤ} (hn : n ≠ 0) :
    ∃ y : GenusTorus g, n • y = x := by
  exact ⟨DivisibleBy.div x n, DivisibleBy.div_cancel x hn⟩

/-- Integer torsion of the genus torus is a product of cyclic groups. -/
def genusTorus_zsmulTorsion_addEquiv (g : ℕ) {n : ℤ} (hn : n ≠ 0) :
    zsmulTorsionSubgroup (GenusTorus g) n ≃+ (Fin (2 * g) → ZMod n.natAbs) := by
  exact (zsmulTorsion_addEquiv_of_addEquiv (AddEquiv.refl _) n).trans
    (productTorus_zsmul_torsion_addEquiv_pi_zmod hn)

/-- The integer torsion of the genus torus has cardinality `|n| ^ (2 * g)`. -/
theorem genusTorus_zsmulTorsion_card (g : ℕ) {n : ℤ} (hn : n ≠ 0) :
    Nat.card (zsmulTorsionSubgroup (GenusTorus g) n) = n.natAbs ^ (2 * g) := by
  rw [Nat.card_congr (genusTorus_zsmulTorsion_addEquiv g hn).toEquiv]
  rw [Nat.card_fun, Nat.card_zmod, Nat.card_eq_fintype_card, Fintype.card_fin]

/-- The torsion classification transported across a chosen genus-torus uniformization. -/
def zsmulTorsion_addEquiv_of_uniformization {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : GenusTorusUniformization X g) {n : ℤ} (hn : n ≠ 0) :
    zsmulTorsionSubgroup X n ≃+ (Fin (2 * g) → ZMod n.natAbs) := by
  exact (zsmulTorsion_addEquiv_of_addEquiv u.equiv n).trans
    (productTorus_zsmul_torsion_addEquiv_pi_zmod hn)

/-- A chosen genus-torus uniformization gives divisibility by every nonzero integer. -/
theorem exists_division_of_uniformization {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : GenusTorusUniformization X g) (x : X) {n : ℤ} (hn : n ≠ 0) :
    ∃ y : X, n • y = x := by
  obtain ⟨y, hy⟩ := genusTorus_exists_division g (u.equiv x) hn
  refine ⟨u.equiv.symm y, ?_⟩
  apply u.equiv.injective
  simpa only [map_zsmul, u.equiv.apply_symm_apply] using hy

/-- The torsion cardinality transported across a chosen genus-torus uniformization. -/
theorem zsmulTorsion_card_of_uniformization {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : GenusTorusUniformization X g) {n : ℤ} (hn : n ≠ 0) :
    Nat.card (zsmulTorsionSubgroup X n) = n.natAbs ^ (2 * g) := by
  rw [Nat.card_congr (zsmulTorsion_addEquiv_of_uniformization u hn).toEquiv]
  rw [Nat.card_fun, Nat.card_zmod, Nat.card_eq_fintype_card, Fintype.card_fin]

/-- A chosen genus-torus uniformization makes every nonzero-integer torsion
subgroup finite. -/
theorem zsmulTorsion_finite_of_uniformization {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : GenusTorusUniformization X g) {n : ℤ} (hn : n ≠ 0) :
    Finite (zsmulTorsionSubgroup X n) := by
  letI : NeZero n.natAbs := ⟨Int.natAbs_pos.mpr hn |>.ne'⟩
  exact Finite.of_injective
    (zsmulTorsion_addEquiv_of_uniformization u hn).toEquiv
    (zsmulTorsion_addEquiv_of_uniformization u hn).injective

end
end Uniformization
end Mumford
