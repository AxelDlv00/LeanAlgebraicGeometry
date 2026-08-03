---
author: sync
content_type: theorem
created: '2026-08-03T13:09:52'
decl: AlgebraicGeometry.eq_of_isDivRepClassifyAff_at
docstring: 'Two widened classes classified by the same morphism agree when the curve
  parameter is

  independent of their certified divisor degree.'
file: AlgebraicJacobian/Picard/DivRepClassifyZarAffSep.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.eq_of_isDivRepClassifyAff_at
type: lean
updated: '2026-08-03T13:09:52'
---
theorem eq_of_isDivRepClassifyAff_at
    (hOAt : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    {gamma : ℕ} (hgamma : gamma ≤ g)
    (hχgamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (F₀ F₁ : DivFamZarAff C S g)
    {v : Spec (CommRingCat.of S) ⟶
      DivScheme k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hπ g).symm)}
    (h₀ : IsDivRepClassifyAff hπ g r₁ r₂ b₁ b₂ F₀ v)
    (h₁ : IsDivRepClassifyAff hπ g r₁ r₂ b₁ b₂ F₁ v) : F₀ = F₁ := by
  classical
  obtain ⟨m₀, c₀, hspan₀, hdata₀⟩ :=
    DivFamZarAff.exists_certChartCover_at (gamma := gamma)
      hπ g r₁ r₂ b₁ b₂ F₀ hgamma hχgamma
  obtain ⟨m₁, c₁, hspan₁, hdata₁⟩ :=
    DivFamZarAff.exists_certChartCover_at (gamma := gamma)
      hπ g r₁ r₂ b₁ b₂ F₁ hgamma hχgamma
  choose G₀ ci₀ cj₀ cw₀ hZ₀ hframe₀ using hdata₀
  choose G₁ ci₁ cj₁ cw₁ hZ₁ hframe₁ using hdata₁
  have hspan : Ideal.span (Set.range
      fun p : ULift.{u} (Fin m₀) × ULift.{u} (Fin m₁) ↦ c₀ p.1.down * c₁ p.2.down) = ⊤ := by
    have hsurj : Function.Surjective
        (fun p : ULift.{u} (Fin m₀) × ULift.{u} (Fin m₁) ↦
          (p.1.down, p.2.down)) := by
      rintro ⟨a, b⟩
      exact ⟨(⟨a⟩, ⟨b⟩), rfl⟩
    have hrange := hsurj.range_comp
      (fun q : Fin m₀ × Fin m₁ ↦ c₀ q.1 * c₁ q.2)
    exact hrange ▸ span_range_mul_eq_top c₀ c₁ hspan₀ hspan₁
  refine DivFamZarAff.eq_of_away_eq g
    (fun p : ULift.{u} (Fin m₀) × ULift.{u} (Fin m₁) ↦
      c₀ p.1.down * c₁ p.2.down)
    (fun p ↦ Localization.Away (c₀ p.1.down * c₁ p.2.down)) hspan ?_
  rintro ⟨⟨p₀⟩, ⟨p₁⟩⟩
  letI : Algebra (Localization.Away (c₀ p₀))
      (Localization.Away (c₀ p₀ * c₁ p₁)) :=
    (IsLocalization.Away.lift (S := Localization.Away (c₀ p₀)) (c₀ p₀)
      (g := algebraMap S (Localization.Away (c₀ p₀ * c₁ p₁)))
      (IsLocalization.Away.isUnit_of_dvd (x := c₀ p₀ * c₁ p₁)
        (dvd_mul_right (c₀ p₀) (c₁ p₁)))).toAlgebra
  haveI : IsScalarTower S (Localization.Away (c₀ p₀))
      (Localization.Away (c₀ p₀ * c₁ p₁)) :=
    IsScalarTower.of_algebraMap_eq' (by
      rw [RingHom.algebraMap_toAlgebra, IsLocalization.Away.lift_comp])
  haveI : IsScalarTower k (Localization.Away (c₀ p₀))
      (Localization.Away (c₀ p₀ * c₁ p₁)) :=
    isScalarTower_left_of_isScalarTower (R₀ := S)
  letI : Algebra (Localization.Away (c₁ p₁))
      (Localization.Away (c₀ p₀ * c₁ p₁)) :=
    (IsLocalization.Away.lift (S := Localization.Away (c₁ p₁)) (c₁ p₁)
      (g := algebraMap S (Localization.Away (c₀ p₀ * c₁ p₁)))
      (IsLocalization.Away.isUnit_of_dvd (x := c₀ p₀ * c₁ p₁)
        (dvd_mul_left (c₁ p₁) (c₀ p₀)))).toAlgebra
  haveI : IsScalarTower S (Localization.Away (c₁ p₁))
      (Localization.Away (c₀ p₀ * c₁ p₁)) :=
    IsScalarTower.of_algebraMap_eq' (by
      rw [RingHom.algebraMap_toAlgebra, IsLocalization.Away.lift_comp])
  haveI : IsScalarTower k (Localization.Away (c₁ p₁))
      (Localization.Away (c₀ p₀ * c₁ p₁)) :=
    isScalarTower_left_of_isScalarTower (R₀ := S)
  exact mapAlg_eq_of_certChartFramesAff_at
    (hπ := hπ) (g := g) (r₁ := r₁) (r₂ := r₂) (b₁ := b₁) (b₂ := b₂)
    (hOAt := hOAt) (gamma := gamma) (hgamma := hgamma) (hχgamma := hχgamma)
    F₀ F₁ h₀ h₁
    (G₀ p₀) (hZ₀ p₀) (cw₀ p₀) (hframe₀ p₀)
    (G₁ p₁) (hZ₁ p₁) (cw₁ p₁) (hframe₁ p₁)