/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.Theta
import Mathlib.GroupTheory.Coset.Card
import Mathlib.SetTheory.Cardinal.NatCard

/-!
# Isotropic subgroups of theta extensions

The commutator orthogonal is the kernel of restriction to a subgroup's
character group. Maximal isotropic subgroups coincide with their orthogonal.
-/

set_option autoImplicit false

universe u v w

namespace Mumford
namespace ThetaExtension

variable {G : Type u} {S : Type v} {K : Type w}
  [Group G] [CommGroup S] [AddCommGroup K]

/-- Restrict the second variable of the commutator pairing to a subgroup. -/
noncomputable def commutatorPairingRestriction
    (E : ThetaExtension G S K) (H : AddSubgroup K) :
    K →+ (H →+ Additive S) :=
  (AddMonoidHom.compHom' H.subtype).comp E.commutatorPairingBihom

/-- The commutator orthogonal of a subgroup. -/
noncomputable def commutatorPairingOrthogonal
    (E : ThetaExtension G S K) (H : AddSubgroup K) : AddSubgroup K :=
  (E.commutatorPairingRestriction H).ker

@[simp]
theorem mem_commutatorPairingOrthogonal_iff
    (E : ThetaExtension G S K) (H : AddSubgroup K) (k : K) :
    k ∈ E.commutatorPairingOrthogonal H ↔
      ∀ h : H, E.commutatorPairing k h = 1 := by
  rw [commutatorPairingOrthogonal, AddMonoidHom.mem_ker]
  constructor
  · intro hk h
    have hh := DFunLike.congr_fun hk h
    change Additive.ofMul (E.commutatorPairing k h) = 0 at hh
    change E.commutatorPairing k h = 1 at hh
    exact hh
  · intro hk
    ext h
    change Additive.ofMul (E.commutatorPairing k h) = 0
    change E.commutatorPairing k h = 1
    exact hk h

/-- A subgroup is isotropic when its pairing restricts trivially. -/
def IsIsotropic (E : ThetaExtension G S K) (H : AddSubgroup K) : Prop :=
  H ≤ E.commutatorPairingOrthogonal H

theorem isIsotropic_iff
    (E : ThetaExtension G S K) (H : AddSubgroup K) :
    E.IsIsotropic H ↔
      ∀ ⦃k⦄, k ∈ H → ∀ ⦃l⦄, l ∈ H →
        E.commutatorPairing k l = 1 := by
  constructor
  · intro h k hk l hl
    exact (E.mem_commutatorPairingOrthogonal_iff H k).mp (h hk) ⟨l, hl⟩
  · intro h k hk
    rw [E.mem_commutatorPairingOrthogonal_iff]
    intro l
    exact h hk l.property

theorem commutatorPairing_zsmul_left
    (E : ThetaExtension G S K) (n : ℤ) (k l : K) :
    E.commutatorPairing (n • k) l = E.commutatorPairing k l ^ n := by
  have h := congrArg (fun f : K →+ Additive S => f l)
    (E.commutatorPairingBihom.map_zsmul n k)
  change Additive.ofMul (E.commutatorPairing (n • k) l) =
    n • Additive.ofMul (E.commutatorPairing k l) at h
  exact h

theorem commutatorPairing_zsmul_right
    (E : ThetaExtension G S K) (n : ℤ) (k l : K) :
    E.commutatorPairing k (n • l) = E.commutatorPairing k l ^ n := by
  have h := (E.commutatorPairingHom k).map_zsmul n l
  change Additive.ofMul (E.commutatorPairing k (n • l)) =
    n • Additive.ofMul (E.commutatorPairing k l) at h
  exact h

/-- An isotropic subgroup maximal under inclusion. -/
def IsMaximalIsotropic
    (E : ThetaExtension G S K) (H : AddSubgroup K) : Prop :=
  E.IsIsotropic H ∧
    ∀ J : AddSubgroup K, H ≤ J → E.IsIsotropic J → J ≤ H

/-- A maximal isotropic subgroup equals its commutator orthogonal. -/
theorem eq_commutatorPairingOrthogonal_of_isMaximalIsotropic
    (E : ThetaExtension G S K) (H : AddSubgroup K)
    (hmax : E.IsMaximalIsotropic H) :
    H = E.commutatorPairingOrthogonal H := by
  apply le_antisymm hmax.1
  intro k hk
  let J : AddSubgroup K := H ⊔ AddSubgroup.zmultiples k
  have hJ : E.IsIsotropic J := by
    rw [E.isIsotropic_iff]
    intro a ha b hb
    rcases AddSubgroup.mem_sup.mp ha with ⟨aH, haH, ak, hak, rfl⟩
    rcases AddSubgroup.mem_sup.mp hb with ⟨bH, hbH, bk, hbk, rfl⟩
    rcases AddSubgroup.mem_zmultiples_iff.mp hak with ⟨n, rfl⟩
    rcases AddSubgroup.mem_zmultiples_iff.mp hbk with ⟨m, rfl⟩
    have hHH : E.commutatorPairing aH bH = 1 :=
      (E.isIsotropic_iff H).mp hmax.1 haH hbH
    have hkH : E.commutatorPairing k bH = 1 :=
      (E.mem_commutatorPairingOrthogonal_iff H k).mp hk ⟨bH, hbH⟩
    have hHk : E.commutatorPairing aH k = 1 := by
      rw [← inv_eq_one, ← E.commutatorPairing_swap]
      exact (E.mem_commutatorPairingOrthogonal_iff H k).mp hk ⟨aH, haH⟩
    rw [E.commutatorPairing_add_left, E.commutatorPairing_add_right,
      E.commutatorPairing_add_right, E.commutatorPairing_zsmul_right,
      E.commutatorPairing_zsmul_left, E.commutatorPairing_zsmul_left,
      E.commutatorPairing_zsmul_right, hHH, hHk, hkH,
      E.commutatorPairing_self]
    simp
  apply hmax.2 J le_sup_left hJ
  exact (le_sup_right : AddSubgroup.zmultiples k ≤ J)
    (AddSubgroup.mem_zmultiples k)

/-- A maximal isotropic subgroup has square order when restriction of the
commutator pairing realizes all of its characters and finite character duality
preserves cardinality. -/
theorem natCard_eq_square_of_isMaximalIsotropic
    (E : ThetaExtension G S K) (H : AddSubgroup K)
    (hmax : E.IsMaximalIsotropic H)
    (hsurj : Function.Surjective (E.commutatorPairingRestriction H))
    (hdual : Nat.card (H →+ Additive S) = Nat.card H) :
    Nat.card K = Nat.card H ^ 2 := by
  have hker : (E.commutatorPairingRestriction H).ker = H := by
    change E.commutatorPairingOrthogonal H = H
    exact (E.eq_commutatorPairingOrthogonal_of_isMaximalIsotropic H hmax).symm
  let e : K ⧸ H ≃+ (H →+ Additive S) :=
    (QuotientAddGroup.quotientAddEquivOfEq hker.symm).trans
      (QuotientAddGroup.quotientKerEquivOfSurjective
        (E.commutatorPairingRestriction H) hsurj)
  calc
    Nat.card K = Nat.card (K ⧸ H) * Nat.card H :=
      AddSubgroup.card_eq_card_quotient_mul_card_addSubgroup H
    _ = Nat.card (H →+ Additive S) * Nat.card H := by
      rw [Nat.card_congr e.toEquiv]
    _ = Nat.card H ^ 2 := by rw [hdual, pow_two]

end ThetaExtension
end Mumford
