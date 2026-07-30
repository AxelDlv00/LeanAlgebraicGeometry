---
author: sync
content_type: theorem
created: '2026-07-20T17:01:58'
decl: AlgebraicGeometry.universalMulSpan_eq_divUniversalSndWindow_of_forall_fibre
docstring: 'The relative persistence conclusion: fibrewise spanning makes the finite

  universal multiplication span equal the universal second window.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivMulSpanClose.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.universalMulSpan_eq_divUniversalSndWindow_of_forall_fibre
type: lean
updated: '2026-07-30T15:46:03'
---
theorem universalMulSpan_eq_divUniversalSndWindow_of_forall_fibre
    (hfib : ∀ p : PrimeSpectrum RZ,
      Function.Surjective
        ((universalMulMapToSnd (hπ := hπ) g r₁ r₂ b₁ b₂ i j).rTensor
          p.asIdeal.ResidueField)) :
    universalMulSpan (hπ := hπ) g r₁ r₂ b₁ b₂ i j
      = (divUniversalSndWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule := by
  refine le_antisymm (universalMulSpan_le (hπ := hπ) g r₁ r₂ b₁ b₂ i j) ?_
  intro x hx
  obtain ⟨v, hv⟩ :=
    universalMulMapToSnd_surjective_of_forall_fibre (hπ := hπ) g r₁ r₂ b₁ b₂ i j hfib
      ⟨x, hx⟩
  rw [universalMulSpan]
  exact LinearMap.mem_range.mpr ⟨v, congrArg Subtype.val hv⟩