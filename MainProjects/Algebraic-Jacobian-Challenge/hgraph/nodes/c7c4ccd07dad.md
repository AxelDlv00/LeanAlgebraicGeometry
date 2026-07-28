---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.Scheme.ord_val_eq
docstring: '**Bridging lemma.** The order valuation of `g` at a closed point `x`,
  read in `ℤᵐ⁰`, is the

  divisor bound of the *negated* principal divisor `-div(g)`: a pole of order `n`
  (`div(g) x = -n`)

  contributes valuation `ofAdd n`, matching the classical sign convention (uniformizer
  ↦ order `+1`,

  valuation `ofAdd (-1)`). This is the single geometric input; the whole sheaf isomorphism
  reduces

  to it.'
file: AlgebraicJacobian/RiemannRoch/Ledger/MulEquiv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ord_val_eq
type: lean
updated: '2026-07-28T18:12:20'
---
theorem ord_val_eq {x : X} (hx : x ≠ genericPoint X) :
    Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx (g : X.functionField)
      = divisorBound (- Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g) hx := by
  rw [ord_val_eq_ordZ, divisorBound]
  congr 1

omit [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))] in