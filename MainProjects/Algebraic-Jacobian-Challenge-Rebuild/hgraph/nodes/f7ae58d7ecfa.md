---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.pullback_chart_divClassifyAff_compat
docstring: 'A framed widened representative over an arbitrary test agrees on the pullback
  overlap with

  the local classification of any other representative of the same widened class.'
file: AlgebraicJacobian/Picard/DivRepClassifyZarAffCompat.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pullback_chart_divClassifyAff_compat
type: lean
updated: '2026-08-02T07:12:49'
---
theorem pullback_chart_divClassifyAff_compat (F₀ : DivFamZarAff C S g)
    {T : Type u} [CommRing T] [Algebra k T] [Algebra S T] [IsScalarTower k S T]
    (G : CertifiedDivisorFamilyAff C T g)
    (hZG : G.toZarAff = DivFamZarAff.mapAlg T g F₀)
    {i : (glueData k g r₁).J} {j : (glueData k g r₂).J}
    (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] T)
    (hw : G.IsPairChartFramed hpi g b₁ b₂ i j w)
    {A : Type u} [CommRing A] [Algebra k A] [Algebra S A] [IsScalarTower k S A]
    (F₂ : CertifiedDivisorFamilyAff C A g)
    (hZ₂ : F₂.toZarAff = DivFamZarAff.mapAlg A g F₀)
    {i₂ : (glueData k g r₁).J} {j₂ : (glueData k g r₂).J}
    (w₂ : PairChartRing k g r₁ g r₂ i₂ j₂ →ₐ[k] A)
    (hw₂ : F₂.IsPairChartFramed hpi g b₁ b₂ i₂ j₂ w₂)
    {v₂ : Spec (CommRingCat.of A) ⟶
      DivScheme k (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hpi g).symm)}
    (hv₂ : v₂ ≫ divSchemeι k (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hpi g).symm)
      = Spec.map (CommRingCat.ofHom w₂.toRingHom)
          ≫ pairChartMap k g r₁ g r₂ i₂ j₂) :
    pullback.fst (Spec.map (CommRingCat.ofHom (algebraMap S T)))
        (Spec.map (CommRingCat.ofHom (algebraMap S A)))
        ≫ Spec.map (CommRingCat.ofHom w.toRingHom)
        ≫ pairChartMap k g r₁ g r₂ i j
      = pullback.snd (Spec.map (CommRingCat.ofHom (algebraMap S T)))
          (Spec.map (CommRingCat.ofHom (algebraMap S A)))
          ≫ v₂ ≫ divSchemeι k
            (windowS_choice pi hpi g • fiberWeilDivisor pi)
            (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
            (b₂.map (windowShiftEquiv hpi g).symm) := by
  let u := (G.existsUnique_divClassify hpi g r₁ r₂ b₁ b₂ w hw).choose
  have hu := (G.existsUnique_divClassify hpi g r₁ r₂ b₁ b₂ w hw).choose_spec.1
  have hcompat := pullback_divClassifyAff_compat hpi g hO hchi r₁ r₂ b₁ b₂
    F₀ G F₂ hZG hZ₂ w w₂ hw hw₂ hu hv₂
  calc
    _ = pullback.fst (Spec.map (CommRingCat.ofHom (algebraMap S T)))
          (Spec.map (CommRingCat.ofHom (algebraMap S A))) ≫
          (u ≫ divSchemeι k (windowS_choice pi hpi g • fiberWeilDivisor pi)
            (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
            (b₂.map (windowShiftEquiv hpi g).symm)) := by
        rw [hu]
    _ = (pullback.fst (Spec.map (CommRingCat.ofHom (algebraMap S T)))
          (Spec.map (CommRingCat.ofHom (algebraMap S A))) ≫ u) ≫
          divSchemeι k (windowS_choice pi hpi g • fiberWeilDivisor pi)
            (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
            (b₂.map (windowShiftEquiv hpi g).symm) := by
        rw [Category.assoc]
    _ = (pullback.snd (Spec.map (CommRingCat.ofHom (algebraMap S T)))
          (Spec.map (CommRingCat.ofHom (algebraMap S A))) ≫ v₂) ≫
          divSchemeι k (windowS_choice pi hpi g • fiberWeilDivisor pi)
            (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
            (b₂.map (windowShiftEquiv hpi g).symm) :=
        congrArg (fun z => z ≫ divSchemeι k
          (windowS_choice pi hpi g • fiberWeilDivisor pi)
          (windowM_choice pi hpi g • fiberWeilDivisor pi) g r₁ r₂ b₁
          (b₂.map (windowShiftEquiv hpi g).symm)) hcompat
    _ = _ := by rw [Category.assoc]