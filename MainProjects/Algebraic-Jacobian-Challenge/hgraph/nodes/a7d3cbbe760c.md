---
author: sync
content_type: theorem
created: '2026-07-28T19:06:13'
decl: AlgebraicGeometry.Scheme.ordZ_toAdd_eq_log_ordFrac
docstring: '**The two order functions agree** (★): the ported ledger''s `ordZ`, read
  additively, is

  mathlib''s `Ring.ordFrac` on the stalk, read through `WithZero.log` — which is exactly
  the

  integer `Scheme.RationalMap.order` uses.


  Both are the adic valuation of the maximal ideal of the DVR stalk: `Scheme.ord`
  *is* that

  valuation by construction, `stalkHeightOne` is definitionally

  `IsDiscreteValuationRing.maximalIdeal`, and `Ring.ordFrac_eq_valuation_inv` supplies
  the single

  inversion that `ordZ` performs on the other side of the units equivalence.


  The sign conventions agree with no correction term.'
file: AlgebraicJacobian/RiemannRoch/Ledger/OrdCompare.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ordZ_toAdd_eq_log_ordFrac
type: lean
updated: '2026-07-28T19:26:15'
---
theorem Scheme.ordZ_toAdd_eq_log_ordFrac (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] [IsLocallyNoetherian X]
    (g : X.functionFieldˣ) {x : X} (hx : x ≠ genericPoint X)
    [Ring.KrullDimLE 1 (X.presheaf.stalk x)] :
    Multiplicative.toAdd (Scheme.ordZ f hx g)
      = WithZero.log (Ring.ordFrac (X.presheaf.stalk x) (g : X.functionField)) := by
  letI := isDiscreteValuationRing_stalk f hx
  letI := isDedekindDomain_stalk f hx
  rw [Ring.ordFrac_eq_valuation_inv (K := X.functionField)]
  have hv : (IsDiscreteValuationRing.maximalIdeal (X.presheaf.stalk x)).valuation
      X.functionField (g : X.functionField) = Scheme.ord f hx (g : X.functionField) := rfl
  rw [hv]
  exact (log_coe_units_inv (Units.map (Scheme.ord f hx).toMonoidWithZeroHom.toMonoidHom g)).symm