---
author: sync
content_type: theorem
created: '2026-07-31T03:02:21'
decl: AlgebraicGeometry.probe_pullback_fst_congr_left.{w}
file: Pic0ThetaCocycleProbe.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.probe_pullback_fst_congr_left.{w}
type: lean
updated: '2026-08-01T11:45:17'
---
private theorem probe_pullback_fst_congr_left.{w} {D : Type w} [Category.{u} D]
    {W S T : D} (a : W ⟶ S) {f g : T ⟶ S} (hfg : f = g)
    [HasPullback a f] [HasPullback a g]
    (heq : Limits.pullback a f = Limits.pullback a g) :
    eqToHom heq ≫ pullback.fst a g = pullback.fst a f := by
  subst hfg
  exact Category.id_comp _

open Limits in
set_option maxHeartbeats 1000000 in