---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: RingTheory.CohenMacaulay.exists_notMemSq_of_spanFinrank_pos
docstring: "**Nakayama witness.** For a Noetherian local ring `(R, \U0001D52A)` with\n\
  `spanFinrank \U0001D52A ≥ 1`, there exists `x ∈ \U0001D52A` with `x ∉ \U0001D52A\
  ²`.\n\nThis is the \"cotangent space is nonzero\" content: by Nakayama, if `\U0001D52A\
  \ ⊆ \U0001D52A²`\nthen `\U0001D52A = 0` (so `spanFinrank \U0001D52A = 0`), contradicting\
  \ the hypothesis. \n\n\n\n\n\n * Provenance: CUSTOM."
file: AlgebraicJacobian/Algebra/ABRegularQuotient.lean
generated: lean
lean_status: lean_ok
title: RingTheory.CohenMacaulay.exists_notMemSq_of_spanFinrank_pos
type: lean
updated: '2026-08-14T19:11:10'
---
lemma exists_notMemSq_of_spanFinrank_pos
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    (h : 0 < (IsLocalRing.maximalIdeal R).spanFinrank) :
    ∃ x ∈ IsLocalRing.maximalIdeal R, x ∉ (IsLocalRing.maximalIdeal R) ^ 2 := by
  -- By contradiction: assume 𝔪 ⊆ 𝔪², then by Nakayama 𝔪 = 0, but spanFinrank 𝔪 ≥ 1.
  by_contra h_neg
  push Not at h_neg
  have h𝔪_le_sq : IsLocalRing.maximalIdeal R ≤ (IsLocalRing.maximalIdeal R) ^ 2 := h_neg
  -- 𝔪² = 𝔪 • 𝔪.
  have hsq : (IsLocalRing.maximalIdeal R : Submodule R R) ^ 2
      = (IsLocalRing.maximalIdeal R) • (IsLocalRing.maximalIdeal R : Submodule R R) := by
    rw [sq, ← Ideal.smul_eq_mul]
  have h𝔪_fg : (IsLocalRing.maximalIdeal R : Submodule R R).FG :=
    Ideal.fg_of_isNoetherianRing _
  -- Use Submodule.le_of_le_smul_of_le_jacobson_bot with N = ⊥.
  have hjac : (IsLocalRing.maximalIdeal R) ≤ (⊥ : Ideal R).jacobson :=
    IsLocalRing.maximalIdeal_le_jacobson _
  have h_le_smul : (IsLocalRing.maximalIdeal R : Submodule R R)
      ≤ ⊥ ⊔ (IsLocalRing.maximalIdeal R) •
        (IsLocalRing.maximalIdeal R : Submodule R R) := by
    rw [bot_sup_eq, ← hsq]; exact h𝔪_le_sq
  have h𝔪_bot : (IsLocalRing.maximalIdeal R : Submodule R R) ≤ ⊥ :=
    Submodule.le_of_le_smul_of_le_jacobson_bot h𝔪_fg hjac h_le_smul
  have h𝔪_eq_bot : (IsLocalRing.maximalIdeal R) = ⊥ := le_bot_iff.mp h𝔪_bot
  have h_span : (IsLocalRing.maximalIdeal R).spanFinrank = 0 := by
    rw [h𝔪_eq_bot]; exact Submodule.spanFinrank_bot
  omega

/-! ### The regular quotient step (Stacks 00NU prep)

For a regular local Noetherian ring `R` of `spanFinrank 𝔪 = k + 1` and
`x ∈ 𝔪 \ 𝔪²`, the quotient `R ⧸ Ideal.span {x}` is again a regular local
ring of `spanFinrank 𝔪' = k`.

This is the **axiom-clean** counterpart of
`exists_isSMulRegular_quotient_isRegularLocal_succ`: it avoids the
`IsSMulRegular R x` hypothesis (which depends on `isDomain_of_regularLocal`)
by routing the dimension lower bound through
`ringKrullDim_le_ringKrullDim_quotient_add_encard` — a Krull-height bound
that does NOT require `x` to be a non-zero-divisor — instead of
`ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`. -/