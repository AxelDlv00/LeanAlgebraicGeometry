---
author: sync
content_type: theorem
created: '2026-07-27T19:08:27'
decl: AlgebraicGeometry.Adelic.p1Index_zero_ne_one
docstring: The two homogeneous coordinate indices of `ℙ¹` are distinct.
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.p1Index_zero_ne_one
type: lean
updated: '2026-07-27T19:08:27'
---
theorem p1Index_zero_ne_one : (⟨0⟩ : ULift.{u} (Fin 2)) ≠ ⟨1⟩ := by
  intro h
  simpa using congrArg ULift.down h