---
author: sync
content_type: theorem
created: '2026-07-29T23:31:12'
decl: AlgebraicGeometry.Probe3.probe_univClosed
docstring: 'PROBE 3: universal closedness from the valuative criterion, etale side.'
file: Probe/P3Structure.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Probe3.probe_univClosed
type: lean
updated: '2026-07-30T00:51:00'
---
theorem probe_univClosed (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C]
    (h : ValuativeCriterion.Existence (Scheme.Pic0SchemeEt C).hom) :
    UniversallyClosed (Scheme.Pic0SchemeEt C).hom := by
  haveI : QuasiCompact (Scheme.Pic0SchemeEt C).hom := probe_quasiCompact C
  exact UniversallyClosed.of_valuativeCriterion _ h