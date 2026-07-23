---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.glueLegB_component_transpose
docstring: '**Transpose of the second descent-leg factor** along the composite overlap

  immersion `f_pq ≫ ι_p`: the `bComp`-factor of `glueLegB` (unit along `t_pq ≫ f_qp`,

  `pushforwardComp`, pushforward of `g_pq⁻¹`, `pushforwardCongr`) transposes to the

  pseudofunctor casts, the pullback of the geometric counit, and `g_pq⁻¹`. Companion
  of

  `glueLegA_component_transpose`, via `homEquiv_comp_pushforwardCongr` and the

  transpose naturality in the right argument. Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.glueLegB_component_transpose
type: lean
updated: '2026-07-16T21:14:27'
---
lemma glueLegB_component_transpose (p q : D.J) :
    ((Scheme.Modules.pullbackPushforwardAdjunction (D.f p q ≫ D.ι p)).homEquiv
        ((Scheme.Modules.pushforward (D.ι q)).obj (M q))
        ((Scheme.Modules.pullback (D.f p q)).obj (M p))).symm
        ((Scheme.Modules.pushforward (D.ι q)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction
              (D.t p q ≫ D.f q p)).unit.app (M q)) ≫
          (Scheme.Modules.pushforwardComp (D.t p q ≫ D.f q p) (D.ι q)).hom.app
            ((Scheme.Modules.pullback (D.t p q ≫ D.f q p)).obj (M q)) ≫
          (Scheme.Modules.pushforward
            ((D.t p q ≫ D.f q p) ≫ D.ι q)).map (g p q).inv ≫
          (Scheme.Modules.pushforwardCongr
            (show (D.t p q ≫ D.f q p) ≫ D.ι q = D.f p q ≫ D.ι p by
              rw [Category.assoc]; exact D.glue_condition p q)).hom.app
            ((Scheme.Modules.pullback (D.f p q)).obj (M p)))
      = (Scheme.Modules.pullbackCongr
            (show (D.t p q ≫ D.f q p) ≫ D.ι q = D.f p q ≫ D.ι p by
              rw [Category.assoc]; exact D.glue_condition p q)).inv.app
          ((Scheme.Modules.pushforward (D.ι q)).obj (M q)) ≫
        (Scheme.Modules.pullbackComp (D.t p q ≫ D.f q p) (D.ι q)).inv.app
          ((Scheme.Modules.pushforward (D.ι q)).obj (M q)) ≫
        ((Scheme.Modules.pullback (D.t p q ≫ D.f q p)).map
          ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι q)).counit.app (M q)) ≫
          (g p q).inv) := by
  rw [Equiv.symm_apply_eq]
  have hpq : (D.t p q ≫ D.f q p) ≫ D.ι q = D.f p q ≫ D.ι p := by
    rw [Category.assoc]; exact D.glue_condition p q
  -- transpose of the unit pair at `(t_pq ≫ f_qp, ι_q)`: the counit trick of
  -- `glueLegA_component_transpose`
  have hε : (Scheme.Modules.pullbackPushforwardAdjunction (D.ι q)).homEquiv
        ((Scheme.Modules.pushforward (D.ι q)).obj (M q)) (M q)
        ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι q)).counit.app (M q))
      = 𝟙 ((Scheme.Modules.pushforward (D.ι q)).obj (M q)) :=
    (Adjunction.homEquiv_unit _ _ _ _).trans
      ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι q)).right_triangle_components
        (M q))
  have h1 := homEquiv_comp_unit_pushforwardComp (D.t p q ≫ D.f q p) (D.ι q)
    ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι q)).counit.app (M q))
  -- `rw [hε] at h1` cannot match (the counit codomain carries a `𝟭`-wrapper); term-mode
  replace h1 := (Category.id_comp _).symm.trans ((eq_whisker hε _).symm.trans h1)
  -- re-index along the glue condition
  have h2 := homEquiv_comp_pushforwardCongr hpq
    (W := (Scheme.Modules.pushforward (D.ι q)).obj (M q))
    (y := (Scheme.Modules.pullbackComp (D.t p q ≫ D.f q p) (D.ι q)).inv.app
        ((Scheme.Modules.pushforward (D.ι q)).obj (M q)) ≫
      ((Scheme.Modules.pullback (D.t p q ≫ D.f q p)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι q)).counit.app (M q)) ≫
        (g p q).inv))
  -- absorb `g⁻¹` into the transpose and fold the unit pair
  have hy : (Scheme.Modules.pullbackPushforwardAdjunction
        ((D.t p q ≫ D.f q p) ≫ D.ι q)).homEquiv
        ((Scheme.Modules.pushforward (D.ι q)).obj (M q))
        ((Scheme.Modules.pullback (D.f p q)).obj (M p))
        ((Scheme.Modules.pullbackComp (D.t p q ≫ D.f q p) (D.ι q)).inv.app
            ((Scheme.Modules.pushforward (D.ι q)).obj (M q)) ≫
          ((Scheme.Modules.pullback (D.t p q ≫ D.f q p)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι q)).counit.app (M q)) ≫
            (g p q).inv))
      = ((Scheme.Modules.pushforward (D.ι q)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction
              (D.t p q ≫ D.f q p)).unit.app (M q)) ≫
          (Scheme.Modules.pushforwardComp (D.t p q ≫ D.f q p) (D.ι q)).hom.app
            ((Scheme.Modules.pullback (D.t p q ≫ D.f q p)).obj (M q))) ≫
        (Scheme.Modules.pushforward ((D.t p q ≫ D.f q p) ≫ D.ι q)).map (g p q).inv :=
    (congrArg ((Scheme.Modules.pullbackPushforwardAdjunction
        ((D.t p q ≫ D.f q p) ≫ D.ι q)).homEquiv _ _)
        (Category.assoc _ _ _).symm).trans
      ((Adjunction.homEquiv_naturality_right _ _ _).trans (eq_whisker h1.symm _))
  refine Eq.trans ?_ h2
  refine Eq.trans (((Category.assoc _ _ _).trans (Category.assoc _ _ _)).symm) ?_
  exact eq_whisker hy.symm _