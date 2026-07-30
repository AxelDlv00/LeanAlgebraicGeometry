---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: Module.descentCoboundary
docstring: 'The descent coboundary of a unit `β : Bˣ`: the unit `(1 ⊗ₜ β) * (β ⊗ₜ
  1)⁻¹` of

  `B ⊗[A] B`.'
file: AlgebraicJacobian/Descent/UnitDescent.lean
generated: lean
lean_status: lean_ok
title: Module.descentCoboundary
type: lean
updated: '2026-07-30T15:46:01'
---
noncomputable def descentCoboundary (β : Bˣ) : (B ⊗[A] B)ˣ :=
  Units.map (descentIncl₂ A B).toRingHom.toMonoidHom β
    * (Units.map (descentIncl₁ A B).toRingHom.toMonoidHom β)⁻¹