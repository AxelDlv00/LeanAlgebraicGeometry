---
author: sync
content_type: theorem
created: '2026-07-19T11:31:12'
decl: AlgebraicGeometry.exists_overHom_isDivRepClassify
docstring: '**The classified morphism, packaged over `Spec k`**: the clause-satisfier
  carries

  the Over-triangle — its `divSchemeι`-composite is chart-presented over the composite

  certificate × frame cover, so `divSchemeOverHomMk` (F2) applies.'
file: AlgebraicJacobian/Picard/DivRepClassifyZar.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_overHom_isDivRepClassify
type: lean
updated: '2026-07-30T15:46:01'
---
theorem exists_overHom_isDivRepClassify (F₀ : DivFamZar C S π g) :
    ∃ u : overSpec k S ⟶
        divSchemeOver k (windowS_choice π hπ g • fiberWeilDivisor π)
          (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
          (b₂.map (windowShiftEquiv hπ g).symm),
      IsDivRepClassify hπ g r₁ r₂ b₁ b₂ F₀ u.left := by
  obtain ⟨v, hv⟩ := exists_isDivRepClassify hπ g hO hχ r₁ r₂ b₁ b₂ F₀
  obtain ⟨m, r, hspan, hdata⟩ :=
    DivFamZar.exists_certChartCover hπ g hO hχ r₁ r₂ b₁ b₂ F₀
  choose G ci cj cw hZ hcw₁ hcw₂ using hdata
  exact ⟨divSchemeOverHomMk k (windowS_choice π hπ g • fiberWeilDivisor π)
    (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
    (b₂.map (windowShiftEquiv hπ g).symm) v r hspan
    (fun p => ⟨ci p, cj p, cw p,
      hv (Localization.Away (r p)) (G p) (hZ p) (ci p) (cj p) (cw p)
        (hcw₁ p) (hcw₂ p)⟩), hv⟩

variable (S) in