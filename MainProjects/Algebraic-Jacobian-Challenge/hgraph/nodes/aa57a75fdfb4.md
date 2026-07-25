---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.functor
docstring: 'The **Grassmannian functor** `Grass(r,d)` (`def:grassmannian_functor`):
  the

  contravariant functor from schemes to sets sending `T` to the set of equivalence
  classes

  of rank-`d` locally free quotients `q : O_T^r ↠ F`, acting on morphisms by pullback.


  The object and morphism assignments are complete; the functoriality laws (`map_id`,

  `map_comp`) are discharged — via the naturality of the pseudofunctor comparison
  isomorphisms

  `pullbackId`/`pullbackComp` of `Scheme.Modules.pullback` — through the free-sheaf
  coherences

  `pullbackFreeIso_id`/`pullbackFreeIso_comp`, which reduce by coproduct extensionality
  to the

  unit-level coherences `pullbackObjUnitToUnit_id`/`pullbackObjUnitToUnit_comp`. Fully
  proved.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.functor
type: lean
updated: '2026-07-26T06:03:22'
---
noncomputable def functor (d r : ℕ) : Scheme.{0}ᵒᵖ ⥤ Type 1 where
  obj T := Quotient (rqSetoid r d T.unop)
  map {X Y} g := TypeCat.ofHom (Quotient.map (rqPullback (r := r) (d := d) g.unop)
    (fun _ _ h => rqPullback_rel g.unop h))
  map_id X := by
    -- reduce to the equivalence relation on representatives
    ext z
    induction z using Quotient.ind with
    | _ x =>
      change Quotient.mk _ (rqPullback (𝟙 X).unop x) = Quotient.mk _ x
      -- the canonical iso `(𝟙)^* x.F ≅ x.F` is `pullbackId`; the quotient-map equation it
      -- must satisfy reduces, by naturality of `pullbackId.hom`, to the free coherence
      -- `pullbackFreeIso (𝟙) = (pullbackId).app (free _)`, hence to the unit-level identity
      -- `pullbackObjUnitToUnit (𝟙) = (pullbackId).app unit`. That coherence between
      -- `SheafOfModules.pullbackObjFreeIso` and Mathlib's `pullbackId` is the open obstacle.
      refine Quotient.sound ⟨(Scheme.Modules.pullbackId X.unop).app x.F, ?_⟩
      -- unfold `(rqPullback (𝟙) x).q` and `(pullbackId.app x.F).hom` (defeq)
      change ((Scheme.Modules.pullbackFreeIso (𝟙 X.unop) (Fin r)).inv ≫
          (Scheme.Modules.pullback (𝟙 X.unop)).map x.q) ≫
          (Scheme.Modules.pullbackId X.unop).hom.app x.F = x.q
      rw [Category.assoc, (Scheme.Modules.pullbackId X.unop).hom.naturality x.q,
        ← Scheme.Modules.pullbackFreeIso_id]
      -- `(𝟭).map x.q = x.q` is only defeq, so close by term (rw can't see through it)
      exact Iso.inv_hom_id_assoc _ _
  map_comp {X Y Z} f g := by
    ext z
    induction z using Quotient.ind with
    | _ x =>
      change Quotient.mk _ (rqPullback (f ≫ g).unop x)
        = Quotient.mk _ (rqPullback g.unop (rqPullback f.unop x))
      -- the canonical iso `(g.unop ≫ f.unop)^* x.F ≅ g.unop^*(f.unop^* x.F)` is `pullbackComp`;
      -- the quotient-map equation reduces, by naturality, to the composite free coherence
      -- relating `pullbackFreeIso (g.unop ≫ f.unop)` to `pullbackFreeIso g.unop`/`f.unop`
      -- through `pullbackComp` — the composite analogue of the `map_id` obstacle.
      refine Quotient.sound ⟨((Scheme.Modules.pullbackComp g.unop f.unop).app x.F).symm, ?_⟩
      -- unfold `(rqPullback (g∘f) x).q` and `(pullbackComp.app x.F).symm.hom` (defeq), writing
      -- the composite as `g.unop ≫ f.unop` so the `pullbackComp` naturality matches syntactically
      change ((Scheme.Modules.pullbackFreeIso (g.unop ≫ f.unop) (Fin r)).inv ≫
          (Scheme.Modules.pullback (g.unop ≫ f.unop)).map x.q) ≫
          (Scheme.Modules.pullbackComp g.unop f.unop).inv.app x.F
        = (rqPullback g.unop (rqPullback f.unop x)).q
      -- expose the `pullbackComp.inv` naturality square (mirrors the `map_id` reduction)
      rw [Category.assoc, (Scheme.Modules.pullbackComp g.unop f.unop).inv.naturality x.q]
      -- the composite free coherence (`pullbackFreeIso_comp`) in inverse form: invert both
      -- sides of the iso equation `pullbackComp.hom.app free ≫ pfba.hom = (pullback g).map pfa.hom
      -- ≫ pfb.hom`.
      have hstar : (Scheme.Modules.pullbackFreeIso (g.unop ≫ f.unop) (Fin r)).inv ≫
            (Scheme.Modules.pullbackComp g.unop f.unop).inv.app (SheafOfModules.free (Fin r))
          = (Scheme.Modules.pullbackFreeIso g.unop (Fin r)).inv ≫
            (Scheme.Modules.pullback g.unop).map
              (Scheme.Modules.pullbackFreeIso f.unop (Fin r)).inv := by
        have hH := Scheme.Modules.pullbackFreeIso_comp f.unop g.unop (Fin r)
        rw [← cancel_epi ((Scheme.Modules.pullbackComp g.unop f.unop).hom.app
          (SheafOfModules.free (Fin r)) ≫
          (Scheme.Modules.pullbackFreeIso (g.unop ≫ f.unop) (Fin r)).hom)]
        trans (𝟙 _)
        · rw [Category.assoc, Iso.hom_inv_id_assoc]
          exact (Scheme.Modules.pullbackComp g.unop f.unop).hom_inv_id_app _
        · rw [hH]; simp; rfl
      -- whisker `hstar` by `≫ (pullback f ⋙ pullback g).map x.q` and refold the RHS via
      -- `map_comp` into `(rqPullback g (rqPullback f x)).q`.
      exact (Category.assoc _ _ _).symm.trans
        ((congrArg (· ≫ (Scheme.Modules.pullback f.unop ⋙
              Scheme.Modules.pullback g.unop).map x.q) hstar).trans
          ((Category.assoc _ _ _).trans
            (congrArg ((Scheme.Modules.pullbackFreeIso g.unop (Fin r)).inv ≫ ·)
              ((Scheme.Modules.pullback g.unop).map_comp
                (Scheme.Modules.pullbackFreeIso f.unop (Fin r)).inv
                ((Scheme.Modules.pullback f.unop).map x.q)).symm)))