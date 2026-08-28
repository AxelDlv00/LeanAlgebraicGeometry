---
author: sync
content_type: lemma
created: '2026-07-17T16:57:14'
decl: AlgebraicGeometry.Scheme.exists_coeffAt_divOf_le_sum
docstring: '**The finite-sum ultrametric**: a nonzero finite sum has some nonzero
  summand of

  order `≤` the order of the sum.'
file: AlgebraicJacobian/RiemannRoch/BaseDivisorSpan.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.exists_coeffAt_divOf_le_sum
type: lean
updated: '2026-08-01T09:44:17'
---
lemma Scheme.exists_coeffAt_divOf_le_sum {ι : Type*} (s : Finset ι)
    (F : ι → X.functionField) (hsum : ∑ i ∈ s, F i ≠ 0) {x : X}
    (hx : x ≠ genericPoint X) :
    ∃ i ∈ s, ∃ (hFi : F i ≠ 0),
      coeffAt hx (Scheme.divOf (X ↘ Spec (CommRingCat.of K)) (Units.mk0 (F i) hFi))
        ≤ coeffAt hx (Scheme.divOf (X ↘ Spec (CommRingCat.of K))
            (Units.mk0 (∑ i ∈ s, F i) hsum)) := by
  classical
  induction s using Finset.induction_on with
  | empty => exact absurd (Finset.sum_empty (f := F)) hsum
  | insert a s ha ih =>
    have hsum' : F a + ∑ i ∈ s, F i ≠ 0 := by rwa [Finset.sum_insert ha] at hsum
    have hU : Units.mk0 (∑ i ∈ Insert.insert a s, F i) hsum
        = Units.mk0 (F a + ∑ i ∈ s, F i) hsum' := by
      refine Units.ext ?_
      simp only [Units.val_mk0]
      exact Finset.sum_insert ha
    rw [hU]
    by_cases hFa : F a = 0
    · -- the head vanishes: recurse into the tail
      have hrest : ∑ i ∈ s, F i ≠ 0 := by rwa [hFa, zero_add] at hsum'
      have hU₂ : Units.mk0 (F a + ∑ i ∈ s, F i) hsum'
          = Units.mk0 (∑ i ∈ s, F i) hrest := by
        refine Units.ext ?_
        simp only [Units.val_mk0]
        rw [hFa, zero_add]
      rw [hU₂]
      obtain ⟨i, his, hFi, hle⟩ := ih hrest
      exact ⟨i, Finset.mem_insert_of_mem his, hFi, hle⟩
    · by_cases hrest : ∑ i ∈ s, F i = 0
      · -- the tail vanishes: the head is the sum
        have hU₃ : Units.mk0 (F a + ∑ i ∈ s, F i) hsum' = Units.mk0 (F a) hFa := by
          refine Units.ext ?_
          simp only [Units.val_mk0]
          rw [hrest, add_zero]
        rw [hU₃]
        exact ⟨a, Finset.mem_insert_self a s, hFa, le_rfl⟩
      · -- both halves are nonzero: the two-term ultrametric splits the minimum
        have hmin := Scheme.min_coeffAt_divOf_le_add K hFa hrest hsum' hx
        rcases min_cases
            (coeffAt hx (Scheme.divOf (X ↘ Spec (CommRingCat.of K))
              (Units.mk0 (F a) hFa)))
            (coeffAt hx (Scheme.divOf (X ↘ Spec (CommRingCat.of K))
              (Units.mk0 (∑ i ∈ s, F i) hrest))) with ⟨hcase, _⟩ | ⟨hcase, _⟩
        · exact ⟨a, Finset.mem_insert_self a s, hFa, by omega⟩
        · obtain ⟨i, his, hFi, hle⟩ := ih hrest
          exact ⟨i, Finset.mem_insert_of_mem his, hFi, by omega⟩

/-! ## The keystone: the achiever of a span lies in the spanning set -/