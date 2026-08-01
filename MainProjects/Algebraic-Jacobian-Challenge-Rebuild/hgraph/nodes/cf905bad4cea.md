---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.overSpecMap_id
docstring: 'The base comparison of the identity tower is the identity: `Spec` of

  `algebraMap R R = id` in `Over (Spec k)` (the instance-based `overSpecMap` companion
  of

  `Over.overSpecMap_id`).'
file: AlgebraicJacobian/Picard/DivisorFamilyMapAlg.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.overSpecMap_id
type: lean
updated: '2026-08-01T09:44:14'
---
lemma overSpecMap_id : overSpecMap (k := k) R R = 𝟙 (overSpec k R) := by
  ext : 1
  rw [overSpecMap_left, Algebra.algebraMap_self, CommRingCat.ofHom_id, Spec.map_id,
    Over.id_left]
  rfl