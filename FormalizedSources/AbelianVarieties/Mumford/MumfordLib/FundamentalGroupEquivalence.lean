/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.FundamentalGroupLattice
import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup

/-!
# Fundamental group of a full-lattice quotient

Translation by a period commutes with lifting a based loop. Consequently the
endpoint of its lift identifies the fundamental group with the period lattice.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford
namespace Uniformization

open ComplexVectorLatticeExponentialData

variable {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
  [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
  (d : ComplexVectorLatticeExponentialData V X g)

/-- Changing the initial lift by a period translates the terminal lift by that period. -/
theorem quotient_monodromy_endpoint_translate
    (γ : Path.Homotopic.Quotient (0 : V ⧸ d.ambientPeriodLattice) 0)
    (e : (QuotientAddGroup.mk' d.ambientPeriodLattice) ⁻¹' {0}) :
    (d.quotient_mk_isCoveringMap.monodromy γ e).1 =
      e.1 + (d.quotient_mk_isCoveringMap.monodromy γ ⟨0, by simp⟩).1 := by
  induction γ using Path.Homotopic.Quotient.ind with
  | _ p =>
    let cov := d.quotient_mk_isCoveringMap
    let hstart : (p : C(unitInterval, V ⧸ d.ambientPeriodLattice)) 0 = 0 := by simp
    let Γ := cov.liftPath p 0 hstart
    let Γe : C(unitInterval, V) :=
      ⟨fun t => e.1 + Γ t, continuous_const.add Γ.continuous⟩
    have he : QuotientAddGroup.mk' d.ambientPeriodLattice e.1 = 0 := e.property
    have hproj : (QuotientAddGroup.mk' d.ambientPeriodLattice) ∘ Γe = p := by
      ext t
      change QuotientAddGroup.mk' d.ambientPeriodLattice (e.1 + Γ t) = p t
      rw [map_add, he, zero_add]
      exact congr_fun (cov.liftPath_lifts p 0 hstart) t
    have hΓe : Γe = cov.liftPath p e.1 (p.source.trans he.symm) := by
      apply (cov.eq_liftPath_iff' _).mpr
      refine ⟨hproj, ?_⟩
      change e.1 + Γ 0 = e.1
      rw [cov.liftPath_zero, add_zero]
    change cov.liftPath p e.1 (p.source.trans he.symm) 1 = e.1 + Γ 1
    rw [← hΓe]
    rfl

/-- Concatenation of based loops adds their lifted periods. -/
theorem quotient_monodromy_endpoint_trans
    (γ δ : Path.Homotopic.Quotient (0 : V ⧸ d.ambientPeriodLattice) 0) :
    (d.quotient_mk_isCoveringMap.monodromy (γ.trans δ) ⟨0, by simp⟩).1 =
      (d.quotient_mk_isCoveringMap.monodromy γ ⟨0, by simp⟩).1 +
        (d.quotient_mk_isCoveringMap.monodromy δ ⟨0, by simp⟩).1 := by
  rw [d.quotient_mk_isCoveringMap.monodromy_trans_apply]
  exact quotient_monodromy_endpoint_translate d δ _

/-- The lifted endpoint, as a homomorphism to the period lattice. -/
def quotientFundamentalGroupPeriodHom :
    FundamentalGroup (V ⧸ d.ambientPeriodLattice) 0 →*
      Multiplicative d.ambientPeriodLattice where
  toFun γ := Multiplicative.ofAdd
    ⟨(d.quotient_mk_isCoveringMap.monodromy γ.toPath ⟨0, by simp⟩).1,
      quotient_monodromy_endpoint_mem_ambientPeriodLattice d⟩
  map_one' := by
    apply congr_arg Multiplicative.ofAdd
    apply Subtype.ext
    change (d.quotient_mk_isCoveringMap.monodromy
      (Path.Homotopic.Quotient.refl 0) ⟨0, by simp⟩).1 = 0
    rw [d.quotient_mk_isCoveringMap.monodromy_refl]
    rfl
  map_mul' γ δ := by
    apply congr_arg Multiplicative.ofAdd
    apply Subtype.ext
    change (d.quotient_mk_isCoveringMap.monodromy
        (δ.toPath.trans γ.toPath) ⟨0, by simp⟩).1 = _
    rw [quotient_monodromy_endpoint_trans]
    exact add_comm _ _

theorem quotientFundamentalGroupPeriodHom_injective :
    Function.Injective (quotientFundamentalGroupPeriodHom d) := by
  apply (injective_iff_map_eq_one _).mpr
  intro γ hγ
  apply (quotient_monodromy_endpoint_eq_zero_iff d).mp
  exact congr_arg (fun u : Multiplicative d.ambientPeriodLattice => (u.toAdd : V)) hγ

theorem quotientFundamentalGroupPeriodHom_surjective :
    Function.Surjective (quotientFundamentalGroupPeriodHom d) := by
  intro u
  obtain ⟨γ, hγ⟩ := quotient_liftPath_endpoint_surjective d u.toAdd
  refine ⟨FundamentalGroup.fromPath γ, ?_⟩
  apply congr_arg Multiplicative.ofAdd
  exact Subtype.ext hγ

/-- The fundamental group of the quotient is its period lattice, via lifted endpoints. -/
def quotientFundamentalGroupPeriodEquiv :
    FundamentalGroup (V ⧸ d.ambientPeriodLattice) 0 ≃*
      Multiplicative d.ambientPeriodLattice :=
  MulEquiv.ofBijective (quotientFundamentalGroupPeriodHom d)
    ⟨quotientFundamentalGroupPeriodHom_injective d,
      quotientFundamentalGroupPeriodHom_surjective d⟩

@[simp]
theorem quotientFundamentalGroupPeriodEquiv_apply
    (γ : FundamentalGroup (V ⧸ d.ambientPeriodLattice) 0) :
    ((quotientFundamentalGroupPeriodEquiv d γ).toAdd : V) =
      (d.quotient_mk_isCoveringMap.monodromy γ.toPath ⟨0, by simp⟩).1 := rfl

/-- Additive form of the lifted-period identification. -/
def quotientFundamentalGroupPeriodAddEquiv :
    Additive (FundamentalGroup (V ⧸ d.ambientPeriodLattice) 0) ≃+
      d.ambientPeriodLattice :=
  (quotientFundamentalGroupPeriodEquiv d).toAdditive.trans
    (AddEquiv.additiveMultiplicative d.ambientPeriodLattice)

end Uniformization
end Mumford
