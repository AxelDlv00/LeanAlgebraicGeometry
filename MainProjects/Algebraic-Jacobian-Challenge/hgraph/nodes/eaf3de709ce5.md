---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushPullMap_eq_raw
docstring: '`pushPullMap` is the `Over X` instance of `rawPushPullMap`.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushPullMap_eq_raw
type: lean
updated: '2026-07-24T03:02:09'
---
lemma pushPullMap_eq_raw (F : X.Modules) {Y₁ Y₂ : Over X} (g : Y₂ ⟶ Y₁) :
    pushPullMap F g = rawPushPullMap g.left Y₁.hom Y₂.hom (Over.w g) F :=
  rfl

/- **The functor laws `pushPullMap_id` / `pushPullMap_comp`.**
Assembling `pushPullObj` / `pushPullMap` into the functor `G : (Over X)ᵒᵖ ⥤
X.Modules` requires
```
  pushPullMap_id   : pushPullMap F (𝟙 Y) = 𝟙 (pushPullObj F Y)
  pushPullMap_comp : pushPullMap F (g ≫ h) = pushPullMap F h ≫ pushPullMap F g
```
Both laws are proved axiom-clean below (see `pushPullMap_id` and `pushPullMap_comp`),
and `pushPullFunctor` is assembled from them immediately after. -/

/-! ### Functor laws of the push–pull functor `G` -/

set_option backward.isDefEq.respectTransparency false in