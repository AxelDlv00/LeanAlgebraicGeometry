---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.DivRepAffinePullbackAff.pullGlobal_val
file: AlgebraicJacobian/Picard/DivRepGlobalClassifyAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivRepAffinePullbackAff.pullGlobal_val
type: lean
updated: '2026-08-18T20:50:56'
---
theorem pullGlobal_val
    (D : DivRepAffinePullbackAff hpi g r1 r2 b1 b2)
    {T : Over (Spec (CommRingCat.of k))} (v : T ⟶ DivOver)
    (W : T.left.affineOpens) :
    (pullGlobal (hpi := hpi) (g := g) (r1 := r1) (r2 := r2)
      (b1 := b1) (b2 := b2) D v).1 W
      = D.pull Γ(T.left, W.1) (Over.fromSpecAffine T W ≫ v) :=
  rfl