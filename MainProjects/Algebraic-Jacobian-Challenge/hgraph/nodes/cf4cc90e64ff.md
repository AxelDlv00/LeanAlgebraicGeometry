---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.glueTripleFactor_transpose
docstring: '**Transpose of the triple-overlap base change** (triple mate core): the
  adjoint

  transpose along `ι_i` of the pullback-form triple base change is the canonical

  four-functor comparison of the triple square — the unit along `τ = t''_ipq ≫ fst`

  pushed forward along `f_pq ≫ ι_p`, regrouped by `pushforwardComp`, re-indexed by

  `pushforwardCongr` along `glueData_triple_square`, and ungrouped by

  `pushforwardComp⁻¹`. Cocycle-free site-level content; triple analogue of

  `glueOverlapFactor_transpose` (same proof). Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.glueTripleFactor_transpose
type: lean
updated: '2026-07-24T03:02:10'
---
lemma glueTripleFactor_transpose (D : Scheme.GlueData.{0}) (i p q : D.J)
    (N : (D.V (p, q)).Modules) :
    (Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).unit.app N) ≫
      (Scheme.Modules.pushforwardComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
        (D.f p q ≫ D.ι p)).hom.app
        ((Scheme.Modules.pullback
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) ≫
      (Scheme.Modules.pushforwardCongr (glueData_triple_square D i p q)).hom.app
        ((Scheme.Modules.pullback
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) ≫
      (Scheme.Modules.pushforwardComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
        (D.ι i)).inv.app
        ((Scheme.Modules.pullback
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N)
    = (Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).homEquiv
        ((Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).obj N)
        ((Scheme.Modules.pushforward (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)).obj
          ((Scheme.Modules.pullback
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N))
        ((glueTripleFactorIso D i p q N).hom) := by
  have hglue := glueData_triple_square D i p q
  -- RHS: expand the transpose in unit form; the `leftAdjointUniq` conjugation of the
  -- chart comparison cancels against the unit bridge, leaving the site-level `β_ipq`
  have hRHS : (Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).homEquiv
        ((Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).obj N)
        ((Scheme.Modules.pushforward (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)).obj
          ((Scheme.Modules.pullback
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N))
        ((glueTripleFactorIso D i p q N).hom)
      = (restrictAdjunction (D.ι i)).unit.app
          ((Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).obj N) ≫
        (Scheme.Modules.pushforward (D.ι i)).map
          ((glueTripleBaseChangeIso D i p q).hom.app N) ≫
        (Scheme.Modules.pushforward (D.ι i)).map
          ((Scheme.Modules.pushforward
            (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)).map
            ((restrictFunctorIsoPullback
              (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).hom.app N)) := by
    refine (Adjunction.homEquiv_unit _ _ _ _).trans ?_
    refine Eq.trans (eq_whisker
      (restrictAdjunction_unit_app_iso (D.ι i)
        ((Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).obj N)).symm _) ?_
    refine (Category.assoc _ _ _).trans (whisker_eq _ ?_)
    refine ((Scheme.Modules.pushforward (D.ι i)).map_comp _ _).symm.trans ?_
    refine Eq.trans (congrArg (Scheme.Modules.pushforward (D.ι i)).map ?_)
      ((Scheme.Modules.pushforward (D.ι i)).map_comp _ _)
    exact Iso.hom_inv_id_app_assoc (restrictFunctorIsoPullback (D.ι i)) _ _
  rw [hRHS]
  -- LHS: bridge the geometric unit at `τ` to the site-level unit; the emerging
  -- `restrictFunctorIsoPullback` factor migrates across the three casts by naturality
  have h_a : (Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).unit.app N)
      = (Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
          ((restrictAdjunction
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).unit.app N) ≫
        (Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
          ((Scheme.Modules.pushforward
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).map
            ((restrictFunctorIsoPullback
              (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).hom.app N)) :=
    (congrArg (Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
        (restrictAdjunction_unit_app_iso
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)) N).symm).trans
      ((Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map_comp _ _)
  have n₁ := (Scheme.Modules.pushforwardComp
      (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)) (D.f p q ≫ D.ι p)).hom.naturality
    ((restrictFunctorIsoPullback
      (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).hom.app N)
  have n₂ := (Scheme.Modules.pushforwardCongr hglue).hom.naturality
    ((restrictFunctorIsoPullback
      (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).hom.app N)
  have n₃ := (Scheme.Modules.pushforwardComp
      (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p) (D.ι i)).inv.naturality
    ((restrictFunctorIsoPullback
      (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).hom.app N)
  -- the site-level core: all four factors are concrete on sections; both sides are a
  -- single presheaf restriction along the triple opens identity
  have hcore : (Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
        ((restrictAdjunction
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).unit.app N) ≫
      (Scheme.Modules.pushforwardComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
        (D.f p q ≫ D.ι p)).hom.app
        ((restrictFunctor (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) ≫
      (Scheme.Modules.pushforwardCongr hglue).hom.app
        ((restrictFunctor (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) ≫
      (Scheme.Modules.pushforwardComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
        (D.ι i)).inv.app
        ((restrictFunctor (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N)
      = (restrictAdjunction (D.ι i)).unit.app
          ((Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).obj N) ≫
        (Scheme.Modules.pushforward (D.ι i)).map
          ((glueTripleBaseChangeIso D i p q).hom.app N) := by
    ext O x
    have htot : N.presheaf.map
          (homOfLE ((D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)).image_preimage_le
            ((D.f p q ≫ D.ι p) ⁻¹ᵁ O))).op ≫
        N.presheaf.map
          ((D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)).opensFunctor.map
            (eqToHom (show ((pullback.fst (D.f i p) (D.f i q) ≫ D.f i p) ≫ D.ι i) ⁻¹ᵁ O
                = ((D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)) ≫
                    (D.f p q ≫ D.ι p)) ⁻¹ᵁ O by
              rw [hglue]))).op
        = N.presheaf.map ((TopologicalSpace.Opens.map (D.f p q ≫ D.ι p).base).map
            (homOfLE ((D.ι i).image_preimage_le O))).op ≫
          N.presheaf.map
            (eqToHom (glueData_preimage_image_eq₃ D i p q ((D.ι i) ⁻¹ᵁ O)).symm).op := by
      rw [← Functor.map_comp, ← Functor.map_comp]
      exact congrArg N.presheaf.map (Subsingleton.elim _ _)
    exact congr($(htot) x)
  -- restate `h_a` with the composite-functor map (defeq) so `n₁` fires syntactically
  have h_a' : (Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).unit.app N)
      = (Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
          ((restrictAdjunction
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).unit.app N) ≫
        (Scheme.Modules.pushforward (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)) ⋙
          Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
          ((restrictFunctorIsoPullback
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).hom.app N) := h_a
  rw [h_a']
  -- inner chain: migrate the comparison factor through the three casts (`n₁`–`n₃`)
  have hmove : (Scheme.Modules.pushforward
        (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)) ⋙
        Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).map
        ((restrictFunctorIsoPullback
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).hom.app N) ≫
      (Scheme.Modules.pushforwardComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
        (D.f p q ≫ D.ι p)).hom.app
        ((Scheme.Modules.pullback
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) ≫
      (Scheme.Modules.pushforwardCongr hglue).hom.app
        ((Scheme.Modules.pullback
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) ≫
      (Scheme.Modules.pushforwardComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
        (D.ι i)).inv.app
        ((Scheme.Modules.pullback
          (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N)
      = (Scheme.Modules.pushforwardComp (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))
          (D.f p q ≫ D.ι p)).hom.app
          ((restrictFunctor (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) ≫
        (Scheme.Modules.pushforwardCongr hglue).hom.app
          ((restrictFunctor (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) ≫
        (Scheme.Modules.pushforwardComp (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)
          (D.ι i)).inv.app
          ((restrictFunctor (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) ≫
        (Scheme.Modules.pushforward (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p) ⋙
          Scheme.Modules.pushforward (D.ι i)).map
          ((restrictFunctorIsoPullback
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).hom.app N) :=
    (Category.assoc _ _ _).symm.trans ((eq_whisker n₁ _).trans
      ((Category.assoc _ _ _).trans (whisker_eq _
        ((Category.assoc _ _ _).symm.trans ((eq_whisker n₂ _).trans
          ((Category.assoc _ _ _).trans (whisker_eq _ n₃)))))))
  refine (Category.assoc _ _ _).trans ((whisker_eq _ hmove).trans ?_)
  refine ((whisker_eq _ ((whisker_eq _ (Category.assoc _ _ _).symm).trans
    (Category.assoc _ _ _).symm)).trans ?_)
  refine (Category.assoc _ _ _).symm.trans ?_
  refine (eq_whisker hcore _).trans ?_
  exact Category.assoc _ _ _