---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechNerveCosimplicial
docstring: 'The cosimplicial `O_X`-module obtained by post-composing the over-category
  Čech

  backbone `coverCechNerveOver` (read contravariantly, via `Functor.leftOp`) with
  the

  push–pull functor `pushPullFunctor F = G`. This is the underlying cosimplicial object

  of `CechNerve` (before adjoining the augmentation `F`). Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechNerveCosimplicial
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def cechNerveCosimplicial (𝒰 : X.OpenCover) (F : X.Modules) :
    CosimplicialObject X.Modules :=
  (coverCechNerveOver 𝒰 : SimplexCategoryᵒᵖ ⥤ Over X).rightOp ⋙ pushPullFunctor F