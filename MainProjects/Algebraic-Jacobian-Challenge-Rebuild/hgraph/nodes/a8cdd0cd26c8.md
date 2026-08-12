---
author: sync
content_type: theorem
created: '2026-08-12T15:42:08'
decl: AlgebraicGeometry.Scheme.PicScheme.coverMap_left
file: AlgebraicJacobian/Descent/GaloisKernelCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.coverMap_left
type: lean
updated: '2026-08-12T15:42:08'
---
theorem coverMap_left (T : Over (Spec (CommRingCat.of k))) :
    (coverMap (k' := k') T).left = pullback.fst T.hom (specMapAlgebra k k') := rfl