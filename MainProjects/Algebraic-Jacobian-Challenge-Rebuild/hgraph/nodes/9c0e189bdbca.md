---
author: sync
content_type: theorem
created: '2026-07-30T10:29:03'
decl: AlgebraicGeometry.ProbeP4R6.probeConv
docstring: 'B: THE CONVERSE -- an iso of presheaves is an open immersion of presheaves.'
file: scratch_p4r6/probe4.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ProbeP4R6.probeConv
type: lean
updated: '2026-07-31T20:31:22'
---
theorem probeConv {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) [IsIso f] :
    IsOpenImmersion.presheaf f :=
  MorphismProperty.of_isIso (P := IsOpenImmersion.presheaf) f