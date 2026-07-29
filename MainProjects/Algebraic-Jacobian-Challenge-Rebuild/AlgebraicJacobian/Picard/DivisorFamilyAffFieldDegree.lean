/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffAbel
import AlgebraicJacobian.Picard.DivisorFamilyFieldDegree

/-!
# The degree ledger on the WIDENED adaptation: the algebraic half of the port

`Picard/DivisorFamilyAffAbel.lean` leaves exactly one obligation, `hdegAff` — the widened Abel
value of a degree-`n` widened class has degree `n` at every field point — and names its price:
port four lemmas of `Picard/DivisorFamilyFieldDegree.lean` from `DivisorAdaptation` to
`AffAdaptation`.  That price was itself a correction: an earlier version of the row called the
port *obstructed* by the pinned-pair covering, which is false (the step in question outputs only
"every point lies in some piece", a structure **field** of `AffCoverData`).

This file executes the part of the port that is pure module algebra over the field, and it is
deliberately a verbatim transcription: same statements, same proofs, `AffAdaptation` in place of
`DivisorAdaptation`.  Nothing here is new mathematics — the point is that nothing *had* to be,
which is what the reprice predicted and what a transcription either confirms or refutes.

## Why these two and not all four

`finrank_glued_eq_sum_of_separated` and its input `gluedSubmodule_eq_top_of_separated` are the
two steps that mention **no** geometry at all: they quantify over `A.index`, `A.colength`,
`A.ovlColength`, `A.chartProd`, `A.Glued` and the two overlap-restriction maps, every one of
which `AffAdaptation` carries under the same name.  The remaining two
(`finrank_colength_eq_sum`, `coeffAt_eq_zero_of_isUnit_germ`) are about the *presentation
divisor* and need the geometric side of the transcription; they are not attempted here, and
`hdegAff` therefore remains open.  Read this as one third of a named residue discharged, not as
the ledger.

## Main declarations

* `AlgebraicGeometry.AffAdaptation.toOvlLeft_self_eq_toOvlRight_self` — the diagonal collapse.
* `AlgebraicGeometry.AffAdaptation.gluedSubmodule_eq_top_of_separated` — separation makes the
  equalizer the whole product.
* `AlgebraicGeometry.AffAdaptation.gluedTopEquiv` — that identification as a `LinearEquiv`.
* `AlgebraicGeometry.AffAdaptation.finrank_glued_eq_sum_of_separated` — Mayer–Vietoris finrank
  additivity with no overlap correction, on the widened adaptation over a field.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161); pin in-file. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Module

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {K : Type u} [Field K] [Algebra k K]

namespace AffAdaptation

variable {D : AffCoverData C K} {d : (relCurve C K).LocalEquations} (A : AffAdaptation D d)

/-- On the diagonal the two overlap-restriction maps coincide: the two `≤`-witnesses
`pieces i ⊓ pieces i ≤ pieces i` are definitionally equal by proof irrelevance. -/
lemma toOvlLeft_self_eq_toOvlRight_self (i : D.index) :
    A.toOvlLeft i i = A.toOvlRight i i :=
  rfl

/-- **Support separation collapses the equalizer to the whole product**, widened.  If the
overlap colength modules vanish off the diagonal then every element of `∏ⱼ colength j` satisfies
the equalizer condition. -/
lemma gluedSubmodule_eq_top_of_separated
    (hsep : ∀ i j : D.index, i ≠ j → Subsingleton (A.ovlColength i j)) :
    A.gluedSubmodule = ⊤ := by
  refine eq_top_iff.mpr fun s _ => ?_
  rw [mem_gluedSubmodule_iff]
  rintro ⟨i, j⟩
  by_cases hij : i = j
  · subst hij
    exact congrFun (congrArg (fun f : A.colength i →ₐ[K] A.ovlColength i i => (f : _ → _))
      (A.toOvlLeft_self_eq_toOvlRight_self i)) (s i)
  · haveI := hsep i j hij
    exact Subsingleton.elim _ _

/-- The equalizer as the whole product, when the glued submodule is `⊤`. -/
noncomputable def gluedTopEquiv (h : A.gluedSubmodule = ⊤) : A.Glued ≃ₗ[K] A.chartProd :=
  (LinearEquiv.ofEq _ _ h).trans Submodule.topEquiv

/-- **The support-separated colength↔degree bridge, algebraic half — on the WIDENED
adaptation.**  When the overlaps vanish, the `K`-dimension of the glued equalizer is the sum of
the piece-local colength dimensions.

Pure module algebra over the field: every colength is free, and the equalizer is the whole
product.  Not one step of the chart-typed proof
(`DivisorAdaptation.finrank_glued_eq_sum_of_separated`) had to change, which is the substantive
content — it confirms, rather than assumes, that this half of the degree ledger owes the
widening nothing. -/
theorem finrank_glued_eq_sum_of_separated
    (hfin : ∀ j : D.index, Module.Finite K (A.colength j))
    (hsep : ∀ i j : D.index, i ≠ j → Subsingleton (A.ovlColength i j)) :
    finrank K A.Glued = ∑ j : D.index, finrank K (A.colength j) := by
  haveI : ∀ j : D.index, Module.Free K (A.colength j) := fun j => Module.Free.of_divisionRing _ _
  haveI := hfin
  rw [LinearEquiv.finrank_eq (A.gluedTopEquiv (A.gluedSubmodule_eq_top_of_separated hsep))]
  exact Module.finrank_pi_fintype K

/-! ## The geometric half: the presentation divisor read off an arbitrary affine piece -/

section Geometric

variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]

/-- **The divisor coefficient is read off any piece**, widened. -/
lemma coeffAt_eq_toAdd_ordZ_eqn (j : D.index) {z : relCurve C K}
    (hz : z ∈ D.pieces j) (hzg : z ≠ genericPoint (relCurve C K))
    (gⱼ : (relCurve C K).functionFieldˣ)
    (hgⱼ : (gⱼ : (relCurve C K).functionField)
      = ((relCurve C K).presheaf.germ (D.pieces j) (genericPoint (relCurve C K))
          (Scheme.genericPoint_mem_of_nonempty ⟨z, hz⟩)).hom (A.eqn j)) :
    Multiplicative.toAdd (Scheme.ordZ (relCurve C K ↘ Spec (CommRingCat.of K)) hzg gⱼ)
      = coeffAt hzg (Scheme.presentationDivisor K d.presentation) := by
  have hηj : genericPoint (relCurve C K) ∈ D.pieces j :=
    Scheme.genericPoint_mem_of_nonempty ⟨z, hz⟩
  obtain ⟨u, hu⟩ := A.eqn_rel j z
  have hηW : genericPoint (relCurve C K) ∈ D.pieces j ⊓ d.cover.opens z :=
    ⟨hηj, d.cover.genericPoint_mem_opens z⟩
  have hzW : z ∈ D.pieces j ⊓ d.cover.opens z := ⟨hz, d.cover.mem_opens z⟩
  have hval : (gⱼ : (relCurve C K).functionField)
      = (Scheme.germGenericUnits hηW u : (relCurve C K).functionField)
        * (d.presentation.elem z : (relCurve C K).functionField) := by
    have h := congrArg ((relCurve C K).presheaf.germ
      (D.pieces j ⊓ d.cover.opens z) (genericPoint (relCurve C K)) hηW).hom hu
    rw [map_mul, TopCat.Presheaf.germ_res_apply, TopCat.Presheaf.germ_res_apply] at h
    rw [hgⱼ, Scheme.germGenericUnits_val, Scheme.LocalEquations.presentation_elem_val]
    exact h
  have hunit : gⱼ = Scheme.germGenericUnits hηW u * d.presentation.elem z :=
    Units.ext hval
  rw [Scheme.coeffAt_presentationDivisor, hunit, map_mul,
    Scheme.ordZ_germGenericUnits K hηW u hzg hzW, one_mul]

open scoped Classical in
/-- **The per-piece degree reading**, widened. -/
lemma finrank_colength_eq_sum (j : D.index) :
    (finrank K (A.colength j) : ℤ)
      = ∑ p ∈ (Scheme.presentationDivisor K d.presentation).support.filter
          (fun p => p.1 ∈ D.pieces j),
        coeffAt p.2 (Scheme.presentationDivisor K d.presentation)
          * ((relCurve C K).residueDeg K p.1 : ℤ) := by
  classical
  haveI : LocallyOfFiniteType (relCurve C K ↘ Spec (CommRingCat.of K)) :=
    haveI : Smooth (relCurve C K ↘ Spec (CommRingCat.of K)) :=
      SmoothOfRelativeDimension.smooth 1 _
    inferInstance
  by_cases hη : genericPoint (relCurve C K) ∈ D.pieces j
  · have hne : ((relCurve C K).presheaf.germ (D.pieces j) (genericPoint (relCurve C K)) hη).hom
        (A.eqn j) ≠ 0 :=
      mem_nonZeroDivisors_iff_ne_zero.mp (A.eqn_regular j (genericPoint (relCurve C K)) hη)
    set gⱼ : (relCurve C K).functionFieldˣ := Units.mk0 _ hne with hgⱼdef
    have hg : (gⱼ : (relCurve C K).functionField)
        = ((relCurve C K).presheaf.germ (D.pieces j) (genericPoint (relCurve C K)) hη).hom
            (A.eqn j) := rfl
    have hout : ∀ (z : relCurve C K) (hz : z ∈ D.pieces j)
        (hzg : z ≠ genericPoint (relCurve C K)),
        (⟨z, hzg⟩ : {x : relCurve C K // x ≠ genericPoint (relCurve C K)})
          ∉ (Scheme.presentationDivisor K d.presentation).support.filter
            (fun p => p.1 ∈ D.pieces j) →
        IsUnit (((relCurve C K).presheaf.germ (D.pieces j) z hz).hom (A.eqn j)) := by
      intro z hz hzg hznot
      have hzsupp : (⟨z, hzg⟩ : {x : relCurve C K // x ≠ genericPoint (relCurve C K)})
          ∉ (Scheme.presentationDivisor K d.presentation).support :=
        fun hin => hznot (Finset.mem_filter.mpr ⟨hin, hz⟩)
      have hcoeff : coeffAt hzg (Scheme.presentationDivisor K d.presentation) = 0 := by
        by_contra hc
        exact hzsupp (Finsupp.mem_support_iff.mpr hc)
      have h1 := A.coeffAt_eq_toAdd_ordZ_eqn j hz hzg gⱼ hg
      rw [hcoeff] at h1
      have hord : Scheme.ordZ (relCurve C K ↘ Spec (CommRingCat.of K)) hzg gⱼ = 1 :=
        Multiplicative.toAdd.injective (by rw [h1]; exact toAdd_one.symm)
      exact (Scheme.isUnit_germ_iff_ordZ_eq_one K hη (A.eqn j) gⱼ hg hz hzg).mpr hord
    calc (finrank K (A.colength j) : ℤ)
        = ∑ p ∈ (Scheme.presentationDivisor K d.presentation).support.filter
            (fun p => p.1 ∈ D.pieces j),
            Multiplicative.toAdd (Scheme.ordZ (relCurve C K ↘ Spec (CommRingCat.of K)) p.2 gⱼ)
              * ((relCurve C K).residueDeg K p.1 : ℤ) :=
          finrank_quotient_span_section K (D.isAffineOpen_pieces j) hη gⱼ hg _
            (fun p hp => (Finset.mem_filter.mp hp).2) hout
      _ = ∑ p ∈ (Scheme.presentationDivisor K d.presentation).support.filter
            (fun p => p.1 ∈ D.pieces j),
            coeffAt p.2 (Scheme.presentationDivisor K d.presentation)
              * ((relCurve C K).residueDeg K p.1 : ℤ) :=
          Finset.sum_congr rfl fun p hp => by
            rw [A.coeffAt_eq_toAdd_ordZ_eqn j (Finset.mem_filter.mp hp).2 p.2 gⱼ hg]
  · have hbot : D.pieces j ≤ ⊥ :=
      fun x hx => hη (Scheme.genericPoint_mem_of_nonempty ⟨x, hx⟩)
    haveI : Subsingleton Γ(relCurve C K, D.pieces j) :=
      (relCurve C K).subsingleton_sections_of_le_bot hbot
    haveI : Subsingleton (A.colength j) :=
      (Ideal.Quotient.mk_surjective (I := Ideal.span {A.eqn j})).subsingleton
    rw [show finrank K (A.colength j) = 0 from Module.finrank_zero_of_subsingleton,
      Nat.cast_zero,
      Finset.filter_false_of_mem fun p _ hp => by simpa using hbot hp, Finset.sum_empty]

/-- Unit germ on a piece kills the coefficient, widened. -/
lemma coeffAt_eq_zero_of_isUnit_germ (j : D.index) {z : relCurve C K} (hz : z ∈ D.pieces j)
    (hzg : z ≠ genericPoint (relCurve C K))
    (hu : IsUnit (((relCurve C K).presheaf.germ (D.pieces j) z hz).hom (A.eqn j))) :
    coeffAt hzg (Scheme.presentationDivisor K d.presentation) = 0 := by
  have hηj : genericPoint (relCurve C K) ∈ D.pieces j :=
    Scheme.genericPoint_mem_of_nonempty ⟨z, hz⟩
  have hne : ((relCurve C K).presheaf.germ (D.pieces j) (genericPoint (relCurve C K)) hηj).hom
      (A.eqn j) ≠ 0 :=
    mem_nonZeroDivisors_iff_ne_zero.mp (A.eqn_regular j (genericPoint (relCurve C K)) hηj)
  set gⱼ : (relCurve C K).functionFieldˣ := Units.mk0 _ hne with hgⱼdef
  have hg : (gⱼ : (relCurve C K).functionField)
      = ((relCurve C K).presheaf.germ (D.pieces j) (genericPoint (relCurve C K)) hηj).hom
          (A.eqn j) := rfl
  have hord : Scheme.ordZ (relCurve C K ↘ Spec (CommRingCat.of K)) hzg gⱼ = 1 :=
    (Scheme.isUnit_germ_iff_ordZ_eq_one K hηj (A.eqn j) gⱼ hg hz hzg).mp hu
  have h1 := A.coeffAt_eq_toAdd_ordZ_eqn j hz hzg gⱼ hg
  rw [hord, toAdd_one] at h1
  exact h1.symm

omit [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))] in
/-- Overlap vanishing from separation, widened. -/
lemma subsingleton_ovlColength_of_sep
    (hsep : ∀ i j : D.index, i ≠ j → ∀ (z : relCurve C K) (hzi : z ∈ D.pieces i),
      z ∈ D.pieces j → IsUnit (((relCurve C K).presheaf.germ (D.pieces i) z hzi).hom (A.eqn i)))
    (i j : D.index) (hij : i ≠ j) : Subsingleton (A.ovlColength i j) := by
  have hunit : IsUnit (relResAlgHom C K
      (inf_le_left : D.pieces i ⊓ D.pieces j ≤ D.pieces i) (A.eqn i)) := by
    rw [relResAlgHom_apply]
    apply (relCurve C K).toRingedSpace.isUnit_of_isUnit_germ
    intro z hz
    rw [(relCurve C K).presheaf.germ_res_apply]
    exact hsep i j hij z hz.1 hz.2
  have htop : A.ovlIdeal i j = ⊤ :=
    Ideal.eq_top_of_isUnit_mem _ (Ideal.subset_span (Set.mem_insert _ _)) hunit
  exact (Ideal.Quotient.subsingleton_iff).mpr htop

/-- **The colength↔degree identity, support-separated case — WIDENED.** -/
theorem deg_presentationDivisor_eq_finrank_glued
    (hsep : ∀ i j : D.index, i ≠ j → ∀ (z : relCurve C K) (hzi : z ∈ D.pieces i),
      z ∈ D.pieces j → IsUnit (((relCurve C K).presheaf.germ (D.pieces i) z hzi).hom (A.eqn i)))
    (hfin : ∀ j : D.index, Module.Finite K (A.colength j)) :
    Scheme.CurveDivisor.deg K (Scheme.presentationDivisor K d.presentation)
      = (finrank K A.Glued : ℤ) := by
  sorry

end Geometric

end AffAdaptation

end AlgebraicGeometry
