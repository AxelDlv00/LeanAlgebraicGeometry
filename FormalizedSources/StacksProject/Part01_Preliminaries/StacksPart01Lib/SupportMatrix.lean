/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.CommutativeAlgebra
import StacksPart01Lib.FiniteLocalizedQuotient
import Mathlib.RingTheory.Finiteness.Cardinality
import Mathlib.RingTheory.Support
import Mathlib.RingTheory.Spectrum.Prime.Topology

/-!
# Determinantal support obstructions

This file proves the finite-presentation support argument. Maximal column minors
annihilate a matrix cokernel, and a finite-localization argument identifies its
full support with the corresponding zero locus. An arbitrary finitely presented
module admits such a finite matrix presentation.
-/

namespace StacksPart01

set_option autoImplicit false

/-! ### Finiteness of the determinantal ideals -/

/-- The maximal row-minor ideal is finitely generated. -/
theorem minorIdeal_fg
    {R ι κ : Type*} [CommRing R] [Fintype ι] [Fintype κ]
    [DecidableEq ι] [DecidableEq κ] (A : Matrix ι κ R) :
    (minorIdeal A).FG := by
  unfold minorIdeal
  exact Submodule.fg_span (Set.finite_range _)

/-- The maximal column-minor ideal is finitely generated. -/
theorem columnMinorIdeal_fg
    {R ι κ : Type*} [CommRing R] [Fintype ι] [Fintype κ]
    [DecidableEq ι] [DecidableEq κ] (A : Matrix ι κ R) :
    (columnMinorIdeal A).FG := by
  unfold columnMinorIdeal
  exact minorIdeal_fg A.transpose

/-! ### The annihilator obstruction -/

/-- Every maximal column minor annihilates the cokernel of the associated
matrix map.  This is the determinantal inclusion used in the support argument
for a finite presentation. -/
theorem columnMinorIdeal_le_annihilator_matrixCoker
    {R ι κ : Type*} [CommRing R] [Fintype ι] [Fintype κ]
    [DecidableEq ι] [DecidableEq κ] (A : Matrix ι κ R) :
    columnMinorIdeal A ≤
      Module.annihilator R ((ι → R) ⧸ LinearMap.range A.mulVecLin) := by
  intro f hf
  rw [Module.mem_annihilator]
  intro q
  refine Submodule.Quotient.induction_on (LinearMap.range A.mulVecLin) q ?_
  intro y
  rw [← Submodule.Quotient.mk_smul]
  obtain ⟨B, hAB⟩ := matrix_right_inverse_of_mem_columnMinorIdeal A hf
  apply (Submodule.Quotient.mk_eq_zero _).mpr
  refine ⟨B.mulVec y, ?_⟩
  change A.mulVec (B.mulVec y) = f • y
  rw [Matrix.mulVec_mulVec, hAB, Matrix.smul_mulVec, Matrix.one_mulVec]

/-- If a scalar sends every target vector into the matrix range, it gives a
right inverse up to that scalar. -/
theorem matrix_right_inverse_of_smul_mem_range
    {R ι κ : Type*} [CommRing R] [Fintype κ]
    [DecidableEq ι]
    (A : Matrix ι κ R) {f : R}
    (hf : ∀ y : ι → R, f • y ∈ LinearMap.range A.mulVecLin) :
    ∃ B : Matrix κ ι R, A * B = f • (1 : Matrix ι ι R) := by
  classical
  choose x hx using fun j : ι => LinearMap.mem_range.mp (hf (Pi.single j 1))
  let B : Matrix κ ι R := Matrix.of fun k j => x j k
  refine ⟨B, ?_⟩
  ext i j
  have hj := congrFun (hx j) i
  simpa [B, Matrix.mul_apply, Matrix.mulVecLin_apply, Matrix.mulVec,
    dotProduct, Pi.smul_apply, Matrix.smul_apply, Matrix.one_apply,
    Pi.single_apply, eq_comm] using hj

/-- The support of the matrix cokernel is contained in the zero locus of its
maximal column-minor ideal. -/
theorem matrixCoker_support_subset_zeroLocus_columnMinorIdeal
    {R ι κ : Type*} [CommRing R] [Fintype ι] [Fintype κ]
    [DecidableEq ι] [DecidableEq κ] (A : Matrix ι κ R) :
    Module.support R ((ι → R) ⧸ LinearMap.range A.mulVecLin) ⊆
      PrimeSpectrum.zeroLocus (columnMinorIdeal A : Set R) := by
  rw [Module.support_eq_zeroLocus]
  intro p hp
  rw [PrimeSpectrum.mem_zeroLocus]
  intro f hf
  exact hp (columnMinorIdeal_le_annihilator_matrixCoker A hf)

/-- The support of a finite free matrix cokernel is exactly the zero locus of
the maximal column-minor ideal. -/
theorem matrixCoker_support_eq_zeroLocus_columnMinorIdeal
    {R ι κ : Type*} [CommRing R] [Fintype ι] [Fintype κ]
    [DecidableEq ι] [DecidableEq κ] (A : Matrix ι κ R) :
    Module.support R ((ι → R) ⧸ LinearMap.range A.mulVecLin) =
      PrimeSpectrum.zeroLocus (columnMinorIdeal A : Set R) := by
  apply Set.Subset.antisymm
  · exact matrixCoker_support_subset_zeroLocus_columnMinorIdeal A
  · intro p hp
    by_contra hnot
    have hsub : Subsingleton
        (LocalizedModule p.asIdeal.primeCompl
          ((ι → R) ⧸ LinearMap.range A.mulVecLin)) :=
      Module.notMem_support_iff.mp hnot
    obtain ⟨s, hsrange⟩ :=
      (finite_localizedQuotient_subsingleton_iff p.asIdeal.primeCompl
        (LinearMap.range A.mulVecLin)).mp hsub
    obtain ⟨B, hAB⟩ := matrix_right_inverse_of_smul_mem_range A hsrange
    have hpow := matrix_right_inverse_pow_mem_columnMinorIdeal A B hAB
    have hpows : (s : R) ^ Fintype.card ι ∈ p.asIdeal :=
      (PrimeSpectrum.mem_zeroLocus p (columnMinorIdeal A : Set R)).mp hp hpow
    exact (Ideal.mem_primeCompl_iff.mp s.property)
      (p.isPrime.mem_of_pow_mem _ hpows)

/-- The complement of the determinantal zero locus is quasi-compact. -/
theorem isCompact_compl_zeroLocus_columnMinorIdeal
    {R ι κ : Type*} [CommRing R] [Fintype ι] [Fintype κ]
    [DecidableEq ι] [DecidableEq κ] (A : Matrix ι κ R) :
    IsCompact (PrimeSpectrum.zeroLocus (columnMinorIdeal A : Set R))ᶜ := by
  exact (PrimeSpectrum.isRetrocompact_zeroLocus_compl_of_fg
    (columnMinorIdeal_fg A)).isCompact

/-! ### Finitely presented modules -/

/-- A finitely presented module is linearly equivalent to the cokernel of a
matrix between finite free modules. -/
theorem exists_matrixCoker_equiv_of_finitePresentation
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    [Module.FinitePresentation R M] :
    ∃ (n m : ℕ) (A : Matrix (Fin n) (Fin m) R),
      Nonempty (M ≃ₗ[R] ((Fin n → R) ⧸ LinearMap.range A.mulVecLin)) := by
  classical
  obtain ⟨n, K, e, hK⟩ := Module.FinitePresentation.exists_fin R M
  obtain ⟨m, f, hf⟩ :=
    (Submodule.fg_iff_exists_fin_linearMap R (Fin n → R)).mp hK
  let A : Matrix (Fin n) (Fin m) R := LinearMap.toMatrix' f
  have hAf : A.mulVecLin = f := by
    exact Matrix.toLin'_toMatrix' f
  rw [← hf, ← hAf] at e
  exact ⟨n, m, A, ⟨e⟩⟩

/-- The support of a finitely presented module is the zero locus of the maximal
column minors of a finite presentation matrix. -/
theorem exists_support_eq_zeroLocus_columnMinorIdeal_of_finitePresentation
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    [Module.FinitePresentation R M] :
    ∃ (n m : ℕ) (A : Matrix (Fin n) (Fin m) R),
      Module.support R M =
        PrimeSpectrum.zeroLocus (columnMinorIdeal A : Set R) := by
  obtain ⟨n, m, A, ⟨e⟩⟩ :=
    exists_matrixCoker_equiv_of_finitePresentation (R := R) (M := M)
  exact ⟨n, m, A,
    e.support_eq.trans (matrixCoker_support_eq_zeroLocus_columnMinorIdeal A)⟩

/-- **Stacks Project, Tag 051B**: the support of a finitely presented module is
closed, and its complement is quasi-compact. -/
@[stacks 051B]
theorem support_finitePresentation_isClosed_and_isCompact_compl
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    [Module.FinitePresentation R M] :
    IsClosed (Module.support R M) ∧ IsCompact (Module.support R M)ᶜ := by
  obtain ⟨n, m, A, hA⟩ :=
    exists_support_eq_zeroLocus_columnMinorIdeal_of_finitePresentation
      (R := R) (M := M)
  rw [hA]
  exact ⟨PrimeSpectrum.isClosed_zeroLocus _,
    isCompact_compl_zeroLocus_columnMinorIdeal A⟩

end StacksPart01
