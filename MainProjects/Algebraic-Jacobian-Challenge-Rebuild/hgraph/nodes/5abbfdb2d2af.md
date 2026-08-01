---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.divRepClassifyZarAff_eq_of_isDivRepClassifyAff
docstring: Any over-morphism satisfying the widened clause is the classified morphism.
file: AlgebraicJacobian/Picard/DivRepClassifyZarAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRepClassifyZarAff_eq_of_isDivRepClassifyAff
type: lean
updated: '2026-08-02T07:12:49'
---
theorem divRepClassifyZarAff_eq_of_isDivRepClassifyAff (F₀ : DivFamZarAff C S g)
    (u : overSpec k S ⟶
      divSchemeOver k (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hpi g).symm))
    (hu : IsDivRepClassifyAff hpi g r₁ r₂ b₁ b₂ F₀ u.left) :
    u = divRepClassifyZarAff hpi g hO hchi r₁ r₂ b₁ b₂ S F₀ :=
  Over.OverMorphism.ext (isDivRepClassifyAff_unique hpi g hO hchi r₁ r₂ b₁ b₂
    F₀ hu (divRepClassifyZarAff_isDivRepClassifyAff hpi g hO hchi r₁ r₂ b₁ b₂ F₀))