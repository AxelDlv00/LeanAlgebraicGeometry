---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.existsUnique_effective_divisor_of_carve
docstring: '**P-fib** (★★★, worksheet §3.2 — the persistence heart of the Div^g carve):
  for

  subspaces `K_M ⊆ H⁰(𝒪(MF))` and `K'' ⊆ H⁰(𝒪((M+s)F))` of codimension exactly `g`

  satisfying the carve `(♦)` — every product of a multiplier section with an element
  of

  `K_M` lies in `K''` — there is a **unique** effective divisor `D` of degree `g`
  with

  `K_M = H⁰(𝒪(MF − D))` and `K'' = H⁰(𝒪((M+s)F − D))`.'
file: AlgebraicJacobian/RiemannRoch/PFib.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.existsUnique_effective_divisor_of_carve
type: lean
updated: '2026-07-29T15:26:31'
---
theorem existsUnique_effective_divisor_of_carve
    (g : ℕ) (hO : Sheaf.h0 (Y.moduleKSheaf K) = 1)
    (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (g : ℤ))
    (KM : Submodule K Y.functionField)
    (hKM : KM ≤ divisorSections K (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)
    (hKMrank : Module.finrank K ↥KM + g
      = Sheaf.h0 (Y.divisorSheaf K (windowM_choice π hπ g • fiberWeilDivisor π)))
    (K' : Submodule K Y.functionField)
    (hK' : K' ≤ divisorSections K
      ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤)
    (hK'rank : Module.finrank K ↥K' + g
      = Sheaf.h0 (Y.divisorSheaf K
          ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π)))
    (hcarve : ∀ h ∈ divisorSections K (windowS_choice π hπ g • fiberWeilDivisor π) ⊤,
      ∀ f ∈ KM, h * f ∈ K') :
    ∃! D : Y.CurveDivisor, 0 ≤ D ∧ CurveDivisor.deg K D = (g : ℤ) ∧
      KM = divisorSections K (windowM_choice π hπ g • fiberWeilDivisor π - D) ⊤ ∧
      K' = divisorSections K
        ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π - D) ⊤ := by
  classical
  set Fd : Y.CurveDivisor := fiberWeilDivisor π with hFd
  haveI hK'fin : Module.Finite K ↥K' := Submodule.finiteDimensional_of_le hK'
  have hdegF : CurveDivisor.deg K Fd = windowδ π := deg_fiberWeilDivisor_windowδ π
  have hδ1 := one_le_windowδ π
  have hMd := two_mul_genus_le_M_mul_windowδ π hπ g hO hχ
  -- ranks of the two embedding windows
  have hrM : (Sheaf.h0 (Y.divisorSheaf K (windowM_choice π hπ g • Fd)) : ℤ)
      = (windowM_choice π hπ g : ℤ) * windowδ π + 1 - (g : ℤ) := by
    rw [hFd]
    exact rank_embedding_of_genus π hπ g hχ
  have hrMs : (Sheaf.h0 (Y.divisorSheaf K
        ((windowM_choice π hπ g + windowS_choice π hπ g) • Fd)) : ℤ)
      = ((windowM_choice π hπ g : ℤ) + (windowS_choice π hπ g : ℤ)) * windowδ π
        + 1 - (g : ℤ) := by
    rw [hFd]
    exact rank_embedding_shift_of_genus π hπ g hχ
  -- F1: `K_M` is nonzero, its base divisor is the divisor
  have hKMne : ∃ f ∈ KM, f ≠ 0 := by
    refine Submodule.exists_mem_ne_zero_of_ne_bot (fun hbot => ?_)
    rw [hbot, finrank_bot] at hKMrank
    omega
  set D : Y.CurveDivisor := Scheme.baseDivisor K KM (windowM_choice π hπ g • Fd) hKMne
    with hDdef
  have hD0 : 0 ≤ D := Scheme.baseDivisor_nonneg K hKMne
  have hDdeg0 : 0 ≤ CurveDivisor.deg K D := Scheme.CurveDivisor.deg_nonneg K hD0
  have hKMsub : KM ≤ divisorSections K (windowM_choice π hπ g • Fd - D) ⊤ := by
    rw [hDdef]
    exact Scheme.le_divisorSections_sub_baseDivisor K hKM hKMne
  -- the degree of the normalization level
  have hdegND : CurveDivisor.deg K (windowM_choice π hπ g • Fd - D)
      = (windowM_choice π hπ g : ℤ) * windowδ π - CurveDivisor.deg K D := by
    rw [Scheme.CurveDivisor.deg_sub' K, Scheme.CurveDivisor.deg_nsmul' K, hdegF]
  -- F1 degree bound: first `≤ 2g` by the section bound, then `≤ g` by the exact window
  have hfrKM : Module.finrank K ↥KM
      ≤ Sheaf.h0 (Y.divisorSheaf K (windowM_choice π hπ g • Fd - D)) := by
    rw [← finrank_divisorSections_top K _]
    exact Submodule.finrank_mono hKMsub
  have hKMpos : 0 < Module.finrank K ↥KM := by omega
  have hposND : 0 < Sheaf.h0 (Y.divisorSheaf K (windowM_choice π hπ g • Fd - D)) := by
    omega
  have hsec := h0_le_deg_add_one_of_pos K hO (windowM_choice π hπ g • Fd - D) hposND
  rw [hdegND] at hsec
  have hD2g : CurveDivisor.deg K D ≤ 2 * (g : ℤ) := by omega
  have hrND : (Sheaf.h0 (Y.divisorSheaf K (windowM_choice π hπ g • Fd - D)) : ℤ)
      = (windowM_choice π hπ g : ℤ) * windowδ π - CurveDivisor.deg K D
        + Sheaf.chi (Y.moduleKSheaf K) :=
    rank_normalization π hπ g D hD2g
  rw [hχ] at hrND
  have hDg : CurveDivisor.deg K D ≤ (g : ℤ) := by omega
  -- the codimension of `K_M` inside its normalization window
  set c : ℕ := Sheaf.h0 (Y.divisorSheaf K (windowM_choice π hπ g • Fd - D))
    - Module.finrank K ↥KM with hcdef
  have hcrank : Module.finrank K ↥KM + c
      = Sheaf.h0 (Y.divisorSheaf K (windowM_choice π hπ g • Fd - D)) := by
    omega
  have hcg : c ≤ g := by omega
  -- the bpf achievers
  have hbpf : ∀ (x : Y) (hx : x ≠ genericPoint Y),
      ∃ (f : Y.functionField) (_ : f ∈ KM) (hf : f ≠ 0),
        coeffAt hx ((windowM_choice π hπ g • Fd - D)
          + Scheme.divOf (Y ↘ Spec (CommRingCat.of K)) (Units.mk0 f hf)) = 0 := by
    intro x hx
    rw [hDdef]
    exact Scheme.exists_achiever_baseDivisor_sub K hKM hKMne hx
  -- F3-core: the span is the full shifted window
  have hspan : Scheme.mulSpan K (divisorSections K (windowS_choice π hπ g • Fd) ⊤) KM
      = divisorSections K
          ((windowM_choice π hπ g + windowS_choice π hπ g) • Fd - D) ⊤ :=
    mulSpan_eq_divisorSections_of_basepointFree π hπ g hO hχ D hD0 hDg
      KM hKMsub c hcg hcrank hbpf
  -- `(♦)` traps the span inside `K'`
  have hspanle : divisorSections K
      ((windowM_choice π hπ g + windowS_choice π hπ g) • Fd - D) ⊤ ≤ K' := by
    rw [← hspan]
    exact Scheme.mulSpan_le K hcarve
  -- corank pinch: `deg D = g`
  have hdegMsD : CurveDivisor.deg K
      ((windowM_choice π hπ g + windowS_choice π hπ g) • Fd - D)
      = ((windowM_choice π hπ g : ℤ) + (windowS_choice π hπ g : ℤ)) * windowδ π
        - CurveDivisor.deg K D := by
    rw [Scheme.CurveDivisor.deg_sub' K, Scheme.CurveDivisor.deg_nsmul' K, hdegF]
    push_cast
    ring
  have hrMsD : (Sheaf.h0 (Y.divisorSheaf K
        ((windowM_choice π hπ g + windowS_choice π hπ g) • Fd - D)) : ℤ)
      = ((windowM_choice π hπ g : ℤ) + (windowS_choice π hπ g : ℤ)) * windowδ π
        - CurveDivisor.deg K D + Sheaf.chi (Y.moduleKSheaf K) :=
    rank_normalization_shift π hπ g D hD2g
  rw [hχ] at hrMsD
  have hfrK' : Sheaf.h0 (Y.divisorSheaf K
      ((windowM_choice π hπ g + windowS_choice π hπ g) • Fd - D))
      ≤ Module.finrank K ↥K' := by
    rw [← finrank_divisorSections_top K _]
    exact Submodule.finrank_mono hspanle
  have hDeqg : CurveDivisor.deg K D = (g : ℤ) := by omega
  -- the two equalities
  have hKMeq : KM = divisorSections K (windowM_choice π hπ g • Fd - D) ⊤ := by
    refine Submodule.eq_of_le_of_finrank_le hKMsub ?_
    rw [finrank_divisorSections_top K _]
    omega
  have hK'eq : K' = divisorSections K
      ((windowM_choice π hπ g + windowS_choice π hπ g) • Fd - D) ⊤ := by
    refine (Submodule.eq_of_le_of_finrank_le hspanle ?_).symm
    rw [finrank_divisorSections_top K _]
    omega
  refine ⟨D, ⟨hD0, hDeqg, hKMeq, hK'eq⟩, ?_⟩
  -- uniqueness: the divisor is the base divisor of `K_M`
  rintro D' ⟨hD'0, hD'deg, hKM', _⟩
  refine CurveDivisor.ext_coeffAt (fun x hx => ?_)
  have hrec : (Scheme.baseDivisorAt K
      (divisorSections K (windowM_choice π hπ g • Fd - D') ⊤)
      (windowM_choice π hπ g • Fd) ⟨x, hx⟩ : ℤ) = coeffAt hx D' :=
    baseDivisorAt_normalization π hπ g hO hχ D' hD'0 hD'deg hx
  have hcoeffD : coeffAt hx D
      = (Scheme.baseDivisorAt K KM (windowM_choice π hπ g • Fd) ⟨x, hx⟩ : ℤ) := by
    rw [hDdef]
    exact Scheme.coeffAt_baseDivisor K hKMne hx
  rw [hKM'] at hcoeffD
  rw [hcoeffD]
  exact hrec.symm