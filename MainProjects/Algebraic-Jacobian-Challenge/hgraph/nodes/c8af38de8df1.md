---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.InternalHom.termRingMap
docstring: '**The canonical ring map `R(T) → R(Y)` from a terminal object `T`.** For
  each

  object `Y`, the unique morphism `Y.unop → T` (terminality) induces, after `op` and

  applying `R`, the ring map `R(T) → R(Y)` along which a global scalar `f ∈ R(T)`
  acts

  on `R(Y)`-modules. Project-local: the `R(T)`-module structure on `Hom(M, N)` (the
  slice

  internal-hom value) is defined through this map.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.InternalHom.termRingMap
type: lean
updated: '2026-07-16T21:14:28'
---
noncomputable def termRingMap (Y : Cᵒᵖ) : R.obj (Opposite.op T) ⟶ R.obj Y :=
  R.map (hT.from Y.unop).op