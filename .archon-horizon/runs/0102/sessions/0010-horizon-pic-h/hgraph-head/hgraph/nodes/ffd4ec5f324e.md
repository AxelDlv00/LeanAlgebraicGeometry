---
author: sync
content_type: lemma
created: '2026-07-30T02:30:06'
decl: AlgebraicGeometry.AffAdaptation.finrank_colength_eq_sum
docstring: '**The per-piece degree reading**, widened.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffFieldDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.finrank_colength_eq_sum
type: lean
updated: '2026-08-01T09:44:13'
---
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