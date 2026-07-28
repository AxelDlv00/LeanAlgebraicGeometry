---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.P1.isUnit_dehomogenize_X_self
file: AlgebraicJacobian/RiemannRoch/Ledger/P1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.isUnit_dehomogenize_X_self
type: lean
updated: '2026-07-28T18:12:20'
---
theorem isUnit_dehomogenize_X_self (i : Fin 2) :
    IsUnit ((dehomogenize k i).toRingHom (X i)) := by
  have h : (dehomogenize k i).toRingHom (X i) = 1 := dehomogenize_X_self k i
  rw [h]
  exact isUnit_one