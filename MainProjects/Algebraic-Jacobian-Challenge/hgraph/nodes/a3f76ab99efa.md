---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.DivFamily.ClassHasFiberDeg
docstring: 'Constant fibre degree, descended to the divisor classes

  `Quotient (DivFamily.setoid π T)` — the carrier predicate of

  `DivFunctorDeg π d`.  Well defined by `Rel.hasFiberDeg_iff`.'
file: AlgebraicJacobian/Picard/DivDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.ClassHasFiberDeg
type: lean
updated: '2026-07-16T21:14:26'
---
def ClassHasFiberDeg {T : Over S} (d : ℕ)
    (z : Quotient (DivFamily.setoid π T)) : Prop :=
  Quotient.liftOn z (fun x => x.HasFiberDeg d)
    fun _ _ h => propext (h.hasFiberDeg_iff d)

@[simp]