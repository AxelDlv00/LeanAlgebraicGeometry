---
author: sync
content_type: lemma
created: '2026-07-30T23:41:24'
decl: AlgebraicGeometry.picRepOverlapSpec_comp_base
docstring: The two overlap projections have the same composite to `Spec k`.
file: AlgebraicJacobian/Picard/Pic0RepAmitsurDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picRepOverlapSpec_comp_base
type: lean
updated: '2026-07-30T23:41:24'
---
lemma picRepOverlapSpec_comp_base :
    picRepOverlapSpecInl k L ≫ picRepBaseSpecMap k L =
      picRepOverlapSpecInr k L ≫ picRepBaseSpecMap k L := by
  dsimp [picRepOverlapSpecInl, picRepOverlapSpecInr, picRepBaseSpecMap]
  rw [← Spec.map_comp, ← Spec.map_comp, ← CommRingCat.ofHom_comp,
    ← CommRingCat.ofHom_comp]
  congr 1
  ext x
  simp [tensorInl, tensorInr]