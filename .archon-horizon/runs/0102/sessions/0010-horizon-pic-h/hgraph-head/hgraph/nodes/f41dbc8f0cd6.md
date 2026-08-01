---
author: sync
content_type: definition
created: '2026-07-20T16:13:00'
decl: imageModulo
file: SpanMapProbe.lean
generated: lean
lean_status: lean_ok
stale: true
title: imageModulo
type: lean
updated: '2026-07-20T16:31:25'
---
noncomputable def imageModulo (J : Ideal B) : Submodule B (B ⧸ I) :=
  Submodule.map (Ideal.Quotient.mkₐ B I).toLinearMap J