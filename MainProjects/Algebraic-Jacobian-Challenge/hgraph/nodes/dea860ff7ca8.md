---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.glueTripleFactor_mate
docstring: '**Mate recognition for the triple-overlap square**: for any `W` on the
  glued

  scheme and `m : W ⟶ (f_pq ≫ ι_p)_* N`, transposing `m` along `f_pq ≫ ι_p`, pulling

  back to the triple overlap along `τ = t''_ipq ≫ fst`, and re-indexing through the

  pullback-pseudofunctor casts of the triple square equals the transpose along

  `q = fst ≫ f_ip` of `ι_i^* m` composed with the triple base change in pullback form

  (`glueTripleFactorIso`). Triple analogue of `glueOverlapFactor_mate` (same proof,

  reducing to the mate core `glueTripleFactor_transpose`). Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.glueTripleFactor_mate
type: lean
updated: '2026-07-24T03:02:10'
---
lemma glueTripleFactor_mate (D : Scheme.GlueData.{0}) (i p q : D.J)
    (N : (D.V (p, q)).Modules) {W : D.glued.Modules}
    (m : W ⟶ (Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).obj N) :
    (Scheme.Modules.pullbackComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
        (D.ι i)).hom.app W ≫
      (Scheme.Modules.pullbackCongr (glueData_triple_square D i p q)).inv.app W ≫
      (Scheme.Modules.pullbackComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
        (D.f p q ≫ D.ι p)).inv.app W ≫
      (Scheme.Modules.pullback (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).map
        (((Scheme.Modules.pullbackPushforwardAdjunction
          (D.f p q ≫ D.ι p)).homEquiv W N).symm m)
    = ((Scheme.Modules.pullbackPushforwardAdjunction
          (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)).homEquiv
          ((Scheme.Modules.pullback (D.ι i)).obj W)
          ((Scheme.Modules.pullback
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N)).symm
        ((Scheme.Modules.pullback (D.ι i)).map m ≫
          (glueTripleFactorIso D i p q N).hom) := by
  have hglue := glueData_triple_square D i p q
  apply ((Scheme.Modules.pullbackPushforwardAdjunction
    (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)).homEquiv
    ((Scheme.Modules.pullback (D.ι i)).obj W)
    ((Scheme.Modules.pullback
      (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N)).injective
  refine Eq.trans ?_ (Equiv.apply_symm_apply _ _).symm
  apply ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).homEquiv _ _).injective
  -- right-hand side: peel `m` off by naturality of the transpose
  have hR : (Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).homEquiv _ _
        ((Scheme.Modules.pullback (D.ι i)).map m ≫ (glueTripleFactorIso D i p q N).hom)
      = m ≫ (Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).homEquiv _ _
          ((glueTripleFactorIso D i p q N).hom) :=
    Adjunction.homEquiv_naturality_left _ _ _
  -- the conjugate of `pullbackComp.hom` is `pushforwardComp.inv`
  have hcomm := CategoryTheory.conjugateEquiv_comm
    (adj₁ := (Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).comp
      (Scheme.Modules.pullbackPushforwardAdjunction
        (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)))
    (adj₂ := Scheme.Modules.pullbackPushforwardAdjunction
      ((pullback.fst (D.f i p) (D.f i q) ≫ D.f i p) ≫ D.ι i))
    (show (Scheme.Modules.pullbackComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
        (D.ι i)).hom ≫
        (Scheme.Modules.pullbackComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
          (D.ι i)).inv = 𝟙 _
      from (Scheme.Modules.pullbackComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
        (D.ι i)).hom_inv_id)
  rw [Scheme.Modules.conjugateEquiv_pullbackComp_inv] at hcomm
  have hConj : CategoryTheory.conjugateEquiv
        (Scheme.Modules.pullbackPushforwardAdjunction
          ((pullback.fst (D.f i p) (D.f i q) ≫ D.f i p) ≫ D.ι i))
        ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).comp
          (Scheme.Modules.pullbackPushforwardAdjunction
            (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)))
        (Scheme.Modules.pullbackComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
          (D.ι i)).hom
      = (Scheme.Modules.pushforwardComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
          (D.ι i)).inv :=
    (CategoryTheory.Iso.hom_comp_eq_id _).mp hcomm
  -- transpose of the inner chain along `τ ≫ (f_pq ≫ ι_p)`: fold the unit pair
  have h1 : (Scheme.Modules.pullbackPushforwardAdjunction
        ((D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)) ≫
          (D.f p q ≫ D.ι p))).homEquiv W
        ((Scheme.Modules.pullback
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N)
        ((Scheme.Modules.pullbackComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
          (D.f p q ≫ D.ι p)).inv.app W ≫
          (Scheme.Modules.pullback
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).map
            (((Scheme.Modules.pullbackPushforwardAdjunction
              (D.f p q ≫ D.ι p)).homEquiv W N).symm m))
      = m ≫ ((Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
          ((Scheme.Modules.pullbackPushforwardAdjunction
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).unit.app N) ≫
        (Scheme.Modules.pushforwardComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
          (D.f p q ≫ D.ι p)).hom.app
          ((Scheme.Modules.pullback
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N)) := by
    have h := homEquiv_comp_unit_pushforwardComp
      (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)) (D.f p q ≫ D.ι p)
      (((Scheme.Modules.pullbackPushforwardAdjunction
        (D.f p q ≫ D.ι p)).homEquiv W N).symm m)
    rw [Equiv.apply_symm_apply] at h
    exact h.symm
  -- re-index along the triple square
  have h2 := homEquiv_comp_pushforwardCongr hglue
    (W := W)
    (y := (Scheme.Modules.pullbackComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
        (D.f p q ≫ D.ι p)).inv.app W ≫
      (Scheme.Modules.pullback (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).map
        (((Scheme.Modules.pullbackPushforwardAdjunction
          (D.f p q ≫ D.ι p)).homEquiv W N).symm m))
  -- the double transpose of the full cast chain
  have hstar := homEquiv_conjugateEquiv_app
    (Scheme.Modules.pullbackPushforwardAdjunction
      ((pullback.fst (D.f i p) (D.f i q) ≫ D.f i p) ≫ D.ι i))
    ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).comp
      (Scheme.Modules.pullbackPushforwardAdjunction
        (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)))
    (Scheme.Modules.pullbackComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
      (D.ι i)).hom
    (f := (Scheme.Modules.pullbackCongr hglue).inv.app W ≫
      (Scheme.Modules.pullbackComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
        (D.f p q ≫ D.ι p)).inv.app W ≫
      (Scheme.Modules.pullback (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).map
        (((Scheme.Modules.pullbackPushforwardAdjunction
          (D.f p q ≫ D.ι p)).homEquiv W N).symm m))
  rw [hConj] at hstar
  -- assemble: LHS double transpose = m ≫ (four-functor comparison) = m ≫ transpose β₃
  refine Eq.trans ?_ hR.symm
  refine Eq.trans (?_ : _ = ((Scheme.Modules.pullbackPushforwardAdjunction
      ((pullback.fst (D.f i p) (D.f i q) ≫ D.f i p) ≫ D.ι i)).homEquiv W _
      ((Scheme.Modules.pullbackCongr hglue).inv.app W ≫
        (Scheme.Modules.pullbackComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
          (D.f p q ≫ D.ι p)).inv.app W ≫
        (Scheme.Modules.pullback (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).map
          (((Scheme.Modules.pullbackPushforwardAdjunction
            (D.f p q ≫ D.ι p)).homEquiv W N).symm m)) ≫
      (Scheme.Modules.pushforwardComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
        (D.ι i)).inv.app
        ((Scheme.Modules.pullback
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N))) ?_
  · -- the composite-adjunction transpose computes the nested transposes
    refine Eq.trans ?_ hstar
    rw [Adjunction.comp_homEquiv]
    rfl
  · -- substitute `h2`, then `h1`, regroup, and finish with the mate core
    rw [← h2]
    exact (eq_whisker (eq_whisker h1 _) _).trans
      ((eq_whisker (Category.assoc _ _ _) _).trans
        ((Category.assoc _ _ _).trans (whisker_eq m
          ((eq_whisker (Category.assoc _ _ _) _).trans
            ((Category.assoc _ _ _).trans ((whisker_eq _ (Category.assoc _ _ _)).trans
              (glueTripleFactor_transpose D i p q N)))))))