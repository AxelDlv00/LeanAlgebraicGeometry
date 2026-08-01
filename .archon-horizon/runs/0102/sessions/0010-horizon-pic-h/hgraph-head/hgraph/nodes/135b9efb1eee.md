---
author: sync
content_type: lemma
created: '2026-07-17T16:57:11'
decl: RingTheory.CohenMacaulay.spanFinrank_maximalIdeal_le_of_surjective
docstring: 'The span-rank of the maximal ideal can only drop along a surjection of

  local Noetherian rings.'
file: AlgebraicJacobian/Albanese/Milne33KernelGen.lean
generated: lean
lean_status: lean_ok
title: RingTheory.CohenMacaulay.spanFinrank_maximalIdeal_le_of_surjective
type: lean
updated: '2026-08-01T09:44:08'
---
lemma spanFinrank_maximalIdeal_le_of_surjective [IsLocalRing B]
    [IsNoetherianRing B] [IsLocalRing A] (φ : B →+* A)
    (hφ : Function.Surjective φ) :
    (IsLocalRing.maximalIdeal A).spanFinrank
      ≤ (IsLocalRing.maximalIdeal B).spanFinrank := by
  obtain ⟨s, hscard, hsspan⟩ :=
    (IsNoetherian.noetherian (IsLocalRing.maximalIdeal B)
      : (IsLocalRing.maximalIdeal B).FG).exists_span_finset_card_eq_spanFinrank
  have hsspan' : Ideal.span (↑s : Set B) = IsLocalRing.maximalIdeal B := hsspan
  have hAspan : Ideal.span (φ '' ↑s) = IsLocalRing.maximalIdeal A := by
    rw [← Ideal.map_span, hsspan', map_maximalIdeal_eq_of_surjective φ hφ]
  calc (IsLocalRing.maximalIdeal A).spanFinrank
      = (Ideal.span (φ '' ↑s)).spanFinrank := by rw [hAspan]
    _ ≤ (φ '' ↑s).ncard :=
        Submodule.spanFinrank_span_le_ncard_of_finite (s.finite_toSet.image φ)
    _ ≤ (↑s : Set B).ncard := Set.ncard_image_le s.finite_toSet
    _ = s.card := Set.ncard_coe_finset _
    _ = _ := hscard