---
author: sync
content_type: definition
created: '2026-07-30T23:41:24'
decl: AlgebraicGeometry.pic0OverlapRepresentableByInl
docstring: The first pullback of `J` represents the first restriction of the `L`-Picard
  functor.
file: AlgebraicJacobian/Picard/Pic0RepAmitsurDatum.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.pic0OverlapRepresentableByInl
type: lean
updated: '2026-07-31T00:01:07'
---
noncomputable def pic0OverlapRepresentableByInl :
    ((Over.map (picRepOverlapSpecInl k L)).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy
      ((Over.pullback (picRepOverlapSpecInl k L)).obj J) :=
  ((Over.mapPullbackAdj (picRepOverlapSpecInl k L)).representableBy J).ofIso
    (Functor.isoWhiskerLeft (Over.map (picRepOverlapSpecInl k L)).op repL.toIso)