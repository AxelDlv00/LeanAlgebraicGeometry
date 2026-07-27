---
author: sync
content_type: theorem
created: '2026-07-27T19:08:28'
decl: AlgebraicGeometry.Adelic.positivePart_apply
docstring: '**The coefficients of the positive part.**'
file: AlgebraicJacobian/RiemannRoch/Adelic/LedgerClosure.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.positivePart_apply
type: lean
updated: '2026-07-27T19:08:28'
---
theorem positivePart_apply (D : X.WeilDivisor) (P : X.PrimeDivisor) :
    (show X.PrimeDivisor →₀ ℤ from Scheme.WeilDivisor.positivePart D) P =
      max ((show X.PrimeDivisor →₀ ℤ from D) P) 0 := by
  change (Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp)
    (show X.PrimeDivisor →₀ ℤ from D)) P = _
  rw [Finsupp.mapRange_apply]

omit [IsIntegral X] [IsLocallyNoetherian X] [X.IsRegularInCodimensionOne] in