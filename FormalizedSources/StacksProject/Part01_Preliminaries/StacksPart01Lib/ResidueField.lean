/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.RingTheory.LocalRing.ResidueField.Instances
import Mathlib.RingTheory.Localization.Integral
import Mathlib.RingTheory.Ideal.Over
import Mathlib.RingTheory.IntegralClosure.IsIntegralClosure.Basic
import StacksPart01Lib.GoingUp

/-!
# Residue fields and maximal ideals

The finite-residue-extension criterion for a prime ideal to be maximal is the
algebraic core of Stacks Project Tag `00GA`.
-/

namespace StacksPart01

/-- A prime ideal whose residue field is algebraic over the residue field of a
maximal ideal below it is maximal (Stacks, Tag `00GA`). -/
theorem finite_residue_extension_closed
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    (m : Ideal R) [m.IsMaximal] (q : Ideal S) [q.IsPrime]
    (hq : m = q.comap (algebraMap R S))
    (hAlg : @Algebra.IsAlgebraic m.ResidueField q.ResidueField _ _
      (Ideal.ResidueField.map m q (algebraMap R S) hq).toAlgebra) : q.IsMaximal := by
  let f : R →+* (S ⧸ q) := (Ideal.Quotient.mk q).comp (algebraMap R S)
  have hf₁ : m ≤ RingHom.ker f := by
    intro r hr
    change (Ideal.Quotient.mk q) (algebraMap R S r) = 0
    rw [Ideal.Quotient.eq_zero_iff_mem]
    change r ∈ q.comap (algebraMap R S)
    exact hq ▸ hr
  have hf₂ : m.primeCompl ≤ (IsUnit.submonoid (S ⧸ q)).comap f := by
    intro r hr
    change r ∉ m at hr
    letI : Field (R ⧸ m) := Ideal.Quotient.field m
    letI : Algebra (R ⧸ m) (S ⧸ q) :=
      Ideal.Quotient.algebraQuotientOfLEComap (le_of_eq hq)
    have hu : IsUnit (Ideal.Quotient.mk m r) := by
      apply isUnit_iff_ne_zero.mpr
      exact (Ideal.Quotient.eq_zero_iff_mem.not).mpr hr
    have hu' := hu.map (algebraMap (R ⧸ m) (S ⧸ q))
    change IsUnit ((Ideal.Quotient.mk q) (algebraMap R S r))
    exact hu'
  let liftf : m.ResidueField →+* (S ⧸ q) := Ideal.ResidueField.lift m f hf₁ hf₂
  letI : Algebra m.ResidueField (S ⧸ q) := liftf.toAlgebra
  let mapf : m.ResidueField →+* q.ResidueField :=
    Ideal.ResidueField.map m q (algebraMap R S) hq
  letI : Algebra m.ResidueField q.ResidueField := mapf.toAlgebra
  have hAlg' : Algebra.IsAlgebraic m.ResidueField q.ResidueField := by
    simpa [mapf] using hAlg
  have hcomp : (algebraMap (S ⧸ q) q.ResidueField).comp liftf = mapf := by
    apply Ideal.ResidueField.ringHom_ext
    ext r
    simp only [liftf, mapf, f, RingHom.coe_comp, Function.comp_apply,
      Ideal.ResidueField.lift_algebraMap, Ideal.ResidueField.map_algebraMap,
      Ideal.algebraMap_quotient_residueField_mk]
  letI : IsScalarTower m.ResidueField (S ⧸ q) q.ResidueField :=
    IsScalarTower.of_algebraMap_eq' hcomp.symm
  have h_alg : Algebra.IsAlgebraic m.ResidueField (S ⧸ q) :=
    (IsFractionRing.isAlgebraic_iff' m.ResidueField (S ⧸ q) q.ResidueField).2 hAlg'
  letI : Algebra.IsAlgebraic m.ResidueField (S ⧸ q) := h_alg
  letI : Algebra.IsIntegral m.ResidueField (S ⧸ q) := Algebra.IsAlgebraic.isIntegral
  letI : Field m.ResidueField := IsLocalRing.ResidueField.field _
  apply (Ideal.Quotient.maximal_ideal_iff_isField_quotient q).mpr
  exact isField_of_isIntegral_of_isField' (R := m.ResidueField) (S := S ⧸ q)
    (Field.toIsField m.ResidueField)

end StacksPart01
