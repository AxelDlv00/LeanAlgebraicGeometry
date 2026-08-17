---
author: sync
content_type: definition
created: '2026-08-16T20:15:44'
decl: AlgebraicGeometry.pic0SepClosedAtlasGlueData
docstring: 'The canonical finite affine gluing datum associated by Mathlib to the
  chosen open cover.

  Its transition maps and triple-overlap cocycle are construction output of `gluedCover`;
  this

  does not yet assert that the datum descends to a finite subextension.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageAffineIntersections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0SepClosedAtlasGlueData
type: lean
updated: '2026-08-16T20:15:44'
---
noncomputable def pic0SepClosedAtlasGlueData : Scheme.GlueData :=
  (pic0SepClosedAtlasOpenCover C).gluedCover