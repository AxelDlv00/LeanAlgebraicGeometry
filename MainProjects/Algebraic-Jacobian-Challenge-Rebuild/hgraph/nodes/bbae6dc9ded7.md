---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.degAt_abelPicEt
docstring: '**The degree-zero certificate of the Abel class**: at every field point

  `t : overSpec k K ⟶ C` the degree is `1 − 1 = 0` — both factors restrict to graph

  classes of `K`-points, each of degree one by THE degree-1 keystone

  `classDeg_graphPicClass`.'
file: AlgebraicJacobian/Picard/AbelElement.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.degAt_abelPicEt
type: lean
updated: '2026-07-30T15:28:03'
---
theorem degAt_abelPicEt (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) {K : Type u} [Field K]
    [Algebra k K] (t : overSpec k K ⟶ C) :
    degAt (abelPicEt C P) t = 0 := by
  rw [abelPicEt, degAt_relPicToPicEt, relPicMap_mk, relPicDeg_relPicMk,
    cechPicMap_abelCechClass, classDeg_mul, classDeg_inv, classDeg_graphPicClass,
    classDeg_graphPicClass]
  ring

/-! ## The Abel element -/

variable (C) in