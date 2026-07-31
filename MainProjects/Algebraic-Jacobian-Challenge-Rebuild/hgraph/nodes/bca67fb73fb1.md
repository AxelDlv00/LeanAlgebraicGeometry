---
author: sync
content_type: theorem
created: '2026-07-31T18:11:08'
decl: AlgebraicGeometry.P1.specPoint_structureMap
docstring: '`specPoint` is a morphism over `k`: composing with the structure map of
  `ℙ¹` gives the

  structure map `Spec A ⟶ Spec k` of `overSpec k A`.'
file: AlgebraicJacobian/Curve/P1Section.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.specPoint_structureMap
type: lean
updated: '2026-07-31T18:11:08'
---
theorem specPoint_structureMap :
    specPoint k A ≫ structureMap k = Spec.map (CommRingCat.ofHom (algebraMap k A)) := by
  rw [specPoint, fromSpecChart_structureMap]