---
author: sync
content_type: instance
created: '2026-07-19T21:31:15'
decl: AlgebraicGeometry.DatG0.deltaSchemeDiagram_compactSpace
docstring: 'Every δ stage is a one-point (hence compact) space: `Spec` of a field.'
file: AlgebraicJacobian/Picard/PicRepColimitMountain.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.deltaSchemeDiagram_compactSpace
type: lean
updated: '2026-07-19T21:31:15'
---
instance deltaSchemeDiagram_compactSpace (L : (FinSubext k K)ᵒᵖ) :
    CompactSpace ((deltaSchemeDiagram.obj L).left) :=
  inferInstanceAs (CompactSpace (Spec _))