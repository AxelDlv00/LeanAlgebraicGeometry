---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.rawPushPullMap_comp
docstring: 'Composition law for `rawPushPullMap` with the two over-triangles as free

  hypotheses (kernel-cheap).'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rawPushPullMap_comp
type: lean
updated: '2026-07-23T22:32:05'
---
lemma rawPushPullMap_comp {Z₁ Z₂ Z₃ : Scheme.{u}} (a : Z₂ ⟶ Z₁) (b : Z₃ ⟶ Z₂)
    (p₁ : Z₁ ⟶ X) (p₂ : Z₂ ⟶ X) (p₃ : Z₃ ⟶ X)
    (wg : a ≫ p₁ = p₂) (wh : b ≫ p₂ = p₃) (F : X.Modules) :
    rawPushPullMap (b ≫ a) p₁ p₃ (by rw [Category.assoc, wg, wh]) F =
      rawPushPullMap a p₁ p₂ wg F ≫ rawPushPullMap b p₂ p₃ wh F := by
  subst wg wh
  rw [rawPushPullMap_self a p₁ F, rawPushPullMap_self b (a ≫ p₁) F,
      rawPushPullMap_self_gen (b ≫ a) p₁ (b ≫ a ≫ p₁) (Category.assoc b a p₁) F]
  -- The over-triangle `eqToHom` (in `X.Modules`) is `(pushforward p₁).map` of the
  -- corresponding `Z₁.Modules`-level `eqToHom` (`pushforward` is strict).
  have he : eqToHom (congrArg (fun q => (Scheme.Modules.pushforward q).obj
        ((Scheme.Modules.pullback q).obj F)) (Category.assoc b a p₁)) =
      (Scheme.Modules.pushforward p₁).map (eqToHom (congrArg
        (fun q => (Scheme.Modules.pushforward (b ≫ a)).obj ((Scheme.Modules.pullback q).obj F))
        (Category.assoc b a p₁))) := by
    rw [eqToHom_map]
  -- The inner identity in `Z₁.Modules`: the pure pushforward-of-pentagon content.
  have INNER : (Scheme.Modules.pullbackPushforwardAdjunction (b ≫ a)).unit.app
          ((Scheme.Modules.pullback p₁).obj F) ≫
        (Scheme.Modules.pushforward (b ≫ a)).map
          ((Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F) ≫
        eqToHom (congrArg (fun q => (Scheme.Modules.pushforward (b ≫ a)).obj
          ((Scheme.Modules.pullback q).obj F)) (Category.assoc b a p₁)) =
      ((Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
            ((Scheme.Modules.pullback p₁).obj F) ≫
          (Scheme.Modules.pushforward a).map ((Scheme.Modules.pullbackComp a p₁).hom.app F)) ≫
        (Scheme.Modules.pushforward a).map
          ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
              ((Scheme.Modules.pullback (a ≫ p₁)).obj F) ≫
            (Scheme.Modules.pushforward b).map
              ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F)) := by
    rw [pushPull_unit_comp b a ((Scheme.Modules.pullback p₁).obj F)]
    -- The `Z₂.Modules`-level content: the pushforward-`b` of the pullback pentagon, with the
    -- composite unit straightened by naturality of `η^b`.
    have INNER2 :
        (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
            ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback p₁).obj F)) ≫
          (Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullbackComp b a).hom.app ((Scheme.Modules.pullback p₁).obj F) ≫
              (Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F ≫
              eqToHom (congrArg (fun q => (Scheme.Modules.pullback q).obj F)
                (Category.assoc b a p₁))) =
        (Scheme.Modules.pullbackComp a p₁).hom.app F ≫
          (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
              ((Scheme.Modules.pullback (a ≫ p₁)).obj F) ≫
            (Scheme.Modules.pushforward b).map
              ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F) := by
      have key2 : (Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullbackComp b a).hom.app ((Scheme.Modules.pullback p₁).obj F) ≫
              (Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F ≫
              eqToHom (congrArg (fun q => (Scheme.Modules.pullback q).obj F)
                (Category.assoc b a p₁))) =
          (Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullback b).map ((Scheme.Modules.pullbackComp a p₁).hom.app F) ≫
              (Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F) :=
        congrArg _ (pushPull_pentagon a b p₁ F)
      have nat2 : (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
            ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback p₁).obj F)) ≫
          (Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullback b).map ((Scheme.Modules.pullbackComp a p₁).hom.app F)) =
          (Scheme.Modules.pullbackComp a p₁).hom.app F ≫
            (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
              ((Scheme.Modules.pullback (a ≫ p₁)).obj F) :=
        ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.naturality
          ((Scheme.Modules.pullbackComp a p₁).hom.app F)).symm
      refine (congrArg (fun t => (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
        ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback p₁).obj F)) ≫ t) key2).trans ?_
      rw [Functor.map_comp]
      exact (Category.assoc _ _ _).symm.trans
        ((congrArg (· ≫ (Scheme.Modules.pushforward b).map
          ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F)) nat2).trans (Category.assoc _ _ _))
    exact congrArg (fun t => (Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
      ((Scheme.Modules.pullback p₁).obj F) ≫ (Scheme.Modules.pushforward a).map t) INNER2
  -- Expose the second RHS factor as `(pushforward p₁).map (…)` (strictness, by `rfl`) so the
  -- `map_comp` unifications below stay kernel-cheap.
  rw [show (Scheme.Modules.pushforward (a ≫ p₁)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
            ((Scheme.Modules.pullback (a ≫ p₁)).obj F) ≫
          (Scheme.Modules.pushforward b).map ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F)) =
      (Scheme.Modules.pushforward p₁).map ((Scheme.Modules.pushforward a).map
        ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
            ((Scheme.Modules.pullback (a ≫ p₁)).obj F) ≫
          (Scheme.Modules.pushforward b).map ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F)))
        from rfl]
  -- Final assembly is now pure term-mode transport (no `rw`, so no motive issues).
  -- LHS = `(pf p₁).map A ≫ E` with `A` the `(b ≫ a)`-head and `E` the outer over-triangle.
  -- `he` rewrites `E = (pf p₁).map eqInner`; fold via `← map_comp`; reassociate the head so
  -- `A ≫ eqInner` matches `INNER`'s LHS; apply `INNER`; then split the RHS by `map_comp`.
  exact
    (congrArg (fun t => (Scheme.Modules.pushforward p₁).map
        ((Scheme.Modules.pullbackPushforwardAdjunction (b ≫ a)).unit.app
            ((Scheme.Modules.pullback p₁).obj F) ≫
          (Scheme.Modules.pushforward (b ≫ a)).map
            ((Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F)) ≫ t) he).trans
      (((Functor.map_comp _ _ _).symm.trans
          (congrArg (Scheme.Modules.pushforward p₁).map
            ((Category.assoc _ _ _).trans INNER))).trans
        (Functor.map_comp _ _ _))