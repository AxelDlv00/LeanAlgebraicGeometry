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

/-- Repackage a real genus-torus uniformization as a complex period-quotient
uniformization. -/
def GenusTorusUniformization.toComplexTorusUniformization
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : GenusTorusUniformization X g) : ComplexTorusUniformization X g :=
  { equiv := u.equiv.trans (complexGenusQuotientAddEquiv g).symm }

@[simp]
theorem ComplexTorusUniformization.toGenusTorusUniformization_apply
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : ComplexTorusUniformization X g) (x : X) :
    u.toGenusTorusUniformization.equiv x =
      complexGenusQuotientAddEquiv g (u.equiv x) :=
  rfl

@[simp]
theorem GenusTorusUniformization.toComplexTorusUniformization_apply
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : GenusTorusUniformization X g) (x : X) :
    u.toComplexTorusUniformization.equiv x =
      (complexGenusQuotientAddEquiv g).symm (u.equiv x) :=
  rfl

theorem GenusTorusUniformization.toComplexTorusUniformization_toGenusTorusUniformization
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : GenusTorusUniformization X g) :
    u.toComplexTorusUniformization.toGenusTorusUniformization = u := by
  apply congrArg (fun e => GenusTorusUniformization.mk e)
  apply AddEquiv.ext
  intro x
  simp

theorem ComplexTorusUniformization.toGenusTorusUniformization_toComplexTorusUniformization
    {X : Type*} [AddCommGroup X] {g : ℕ}
    (u : ComplexTorusUniformization X g) :
    u.toGenusTorusUniformization.toComplexTorusUniformization = u := by
  apply congrArg (fun e => ComplexTorusUniformization.mk e)
  apply AddEquiv.ext
  intro x
  simp

/-- The complex and real witness interfaces carry exactly the same data. -/
def genusTorusUniformizationEquivComplexTorusUniformization
    {X : Type*} [AddCommGroup X] {g : ℕ} :
    GenusTorusUniformization X g ≃ ComplexTorusUniformization X g where
  toFun := GenusTorusUniformization.toComplexTorusUniformization
  invFun := ComplexTorusUniformization.toGenusTorusUniformization
  left_inv := GenusTorusUniformization.toComplexTorusUniformization_toGenusTorusUniformization
  right_inv := ComplexTorusUniformization.toGenusTorusUniformization_toComplexTorusUniformization

theorem complexTorusUniformization_nonempty_iff_genusTorusUniformization_nonempty
    {X : Type*} [AddCommGroup X] {g : ℕ} :
    Nonempty (ComplexTorusUniformization X g) ↔
      Nonempty (GenusTorusUniformization X g) := by
  constructor
  · rintro ⟨u⟩
    exact ⟨u.toGenusTorusUniformization⟩
  · rintro ⟨u⟩
    exact ⟨u.toComplexTorusUniformization⟩

/- The open quotient exponential identifies the real period quotient with the
   product torus also at the topological level. -/
noncomputable def genusRealVectorQuotientHomeomorph (g : ℕ) :
    (GenusRealVector g ⧸ integerPeriodLattice g) ≃ₜ GenusTorus g := by
  refine
    { toEquiv := (genusRealVectorQuotientAddEquiv g).toEquiv
      continuous_toFun := ?_
      continuous_invFun := ?_ }
  · rw [(QuotientAddGroup.isQuotientMap_mk
      (integerPeriodLattice g)).continuous_iff]
    change Continuous (fun v : GenusRealVector g =>
      genusRealVectorQuotientAddEquiv g
        (QuotientAddGroup.mk' (integerPeriodLattice g) v))
    simpa only [genusRealVectorQuotientAddEquiv_mk] using
      (genusTorusExponential_continuous g)
  · apply (genusTorusExponential_isOpenQuotientMap g).continuous_comp_iff.mp
    change Continuous (fun v : GenusRealVector g =>
      (genusRealVectorQuotientAddEquiv g).symm
        (genusTorusExponential g v))
    have hcomp :
        (fun v : GenusRealVector g =>
          (genusRealVectorQuotientAddEquiv g).symm
            (genusTorusExponential g v)) =
          (fun v : GenusRealVector g =>
            QuotientAddGroup.mk' (integerPeriodLattice g) v) := by
      funext v
      rw [← genusRealVectorQuotientAddEquiv_mk]
      exact (genusRealVectorQuotientAddEquiv g).symm_apply_apply _
    rw [hcomp]
    exact QuotientAddGroup.continuous_mk

@[simp]
theorem genusRealVectorQuotientHomeomorph_apply (g : ℕ)
    (q : GenusRealVector g ⧸ integerPeriodLattice g) :
    genusRealVectorQuotientHomeomorph g q = genusRealVectorQuotientAddEquiv g q :=
  rfl

/- The analytic witness can be upgraded to a homeomorphism once continuity of
   its chosen equivalence and inverse has been supplied.  Keeping these as
   explicit hypotheses records the genuine analytic boundary. -/
noncomputable def ComplexTorusUniformization.toHomeomorph
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (u : ComplexTorusUniformization X g)
    (hcont : Continuous u.equiv)
    (hcont_symm : Continuous u.equiv.symm) :
    X ≃ₜ (GenusComplexVector g ⧸ complexPeriodLattice g) :=
  { toEquiv := u.equiv.toEquiv
    continuous_toFun := hcont
    continuous_invFun := hcont_symm }

@[simp]
theorem ComplexTorusUniformization.toHomeomorph_apply
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (u : ComplexTorusUniformization X g)
    (hcont : Continuous u.equiv)
    (hcont_symm : Continuous u.equiv.symm) (x : X) :
    u.toHomeomorph hcont hcont_symm x = u.equiv x :=
  rfl

/- Combining the preceding maps gives a topological real-torus model for a
   topological complex uniformization witness. -/
noncomputable def ComplexTorusUniformization.toGenusTorusHomeomorph
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (u : ComplexTorusUniformization X g)
    (hcont : Continuous u.equiv)
    (hcont_symm : Continuous u.equiv.symm) : X ≃ₜ GenusTorus g :=
  (u.toHomeomorph hcont hcont_symm).trans
    ((complexQuotientToRealQuotientHomeomorph g).trans
      (genusRealVectorQuotientHomeomorph g))

@[simp]
theorem ComplexTorusUniformization.toGenusTorusHomeomorph_apply
    {X : Type*} [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (u : ComplexTorusUniformization X g)
    (hcont : Continuous u.equiv)
    (hcont_symm : Continuous u.equiv.symm) (x : X) :
    u.toGenusTorusHomeomorph hcont hcont_symm x =
      u.toGenusTorusUniformization.equiv x := by
  change genusRealVectorQuotientHomeomorph g
      (complexQuotientToRealQuotientHomeomorph g (u.equiv x)) =
    complexGenusQuotientAddEquiv g (u.equiv x)
  change genusRealVectorQuotientAddEquiv g
      (complexQuotientToRealQuotientAddEquiv g (u.equiv x)) =
    complexGenusQuotientAddEquiv g (u.equiv x)
  rw [← AddEquiv.trans_apply]
  rw [complexQuotientToRealQuotientAddEquiv_trans_genusRealVectorQuotient]


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

/- The positive-natural notation is obtained from the signed classification by
transporting the canonical equality `(n : ℤ).natAbs = n`. -/
noncomputable def complexUniformization_natCast_zsmulTorsion_addEquiv
    {X : Type*} [AddCommGroup X] {g n : ℕ}
    (u : ComplexTorusUniformization X g) (hn : 0 < n) :
    zsmulTorsionSubgroup X (n : ℤ) ≃+ (Fin (2 * g) → ZMod n) := by
  have hne : (n : ℤ) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt hn)
  let castEquiv : (Fin (2 * g) → ZMod (n : ℤ).natAbs) ≃+
      (Fin (2 * g) → ZMod n) :=
    AddEquiv.cast (M := fun m : ℕ => Fin (2 * g) → ZMod m)
      (Int.natAbs_ofNat' n)
  exact (complexUniformization_zsmulTorsion_addEquiv u hne).trans castEquiv

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
