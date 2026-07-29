---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.telescope_core
docstring: 'Cancellation core of the transition telescope: `a = b ⋅ c₁`, `b = d ⋅
  c₂`,

  `a = d ⋅ c₃` give `c₁ ⋅ c₂ = c₃`.'
file: AlgebraicJacobian/Picard/EffectivitySplice.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Over.telescope_core
type: lean
updated: '2026-07-29T15:31:46'
---
private lemma telescope_core {G : Type u} [CommGroup G] {a b d c₁ c₂ c₃ : G}
    (h₁ : a = b * c₁) (h₂ : b = d * c₂) (h₃ : a = d * c₃) : c₁ * c₂ = c₃ := by
  subst h₂
  rw [h₁, mul_assoc] at h₃
  rw [mul_comm]
  exact mul_left_cancel h₃