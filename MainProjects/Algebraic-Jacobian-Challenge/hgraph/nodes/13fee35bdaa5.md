---
author: sync
content_type: theorem
created: '2026-07-30T01:58:51'
decl: AlgebraicGeometry.Scheme.PicScheme.restrictTest_obj_hom
file: AlgebraicJacobian/Picard/PicEtCrossBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.restrictTest_obj_hom
type: lean
updated: '2026-07-30T01:58:51'
---
theorem restrictTest_obj_hom (T : Over (Spec (CommRingCat.of k'))) :
    ((restrictTest k k').obj T).hom = T.hom ≫ specMapAlgebra k k' := rfl