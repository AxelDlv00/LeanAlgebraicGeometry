---
author: sync
content_type: theorem
created: '2026-07-19T16:01:13'
decl: AlgebraicGeometry.DivFamZar.isOpen_setOf_isH1VanishingAt
docstring: '**Openness of the h¹-vanishing locus on an affine test** (worksheet §1.3):
  the

  locus `{p | IsH1VanishingAt F₀ p}` is open in `Spec S`.  Per certificate piece of

  `DivFamZar.exists_certified_away_rep` the trace of the locus is the engine open

  `datumRigidEngine_isOpen_vanishing` of the piece''s divisor datum ((V1b) + (V1c)),

  carried across the away open immersion; the pieces glue since they compute one

  predicate.  This is the single sanctioned openness mechanism of the campaign

  (dat-d §3.5): no Fitting ideals, no semicontinuity, Noetherian-free.'
file: AlgebraicJacobian/Picard/DivisorFamilyH1Locus.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivFamZar.isOpen_setOf_isH1VanishingAt
type: lean
updated: '2026-07-29T15:26:29'
---
theorem DivFamZar.isOpen_setOf_isH1VanishingAt
    (hπ : π ≫ P1.structureMap k = C.hom) (F₀ : DivFamZar C S π n) :
    IsOpen {p : PrimeSpectrum S | F₀.IsH1VanishingAt p} := by
  obtain ⟨m, h, hspan, hG⟩ := DivFamZar.exists_certified_away_rep F₀
  choose G hGZ using hG
  have hkey : {p : PrimeSpectrum S | F₀.IsH1VanishingAt p}
      = ⋃ l : Fin m,
          (PrimeSpectrum.comap (algebraMap S (Localization.Away (h l)))) ''
            {q : PrimeSpectrum (Localization.Away (h l)) |
              Subsingleton ((datumPair (G l).adaptation.divisorDatum).H1
                ⊗[Localization.Away (h l)] q.asIdeal.ResidueField)} := by
    ext p
    simp only [Set.mem_setOf_eq, Set.mem_iUnion, Set.mem_image]
    constructor
    · intro hp
      -- some certificate piece sees `p` (span-⊤ prime avoidance)
      have hex : ∃ l, h l ∉ p.asIdeal := by
        by_contra hall
        have hmem : ∀ l, h l ∈ p.asIdeal := fun l => of_not_not fun hl => hall ⟨l, hl⟩
        have hle : Ideal.span (Set.range h) ≤ p.asIdeal :=
          Ideal.span_le.mpr (by rintro x ⟨l, rfl⟩; exact hmem l)
        rw [hspan] at hle
        exact p.isPrime.ne_top (top_le_iff.mp hle)
      obtain ⟨l, hl⟩ := hex
      have hrange : p ∈ Set.range
          (PrimeSpectrum.comap (algebraMap S (Localization.Away (h l)))) := by
        rw [PrimeSpectrum.localization_away_comap_range
          (S := Localization.Away (h l)) (h l)]
        exact hl
      obtain ⟨q, hq⟩ := hrange
      exact ⟨l, q,
        (F₀.isH1VanishingAt_comap_away_iff (h l) (G l) (hGZ l) q).mp (hq ▸ hp), hq⟩
    · rintro ⟨l, q, hsub, rfl⟩
      exact (F₀.isH1VanishingAt_comap_away_iff (h l) (G l) (hGZ l) q).mpr hsub
  rw [hkey]
  refine isOpen_iUnion fun l => ?_
  refine (PrimeSpectrum.localization_away_isOpenEmbedding
    (Localization.Away (h l)) (h l)).isOpenMap _ ?_
  exact datumRigidEngine_isOpen_vanishing (G l).adaptation.divisorDatum hπ