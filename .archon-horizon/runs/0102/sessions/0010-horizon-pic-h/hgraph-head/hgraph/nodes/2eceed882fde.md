---
author: sync
content_type: theorem
created: '2026-07-31T18:19:48'
decl: AlgebraicGeometry.P1.specPoint_naturality
docstring: '**Naturality of the canonical point** at the scheme level: pulling `specPoint`
  back along

  `Spec` of the algebra map `A → B` is `specPoint` at `B`.


  `fromSpecChart` is natural in the ring (`SpecMap_fromSpecChart`), and the chart
  coordinate is the

  constant `0`, which the algebra map sends to `0`; the base map `k → B` factors as
  `k → A → B` by

  the scalar tower.'
file: AlgebraicJacobian/Curve/P1Section.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.specPoint_naturality
type: lean
updated: '2026-08-01T09:44:10'
---
theorem specPoint_naturality (φ : A →ₐ[k] B) :
    Spec.map (CommRingCat.ofHom φ.toRingHom) ≫ specPoint k A = specPoint k B := by
  rw [specPoint, specPoint, SpecMap_fromSpecChart]
  congr 1
  · rw [← CommRingCat.ofHom_comp]
    congr 1
    exact φ.comp_algebraMap
  · exact map_zero _