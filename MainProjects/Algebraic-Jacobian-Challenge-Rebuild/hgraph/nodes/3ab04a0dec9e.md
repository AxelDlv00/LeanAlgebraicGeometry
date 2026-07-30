---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.Scheme.RationalMap.precomp_hom_toRationalMap
file: AlgebraicJacobian/Albanese/RationalMapPrecomp.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.RationalMap.precomp_hom_toRationalMap
type: lean
updated: '2026-07-30T15:27:58'
---
lemma RationalMap.precomp_hom_toRationalMap (g : X ⟶ Y) (p : W ⟶ X)
    (hp : IsOpenMap p.base) :
    (g.toRationalMap).precomp p hp = (p ≫ g).toRationalMap := by
  rw [show (g.toRationalMap : X ⤏ Y) = g.toPartialMap.toRationalMap from rfl,
    ← RationalMap.precomp_toRationalMap]
  refine congrArg PartialMap.toRationalMap (PartialMap.ext _ _ rfl ?_)
  simp only [Scheme.isoOfEq_rfl, Iso.refl_hom, Category.id_comp, PartialMap.precomp_hom,
    Scheme.Hom.toPartialMap_hom]
  have key : (p ∣_ (g.toPartialMap).domain) ≫ X.topIso.hom = W.topIso.hom ≫ p :=
    morphismRestrict_ι p _
  rw [← Category.assoc, key, Category.assoc]