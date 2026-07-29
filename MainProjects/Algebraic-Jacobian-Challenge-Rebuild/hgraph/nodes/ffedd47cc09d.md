---
author: sync
content_type: theorem
created: '2026-07-30T00:05:11'
decl: ProbeP4.p1
file: scratch_p4/Probe1.lean
generated: lean
lean_status: lean_ok
title: ProbeP4.p1
type: lean
updated: '2026-07-30T00:05:11'
---
theorem p1 (h : CompactSpace (Scheme.LocalRepresentability.glueData hf).glued) :
    QuasiCompact (gluedHom C f hf) :=
  HasAffineProperty.iff_of_isAffine.mpr h

-- P2: does NoetherianSpace of the glued space give it, with NO finiteness of iota?