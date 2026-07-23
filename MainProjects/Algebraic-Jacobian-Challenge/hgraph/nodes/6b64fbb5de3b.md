---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.DivFamily.classHasFiberDeg_mk
file: AlgebraicJacobian/Picard/DivDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.classHasFiberDeg_mk
type: lean
updated: '2026-07-16T21:14:26'
---
theorem classHasFiberDeg_mk {T : Over S} (d : ℕ) (x : DivFamily π T) :
    ClassHasFiberDeg d (Quotient.mk (DivFamily.setoid π T) x) ↔ x.HasFiberDeg d :=
  Iff.rfl