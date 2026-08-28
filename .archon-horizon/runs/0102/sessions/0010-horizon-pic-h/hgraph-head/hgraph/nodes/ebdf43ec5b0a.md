---
author: sync
content_type: lemma
created: '2026-07-27T01:04:30'
decl: AlgebraicGeometry.representableBy_homEquiv_toGlued
docstring: 'The universal element of the glued representation restricts along the
  `i`-th glue map to

  the element classified by `f i`.'
file: AlgebraicJacobian/Picard/JacobianDataCharts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.representableBy_homEquiv_toGlued
type: lean
updated: '2026-08-01T09:44:15'
---
lemma representableBy_homEquiv_toGlued (i : ι) :
    (Scheme.LocalRepresentability.representableBy hf).homEquiv
      (Scheme.LocalRepresentability.toGlued hf i) = yonedaEquiv (f i) :=
  Scheme.LocalRepresentability.yonedaGluedToSheaf_app_toGlued hf