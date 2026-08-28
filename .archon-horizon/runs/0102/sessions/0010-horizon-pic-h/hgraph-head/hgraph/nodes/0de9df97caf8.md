---
author: sync
content_type: theorem
created: '2026-07-18T03:38:57'
decl: AlgebraicGeometry.pullback_fst_congr_left.
docstring: 'Transport of `pullback.fst` along an equality of the second leg (proof-irrelevant

  `eqToHom` cast).'
file: AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.pullback_fst_congr_left.
type: lean
updated: '2026-07-28T13:42:21'
---
private theorem pullback_fst_congr_left.{w} {D : Type w} [Category.{u} D] {W S T : D}
    (a : W ⟶ S) {f g : T ⟶ S} (hfg : f = g) [HasPullback a f] [HasPullback a g]
    (heq : Limits.pullback a f = Limits.pullback a g) :
    eqToHom heq ≫ pullback.fst a g = pullback.fst a f := by
  subst hfg; exact Category.id_comp _

open Limits in
set_option maxHeartbeats 1000000 in
-- The `eqToIso`/`pullbackId` cast term is large; the kernel needs a wider budget.