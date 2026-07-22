---
author: sync
content_type: theorem
created: '2026-07-17T08:41:24'
decl: Ideal.height_le_one_of_colon_span_singleton
docstring: '**Height bound for colon primes of principal ideals.** Let `A` be a

  Noetherian domain and let the prime `Q = ((b) : y)` be the annihilator of

  `y mod (b)`. If `A_Q` is a regular local ring then `ht Q ≤ 1`.


  If `ht Q ≥ 2` then `dim A_Q ≥ 2`, so `A_Q` contains a swap pair `u, v` inside

  its maximal ideal `𝔪_Q`. But `𝔪_Q = ((b) : y) A_Q` is again a colon:

  `𝔪_Q = ((b/1) : (y/1))` in `A_Q`. Hence `u * (y/1), v * (y/1) ∈ (b/1)` and the

  swap lemma gives `y/1 ∈ (b/1)`, i.e. `((b/1) : (y/1)) = ⊤ = 𝔪_Q`,

  a contradiction.'
file: AlgebraicJacobian/Albanese/PolePurityLocal.lean
generated: lean
lean_status: lean_ok
title: Ideal.height_le_one_of_colon_span_singleton
type: lean
updated: '2026-07-17T08:41:24'
---
theorem Ideal.height_le_one_of_colon_span_singleton
    {A : Type u} [CommRing A] [IsDomain A] [IsNoetherianRing A]
    {b y : A} {Q : Ideal A} [hQp : Q.IsPrime]
    (hQ : Q = (Ideal.span ({b} : Set A)).colon {y})
    (hreg : IsRegularLocalRing (Localization.AtPrime Q)) :
    Q.height ≤ 1 := by
  by_contra hgt
  -- `2 ≤ ht Q`, hence `2 ≤ ringKrullDim A_Q`.
  have h2 : (2 : ℕ∞) ≤ Q.height := by
    have h1 : (1 : ℕ∞) < Q.height := lt_of_not_ge hgt
    calc (2 : ℕ∞) = 1 + 1 := by norm_num
      _ ≤ Q.height := Order.add_one_le_of_lt h1
  have h2dim : (2 : WithBot ℕ∞) ≤ ringKrullDim (Localization.AtPrime Q) := by
    rw [IsLocalization.AtPrime.ringKrullDim_eq_height Q (Localization.AtPrime Q)]
    simpa using WithBot.coe_le_coe.mpr h2
  haveI := hreg
  haveI : IsDomain (Localization.AtPrime Q) :=
    IsLocalization.isDomain_localization Q.primeCompl_le_nonZeroDivisors
  obtain ⟨u, v, huMem, hvMem, hu0, hv⟩ :=
    IsRegularLocalRing.exists_swap_pair_of_two_le_ringKrullDim
      (A := Localization.AtPrime Q) h2dim
  set φ := algebraMap A (Localization.AtPrime Q) with hφ
  have hinj : Function.Injective φ :=
    IsLocalization.injective (Localization.AtPrime Q) Q.primeCompl_le_nonZeroDivisors
  -- `y/1 ∉ (b/1)`: otherwise some `s ∉ Q` has `s * y ∈ (b)`, i.e. `s ∈ Q`.
  have hy' : φ y ∉ Ideal.span ({φ b} : Set (Localization.AtPrime Q)) := by
    intro hmem
    obtain ⟨s, hsM, hsy⟩ :=
      exists_smul_mem_span_of_algebraMap_mem_span Q.primeCompl hinj hmem
    refine hsM (hQ ▸ Submodule.mem_colon_singleton.mpr ?_)
    rw [smul_eq_mul]
    exact hsy
  -- the maximal ideal of `A_Q` is the colon `((b/1) : (y/1))`.
  have hm_eq : maximalIdeal (Localization.AtPrime Q)
      = (Ideal.span ({φ b} : Set (Localization.AtPrime Q))).colon {φ y} := by
    apply le_antisymm
    · -- `𝔪_Q = Q.map φ ≤ colon`.
      rw [← Localization.AtPrime.map_eq_maximalIdeal]
      rw [Ideal.map_le_iff_le_comap]
      intro r hr
      have hry : r • y ∈ Ideal.span ({b} : Set A) :=
        Submodule.mem_colon_singleton.mp (hQ ▸ hr)
      rw [smul_eq_mul] at hry
      obtain ⟨d, hd⟩ := Ideal.mem_span_singleton.mp hry
      refine Ideal.mem_comap.mpr (Submodule.mem_colon_singleton.mpr ?_)
      have : φ r * φ y = φ b * φ d := by rw [← map_mul, ← map_mul, hd]
      rw [smul_eq_mul, this]
      exact Ideal.mem_span_singleton.mpr ⟨φ d, rfl⟩
    · -- the colon is proper, hence contained in the maximal ideal.
      apply IsLocalRing.le_maximalIdeal
      intro htop
      have h1 : (1 : Localization.AtPrime Q) ∈
          (Ideal.span ({φ b} : Set (Localization.AtPrime Q))).colon {φ y} := by
        rw [htop]; trivial
      have h2' := Submodule.mem_colon_singleton.mp h1
      rw [smul_eq_mul, one_mul] at h2'
      exact hy' h2'
  -- swap lemma: `y/1 ∈ (b/1)`, contradiction.
  refine hy' (mem_span_singleton_of_swap_pair hu0 hv ?_ ?_)
  · have hmm := Submodule.mem_colon_singleton.mp (hm_eq ▸ huMem)
    rwa [smul_eq_mul] at hmm
  · have hmm := Submodule.mem_colon_singleton.mp (hm_eq ▸ hvMem)
    rwa [smul_eq_mul] at hmm

/-! ## §4. The main ring theorem -/