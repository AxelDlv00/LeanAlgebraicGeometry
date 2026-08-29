/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.Theta

set_option autoImplicit false

namespace Mumford

universe u v w

namespace ThetaExtension

variable {G : Type u} {S : Type v} {K : Type w}
  [Group G] [CommGroup S] [AddCommGroup K] (E : ThetaExtension G S K)

/-- The theta commutator pairing is nondegenerate when its radical is trivial. -/
def IsNondegenerate : Prop := E.commutatorPairingRadical = ⊥

theorem isNondegenerate_iff_commutatorPairingBihom_injective :
    E.IsNondegenerate ↔ Function.Injective E.commutatorPairingBihom := by
  unfold IsNondegenerate
  constructor
  · intro h
    apply (AddMonoidHom.ker_eq_bot_iff E.commutatorPairingBihom).mp
    rw [E.commutatorPairingBihom_ker_eq_radical, h]
  · intro h
    rw [← E.commutatorPairingBihom_ker_eq_radical]
    exact (AddMonoidHom.ker_eq_bot_iff E.commutatorPairingBihom).mpr h

theorem commutatorPairingBihom_injective (hE : E.IsNondegenerate) :
    Function.Injective E.commutatorPairingBihom :=
  (E.isNondegenerate_iff_commutatorPairingBihom_injective).mp hE

theorem center_eq_includeScalar_range_of_isNondegenerate
    (hE : E.IsNondegenerate) :
    Subgroup.center G = E.includeScalar.range :=
  E.center_eq_includeScalar_range_of_commutatorPairingRadical_eq_bot hE

theorem isNondegenerate_iff_center_eq_includeScalar_range :
    E.IsNondegenerate ↔ Subgroup.center G = E.includeScalar.range := by
  constructor
  · intro hE
    exact E.center_eq_includeScalar_range_of_isNondegenerate hE
  · intro hcenter
    unfold IsNondegenerate
    apply (AddSubgroup.eq_bot_iff_forall E.commutatorPairingRadical).mpr
    intro k hk
    have hq : E.quotient (E.quotientLift k) = k := by
      unfold quotient
      rw [E.quotientHom_quotientLift]
      rfl
    have hcentral : E.quotientLift k ∈ Subgroup.center G := by
      apply (E.mem_center_iff_mem_commutatorPairingRadical _).mpr
      rw [hq]
      exact hk
    rw [hcenter] at hcentral
    obtain ⟨s, hs⟩ := hcentral
    have hqzero : E.quotient (E.quotientLift k) = 0 := by
      rw [← hs, E.quotient_includeScalar]
    exact hq.symm.trans hqzero

end ThetaExtension

end Mumford
