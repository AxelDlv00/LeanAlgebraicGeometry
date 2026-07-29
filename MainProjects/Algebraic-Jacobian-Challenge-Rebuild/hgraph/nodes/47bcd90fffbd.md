---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: Module.map_transitionUnit
docstring: 'Transition units are compatible with pushforward of trivializations along
  an

  `A`-algebra map.'
file: AlgebraicJacobian/Algebra/BaseChangeTrivialization.lean
generated: lean
lean_status: lean_ok
title: Module.map_transitionUnit
type: lean
updated: '2026-07-29T15:31:33'
---
lemma map_transitionUnit (h : C →ₐ[A] C') :
    transitionUnit (trivializationPush h t₁) (trivializationPush h t₂)
      = Units.map h.toRingHom.toMonoidHom (transitionUnit t₁ t₂) :=
  transitionUnit_eq_of _ _ fun n ↦ by
    have := congrArg h (transitionUnit_mul_apply t₁ t₂ (1 ⊗ₜ n))
    rw [map_mul] at this
    rw [trivializationPush_one_tmul, trivializationPush_one_tmul]
    exact this