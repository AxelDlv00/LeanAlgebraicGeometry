---
author: sync
content_type: definition
created: '2026-07-30T23:41:24'
decl: AlgebraicGeometry.picRepOverlapIso
docstring: The canonical double-overlap isomorphism on a scheme representing `Pic^0_{C_L/L}`.
file: AlgebraicJacobian/Picard/Pic0RepAmitsurDatum.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.picRepOverlapIso
type: lean
updated: '2026-07-31T00:01:07'
---
noncomputable def picRepOverlapIso :
    (Over.pullback (picRepOverlapSpecInl k L)).obj J ≅
      (Over.pullback (picRepOverlapSpecInr k L)).obj J :=
  (pic0OverlapRepresentableByInl k L C repL).uniqueUpToIso
    ((pic0OverlapRepresentableByInr k L C repL).ofIso (pic0OverlapIso k L C).symm)

/-! ## The triple-overlap normalization -/