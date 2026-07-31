---
author: sync
content_type: theorem
created: '2026-07-19T10:01:15'
decl: AlgebraicGeometry.divClassify
docstring: '**`divClassify` — the G-5 keystone** (`informal/w4-g5-worksheet.md` §4,

  Noetherian-free per w4-ddr9 §0.4): a divisor family `F` of degree `g` over an affine

  test `S` whose ε pair satisfies the carve `(♦)` factors through `DivScheme g` by
  a

  **unique** morphism `v : Spec S ⟶ DivScheme g`, characterized by: for EVERY

  localization `Localization.Away f₀` carrying a pair-chart framing `(i, j, w)` of
  the

  restricted ε pair, the restriction of `v` composes with `divSchemeι` to the chart

  morphism of the framing.  The clause is stable under further localization by

  construction (its proof at any `f₀` is the W3 pullback-cover comparison).


  Existence: `Scheme.Cover.glueMorphisms` of the per-piece classifications

  (`divClassifyLocal`) over the frame cover (`divFamEps_exists_frameCover`), glued
  by

  W3; the clause at arbitrary `(f₀, i, j, w)` is `Scheme.Cover.hom_ext` on the pullback

  cover of `Spec (Away f₀)` along the frame cover, with W3 at `(f₀, f t)`.

  Uniqueness: any two clause-satisfiers agree on each frame-cover piece

  (`divScheme_hom_ext`), hence agree (`Scheme.Cover.hom_ext`).'
file: AlgebraicJacobian/Picard/DivSchemeClassifyGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divClassify
type: lean
updated: '2026-07-31T20:15:21'
---
theorem divClassify (F : DivFam C S π g)
    (hcarve : ∀ a : ↥(divisorSections k
        (windowS_choice π hπ g • fiberWeilDivisor π) ⊤),
      carvePairArrow (windowShiftMul hπ g a)
        (divFamEps hπ g F).1 (divFamEps hπ g F).2 = 0) :
    ∃! v : Spec (CommRingCat.of S) ⟶
        DivScheme k (windowS_choice π hπ g • fiberWeilDivisor π)
          (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
          (b₂.map (windowShiftEquiv hπ g).symm),
      ∀ (f₀ : S) (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)
        (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] Localization.Away f₀),
        (Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)).toSubmodule
            = Submodule.map
                (LinearMap.baseChange (Localization.Away f₀) b₁.equivFun.toLinearMap)
                (divFamEps hπ g (DivFam.mapAlg (Localization.Away f₀) g F)).1 →
        (Module.Grassmannian.map w (pairTautSnd k g r₁ r₂ i j)).toSubmodule
            = Submodule.map
                (LinearMap.baseChange (Localization.Away f₀) b₂.equivFun.toLinearMap)
                (divFamEps hπ g (DivFam.mapAlg (Localization.Away f₀) g F)).2 →
        Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away f₀)))
            ≫ v ≫ divSchemeι k (windowS_choice π hπ g • fiberWeilDivisor π)
              (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
              (b₂.map (windowShiftEquiv hπ g).symm)
          = Spec.map (CommRingCat.ofHom w.toRingHom)
              ≫ pairChartMap k g r₁ g r₂ i j := by
  -- the frame cover and its per-piece classifications
  obtain ⟨m, f, hspan, hdata⟩ :=
    divFamEps_exists_frameCover hπ g hO hχ r₁ r₂ b₁ b₂ F
  choose ci cj cw hw₁ hw₂ using hdata
  have hv : ∀ t : Fin m, ∃ vt : Spec (CommRingCat.of (Localization.Away (f t))) ⟶
      DivScheme k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hπ g).symm),
      vt ≫ divSchemeι k (windowS_choice π hπ g • fiberWeilDivisor π)
          (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
          (b₂.map (windowShiftEquiv hπ g).symm)
        = Spec.map (CommRingCat.ofHom (cw t).toRingHom)
            ≫ pairChartMap k g r₁ g r₂ (ci t) (cj t) := fun t =>
    (divClassifyLocal hπ g hO hχ r₁ r₂ b₁ b₂ F hcarve (Localization.Away (f t))
      (ci t) (cj t) (cw t) (hw₁ t) (hw₂ t)).exists
  choose v hveq using hv
  -- the gluing obligation, by W3 on each double overlap
  have hglue : ∀ t t' : Fin m,
      pullback.fst ((Scheme.affineOpenCoverOfSpanRangeEqTop
          (R := CommRingCat.of S) f hspan).openCover.f t)
        ((Scheme.affineOpenCoverOfSpanRangeEqTop
          (R := CommRingCat.of S) f hspan).openCover.f t') ≫ v t
      = pullback.snd _ _ ≫ v t' := fun t t' =>
    pullback_chartFactor_compat hπ g hO hχ r₁ r₂ b₁ b₂ F (f t) (f t')
      (cw t) (cw t') (hw₁ t) (hw₂ t) (hw₁ t') (hw₂ t') (v t) (hveq t) (v t') (hveq t')
  refine ⟨(Scheme.affineOpenCoverOfSpanRangeEqTop
    (R := CommRingCat.of S) f hspan).openCover.glueMorphisms v hglue, ?_, ?_⟩
  · -- the clause at arbitrary `(f₀, i, j, w, hw₁, hw₂)`: the pullback-cover comparison
    intro f₀ i j w hwf₁ hwf₂
    refine Scheme.Cover.hom_ext
      ((Scheme.affineOpenCoverOfSpanRangeEqTop
        (R := CommRingCat.of S) f hspan).openCover.pullback₁
        (Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away f₀)))))
      _ _ fun t => ?_
    change pullback.fst _ _ ≫ _ = pullback.fst _ _ ≫ _
    rw [← Category.assoc, pullback.condition, Category.assoc,
      Scheme.Cover.ι_glueMorphisms_assoc, hveq t]
    exact (pullback_chartMap_compat hπ g hO hχ r₁ r₂ b₁ b₂ F f₀ (f t) w (cw t)
      hwf₁ hwf₂ (hw₁ t) (hw₂ t)).symm
  · -- uniqueness: any clause-satisfier agrees with the glue on each piece
    intro v' hv'
    refine Scheme.Cover.hom_ext
      (Scheme.affineOpenCoverOfSpanRangeEqTop
        (R := CommRingCat.of S) f hspan).openCover _ _ fun t => ?_
    refine divScheme_hom_ext k _ _ g r₁ r₂ b₁ (b₂.map (windowShiftEquiv hπ g).symm)
      _ _ ?_
    rw [Category.assoc, Category.assoc, Scheme.Cover.ι_glueMorphisms_assoc, hveq t]
    exact hv' (f t) (ci t) (cj t) (cw t) (hw₁ t) (hw₂ t)