---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.presentedMatrix_tautological
docstring: '**The tautological quotient is presented by the universal matrix**: over
  the `I`-th

  chart, the matrix presenting the tautological quotient (against its own inverted
  chart

  composite) is the `Γ`-image of the universal matrix `X^I`. The taut-specific layer
  of

  the `represents` inverse laws. Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.presentedMatrix_tautological
type: lean
updated: '2026-07-16T21:14:27'
---
lemma presentedMatrix_tautological (d r : ℕ) (I : (theGlueData d r).J) :
    presentedMatrix (tautologicalRankQuotient d r) ((theGlueData d r).ι I) I.1 I.2
        (hcI := isIso_pullback_chartComposite_tautological d r I)
      = (universalMatrix d r I.1 I.2).map
          ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
            (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ))).inv) := by
  apply matrixEndRect_injective
  letI E := Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι I) (Fin r)
  letI Dd := Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι I) (Fin d)
  letI Φ := universalQuotient_restrictionIso d r I
  letI cqm := chartQuotientMap d r I.1 I.2
  -- the inverse of the pulled-back chart composite, explicitly
  have hinv : @CategoryTheory.inv _ _ _ _
        ((Scheme.Modules.pullback ((theGlueData d r).ι I)).map
          (chartComposite (tautologicalRankQuotient d r) I.1 I.2))
        (isIso_pullback_chartComposite_tautological d r I)
      = Φ.hom ≫ Dd.inv := by
    apply IsIso.inv_eq_of_hom_inv_id
    -- `(Dd.hom ≫ Φ.inv) ≫ Φ.hom ≫ Dd.inv = 𝟙` (term-mode under the diamond)
    exact (congrArg (· ≫ (Φ.hom ≫ Dd.inv))
        (pullback_map_chartComposite_tautological d r I)).trans
      ((Category.assoc _ _ _).trans
        ((congrArg (Dd.hom ≫ ·) (Iso.inv_hom_id_assoc Φ Dd.inv)).trans Dd.hom_inv_id))
  have hq : (Scheme.Modules.pullback ((theGlueData d r).ι I)).map
        ((tautologicalRankQuotient d r).q)
      = (E.hom ≫ cqm) ≫ Φ.inv :=
    (Iso.eq_comp_inv _).mpr (pullback_map_tautologicalQuotient d r I)
  have hBC : (Φ.hom ≫ Dd.inv) ≫ Dd.hom = Φ.hom :=
    (Category.assoc _ _ _).trans
      ((congrArg (Φ.hom ≫ ·) Dd.inv_hom_id).trans (Category.comp_id _))
  have hA : ((E.hom ≫ cqm) ≫ Φ.inv) ≫ Φ.hom = E.hom ≫ cqm :=
    (Category.assoc _ _ _).trans
      ((congrArg ((E.hom ≫ cqm) ≫ ·) Φ.inv_hom_id).trans (Category.comp_id _))
  -- assemble entirely by `.trans` (junction unification is up-to-defeq, which crosses
  -- the hidden-instance mismatches that block `rw`/`set` here)
  exact (matrixEndRect_presentedMatrix (tautologicalRankQuotient d r)
      ((theGlueData d r).ι I) I.1 I.2
      (hcI := isIso_pullback_chartComposite_tautological d r I)).trans
    ((congrArg (fun z => E.inv ≫
        (Scheme.Modules.pullback ((theGlueData d r).ι I)).map
          ((tautologicalRankQuotient d r).q) ≫ z ≫ Dd.hom) hinv).trans
      ((congrArg (fun z => E.inv ≫ z ≫ (Φ.hom ≫ Dd.inv) ≫ Dd.hom) hq).trans
        ((congrArg (fun z => E.inv ≫ ((E.hom ≫ cqm) ≫ Φ.inv) ≫ z) hBC).trans
          ((congrArg (E.inv ≫ ·) hA).trans
            ((Iso.inv_hom_id_assoc E cqm).trans
              (chartQuotientMap_eq_matrixEndRect d r I.1 I.2))))))

/-! ### Chart data of a pulled-back quotient: the locus-level bridge

The two inverse laws of `represents` compare the chart data of `rqPullback ψ y` on `T'`
with the `ψ`-pullback of the chart data of `y` on `T`. `chartComposite_rqPullback` is the
morphism-level bridge; `chartLocus_rqPullback` below is the locus-level bridge. -/