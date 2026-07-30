---
author: sync
content_type: theorem
created: '2026-07-30T10:26:46'
decl: AlgebraicGeometry.Scheme.PicScheme.coverFunctor_obj
file: AlgebraicJacobian/Picard/PicEtDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.coverFunctor_obj
type: lean
updated: '2026-07-30T10:26:46'
---
theorem coverFunctor_obj (T : Over (Spec (CommRingCat.of k))) :
    (coverFunctor (k := k) (k' := k')).obj T
      = (restrictTest k k').obj (baseTest (k' := k') T) := rfl