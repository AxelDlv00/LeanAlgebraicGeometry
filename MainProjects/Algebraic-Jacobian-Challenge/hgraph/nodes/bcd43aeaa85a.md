---
author: sync
content_type: theorem
created: '2026-07-29T18:18:38'
decl: synth_uniformGeneration_p1
docstring: '**The headline at a synthesis site**: extension-uniform global generation
  at a concrete curve

  over a concrete field, every instance found here and the base-divisor hypothesis
  *discharged*.'
file: scripts/ajcrr-uniformriemannroch-axioms.lean
generated: lean
lean_status: lean_ok
stale: true
title: synth_uniformGeneration_p1
type: lean
updated: '2026-07-31T02:29:54'
---
theorem synth_uniformGeneration_p1 : UniformGeneration (p1Over (ULift.{u} ℚ)) :=
  uniformGeneration_p1Over (ULift.{u} ℚ)