---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.isDivRepClassifyAff_unique
docstring: The widened characterizing clause determines its morphism uniquely.
file: AlgebraicJacobian/Picard/DivRepClassifyZarAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isDivRepClassifyAff_unique
type: lean
updated: '2026-08-07T05:01:47'
---
theorem isDivRepClassifyAff_unique (F₀ : DivFamZarAff C S g)
    {v v' : Spec (CommRingCat.of S) ⟶
      DivScheme k (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hpi g).symm)}
    (hv : IsDivRepClassifyAff hpi g r₁ r₂ b₁ b₂ F₀ v)
    (hv' : IsDivRepClassifyAff hpi g r₁ r₂ b₁ b₂ F₀ v') : v = v' := by
  obtain ⟨m, r, hspan, hdata⟩ :=
    DivFamZarAff.exists_certChartCover hpi g hO hchi r₁ r₂ b₁ b₂ F₀
  choose G ci cj cw hZ hframe using hdata
  refine Scheme.Cover.hom_ext
    (Scheme.affineOpenCoverOfSpanRangeEqTop
      (R := CommRingCat.of S) r hspan).openCover _ _ fun p => ?_
  refine divScheme_hom_ext k _ _ g r₁ r₂ b₁
    (b₂.map (windowShiftEquiv hpi g).symm) _ _ ?_
  have h₁ : (Scheme.affineOpenCoverOfSpanRangeEqTop
        (R := CommRingCat.of S) r hspan).openCover.f p ≫ v ≫
        divSchemeι k (windowS_choice pi hpi g • fiberWeilDivisor pi)
          (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
          (b₂.map (windowShiftEquiv hpi g).symm)
      = Spec.map (CommRingCat.ofHom (cw p).toRingHom)
          ≫ pairChartMap k g r₁ g r₂ (ci p) (cj p) :=
    hv (Localization.Away (r p)) (G p) (hZ p) (ci p) (cj p) (cw p) (hframe p)
  have h₂ : (Scheme.affineOpenCoverOfSpanRangeEqTop
        (R := CommRingCat.of S) r hspan).openCover.f p ≫ v' ≫
        divSchemeι k (windowS_choice pi hpi g • fiberWeilDivisor pi)
          (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
          (b₂.map (windowShiftEquiv hpi g).symm)
      = Spec.map (CommRingCat.ofHom (cw p).toRingHom)
          ≫ pairChartMap k g r₁ g r₂ (ci p) (cj p) :=
    hv' (Localization.Away (r p)) (G p) (hZ p) (ci p) (cj p) (cw p) (hframe p)
  rw [Category.assoc, Category.assoc]
  exact h₁.trans h₂.symm

include hO hchi in