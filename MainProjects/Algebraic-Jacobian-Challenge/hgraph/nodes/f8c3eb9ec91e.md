---
author: sync
content_type: definition
created: '2026-07-27T17:35:58'
decl: AlgebraicGeometry.Adelic.p1PolyToAway
docstring: '`R[t] → (R[X₀, X₁]_{Xᵢ})₀`, `t ↦ Xⱼ/Xᵢ`.  Bijective for `i ≠ j`; see `p1AwayAlgEquiv`.'
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.p1PolyToAway
type: lean
updated: '2026-07-27T17:35:58'
---
noncomputable def p1PolyToAway (i j : ULift.{u} (Fin 2)) :
    Polynomial R →ₐ[R] Away (homogeneousSubmodule (ULift.{u} (Fin 2)) R) (X i) :=
  Polynomial.aeval (p1ChartCoord R i j)

@[simp]