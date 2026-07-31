---
author: sync
content_type: theorem
created: '2026-07-17T18:01:32'
decl: AlgebraicGeometry.PicEtAff.baseFieldShuffle_mk
file: AlgebraicJacobian/Picard/PicEtAffBaseFieldShuffle.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.PicEtAff.baseFieldShuffle_mk
type: lean
updated: '2026-07-31T20:14:49'
---
theorem baseFieldShuffle_mk (U : Algebra.EtaleCover A) (x : descentClasses C U) :
    baseFieldShuffle k L C A (mk C U x)
      = mk ((baseChange k L).obj C) U
          ((crossBaseTransportFamily k L C).descentHom U x) :=
  rfl

/-- The computation rule of the inverse shuffle. -/
@[simp]