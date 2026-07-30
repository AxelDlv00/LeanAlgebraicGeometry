---
author: sync
content_type: instance
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.instSmoothOfRelativeDimensionSndLeft
docstring: '**Base change of smooth-of-relative-dimension-one.** The second projection
  is smooth of

  relative dimension one over `K`, by `smoothOfRelativeDimension_isStableUnderBaseChange`.'
file: AlgebraicJacobian/Curve/BaseChangeInstances.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.instSmoothOfRelativeDimensionSndLeft
type: lean
updated: '2026-07-30T15:28:04'
---
instance instSmoothOfRelativeDimensionSndLeft :
    SmoothOfRelativeDimension 1 (snd C (overSpec k K)).left :=
  haveI : MorphismProperty.IsStableUnderBaseChange (@SmoothOfRelativeDimension 1) :=
    smoothOfRelativeDimension_isStableUnderBaseChange 1
  MorphismProperty.of_isPullback (P := @SmoothOfRelativeDimension 1)
    (Over.isPullback_left C (overSpec k K)) inferInstance