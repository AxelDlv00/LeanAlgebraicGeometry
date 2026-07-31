---
author: sync
content_type: theorem
created: '2026-07-30T07:28:28'
decl: AlgebraicGeometry.chart_map_ι_apply
docstring: '**A chart map read at an opens inclusion.**


  `f.app` at the open `W` applied to `W.ι ≫ u` is the restriction along `W.ι` of `f.app`
  at the

  whole scheme applied to `u`.  This is `NatTrans.naturality_apply` at `(W.ι).op`,
  with the

  `yoneda`-side map being precomposition.


  Named rather than inlined because the `yoneda`-side unfolding is the only thing
  that has to be

  got right: an attempt to use the Σ-sheaf''s own restriction on the wrong side does
  not typecheck.

  (An earlier version said "all three refutations below consume it".  **One** does
  — the others

  reach it only transitively through the main theorem.)'
file: AlgebraicJacobian/Picard/Pic0ChartCoverForcesNonInj.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.chart_map_ι_apply
type: lean
updated: '2026-07-31T20:15:26'
---
theorem chart_map_ι_apply {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (W : X.Opens) (u : X ⟶ X) :
    (pic0SigmaSheaf C).1.map (W.ι).op (f.app (op X) u)
      = f.app (op (W : Scheme.{u})) (W.ι ≫ u) :=
  (NatTrans.naturality_apply f (W.ι).op u).symm

/-! ## The step -/

variable (C) in