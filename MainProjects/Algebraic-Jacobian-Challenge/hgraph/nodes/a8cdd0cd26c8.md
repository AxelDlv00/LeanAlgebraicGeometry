---
author: sync
content_type: theorem
created: '2026-07-30T05:53:10'
decl: AlgebraicGeometry.Scheme.PicScheme.coverMap_left
file: AlgebraicJacobian/Picard/PicEtDescentAssembly.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.coverMap_left
type: lean
updated: '2026-07-30T05:53:10'
---
theorem coverMap_left (T : Over (Spec (CommRingCat.of k))) :
    (coverMap (k' := k') T).left = pullback.fst T.hom (specMapAlgebra k k') := rfl

/-! ## §2. The uniqueness half of the descent — PROVED -/