---
author: sync
content_type: theorem
created: '2026-08-03T13:09:52'
decl: AlgebraicGeometry.divRepClassifyZarAff_eq_of_isDivRepClassifyAff_at
docstring: Any over-morphism satisfying the widened clause is the off-diagonal classified
  morphism.
file: AlgebraicJacobian/Picard/DivRepClassifyZarAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRepClassifyZarAff_eq_of_isDivRepClassifyAff_at
type: lean
updated: '2026-08-18T20:50:56'
---
theorem divRepClassifyZarAff_eq_of_isDivRepClassifyAff_at
    {gamma : ℕ} (hgamma : gamma ≤ g)
    (hchiGamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (F₀ : DivFamZarAff C S g)
    (u : overSpec k S ⟶
      divSchemeOver k (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hpi g).symm))
    (hu : IsDivRepClassifyAff hpi g r₁ r₂ b₁ b₂ F₀ u.left) :
    u = divRepClassifyZarAff_at (S := S) hpi g r₁ r₂ b₁ b₂
      (gamma := gamma) hgamma hchiGamma F₀ :=
  Over.OverMorphism.ext
    (isDivRepClassifyAff_unique_at (gamma := gamma)
      hpi g r₁ r₂ b₁ b₂ hgamma hchiGamma F₀ hu
      (divRepClassifyZarAff_isDivRepClassifyAff_at (gamma := gamma)
        hpi g r₁ r₂ b₁ b₂ hgamma hchiGamma F₀))