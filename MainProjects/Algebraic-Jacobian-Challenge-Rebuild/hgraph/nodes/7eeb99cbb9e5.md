---
author: sync
content_type: theorem
created: '2026-08-05T02:56:16'
decl: AlgebraicGeometry.not_injective_abelSigmaChartAff_of_divFamZarAff
docstring: 'Two distinct widened divisor families with the same affine chart value
  refute injectivity of

  the represented widened Abel chart.'
file: AlgebraicJacobian/Picard/Pic0HighDegreeRouteGuard.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.not_injective_abelSigmaChartAff_of_divFamZarAff
type: lean
updated: '2026-08-07T05:01:56'
---
theorem not_injective_abelSigmaChartAff_of_divFamZarAff {T : Over (Spec (.of k))}
    (s₁ s₂ : divFamZarAff C n T) (hne : s₁ ≠ s₂)
    (hval : chartValueAff C n m Z T s₁ = chartValueAff C n m Z T s₂) :
    ¬ Function.Injective ((abelSigmaChartAff C n rep m Z hdeg).app (op T.left)) := by
  set x₁ : T.left ⟶ D.left := (rep.homEquiv.symm s₁).left with hx₁
  set x₂ : T.left ⟶ D.left := (rep.homEquiv.symm s₂).left with hx₂
  have hs₁ : x₁ ≫ D.hom = T.hom := Over.w _
  have hs₂ : x₂ ≫ D.hom = T.hom := Over.w _
  have hstruct : x₁ ≫ D.hom = x₂ ≫ D.hom := hs₁.trans hs₂.symm
  have hrec₁ : rep.homEquiv (Over.homMk x₁ hs₁) = s₁ := by
    refine (congrArg rep.homEquiv (Over.OverMorphism.ext ?_)).trans
      (rep.homEquiv.apply_symm_apply s₁)
    rfl
  have hrec₂ : rep.homEquiv (Over.homMk x₂ (hstruct.symm.trans hs₁)) = s₂ := by
    refine (congrArg rep.homEquiv (Over.OverMorphism.ext ?_)).trans
      (rep.homEquiv.apply_symm_apply s₂)
    rfl
  refine not_injective_abelSigmaChartAff_of_points rep m Z hdeg x₁ x₂ ?_ hstruct ?_
  · intro h
    exact hne (hrec₁.symm.trans ((congrArg rep.homEquiv
      (Over.OverMorphism.ext h)).trans hrec₂))
  · set e : Over.mk (x₁ ≫ D.hom) ⟶ T :=
      Over.homMk (𝟙 T.left) ((Category.id_comp T.hom).trans hs₁.symm) with he
    have hfac₁ : (Over.homMk x₁ rfl : Over.mk (x₁ ≫ D.hom) ⟶ D)
        = e ≫ rep.homEquiv.symm s₁ :=
      Over.OverMorphism.ext (Category.id_comp x₁).symm
    have hfac₂ : (Over.homMk x₂ hstruct.symm : Over.mk (x₁ ≫ D.hom) ⟶ D)
        = e ≫ rep.homEquiv.symm s₂ :=
      Over.OverMorphism.ext (Category.id_comp x₂).symm
    have hpull : ∀ s : divFamZarAff C n T,
        rep.homEquiv (e ≫ rep.homEquiv.symm s) = divFamZarAff.map C n e s := by
      intro s
      rw [rep.homEquiv_comp, rep.homEquiv.apply_symm_apply]
      rfl
    have hstep : ∀ (s : divFamZarAff C n T) (y : Over.mk (x₁ ≫ D.hom) ⟶ D),
        y = e ≫ rep.homEquiv.symm s →
        chartValueAff C n m Z (Over.mk (x₁ ≫ D.hom)) (rep.homEquiv y)
          = picEtMap C e (chartValueAff C n m Z T s) := by
      intro s y hy
      subst hy
      exact (congrArg (chartValueAff C n m Z (Over.mk (x₁ ≫ D.hom))) (hpull s)).trans
        (picEtMap_chartValueAff C n m Z e s).symm
    exact (hstep s₁ _ hfac₁).trans
      ((congrArg (picEtMap C e) hval).trans (hstep s₂ _ hfac₂).symm)