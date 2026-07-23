---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.InternalHom.globalSMul_zero
docstring: '`globalSMul 0 = 0`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.InternalHom.globalSMul_zero
type: lean
updated: '2026-07-16T21:14:28'
---
lemma globalSMul_zero : globalSMul hT N 0 = 0 := by
  ext Y m; rw [globalSMul_hom_apply, map_zero, zero_smul]; rfl