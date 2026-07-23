---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushPull_binary_leg_coherence
docstring: '(★) Per-leg coherence: the push–pull map of the over-inclusion `Over.homMk
  c : Over.mk pC ⟶

  Over.mk q` is, through the canonical leg iso, the pushforward of the disjoint-cover
  restriction unit

  `(restrictAdjunction c).unit`.  This is the bridge that converts the canonical comparison
  map

  `prod.lift (pushPullMap F …)` into the manifestly-iso `coprodDecompMap` chain.  Project-local.'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushPull_binary_leg_coherence
type: lean
updated: '2026-07-16T21:14:26'
---
lemma pushPull_binary_leg_coherence {C : Scheme.{u}} (q : (A ⨿ B) ⟶ X)
    (c : C ⟶ A ⨿ B) [IsOpenImmersion c] (pC : C ⟶ X) (wC : c ≫ q = pC) (F : X.Modules) :
    pushPullMap F (Over.homMk c wC : Over.mk pC ⟶ Over.mk q) =
      (pushforward q).map
          ((Scheme.Modules.restrictAdjunction c).unit.app ((Scheme.Modules.pullback q).obj F)) ≫
        (pushPullCoprodLegIso q c pC wC F).hom := by
  have hraw : pushPullMap F (Over.homMk c wC : Over.mk pC ⟶ Over.mk q)
      = rawPushPullMap c q pC wC F := rfl
  rw [hraw, rawPushPullMap_self_gen]
  have hLAU : (Scheme.Modules.restrictAdjunction c).unit.app ((Scheme.Modules.pullback q).obj F) ≫
        (pushforward c).map
          ((Scheme.Modules.restrictFunctorIsoPullback c).hom.app
            ((Scheme.Modules.pullback q).obj F)) =
      (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
        ((Scheme.Modules.pullback q).obj F) :=
    Adjunction.unit_leftAdjointUniq_hom_app _ _ _
  subst wC
  simp only [pushPullCoprodLegIso, Iso.trans_hom, Functor.mapIso_hom, eqToIso.hom,
    Iso.app_hom, Category.comp_id,
    Scheme.Modules.pullbackCongr, eqToIso_refl, Iso.refl_hom, NatTrans.id_app]
  rw [← hLAU]
  simp only [Functor.map_comp, Category.assoc]; rfl