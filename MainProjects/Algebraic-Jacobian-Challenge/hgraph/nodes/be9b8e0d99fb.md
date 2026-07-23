---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.baseChange_bridge_transition
docstring: '**Triple-transition bridge to `Θ_{IJ}`** (`lem:gr_baseChange_bridge_transition`):
  the

  global-sections base-change map of the composite `t''_{IJK} ≫ p^{JK}_{JKI} : V_IJK
  ⟶ U^J_K`,

  transported through the affine identifications, is the localised cocycle homomorphism

  `Θ_{IJ} ∘ awayInclRight (P^J_I) (P^J_K)` — exactly the composite over which the
  matrix

  cocycle L1 (`bundleTransition_cocycle_matrix`) takes the `(J,K)`-Cramer inverse.
  The

  order-swap `awayMulCommEquiv` of `chartTransition''` is absorbed by

  `awayMulCommEquiv_comp_awayInclLeft`. Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.baseChange_bridge_transition
type: lean
updated: '2026-07-16T21:14:27'
---
lemma baseChange_bridge_transition (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away (minorDet d r J K hJ hK)))).inv ≫
        Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r J K hJ hK))))
          (chartTransition' d r I J K hI hJ hK ≫
            Limits.pullback.fst (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI))
      = CommRingCat.ofHom ((cocycleΘIJ d r I J K hI hJ hK).comp
          (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))) ≫
        tripleOverlapSections d r I J K hI hJ hK := by
  have hfst : (awayPullbackIso (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).inv ≫
        Limits.pullback.fst (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI)
      = Spec.map (CommRingCat.ofHom
          (awayInclLeft (minorDet d r J K hJ hK) (minorDet d r J I hJ hI))) :=
    awayPullbackIso_inv_fst _ _
  have hp : chartTransition' d r I J K hI hJ hK ≫
        Limits.pullback.fst (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI)
      = (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom ≫
        Spec.map (CommRingCat.ofHom ((cocycleΘIJ d r I J K hI hJ hK).comp
          (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))) := by
    rw [chartTransition']
    simp only [Category.assoc]
    -- `erw` (defeq matching) to fire the fst-leg lemma through the `HasPullback` instance
    -- diamond on the heavy localisation objects (the Cells `chartTransition'_fac` precedent)
    erw [hfst]
    -- collapse the three `Spec.map`s in a fresh homogeneous `have` (positional `rw` cannot
    -- see the `Spec.map ≫ Spec.map` nodes after the erw), then transport by `congrArg`
    have htail : Spec.map (CommRingCat.ofHom (cocycleΘIJ d r I J K hI hJ hK)) ≫
          Spec.map (CommRingCat.ofHom
            (awayMulCommEquiv (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).toRingHom) ≫
          Spec.map (CommRingCat.ofHom
            (awayInclLeft (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)))
        = Spec.map (CommRingCat.ofHom ((cocycleΘIJ d r I J K hI hJ hK).comp
            (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))) := by
      rw [← Spec.map_comp, ← Spec.map_comp, ← CommRingCat.ofHom_comp,
        ← CommRingCat.ofHom_comp, awayMulCommEquiv_comp_awayInclLeft]
    exact congrArg
      ((awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom ≫ ·) htail
  -- `rw [hp]` cannot find the composite under `appTop` (comp-node instance mismatch);
  -- transport by `congrArg` instead, then proceed as in `baseChange_bridge_left`.
  refine (congrArg (fun m => (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
    (minorDet d r J K hJ hK)))).inv ≫ Scheme.Hom.appTop m) hp).trans ?_
  rw [Scheme.Hom.comp_appTop]
  -- term-mode reassociation (see `baseChange_bridge_left`)
  exact (Category.assoc _ _ _).symm.trans ((congrArg
    (· ≫ Scheme.Hom.appTop
      (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom)
    (baseChange_bridge_gammaSpec (CommRingCat.ofHom ((cocycleΘIJ d r I J K hI hJ hK).comp
      (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))))).trans
    (Category.assoc _ _ _))