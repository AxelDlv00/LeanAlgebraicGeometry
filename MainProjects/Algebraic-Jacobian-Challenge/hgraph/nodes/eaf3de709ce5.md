---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushPullMap_eq_raw
docstring: '`pushPullMap` is the `Over X`-instance of `rawPushPullMap`. Holds by `rfl`.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushPullMap_eq_raw
type: lean
updated: '2026-07-16T21:14:26'
---
lemma pushPullMap_eq_raw (F : X.Modules) {Y₁ Y₂ : Over X} (g : Y₂ ⟶ Y₁) :
    pushPullMap F g = rawPushPullMap g.left Y₁.hom Y₂.hom (Over.w g) F :=
  rfl

-- Composition law `pushPullMap_comp` is proved axiom-clean below (see `rawPushPullMap_comp`).
-- Dead-end note: `erw`/`congr 1` directly on `pullbackComp` whnf-unfolds it into its
-- `TwoSquare.equivNatTrans`/`mateEquiv` mate form, exploding heartbeats; the
-- `rawPushPullMap_comp` approach (subst the free over-triangle hypotheses) avoids this.