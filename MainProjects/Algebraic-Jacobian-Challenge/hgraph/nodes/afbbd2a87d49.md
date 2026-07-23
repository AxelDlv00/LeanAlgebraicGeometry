---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.InternalHom.globalSMul_one
docstring: '`globalSMul 1 = 𝟙`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.InternalHom.globalSMul_one
type: lean
updated: '2026-07-24T03:02:12'
---
lemma globalSMul_one : globalSMul hT N 1 = 𝟙 N := by
  ext Y m; rw [globalSMul_hom_apply, map_one, one_smul]; rfl