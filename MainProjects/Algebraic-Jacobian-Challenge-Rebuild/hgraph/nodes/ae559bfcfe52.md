---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: TruncExpCech.snd_scaleRingHom
file: AlgebraicJacobian/Tangent/TruncExpUnits.lean
generated: lean
lean_status: lean_ok
title: TruncExpCech.snd_scaleRingHom
type: lean
updated: '2026-07-30T15:46:08'
---
theorem snd_scaleRingHom (a : R) (x : R[ε]) : (scaleRingHom a x).snd = a * x.snd := by
  simp [scaleRingHom]