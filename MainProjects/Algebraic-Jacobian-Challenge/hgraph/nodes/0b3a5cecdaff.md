---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairDiff_hom
docstring: '`pairDiff` is definitionally the difference-of-restrictions map `sectionDiff`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairDiff_hom
type: lean
updated: '2026-07-24T03:02:13'
---
lemma AffineCoverMVSquare.pairDiff_hom :
    (S.pairDiff F).hom = S.sectionDiff F :=
  rfl