---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.isAffineOpen_relPinnedChart
docstring: Both pinned charts are affine.
file: AlgebraicJacobian/Picard/DivSchemeFamilySide.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isAffineOpen_relPinnedChart
type: lean
updated: '2026-07-17T16:57:13'
---
lemma isAffineOpen_relPinnedChart (b : Bool) : IsAffineOpen (relPinnedChart C R π b) := by
  cases b
  · exact relCover_isAffineOpen₀ C R (fiberTwoCover π)
  · exact relCover_isAffineOpen₁ C R (fiberTwoCover π)