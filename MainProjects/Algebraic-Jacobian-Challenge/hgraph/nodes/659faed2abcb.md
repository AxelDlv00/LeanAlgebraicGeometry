---
author: sync
content_type: definition
created: '2026-07-27T17:35:58'
decl: AlgebraicGeometry.Adelic.p1AwayAlgEquiv
docstring: '**The chart ring of `ℙ¹` is free.**  The section ring `(R[X₀, X₁]_{Xᵢ})₀`
  of the standard

  chart `D₊(Xᵢ)` of `ℙ¹_R` is a polynomial ring over `R`, on the chart coordinate

  `t = Xⱼ/Xᵢ` (`p1ChartCoord`).'
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.p1AwayAlgEquiv
type: lean
updated: '2026-07-27T17:35:58'
---
noncomputable def p1AwayAlgEquiv {i j : ULift.{u} (Fin 2)} (hij : i ≠ j) :
    Away (homogeneousSubmodule (ULift.{u} (Fin 2)) R) (X i) ≃ₐ[R] Polynomial R :=
  AlgEquiv.ofAlgHom (p1AwayToPoly R i) (p1PolyToAway R i j)
    (p1AwayToPoly_comp_p1PolyToAway R hij) (p1PolyToAway_comp_p1AwayToPoly R hij)

@[simp]