---
author: sync
content_type: instance
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.instCompactSpaceRelCurve
docstring: '**The relative curve over a proper `C` has a compact space.**  `Spec R`
  is compact and the

  structure morphism is quasi-compact, so this is

  `QuasiCompact.compactSpace_of_compactSpace`.


  This is what makes the extraction below hypothesis-free in the case of interest:
  the finite

  subcover it extracts exists because the curve is quasi-compact, and nothing else
  about it

  matters.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffExtraction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.instCompactSpaceRelCurve
type: lean
updated: '2026-07-29T15:31:43'
---
instance instCompactSpaceRelCurve [IsProper C.hom] : CompactSpace (relCurve C R) :=
  QuasiCompact.compactSpace_of_compactSpace (relCurve C R ↘ Spec (.of R))