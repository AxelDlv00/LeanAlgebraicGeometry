---
author: sync
content_type: theorem
created: '2026-07-29T12:10:03'
decl: synth_subsingleton_h1_p1
docstring: 'The vanishing at a concrete field: `k := ULift.{u} ℚ`.'
file: scripts/ajcrr-p1vanishing-axioms.lean
generated: lean
lean_status: lean_ok
stale: true
title: synth_subsingleton_h1_p1
type: lean
updated: '2026-07-31T06:25:57'
---
theorem synth_subsingleton_h1_p1 :
    Subsingleton (Scheme.HModule (ULift.{u} ℚ)
      (Scheme.toModuleKSheaf (p1Over (ULift.{u} ℚ))) 1) :=
  subsingleton_hModule_one_p1Over (ULift.{u} ℚ)