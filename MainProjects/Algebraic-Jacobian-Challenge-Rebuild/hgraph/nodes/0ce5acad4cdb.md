---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.specMap_pairChartMap_eq_of_aff_window_frames
docstring: 'Two widened pair-chart frames whose base-changed certified families name
  the same class

  present the same morphism to the Grassmannian pair.'
file: AlgebraicJacobian/Picard/DivRepClassifyZarAffCompat.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.specMap_pairChartMap_eq_of_aff_window_frames
type: lean
updated: '2026-08-18T20:50:56'
---
theorem specMap_pairChartMap_eq_of_aff_window_frames
    {S₁ S₂ B : Type u}
    [CommRing S₁] [Algebra k S₁] [CommRing S₂] [Algebra k S₂]
    [CommRing B] [Algebra k B]
    [Algebra S₁ B] [IsScalarTower k S₁ B]
    [Algebra S₂ B] [IsScalarTower k S₂ B]
    (F₁ : CertifiedDivisorFamilyAff C S₁ g)
    (F₂ : CertifiedDivisorFamilyAff C S₂ g)
    (hinf₁ : F₁.cover.HasAffineOverlaps) (hinf₂ : F₂.cover.HasAffineOverlaps)
    (hclass : (F₁.mapAlg B g hinf₁).toZarAff = (F₂.mapAlg B g hinf₂).toZarAff)
    {i₁ i₂ : (glueData k g r₁).J} {j₁ j₂ : (glueData k g r₂).J}
    (w₁ : PairChartRing k g r₁ g r₂ i₁ j₁ →ₐ[k] S₁)
    (w₂ : PairChartRing k g r₁ g r₂ i₂ j₂ →ₐ[k] S₂)
    (hw₁ : F₁.IsPairChartFramed hpi g b₁ b₂ i₁ j₁ w₁)
    (hw₂ : F₂.IsPairChartFramed hpi g b₁ b₂ i₂ j₂ w₂) :
    Spec.map (CommRingCat.ofHom
        ((IsScalarTower.toAlgHom k S₁ B).comp w₁).toRingHom)
        ≫ pairChartMap k g r₁ g r₂ i₁ j₁
      = Spec.map (CommRingCat.ofHom
          ((IsScalarTower.toAlgHom k S₂ B).comp w₂).toRingHom)
          ≫ pairChartMap k g r₁ g r₂ i₂ j₂ := by
  let E₁ := F₁.mapAlg B g hinf₁
  let E₂ := F₂.mapAlg B g hinf₂
  have hdiv : E₁.eqns.DivEq E₂.eqns :=
    DivFamZarAff.mk_eq_mk_iff.mp hclass
  have hframe₁ : E₁.IsPairChartFramed hpi g b₁ b₂ i₁ j₁
      ((IsScalarTower.toAlgHom k S₁ B).comp w₁) :=
    hw₁.mapAlg hpi g hO hchi r₁ r₂ b₁ b₂ F₁ hinf₁ w₁
  have hframe₂ : E₂.IsPairChartFramed hpi g b₁ b₂ i₂ j₂
      ((IsScalarTower.toAlgHom k S₂ B).comp w₂) :=
    hw₂.mapAlg hpi g hO hchi r₁ r₂ b₁ b₂ F₂ hinf₂ w₂
  have heps₁ : (E₁.eps hpi g).1 = (E₂.eps hpi g).1 := by
    rw [CertifiedDivisorFamilyAff.eps_fst, CertifiedDivisorFamilyAff.eps_fst,
      divisorWindow_eq_of_divEq hdiv]
  have heps₂ : (E₁.eps hpi g).2 = (E₂.eps hpi g).2 := by
    rw [CertifiedDivisorFamilyAff.eps_snd, CertifiedDivisorFamilyAff.eps_snd,
      divisorWindow_eq_of_divEq hdiv]
  refine specMap_pairChartMap_eq_of_map_pairTaut_eq k g r₁ r₂ i₁ i₂ j₁ j₂
    ((IsScalarTower.toAlgHom k S₁ B).comp w₁)
    ((IsScalarTower.toAlgHom k S₂ B).comp w₂) ?_ ?_
  · refine Module.Grassmannian.ext ?_
    rw [hframe₁.1, hframe₂.1, heps₁]
  · refine Module.Grassmannian.ext ?_
    rw [hframe₁.2, hframe₂.2, heps₂]

variable {S : Type u} [CommRing S] [Algebra k S]

set_option maxHeartbeats 2400000 in
-- The tensor overlap carries both algebra towers and the pullback-Spec comparison.
include hO hchi in