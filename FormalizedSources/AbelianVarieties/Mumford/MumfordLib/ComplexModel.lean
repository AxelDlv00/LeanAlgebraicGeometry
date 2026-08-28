/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.Lattice
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Complex.Module
import Mathlib.LinearAlgebra.Pi
import Mathlib.Logic.Equiv.Fin.Basic
import Mathlib.Logic.Equiv.Prod

/-!
# The complex vector-space model

The analytic uniformization uses a complex vector space of dimension `g`,
while the underlying real torus has `2 * g` circle factors.  This file makes
that change of coordinates explicit and transports the period-lattice model
through it.
-/

namespace Mumford
namespace Uniformization

noncomputable section

/-- The complex vector group of dimension `g`. -/
abbrev GenusComplexVector (g : ℕ) := Fin g → ℂ

/-- Split a real pair into its two real coordinates. -/
def realPairToFinTwoLinearEquiv : (ℝ × ℝ) ≃ₗ[ℝ] (Fin 2 → ℝ) :=
  (LinearEquiv.finTwoArrow ℝ ℝ).symm

/-- Uncurry a two-level real coordinate family. -/
def uncurryGenusLinearEquiv (g : ℕ) :
    (Fin g → Fin 2 → ℝ) ≃ₗ[ℝ] (Fin g × Fin 2 → ℝ) :=
  { toEquiv := (Equiv.curry (Fin g) (Fin 2) ℝ).symm
    map_add' := by
      intro f h
      rfl
    map_smul' := by
      intro r f
      rfl }

/-- Reindex a pair of finite coordinates as a single `Fin (2 * g)` index. -/
def genusComplexIndexEquiv (g : ℕ) : Fin g × Fin 2 ≃ Fin (2 * g) :=
  (finProdFinEquiv (m := g) (n := 2)).trans
    (Equiv.cast (congrArg Fin (Nat.mul_comm g 2)))

/-- Reindex real coordinates along `genusComplexIndexEquiv`. -/
def reindexGenusRealLinearEquiv (g : ℕ) :
    (Fin g × Fin 2 → ℝ) ≃ₗ[ℝ] GenusRealVector g :=
  { toEquiv :=
      Equiv.piCongrLeft (fun _ : Fin (2 * g) => ℝ) (genusComplexIndexEquiv g)
    map_add' := by
      intro f h
      funext i
      dsimp [Equiv.piCongrLeft, Equiv.piCongrLeft']
      simp
    map_smul' := by
      intro r f
      funext i
      dsimp [Equiv.piCongrLeft, Equiv.piCongrLeft']
      simp }

/-- The canonical additive equivalence from complex `g`-coordinates to real
`2g`-coordinates. -/
def genusComplexVectorRealification (g : ℕ) :
    GenusComplexVector g ≃ₗ[ℝ] GenusRealVector g :=
  (LinearEquiv.piCongrRight (fun _ => Complex.equivRealProdLm)).trans
    ((LinearEquiv.piCongrRight (fun _ => realPairToFinTwoLinearEquiv)).trans
      ((uncurryGenusLinearEquiv g).trans (reindexGenusRealLinearEquiv g)))

/-- The complex-to-real coordinate change evaluated on a paired index. -/
@[simp]
theorem genusComplexVectorRealification_at_index (g : ℕ)
    (z : GenusComplexVector g) (i : Fin g) (j : Fin 2) :
    genusComplexVectorRealification g z (genusComplexIndexEquiv g (i, j)) =
      (realPairToFinTwoLinearEquiv (Complex.equivRealProdLm (z i))) j := by
  have hrr (f : Fin g × Fin 2 → ℝ) :
      reindexGenusRealLinearEquiv g f (genusComplexIndexEquiv g (i, j)) = f (i, j) := by
    change
      (Equiv.piCongrLeft (fun _ : Fin (2 * g) => ℝ)
        (genusComplexIndexEquiv g)) f (genusComplexIndexEquiv g (i, j)) = f (i, j)
    exact Equiv.piCongrLeft_apply_apply (fun _ : Fin (2 * g) => ℝ)
      (genusComplexIndexEquiv g) f (i, j)
  change reindexGenusRealLinearEquiv g
      ((uncurryGenusLinearEquiv g)
        ((LinearEquiv.piCongrRight (fun _ => realPairToFinTwoLinearEquiv))
          ((LinearEquiv.piCongrRight (fun _ => Complex.equivRealProdLm)) z)))
      (genusComplexIndexEquiv g (i, j)) = _
  rw [hrr]
  rfl

/-- The period lattice in complex coordinates, obtained by pulling back the
standard integer lattice along realification. -/
def complexPeriodLattice (g : ℕ) : AddSubgroup (GenusComplexVector g) :=
  AddSubgroup.comap (genusComplexVectorRealification g).toAddMonoidHom
    (integerPeriodLattice g)

/-- The coordinatewise exponential after changing complex coordinates to real
coordinates. -/
def complexGenusTorusExponential (g : ℕ) :
    GenusComplexVector g →+ GenusTorus g :=
  (genusTorusExponential g).comp
    (genusComplexVectorRealification g).toAddMonoidHom

/-- The realified exponential is surjective. -/
theorem complexGenusTorusExponential_surjective (g : ℕ) :
    Function.Surjective (complexGenusTorusExponential g) := by
  intro y
  obtain ⟨v, hv⟩ := genusTorusExponential_surjective g y
  obtain ⟨z, hz⟩ := (genusComplexVectorRealification g).surjective v
  refine ⟨z, ?_⟩
  change genusTorusExponential g (genusComplexVectorRealification g z) = y
  rw [hz, hv]

/-- The pulled-back integer lattice is exactly the kernel of the realified
exponential. -/
theorem complexGenusTorusExponential_ker (g : ℕ) :
    (complexGenusTorusExponential g).ker = complexPeriodLattice g := by
  ext z
  change genusTorusExponential g (genusComplexVectorRealification g z) = 0 ↔
    genusComplexVectorRealification g z ∈ integerPeriodLattice g
  rw [← AddMonoidHom.mem_ker, genusTorusExponential_ker]

/-- A complex-coordinate period-lattice quotient certificate. -/
def standardComplexGenusPeriodLatticeQuotient (g : ℕ) :
    PeriodLatticeQuotient (GenusComplexVector g) (GenusTorus g) where
  periodLattice := complexPeriodLattice g
  exponential := complexGenusTorusExponential g
  exponential_surjective := complexGenusTorusExponential_surjective g
  kernel_exponential := complexGenusTorusExponential_ker g

/-- The complex-coordinate quotient is equivalent to the standard genus torus. -/
def complexGenusQuotientAddEquiv (g : ℕ) :
    GenusComplexVector g ⧸ complexPeriodLattice g ≃+ GenusTorus g :=
  (standardComplexGenusPeriodLatticeQuotient g).quotientAddEquiv

@[simp]
theorem complexGenusQuotientAddEquiv_mk (g : ℕ) (z : GenusComplexVector g) :
    complexGenusQuotientAddEquiv g
        (QuotientAddGroup.mk' (complexPeriodLattice g) z) =
      complexGenusTorusExponential g z := by
  exact PeriodLatticeQuotient.quotientAddEquiv_mk
    (standardComplexGenusPeriodLatticeQuotient g) z

/- Two complex representatives define the same quotient point exactly when
   their difference is a complex period. -/
theorem complexGenusQuotientAddEquiv_mk_eq_iff (g : ℕ)
    (z w : GenusComplexVector g) :
    complexGenusQuotientAddEquiv g
        (QuotientAddGroup.mk' (complexPeriodLattice g) z) =
      complexGenusQuotientAddEquiv g
        (QuotientAddGroup.mk' (complexPeriodLattice g) w) ↔
      z - w ∈ complexPeriodLattice g := by
  exact PeriodLatticeQuotient.quotientAddEquiv_mk_eq_iff
    (standardComplexGenusPeriodLatticeQuotient g) z w

/- The realification carries the complex period quotient to the standard real
   period quotient. -/
def complexQuotientToRealQuotientAddHom (g : ℕ) :
    (GenusComplexVector g ⧸ complexPeriodLattice g) →+
      (GenusRealVector g ⧸ integerPeriodLattice g) :=
  QuotientAddGroup.map (complexPeriodLattice g) (integerPeriodLattice g)
    (genusComplexVectorRealification g).toAddMonoidHom (by
      intro z hz
      exact AddSubgroup.mem_comap.mp hz)

def realQuotientToComplexQuotientAddHom (g : ℕ) :
    (GenusRealVector g ⧸ integerPeriodLattice g) →+
      (GenusComplexVector g ⧸ complexPeriodLattice g) :=
  QuotientAddGroup.map (integerPeriodLattice g) (complexPeriodLattice g)
    (genusComplexVectorRealification g).symm.toAddMonoidHom (by
      intro v hv
      change genusComplexVectorRealification g
          ((genusComplexVectorRealification g).symm v) ∈ integerPeriodLattice g
      simpa only [LinearEquiv.apply_symm_apply] using hv)

theorem realQuotientToComplexQuotientAddHom_comp (g : ℕ) :
    (realQuotientToComplexQuotientAddHom g).comp
        (complexQuotientToRealQuotientAddHom g) = AddMonoidHom.id _ := by
  apply AddMonoidHom.ext
  intro q
  refine QuotientAddGroup.induction_on q ?_
  intro z
  simp [complexQuotientToRealQuotientAddHom,
    realQuotientToComplexQuotientAddHom]

theorem complexQuotientToRealQuotientAddHom_comp (g : ℕ) :
    (complexQuotientToRealQuotientAddHom g).comp
        (realQuotientToComplexQuotientAddHom g) = AddMonoidHom.id _ := by
  apply AddMonoidHom.ext
  intro q
  refine QuotientAddGroup.induction_on q ?_
  intro v
  simp [complexQuotientToRealQuotientAddHom,
    realQuotientToComplexQuotientAddHom]

/-- The additive equivalence between the complex and real period quotients. -/
def complexQuotientToRealQuotientAddEquiv (g : ℕ) :
    (GenusComplexVector g ⧸ complexPeriodLattice g) ≃+
      (GenusRealVector g ⧸ integerPeriodLattice g) :=
  AddMonoidHom.toAddEquiv (complexQuotientToRealQuotientAddHom g)
    (realQuotientToComplexQuotientAddHom g)
    (realQuotientToComplexQuotientAddHom_comp g)
    (complexQuotientToRealQuotientAddHom_comp g)

@[simp]
theorem complexQuotientToRealQuotientAddEquiv_mk (g : ℕ)
    (z : GenusComplexVector g) :
    complexQuotientToRealQuotientAddEquiv g
        (QuotientAddGroup.mk' (complexPeriodLattice g) z) =
      QuotientAddGroup.mk' (integerPeriodLattice g)
        (genusComplexVectorRealification g z) := by
  change complexQuotientToRealQuotientAddHom g
      (QuotientAddGroup.mk' (complexPeriodLattice g) z) = _
  simp [complexQuotientToRealQuotientAddHom]

/- The quotient equivalence intertwines the two exponential models. -/
theorem complexQuotientToRealQuotientAddEquiv_trans_genusRealVectorQuotient
    (g : ℕ) :
    (complexQuotientToRealQuotientAddEquiv g).trans
        (genusRealVectorQuotientAddEquiv g) =
      complexGenusQuotientAddEquiv g := by
  apply AddEquiv.ext
  intro q
  refine QuotientAddGroup.induction_on q ?_
  intro z
  change genusRealVectorQuotientAddEquiv g
      (complexQuotientToRealQuotientAddEquiv g
        (QuotientAddGroup.mk' (complexPeriodLattice g) z)) =
    complexGenusQuotientAddEquiv g
      (QuotientAddGroup.mk' (complexPeriodLattice g) z)
  rw [complexQuotientToRealQuotientAddEquiv_mk,
    genusRealVectorQuotientAddEquiv_mk,
    complexGenusQuotientAddEquiv_mk]
  rfl

/-- The complex-coordinate quotient has the expected signed-integer torsion
classification. -/
def complexGenusQuotient_zsmulTorsion_addEquiv {g : ℕ} {n : ℤ} (hn : n ≠ 0) :
    zsmulTorsionSubgroup
        (GenusComplexVector g ⧸ complexPeriodLattice g) n ≃+
      (Fin (2 * g) → ZMod n.natAbs) :=
  (zsmulTorsion_addEquiv_of_addEquiv (complexGenusQuotientAddEquiv g) n).trans
    (productTorus_zsmul_torsion_addEquiv_pi_zmod hn)

/-- The complex-coordinate quotient has torsion order `|n| ^ (2 * g)`. -/
theorem complexGenusQuotient_zsmulTorsion_card {g : ℕ} {n : ℤ} (hn : n ≠ 0) :
    Nat.card
        (zsmulTorsionSubgroup
          (GenusComplexVector g ⧸ complexPeriodLattice g) n) =
      n.natAbs ^ (2 * g) := by
  calc
    Nat.card
        (zsmulTorsionSubgroup
          (GenusComplexVector g ⧸ complexPeriodLattice g) n) =
        Nat.card (zsmulTorsionSubgroup (GenusTorus g) n) :=
      zsmulTorsion_card_eq_of_addEquiv (complexGenusQuotientAddEquiv g) n
    _ = n.natAbs ^ (2 * g) := genusTorus_zsmulTorsion_card g hn

end
end Uniformization
end Mumford
