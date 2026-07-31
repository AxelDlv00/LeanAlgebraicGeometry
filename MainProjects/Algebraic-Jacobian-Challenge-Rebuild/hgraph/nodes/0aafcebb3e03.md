---
author: sync
content_type: theorem
created: '2026-07-30T11:09:50'
decl: AlgebraicGeometry.ProbeP4R6g.controlSorry
file: scratch_p4r6/probe11.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.ProbeP4R6g.controlSorry
type: lean
updated: '2026-07-31T20:38:24'
---
theorem controlSorry : True := by sorry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]