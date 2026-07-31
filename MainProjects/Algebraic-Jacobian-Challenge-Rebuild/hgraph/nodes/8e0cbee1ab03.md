---
author: sync
content_type: theorem
created: '2026-07-19T10:31:16'
decl: AlgebraicGeometry.existsUnique_effective_divisor_of_carve_windowN
docstring: '**The fibre P-fib-N keystone at the transported windows** (worksheet §1.5,
  the

  G-4 fibre heart): on the fibre curve over any field extension `K/k`, subspaces

  `K_M ⊆ H⁰(𝒪(N))` and `K'' ⊆ H⁰(𝒪(N + S))` of corank exactly `g` at the transported

  windows `N = windowN` (the `M·F`-transport) and `S = windowS` (the `s·F`-transport),

  satisfying the elementwise carve `(♦)`, determine a **unique** effective divisor
  `D`

  of degree `g` with `K_M = H⁰(𝒪(N − D))` and `K'' = H⁰(𝒪(N + S − D))`.


  Every pack slot of `existsUnique_effective_divisor_of_carve_pack` is discharged:

  `hvan` by witness peeling at the minimal exponent `a` (threshold `β = a·δ + g`),

  `hNdeg` by `two_mul_genus_le_deg_windowN`, `hSdeg` by `two_mul_genus_le_S_mul_windowδ`,

  the budgets by `windowA_add_three_mul_genus_le_S_mul` (I-0234''s `windowS_spec_three`)

  and `windowA_add_three_mul_genus_add_S_le_M_mul`.  In the degenerate ledger branch

  `windowBound ≤ 0` the genus is zero and `D = 0` is forced directly.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.existsUnique_effective_divisor_of_carve_windowN
type: lean
updated: '2026-07-31T20:15:22'
---
theorem existsUnique_effective_divisor_of_carve_windowN (g : ℕ)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (hOK : Sheaf.h0 ((relCurve C K).moduleKSheaf K) = 1)
    (hχK : Sheaf.chi ((relCurve C K).moduleKSheaf K) = 1 - (g : ℤ))
    (KM : Submodule K (relCurve C K).functionField)
    (hKM : KM ≤ divisorSections K (windowN C K hπ g) ⊤)
    (hKMrank : Module.finrank K ↥KM + g
      = Sheaf.h0 ((relCurve C K).divisorSheaf K (windowN C K hπ g)))
    (K' : Submodule K (relCurve C K).functionField)
    (hK' : K' ≤ divisorSections K (windowN C K hπ g + windowS C K hπ g) ⊤)
    (hK'rank : Module.finrank K ↥K' + g
      = Sheaf.h0 ((relCurve C K).divisorSheaf K
          (windowN C K hπ g + windowS C K hπ g)))
    (hcarve : ∀ h ∈ divisorSections K (windowS C K hπ g) ⊤, ∀ f ∈ KM, h * f ∈ K') :
    ∃! D : (relCurve C K).CurveDivisor, 0 ≤ D ∧ CurveDivisor.deg K D = (g : ℤ) ∧
      KM = divisorSections K (windowN C K hπ g - D) ⊤ ∧
      K' = divisorSections K (windowN C K hπ g + windowS C K hπ g - D) ⊤ := by
  by_cases hb : windowBound π hπ ≤ 0
  · -- degenerate ledger branch: `g = 0`, the divisor is forced to be `0`
    have hg0 : g = 0 := genus_eq_zero_of_windowBound_nonpos π hπ g hb hO hχ
    subst hg0
    have hKMeq : KM = divisorSections K (windowN C K hπ 0) ⊤ := by
      refine Submodule.eq_of_le_of_finrank_le hKM ?_
      rw [finrank_divisorSections_top K _]
      omega
    have hK'eq : K' = divisorSections K (windowN C K hπ 0 + windowS C K hπ 0) ⊤ := by
      refine Submodule.eq_of_le_of_finrank_le hK' ?_
      rw [finrank_divisorSections_top K _]
      omega
    refine ⟨0, ⟨le_rfl, by rw [CurveDivisor.deg_zero, Nat.cast_zero], ?_, ?_⟩, ?_⟩
    · rw [sub_zero]; exact hKMeq
    · rw [sub_zero]; exact hK'eq
    · rintro D' ⟨hD'0, hD'deg, -, -⟩
      refine Scheme.CurveDivisor.eq_zero_of_deg_le_zero K hD'0 ?_
      rw [hD'deg, Nat.cast_zero]
  · -- main branch: `0 < b`, the pack fires at threshold `β = a·δ + g`
    push Not at hb
    refine existsUnique_effective_divisor_of_carve_pack g hOK hχK
      (windowN C K hπ g) (windowS C K hπ g)
      ((windowA_choice π hπ : ℤ) * windowδ π + (g : ℤ))
      (fun W hW => subsingleton_h1_of_windowA_le_deg C K hπ g hχK W hW)
      (two_mul_genus_le_deg_windowN C K hπ g hO hχ)
      (by rw [deg_windowS]
          exact two_mul_genus_le_S_mul_windowδ π hπ g hO hχ)
      (by rw [deg_windowS]
          have := windowA_add_three_mul_genus_le_S_mul π hπ hb g
          linarith)
      (by rw [deg_windowS, deg_windowN]
          have := windowA_add_three_mul_genus_add_S_le_M_mul π hπ hb g
          linarith)
      KM hKM hKMrank K' hK' hK'rank hcarve

end Keystone
/-! ## The Φ-side interface (G-3 dictionary addenda for the seed bridge) -/

section PhiInterface

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (K : Type u) [Field K] [Algebra k K]
variable (π : C.left ⟶ P1 k) [IsFinite π]

noncomputable local instance instOverCleftSUFP : C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
  [IsDominant π]
variable (a : ℕ)
variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (relCurve C K ↘ Spec (CommRingCat.of K))]