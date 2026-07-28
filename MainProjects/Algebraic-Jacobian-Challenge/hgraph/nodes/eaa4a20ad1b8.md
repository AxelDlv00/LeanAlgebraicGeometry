---
author: sync
content_type: instance
created: '2026-07-28T12:23:40'
decl: AlgebraicGeometry.Scheme.Modules.restrictFunctor_preservesLimits.{w,
docstring: '`restrictFunctor f` along an open immersion preserves limits (it is a
  right

  adjoint). Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.restrictFunctor_preservesLimits.{w,
type: lean
updated: '2026-07-28T12:23:40'
---
noncomputable instance restrictFunctor_preservesLimits.{w, w'} {X Y : Scheme.{u}}
    (f : X ⟶ Y) [IsOpenImmersion f] :
    PreservesLimitsOfSize.{w, w'} (restrictFunctor f) :=
  (Adjunction.ofIsRightAdjoint (restrictFunctor f)).rightAdjoint_preservesLimits