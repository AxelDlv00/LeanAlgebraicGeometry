---
author: sync
content_type: theorem
created: '2026-07-29T07:08:53'
decl: probeProducer
docstring: 'Synthesis site: the producer for `UniformBaseDivisor`.'
file: scripts/ajcrr-vanishingfielddescent-axioms.lean
generated: lean
lean_status: lean_ok
stale: true
title: probeProducer
type: lean
updated: '2026-07-30T11:48:48'
---
theorem probeProducer
    (h : letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
         Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1)) :
    UniformBaseDivisor C 0 :=
  uniformBaseDivisor_zero_of_subsingleton C h