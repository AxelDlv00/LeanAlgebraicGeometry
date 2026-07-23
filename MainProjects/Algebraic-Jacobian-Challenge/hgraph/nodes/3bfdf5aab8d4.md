---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.rqPullback_grPointOfRankQuotient_rel
docstring: '**Pulling the tautological pair back along the glued morphism recovers
  `x`**

  (`thm:grassmannian_universal_property`, the `right_inv` law): the equivalence witness
  is

  assembled with no descent gluing — over each chart locus both quotients are presented
  by

  the same matrix (`pullback_map_rqPullback_grPoint_eq`), so each kernel annihilates
  the

  opposite quotient (`pullback_map_cover_faithful` over `chartLocus_isOpenCover`);
  the two

  `Abelian.epiDesc` descents are mutually inverse by epi-cancellation. Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.rqPullback_grPointOfRankQuotient_rel
type: lean
updated: '2026-07-16T21:14:27'
---
lemma rqPullback_grPointOfRankQuotient_rel {T : Scheme.{0}} (d r : ℕ)
    (x : RankQuotient r d T) :
    (rqPullback (grPointOfRankQuotient d r x) (tautologicalRankQuotient d r)).Rel x := by
  haveI hex' : Epi ((rqPullback (grPointOfRankQuotient d r x)
      (tautologicalRankQuotient d r)).q) :=
    (rqPullback (grPointOfRankQuotient d r x) (tautologicalRankQuotient d r)).epi
  haveI hex : Epi x.q := x.epi
  -- the chart-locus invertibility instances
  haveI hinst : ∀ I : (theGlueData d r).J,
      IsIso ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
        (chartComposite (rqPullback (grPointOfRankQuotient d r x)
          (tautologicalRankQuotient d r)) I.1 I.2)) := fun I =>
    isIso_pullback_map_of_le _ (chartLocus_le_chartLocus_rqPullback_grPoint d r x I)
      (isIso_pullback_isoLocus_map _)
  -- each kernel annihilates the opposite quotient, chart-locally
  have hker1 : kernel.ι ((rqPullback (grPointOfRankQuotient d r x)
        (tautologicalRankQuotient d r)).q) ≫ x.q = 0 := by
    refine pullback_map_cover_faithful (chartLocus_isOpenCover d r x) (fun I => ?_)
    haveI := hinst I
    have heq := pullback_map_rqPullback_grPoint_eq d r x I
    -- `x.q` through the shared presentation
    have hxq : (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map x.q
        = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q) ≫
          (inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (chartComposite (rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)) I.1 I.2)) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite x I.1 I.2)) := by
      calc (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map x.q
          = ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map x.q ≫
              inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
                (chartComposite x I.1 I.2))) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite x I.1 I.2) := by
            rw [Category.assoc, IsIso.inv_hom_id, Category.comp_id]
        _ = ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              ((rqPullback (grPointOfRankQuotient d r x)
                (tautologicalRankQuotient d r)).q) ≫
              inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
                (chartComposite (rqPullback (grPointOfRankQuotient d r x)
                  (tautologicalRankQuotient d r)) I.1 I.2))) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite x I.1 I.2) :=
            congrArg (· ≫ (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite x I.1 I.2)) heq.symm
        _ = _ := Category.assoc _ _ _
    calc (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
          (kernel.ι ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q) ≫ x.q)
        = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (kernel.ι ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q)) ≫
          (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map x.q :=
          (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map_comp _ _
      _ = ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (kernel.ι ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q)) ≫
          (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q)) ≫
          (inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (chartComposite (rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)) I.1 I.2)) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite x I.1 I.2)) :=
          (congrArg ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (kernel.ι ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q)) ≫ ·) hxq).trans
            (Category.assoc _ _ _).symm
      _ = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (kernel.ι ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q) ≫
              (rqPullback (grPointOfRankQuotient d r x)
                (tautologicalRankQuotient d r)).q) ≫
          (inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (chartComposite (rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)) I.1 I.2)) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite x I.1 I.2)) :=
          congrArg (· ≫ _)
            ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map_comp _ _).symm
      _ = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map 0 ≫
          (inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (chartComposite (rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)) I.1 I.2)) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite x I.1 I.2)) :=
          congrArg (· ≫ _)
            (congrArg (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (kernel.condition ((rqPullback (grPointOfRankQuotient d r x) (tautologicalRankQuotient d r)).q)))
      _ = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map 0 := by
          rw [Functor.map_zero, zero_comp, Functor.map_zero]
  have hker2 : kernel.ι x.q ≫ (rqPullback (grPointOfRankQuotient d r x)
        (tautologicalRankQuotient d r)).q = 0 := by
    refine pullback_map_cover_faithful (chartLocus_isOpenCover d r x) (fun I => ?_)
    haveI := hinst I
    have heq := pullback_map_rqPullback_grPoint_eq d r x I
    have hxq' : (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
          ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q)
        = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map x.q ≫
          (inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (chartComposite x I.1 I.2)) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite (rqPullback (grPointOfRankQuotient d r x)
                (tautologicalRankQuotient d r)) I.1 I.2)) := by
      calc (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q)
          = ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              ((rqPullback (grPointOfRankQuotient d r x)
                (tautologicalRankQuotient d r)).q) ≫
              inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
                (chartComposite (rqPullback (grPointOfRankQuotient d r x)
                  (tautologicalRankQuotient d r)) I.1 I.2))) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite (rqPullback (grPointOfRankQuotient d r x)
                (tautologicalRankQuotient d r)) I.1 I.2) := by
            rw [Category.assoc, IsIso.inv_hom_id, Category.comp_id]
        _ = ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map x.q ≫
              inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
                (chartComposite x I.1 I.2))) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite (rqPullback (grPointOfRankQuotient d r x)
                (tautologicalRankQuotient d r)) I.1 I.2) :=
            congrArg (· ≫ _) heq
        _ = _ := Category.assoc _ _ _
    calc (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
          (kernel.ι x.q ≫ (rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q)
        = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map (kernel.ι x.q) ≫
          (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q) :=
          (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map_comp _ _
      _ = ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map (kernel.ι x.q) ≫
          (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map x.q) ≫
          (inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (chartComposite x I.1 I.2)) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite (rqPullback (grPointOfRankQuotient d r x)
                (tautologicalRankQuotient d r)) I.1 I.2)) :=
          (congrArg ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (kernel.ι x.q) ≫ ·) hxq').trans (Category.assoc _ _ _).symm
      _ = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (kernel.ι x.q ≫ x.q) ≫
          (inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (chartComposite x I.1 I.2)) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite (rqPullback (grPointOfRankQuotient d r x)
                (tautologicalRankQuotient d r)) I.1 I.2)) :=
          congrArg (· ≫ _)
            ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map_comp _ _).symm
      _ = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map 0 ≫
          (inv ((Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
            (chartComposite x I.1 I.2)) ≫
            (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map
              (chartComposite (rqPullback (grPointOfRankQuotient d r x)
                (tautologicalRankQuotient d r)) I.1 I.2)) :=
          congrArg (· ≫ _)
            (congrArg (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map (kernel.condition x.q))
      _ = (Scheme.Modules.pullback (chartLocus x I.1 I.2).ι).map 0 := by
          rw [Functor.map_zero, zero_comp, Functor.map_zero]
  -- the two epi-descents are mutually inverse
  have hfg : Abelian.epiDesc ((rqPullback (grPointOfRankQuotient d r x)
        (tautologicalRankQuotient d r)).q) x.q hker1 ≫
        Abelian.epiDesc x.q ((rqPullback (grPointOfRankQuotient d r x)
          (tautologicalRankQuotient d r)).q) hker2
      = 𝟙 _ := by
    rw [← cancel_epi ((rqPullback (grPointOfRankQuotient d r x)
      (tautologicalRankQuotient d r)).q)]
    calc (rqPullback (grPointOfRankQuotient d r x) (tautologicalRankQuotient d r)).q ≫
          (Abelian.epiDesc ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q) x.q hker1 ≫
            Abelian.epiDesc x.q ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q) hker2)
        = ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q ≫
            Abelian.epiDesc ((rqPullback (grPointOfRankQuotient d r x)
              (tautologicalRankQuotient d r)).q) x.q hker1) ≫
          Abelian.epiDesc x.q ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q) hker2 := (Category.assoc _ _ _).symm
      _ = x.q ≫ Abelian.epiDesc x.q ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q) hker2 :=
          congrArg (· ≫ Abelian.epiDesc x.q _ hker2) (Abelian.comp_epiDesc _ _ _)
      _ = (rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q := Abelian.comp_epiDesc _ _ _
      _ = (rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q ≫ 𝟙 _ := (Category.comp_id _).symm
  have hgf : Abelian.epiDesc x.q ((rqPullback (grPointOfRankQuotient d r x)
        (tautologicalRankQuotient d r)).q) hker2 ≫
        Abelian.epiDesc ((rqPullback (grPointOfRankQuotient d r x)
          (tautologicalRankQuotient d r)).q) x.q hker1
      = 𝟙 _ := by
    rw [← cancel_epi x.q]
    calc x.q ≫ (Abelian.epiDesc x.q ((rqPullback (grPointOfRankQuotient d r x)
          (tautologicalRankQuotient d r)).q) hker2 ≫
          Abelian.epiDesc ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q) x.q hker1)
        = (x.q ≫ Abelian.epiDesc x.q ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q) hker2) ≫
          Abelian.epiDesc ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q) x.q hker1 := (Category.assoc _ _ _).symm
      _ = (rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q ≫
          Abelian.epiDesc ((rqPullback (grPointOfRankQuotient d r x)
            (tautologicalRankQuotient d r)).q) x.q hker1 :=
          congrArg (· ≫ Abelian.epiDesc _ x.q hker1) (Abelian.comp_epiDesc _ _ _)
      _ = x.q := Abelian.comp_epiDesc _ _ _
      _ = x.q ≫ 𝟙 _ := (Category.comp_id _).symm
  exact ⟨⟨Abelian.epiDesc ((rqPullback (grPointOfRankQuotient d r x)
      (tautologicalRankQuotient d r)).q) x.q hker1,
    Abelian.epiDesc x.q ((rqPullback (grPointOfRankQuotient d r x)
      (tautologicalRankQuotient d r)).q) hker2, hfg, hgf⟩,
    Abelian.comp_epiDesc _ _ _⟩