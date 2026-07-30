---
author: sync
content_type: instance
created: '2026-07-19T14:31:14'
decl: AlgebraicGeometry.compactSpace_carveScheme
docstring: '**The glued carve locus is a compact space**: a closed subscheme of the
  compact

  Grassmannian pair (§4.1: closed subscheme of qc is qc).'
file: AlgebraicJacobian/Picard/DivSchemeQProj.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.compactSpace_carveScheme
type: lean
updated: '2026-07-30T15:27:57'
---
instance compactSpace_carveScheme : CompactSpace (carveScheme k g r₁ r₂ μ) :=
  QuasiCompact.compactSpace_of_compactSpace (carveSchemeι k g r₁ r₂ μ)