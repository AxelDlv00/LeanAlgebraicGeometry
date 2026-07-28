---
author: sync
content_type: lemma
created: '2026-07-19T14:01:14'
decl: AlgebraicGeometry.germ_resHom_assemble
docstring: (Implementation) Germs commute with `resHom`.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivAssemble.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.germ_resHom_assemble
type: lean
updated: '2026-07-28T17:25:24'
---
private lemma germ_resHom_assemble {X : Scheme.{u}} {W V : X.Opens} (h : W ≤ V) (z : X)
    (hz : z ∈ W) (t : Γ(X, V)) :
    (X.presheaf.germ W z hz).hom (X.resHom h t)
      = (X.presheaf.germ V z (h hz)).hom t :=
  X.presheaf.germ_res_apply (homOfLE h) z hz t

omit [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))] in