---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.relCover
docstring: 'The **base-changed affine two-cover** of the relative curve: the preimages
  of the

  charts of `D` under the first projection `relCurve C R ⟶ C.left`

  (`Scheme.AffineTwoCover.pullbackProd`), an affine two-chart cover of `relCurve C
  R`.'
file: AlgebraicJacobian/Cohomology/RelativeTwoCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relCover
type: lean
updated: '2026-07-30T15:46:00'
---
noncomputable def relCover : (relCurve C R).AffineTwoCover := D.pullbackProd R