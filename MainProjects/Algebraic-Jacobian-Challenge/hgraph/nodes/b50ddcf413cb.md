---
author: sync
content_type: definition
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.P1.polyToAway
docstring: '`k[t] → (k[X₀,X₁]_(Xᵢ))₀`, `t ↦ Xⱼ/Xᵢ`. Bijective for `i ≠ j`; see `P1.awayAlgEquiv`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/P1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.polyToAway
type: lean
updated: '2026-07-28T18:12:20'
---
noncomputable def polyToAway (i j : Fin 2) : Polynomial k →ₐ[k] Away 𝒜 (X i) :=
  Polynomial.aeval (chartCoord k i j)

@[simp]