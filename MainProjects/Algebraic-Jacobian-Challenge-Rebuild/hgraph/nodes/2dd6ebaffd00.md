---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Scheme.germ_resHom
docstring: 'Germs at a point commute with `resHom`: the germ of a restricted section
  is the germ

  of the section.'
file: AlgebraicJacobian/RiemannRoch/GluedDivisorSheaf.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.germ_resHom
type: lean
updated: '2026-07-29T15:31:49'
---
private lemma germ_resHom {V W : X.Opens} (h : W ≤ V) (x : X) (hx : x ∈ W)
    (t : Γ(X, V)) :
    (X.presheaf.germ W x hx).hom (X.resHom h t) =
      (X.presheaf.germ V x (h hx)).hom t :=
  X.presheaf.germ_res_apply (homOfLE h) x hx t