---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.picEt.ext
file: AlgebraicJacobian/Picard/PicEt.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.picEt.ext
type: lean
updated: '2026-07-30T15:28:01'
---
lemma ext {s t : picEt C T} (h : ∀ U : T.left.affineOpens, s.1 U = t.1 U) : s = t :=
  Subtype.ext (funext h)

variable (C T) in