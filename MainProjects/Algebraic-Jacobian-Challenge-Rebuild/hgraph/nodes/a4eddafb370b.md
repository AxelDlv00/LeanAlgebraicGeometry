---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.pointTransitionUnit
docstring: '**The trivializing unit of the pulled point system**: the pullback `π^♯`
  of the chosen

  uniformizer at `x''`, as a unit of `K(C_{K₂})`.'
file: AlgebraicJacobian/RiemannRoch/DegreeBaseFieldInvariance.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.pointTransitionUnit
type: lean
updated: '2026-07-30T15:28:02'
---
noncomputable def pointTransitionUnit (φ : K₁ →ₐ[k] K₂) {x' : (C ⊗ overSpec k K₁).left}
    (hx' : x' ≠ genericPoint (C ⊗ overSpec k K₁).left) :
    (C ⊗ overSpec k K₂).left.functionFieldˣ :=
  (C ◁ Over.overSpecMap φ).left.functionFieldMapUnits (baseFieldTransition_genericPoint C φ)
    (Units.mk0 (uniformizer K₁ hx') (uniformizer_ne_zero K₁ hx'))

omit [IsProper C.hom] in