---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.sectionRestrict_comp
docstring: Restriction of a section along `W ≤ V ≤ U` composes to restriction along
  `W ≤ U`.
file: AlgebraicJacobian/Picard/DivisorClass.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.Scheme.sectionRestrict_comp
type: lean
updated: '2026-07-29T15:26:29'
---
private lemma sectionRestrict_comp {W V U : X.Opens} (h₁ : W ≤ V) (h₂ : V ≤ U)
    (s : Γ(X, U)) :
    (X.presheaf.map (homOfLE h₁).op).hom ((X.presheaf.map (homOfLE h₂).op).hom s)
      = (X.presheaf.map (homOfLE (h₁.trans h₂)).op).hom s := by
  rw [← CommRingCat.comp_apply, ← Functor.map_comp, ← op_comp, homOfLE_comp]