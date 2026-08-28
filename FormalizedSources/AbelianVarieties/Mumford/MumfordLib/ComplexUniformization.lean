/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexModel

/-!
# Complex uniformization interface

The analytic uniformization theorem supplies an additive equivalence from a
complex vector-space quotient by a period lattice to the underlying complex
torus.  Mathlib does not currently provide the analytic Lie-group theorem, so
this module records that witness explicitly and exposes the algebraic
consequences that follow from it.
-/

namespace Mumford
namespace Uniformization

noncomputable section

/-- A chosen additive uniformization by a complex period-lattice quotient.

This is the algebraic interface to the analytic uniformization theorem; the
existence of such a witness is intentionally a hypothesis rather than an
unproved global declaration. -/
structure ComplexTorusUniformization (X : Type*) [AddCommGroup X] (g : ℕ) where
  equiv : X ≃+ (GenusComplexVector g ⧸ complexPeriodLattice g)

/-- Forget the complex coordinates and obtain the real genus-torus model. -/
def ComplexTorusUniformization.toGenusTorusUniformization
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : ComplexTorusUniformization X g) : GenusTorusUniformization X g :=
  { equiv := u.equiv.trans (complexGenusQuotientAddEquiv g) }

@[simp]
theorem ComplexTorusUniformization.toGenusTorusUniformization_apply
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : ComplexTorusUniformization X g) (x : X) :
    u.toGenusTorusUniformization.equiv x =
      complexGenusQuotientAddEquiv g (u.equiv x) :=
  rfl

/-- Division by every nonzero integer transported through complex
uniformization. -/
theorem complexUniformization_exists_division
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : ComplexTorusUniformization X g) (x : X) {n : ℤ} (hn : n ≠ 0) :
    ∃ y : X, n • y = x := by
  exact exists_division_of_uniformization
    u.toGenusTorusUniformization x hn

/-- Signed-integer torsion in a complex period-lattice quotient is the
expected product of cyclic groups. -/
def complexUniformization_zsmulTorsion_addEquiv
    {X : Type*} [AddCommGroup X] {g : ℕ} {n : ℤ}
  (u : ComplexTorusUniformization X g) (hn : n ≠ 0) :
    zsmulTorsionSubgroup X n ≃+
      (Fin (2 * g) → ZMod n.natAbs) :=
  (zsmulTorsion_addEquiv_of_addEquiv
      u.toGenusTorusUniformization.equiv n).trans
    (productTorus_zsmul_torsion_addEquiv_pi_zmod hn)

/- The complex torsion classification factors through the complex quotient
   equivalence before applying the coordinatewise cyclic classification. -/
theorem complexUniformization_zsmulTorsion_addEquiv_eq_trans
    {X : Type*} [AddCommGroup X] {g : ℕ} {n : ℤ}
    (u : ComplexTorusUniformization X g) (hn : n ≠ 0) :
    complexUniformization_zsmulTorsion_addEquiv u hn =
        (zsmulTorsion_addEquiv_of_addEquiv u.equiv n).trans
        (complexGenusQuotient_zsmulTorsion_addEquiv hn) := by
  simp only [complexUniformization_zsmulTorsion_addEquiv,
    ComplexTorusUniformization.toGenusTorusUniformization,
    complexGenusQuotient_zsmulTorsion_addEquiv]
  rw [zsmulTorsion_addEquiv_of_addEquiv_trans]
  apply AddEquiv.ext
  intro x
  rfl

/- The complex torsion classification can also be computed through the real
   period quotient. -/
theorem complexUniformization_zsmulTorsion_addEquiv_eq_real
    {X : Type*} [AddCommGroup X] {g : ℕ} {n : ℤ}
    (u : ComplexTorusUniformization X g) (hn : n ≠ 0) :
    complexUniformization_zsmulTorsion_addEquiv u hn =
      (zsmulTorsion_addEquiv_of_addEquiv u.equiv n).trans
        ((zsmulTorsion_addEquiv_of_addEquiv
          (complexQuotientToRealQuotientAddEquiv g) n).trans
          (genusRealVectorQuotient_zsmulTorsion_addEquiv hn)) := by
  rw [complexUniformization_zsmulTorsion_addEquiv_eq_trans u hn]
  have htor :
      zsmulTorsion_addEquiv_of_addEquiv (complexGenusQuotientAddEquiv g) n =
        (zsmulTorsion_addEquiv_of_addEquiv
          (complexQuotientToRealQuotientAddEquiv g) n).trans
          (zsmulTorsion_addEquiv_of_addEquiv
            (genusRealVectorQuotientAddEquiv g) n) := by
    rw [← complexQuotientToRealQuotientAddEquiv_trans_genusRealVectorQuotient]
    exact zsmulTorsion_addEquiv_of_addEquiv_trans _ _ n
  change
    (zsmulTorsion_addEquiv_of_addEquiv u.equiv n).trans
        ((zsmulTorsion_addEquiv_of_addEquiv
          (complexGenusQuotientAddEquiv g) n).trans
          (productTorus_zsmul_torsion_addEquiv_pi_zmod hn)) =
      (zsmulTorsion_addEquiv_of_addEquiv u.equiv n).trans
        ((zsmulTorsion_addEquiv_of_addEquiv
          (complexQuotientToRealQuotientAddEquiv g) n).trans
          ((zsmulTorsion_addEquiv_of_addEquiv
            (genusRealVectorQuotientAddEquiv g) n).trans
            (productTorus_zsmul_torsion_addEquiv_pi_zmod hn)))
  rw [htor]
  rfl

@[simp]
theorem complexUniformization_zsmulTorsion_addEquiv_apply
    {X : Type*} [AddCommGroup X] {g : ℕ} {n : ℤ}
    (u : ComplexTorusUniformization X g) (hn : n ≠ 0)
    (x : zsmulTorsionSubgroup X n) :
    ((complexUniformization_zsmulTorsion_addEquiv u hn) x : Fin (2 * g) → ZMod n.natAbs) =
      (productTorus_zsmul_torsion_addEquiv_pi_zmod hn)
        ((zsmulTorsion_addEquiv_of_addEquiv
          u.toGenusTorusUniformization.equiv n) x) := by
  rfl

/-- Cardinality of signed-integer torsion under a complex uniformization. -/
theorem complexUniformization_zsmulTorsion_card
    {X : Type*} [AddCommGroup X] {g : ℕ} {n : ℤ}
    (u : ComplexTorusUniformization X g) (hn : n ≠ 0) :
    Nat.card (zsmulTorsionSubgroup X n) = n.natAbs ^ (2 * g) := by
  exact zsmulTorsion_card_of_uniformization u.toGenusTorusUniformization hn

/-- Finiteness of every nonzero signed-integer torsion subgroup under a
complex uniformization. -/
theorem complexUniformization_zsmulTorsion_finite
    {X : Type*} [AddCommGroup X] {g : ℕ} {n : ℤ}
    (u : ComplexTorusUniformization X g) (hn : n ≠ 0) :
    Finite (zsmulTorsionSubgroup X n) := by
  exact zsmulTorsion_finite_of_uniformization u.toGenusTorusUniformization hn

/-- Positive-natural torsion cardinality in the complex model. -/
theorem complexUniformization_natCast_zsmulTorsion_card
    {X : Type*} [AddCommGroup X] {g n : ℕ}
    (u : ComplexTorusUniformization X g) (hn : 0 < n) :
    Nat.card (zsmulTorsionSubgroup X (n : ℤ)) = n ^ (2 * g) := by
  exact natCast_zsmulTorsion_card_of_uniformization
    u.toGenusTorusUniformization hn

end
end Uniformization
end Mumford
