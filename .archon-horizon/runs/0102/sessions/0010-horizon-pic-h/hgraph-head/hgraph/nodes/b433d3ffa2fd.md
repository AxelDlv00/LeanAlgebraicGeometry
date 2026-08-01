---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.picEt.eval_apply
file: AlgebraicJacobian/Picard/PicEt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picEt.eval_apply
type: lean
updated: '2026-08-01T09:44:16'
---
lemma eval_apply (U : T.left.affineOpens) (s : picEt C T) : eval C T U s = s.1 U :=
  rfl

@[simp]