---
author: sync
content_type: instance
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.instFlatRelCurveHom
docstring: '**The relative curve is flat over its test base.** `(snd C (overSpec k
  R)).left` is the

  base change of `C.hom` along `(overSpec k R).hom` (`Over.isPullback_left`), and
  every

  structure morphism to the spectrum of a field is flat (`flat_hom_over_field`).'
file: AlgebraicJacobian/Picard/DivisorFamilyAffCover.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.instFlatRelCurveHom
type: lean
updated: '2026-07-29T15:26:35'
---
instance instFlatRelCurveHom : AlgebraicGeometry.Flat (relCurve C R ↘ Spec (.of R)) :=
  AlgebraicGeometry.Flat.isStableUnderBaseChange.of_isPullback
    (Over.isPullback_left C (overSpec k R)) inferInstance