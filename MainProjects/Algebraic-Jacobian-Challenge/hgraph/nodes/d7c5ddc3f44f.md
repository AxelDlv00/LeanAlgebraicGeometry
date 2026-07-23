---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Hom.baseRingSectionsResAlgHom_apply
docstring: 'The underlying function of `baseRingSectionsResAlgHom` is the presheaf

  restriction.'
file: AlgebraicJacobian/Picard/P1SectionsFinite.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.baseRingSectionsResAlgHom_apply
type: lean
updated: '2026-07-16T21:14:27'
---
lemma Hom.baseRingSectionsResAlgHom_apply (p : X ⟶ S) {W W' : X.Opens} (h : W' ≤ W)
    (c : Γ(X, W)) :
    p.baseRingSectionsResAlgHom h c = (X.presheaf.map (homOfLE h).op).hom c :=
  rfl