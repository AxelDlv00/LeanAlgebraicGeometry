/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.RingTheory.Flat.FaithfullyFlat.Basic
import Mathlib.RingTheory.LocalRing.Module
import Mathlib.RingTheory.Spectrum.Prime.RingHom
import Mathlib.RingTheory.Support

/-!
# Support and base change

This file proves that the support of a finite module commutes with arbitrary
base change, following Stacks Project Tag 0BUR.
-/

set_option autoImplicit false

open TensorProduct

namespace StacksPart01

universe u v w

variable {A : Type u} {B : Type v} [CommRing A] [CommRing B] [Algebra A B]

/-- **Stacks Project, Tag 0BUR** (pointwise form): a prime of `B` belongs to the
support of the base-changed finite module exactly when its contraction belongs
to the support of the original module. -/
theorem support_baseChange_finite (M : Type w) [AddCommGroup M] [Module A M]
    [Module.Finite A M] (q : PrimeSpectrum B) :
    q ∈ Module.support B (B ⊗[A] M) ↔
      PrimeSpectrum.comap (algebraMap A B) q ∈ Module.support A M := by
  set p := PrimeSpectrum.comap (algebraMap A B) q with hp
  rw [Module.mem_support_iff_nontrivial_residueField_tensorProduct,
    Module.mem_support_iff_nontrivial_residueField_tensorProduct]
  have hcom : p.asIdeal = q.asIdeal.comap (algebraMap A B) := rfl
  letI phi : p.asIdeal.ResidueField →+* q.asIdeal.ResidueField :=
    Ideal.ResidueField.map p.asIdeal q.asIdeal (algebraMap A B) hcom
  letI algPhi : Algebra p.asIdeal.ResidueField q.asIdeal.ResidueField := phi.toAlgebra
  haveI tower : IsScalarTower A p.asIdeal.ResidueField q.asIdeal.ResidueField := by
    apply IsScalarTower.of_algebraMap_eq
    intro a
    change (algebraMap A q.asIdeal.ResidueField) a = phi _
    rw [Ideal.ResidueField.map_algebraMap,
      IsScalarTower.algebraMap_apply A B q.asIdeal.ResidueField]
  have cancelB : Nontrivial (q.asIdeal.ResidueField ⊗[B] (B ⊗[A] M)) ↔
      Nontrivial (q.asIdeal.ResidueField ⊗[A] M) :=
    (AlgebraTensorModule.cancelBaseChange A B q.asIdeal.ResidueField
      q.asIdeal.ResidueField M).toEquiv.nontrivial_congr
  have factorResidue : Nontrivial (q.asIdeal.ResidueField ⊗[A] M) ↔
      Nontrivial (q.asIdeal.ResidueField ⊗[p.asIdeal.ResidueField]
        (p.asIdeal.ResidueField ⊗[A] M)) :=
    ((AlgebraTensorModule.cancelBaseChange A p.asIdeal.ResidueField
      q.asIdeal.ResidueField q.asIdeal.ResidueField M).toEquiv.nontrivial_congr).symm
  have faithful : Nontrivial (q.asIdeal.ResidueField ⊗[p.asIdeal.ResidueField]
        (p.asIdeal.ResidueField ⊗[A] M)) ↔
      Nontrivial (p.asIdeal.ResidueField ⊗[A] M) :=
    Module.FaithfullyFlat.nontrivial_tensorProduct_iff_right
      p.asIdeal.ResidueField q.asIdeal.ResidueField
  rw [cancelB, factorResidue, faithful]

/-- **Stacks Project, Tag 0BUR**: the support of `B ⊗[A] M` is the inverse
image of the support of `M` under contraction of prime ideals. -/
theorem support_baseChange_finite_eq (M : Type w) [AddCommGroup M] [Module A M]
    [Module.Finite A M] :
    Module.support B (B ⊗[A] M) =
      PrimeSpectrum.comap (algebraMap A B) ⁻¹' Module.support A M := by
  ext q
  simpa using support_baseChange_finite M q

/-- Empty support is preserved by arbitrary base change of a finite module. -/
theorem support_baseChange_finite_eq_empty_of_isEmpty
    (M : Type w) [AddCommGroup M] [Module A M] [Module.Finite A M]
    (h : Module.support A M = ∅) :
    Module.support B (B ⊗[A] M) = ∅ := by
  rw [support_baseChange_finite_eq, h, Set.preimage_empty]

end StacksPart01
