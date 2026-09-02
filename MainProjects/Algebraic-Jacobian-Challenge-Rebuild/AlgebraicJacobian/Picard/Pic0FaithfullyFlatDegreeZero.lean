/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DegreeAtBaseField
import AlgebraicJacobian.Picard.Pic0VanishingAffineReduction
import Mathlib.RingTheory.Flat.FaithfullyFlat.Algebra

/-!
# Faithfully flat locality of the degree-zero condition

The degree-zero condition for an etale Picard class on an affine test is reflected by an
arbitrary faithfully flat extension of its coordinate ring.  A field-valued point of the
base and the faithfully flat extension have a common field-valued refinement: take a
residue field of their nonzero tensor product.  Degree zero over that common field then
descends along the field extension.

This is only the degree-condition half of fpqc descent.  It does not assert effectivity for
the underlying `picEt` class.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

/-- If a Picard class becomes degree zero after a faithfully flat extension of an affine
test ring, then it was already degree zero on the original test. -/
theorem mem_pic0Subgroup_of_faithfullyFlat
    {A A' : Type u} [CommRing A] [CommRing A'] [Algebra k A] [Algebra k A']
    (phi : A →ₐ[k] A') (hphi : phi.toRingHom.FaithfullyFlat)
    (lam : picEt C (overSpec k A))
    (h : picEtMap C (Over.overSpecMap phi) lam
      ∈ pic0Subgroup C (overSpec k A')) :
    lam ∈ pic0Subgroup C (overSpec k A) := by
  letI : Algebra A A' := phi.toRingHom.toAlgebra
  haveI : IsScalarTower k A A' :=
    IsScalarTower.of_algebraMap_eq fun a => (phi.commutes a).symm
  have halgebraMap : algebraMap A A' = phi.toRingHom := rfl
  haveI : Module.FaithfullyFlat A A' :=
    RingHom.faithfullyFlat_algebraMap_iff.mp (halgebraMap.symm ▸ hphi)
  rw [mem_pic0Subgroup_iff] at h ⊢
  intro K _ _ t
  obtain ⟨psi, rfl⟩ := exists_algHom_eq_of_overSpec_hom (k := k) A K t
  letI : Algebra A K := psi.toRingHom.toAlgebra
  haveI : IsScalarTower k A K :=
    IsScalarTower.of_algebraMap_eq fun a => (psi.commutes a).symm
  haveI : Nontrivial (K ⊗[A] A') :=
    (Module.FaithfullyFlat.nontrivial_tensorProduct_iff_left A K).mpr inferInstance
  let q : PrimeSpectrum (K ⊗[A] A') := Classical.choice inferInstance
  let L := q.asIdeal.ResidueField
  letI : Field L := inferInstance
  letI : Algebra k L :=
    ((algebraMap (K ⊗[A] A') L).comp (algebraMap k (K ⊗[A] A'))).toAlgebra
  haveI : IsScalarTower k (K ⊗[A] A') L :=
    IsScalarTower.of_algebraMap_eq fun _ => rfl
  let rho : (K ⊗[A] A') →ₐ[k] L :=
    (Algebra.ofId (K ⊗[A] A') L).restrictScalars k
  let kappa : K →ₐ[k] L :=
    rho.comp ((Algebra.TensorProduct.includeLeft : K →ₐ[A] K ⊗[A] A').restrictScalars k)
  let chi : A' →ₐ[k] L :=
    rho.comp ((Algebra.TensorProduct.includeRight : A' →ₐ[A] K ⊗[A] A').restrictScalars k)
  have hcomp : chi.comp phi = kappa.comp psi := by
    ext a
    change rho ((Algebra.TensorProduct.includeRight : A' →ₐ[A] K ⊗[A] A') (phi a)) =
      rho ((Algebra.TensorProduct.includeLeft : K →ₐ[A] K ⊗[A] A') (psi a))
    apply congrArg rho
    change 1 ⊗ₜ[A] algebraMap A A' a = algebraMap A K a ⊗ₜ[A] 1
    rw [← Algebra.TensorProduct.algebraMap_apply', Algebra.TensorProduct.algebraMap_apply]
  have hzero :
      degAt lam (Over.overSpecMap chi ≫ Over.overSpecMap phi) = 0 := by
    rw [← degAt_picEtMap]
    exact h L (Over.overSpecMap chi)
  have hpoint :
      Over.overSpecMap kappa ≫ Over.overSpecMap psi =
        Over.overSpecMap chi ≫ Over.overSpecMap phi := by
    rw [← Over.overSpecMap_comp, ← Over.overSpecMap_comp, hcomp]
  rw [← hpoint] at hzero
  exact (degAt_overSpecMap_eq_zero_iff lam kappa (Over.overSpecMap psi)).mp hzero

end

end AlgebraicGeometry
