---
author: sync
content_type: theorem
created: '2026-07-30T08:49:44'
decl: ProbeP1Bridge.controlSorry
file: ScratchP1/probe_bridge.lean
generated: lean
lean_status: sorry
title: ProbeP1Bridge.controlSorry
type: lean
updated: '2026-07-30T08:49:44'
---
theorem controlSorry : True := by
  have : 1 = 1 := by sorry
  trivial

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]