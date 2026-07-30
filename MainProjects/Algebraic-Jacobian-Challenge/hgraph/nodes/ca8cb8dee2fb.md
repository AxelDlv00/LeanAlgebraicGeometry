---
author: sync
content_type: theorem
created: '2026-07-28T12:23:41'
decl: AlgebraicGeometry.Scheme.Pic0.probe_smooth_converse
docstring: 'Does `Smooth` give back `GeometricallyReduced`? If yes the run-0067

  "reduction" is a logical EQUIVALENCE, not a shrink.'
file: Probe4.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.Pic0.probe_smooth_converse
type: lean
updated: '2026-07-31T02:29:54'
---
theorem probe_smooth_converse {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (h : Smooth (Pic0Scheme C).hom) :
    GeometricallyReduced (Pic0Scheme C).hom := by
  haveI := h; infer_instance