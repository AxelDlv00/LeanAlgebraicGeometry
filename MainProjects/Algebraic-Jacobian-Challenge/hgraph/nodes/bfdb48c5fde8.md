---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: DualNumber.scaleRingHom_zero
docstring: 'Scaling by `0` is the retract `R[ε] → R → R[ε]` (kill `ε`, include

  back).'
file: AlgebraicJacobian/Picard/Pic0DualNumberCocycle.lean
generated: lean
lean_status: lean_ok
title: DualNumber.scaleRingHom_zero
type: lean
updated: '2026-07-16T21:14:27'
---
theorem scaleRingHom_zero :
    scaleRingHom (0 : R) = (algebraMap R R[ε]).comp (fstRingHom (R := R)) :=
  RingHom.ext fun x => TrivSqZeroExt.ext
    (by simp [TrivSqZeroExt.algebraMap_eq_inl])
    (by simp [TrivSqZeroExt.algebraMap_eq_inl])