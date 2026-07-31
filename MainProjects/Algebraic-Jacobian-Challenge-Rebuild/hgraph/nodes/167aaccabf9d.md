---
author: sync
content_type: theorem
created: '2026-07-20T20:32:02'
decl: AlgebraicGeometry.DivRepGlobalData.representableBy_homEquiv_symm_apply
file: AlgebraicJacobian/Picard/DivRepKit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivRepGlobalData.representableBy_homEquiv_symm_apply
type: lean
updated: '2026-07-31T20:14:40'
---
theorem representableBy_homEquiv_symm_apply
    (D : DivRepGlobalData hpi g r1 r2 b1 b2)
    {T : Over (Spec (CommRingCat.of k))} (F : divFamZar C pi g T) :
    (representableBy (hpi := hpi) (g := g) (r1 := r1) (r2 := r2) (b1 := b1)
      (b2 := b2) D).homEquiv.symm F = D.classify F :=
  rfl