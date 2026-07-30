---
author: sync
content_type: lemma
created: '2026-07-30T23:41:24'
decl: AlgebraicGeometry.picRepTripleLeg1
docstring: Equality of the two presentations of the first projection from the triple
  overlap.
file: AlgebraicJacobian/Picard/Pic0RepAmitsurDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picRepTripleLeg1
type: lean
updated: '2026-07-30T23:41:24'
---
lemma picRepTripleLeg1 :
    picRepFace12Spec k L ≫ picRepOverlapSpecInl k L =
      picRepFace13Spec k L ≫ picRepOverlapSpecInl k L := by
  dsimp [picRepFace12Spec, picRepFace13Spec, picRepOverlapSpecInl]
  rw [← Spec.map_comp, ← Spec.map_comp, ← CommRingCat.ofHom_comp,
    ← CommRingCat.ofHom_comp]
  congr 1