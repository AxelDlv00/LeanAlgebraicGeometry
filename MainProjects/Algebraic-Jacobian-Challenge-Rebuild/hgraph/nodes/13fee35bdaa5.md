---
author: sync
content_type: theorem
created: '2026-08-12T15:42:08'
decl: AlgebraicGeometry.Scheme.PicScheme.restrictTest_obj_hom
file: AlgebraicJacobian/Descent/GaloisKernelCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.restrictTest_obj_hom
type: lean
updated: '2026-08-18T20:50:53'
---
theorem restrictTest_obj_hom (T : Over (Spec (CommRingCat.of k'))) :
    ((restrictTest k k').obj T).hom = T.hom ≫ specMapAlgebra k k' := rfl