---
author: sync
content_type: theorem
created: '2026-07-29T23:41:46'
decl: AlgebraicGeometry.Probe3P.probe_p2_smooth
docstring: 'PROBE E: and therefore obligation 4 discharges my whole smoothness half.'
file: Probe/P3Perfect.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Probe3P.probe_p2_smooth
type: lean
updated: '2026-07-30T00:51:01'
---
theorem probe_p2_smooth
    (hB : SmoothOfRelativeDimension (genus C) (Scheme.Pic0SchemeEt C).hom) :
    Smooth (Scheme.Pic0SchemeEt C).hom :=
  Scheme.Pic0Et.smooth_of_geometricallyReduced C (probe_p2_claim C hB)