/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.PrincipalDivisor
import AlgebraicJacobian.RiemannRoch.WeilDivisor

/-!
# The two projects' principal divisors have the same coefficients

The ported ledger's principal divisor is `Scheme.divOf` (`Ledger/PrincipalDivisor.lean`), whose
coefficient at a closed point is `Multiplicative.toAdd (Scheme.ordZ f hx g)`, built from the
adic valuation of the maximal ideal of the DVR stalk.  This project's own principal divisor is
`Scheme.WeilDivisor.principal` (`RiemannRoch/WeilDivisor.lean`), whose coefficient at a prime
divisor is `Scheme.RationalMap.order`, built from mathlib's `Ring.ordFrac` on the same stalk.

Those are *different constructions of the same integer*, and until now the identification was
unproved — it is the second of the two gaps this lane reported against reading `deg_divOf` as
`principal_degree_zero` (the first, the residue weighting, is
`Ledger/ResidueOneAlgClosed.lean`).  This file closes it:

* `Scheme.ordZ_toAdd_eq_log_ordFrac` — the coefficient identity at a point;
* `Scheme.divOf_apply_eq_rationalMap_order` — the same, stated against
  `Scheme.RationalMap.order` as `WeilDivisor.principal` uses it.

## The proof, and why it is short

Both sides bottom out in the *same* valuation, which is not obvious from the definitions:

1. `Scheme.ord f hx` is by construction the adic valuation of `stalkHeightOne X x`, the maximal
   ideal of the stalk viewed as a height-one prime (`Scheme.ord_eq_valuation`, `rfl`).
2. `stalkHeightOne X x` is *definitionally* `IsDiscreteValuationRing.maximalIdeal` of that stalk
   — checked by `rfl`, so no transport is needed.
3. Mathlib's `Ring.ordFrac_eq_valuation_inv` says `ordFrac R = (valuation K _)⁻¹` on a DVR.  So
   `ordFrac` is the *inverse* of the valuation, and `ordZ` is the valuation composed with
   `invMonoidHom` — the same inversion, on the other side of the units equivalence.
4. `WithZero.log` of a coerced unit is `Multiplicative.toAdd`, which turns (3) into the claim.

The sign conventions therefore agree with no correction term: both are `+1` at a simple zero.
That is worth stating explicitly, because a sign error here would be invisible in any
degree-zero statement (`0 = -0`) and would corrupt every non-principal use.

## Provenance

AJC-native rederivation.  Neither project had this comparison: the ledger side is a port from
`Algebraic-Jacobian-Challenge-Rebuild`, which has no `WeilDivisor.principal` to compare against,
and this project's `WeilDivisor.lean` records the comparison as an unmeasured cost.  The
load-bearing input is mathlib's `Ring.ordFrac_eq_valuation_inv`
(`Mathlib/RingTheory/OrderOfVanishing/Noetherian.lean`), which neither project had used.

## What is still not closed

This identifies **coefficients at a point**.  It is not yet the divisor-level statement
`divOf f g = principal (g : K(X)) _` transported along
`RiemannRoch/CurveDivisorIndexBridge.addEquivNonGeneric`, because the two divisors are indexed
by `{x // x ≠ η}` and `X.PrimeDivisor` respectively and `WeilDivisor.lean` is not this lane's
file to edit.  With this lemma that transport is `Finsupp.ext` along the index equivalence plus
the coefficient identity below; the remaining work is bookkeeping, not mathematics.  See the
AJC thread (inbox `I-0493`) — `ajc-pic0av` owns that file and the `AJC.rr.principal` milestone.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

variable {K : Type u} [Field K] {X : Scheme.{u}}

/-- `WithZero.log` of a coerced unit of `ℤᵐ⁰`, after inversion, is `toAdd` of the inverse in the
units group: the pure `WithZero` bookkeeping separating the two spellings of "order". -/
private lemma log_coe_units_inv (u : (WithZero (Multiplicative ℤ))ˣ) :
    WithZero.log ((u : WithZero (Multiplicative ℤ))⁻¹)
      = Multiplicative.toAdd (invMonoidHom (WithZero.unitsWithZeroEquiv u)) := by
  obtain ⟨a, ha⟩ : ∃ a : Multiplicative ℤ,
      (u : WithZero (Multiplicative ℤ)) = (a : WithZero _) :=
    ⟨WithZero.unitsWithZeroEquiv u, by simp [WithZero.unitsWithZeroEquiv]⟩
  simp only [ha, invMonoidHom]
  rw [← WithZero.coe_inv]
  have hlog : ∀ b : Multiplicative ℤ,
      WithZero.log (b : WithZero (Multiplicative ℤ)) = Multiplicative.toAdd b :=
    fun b => (Equiv.symm_apply_eq Multiplicative.toAdd).mp rfl
  rw [hlog]
  simp [WithZero.unitsWithZeroEquiv, ha]

/-- **The two order functions agree** (★): the ported ledger's `ordZ`, read additively, is
mathlib's `Ring.ordFrac` on the stalk, read through `WithZero.log` — which is exactly the
integer `Scheme.RationalMap.order` uses.

Both are the adic valuation of the maximal ideal of the DVR stalk: `Scheme.ord` *is* that
valuation by construction, `stalkHeightOne` is definitionally
`IsDiscreteValuationRing.maximalIdeal`, and `Ring.ordFrac_eq_valuation_inv` supplies the single
inversion that `ordZ` performs on the other side of the units equivalence.

The sign conventions agree with no correction term. -/
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

/-- **The ledger's principal divisor has this project's coefficients** (★): at a prime divisor
`Y` of the curve, the coefficient of `Scheme.divOf f g` at `Y.point` is
`Scheme.RationalMap.order Y g` — the coefficient `Scheme.WeilDivisor.principal` uses.

This is `ordZ_toAdd_eq_log_ordFrac` with the right-hand side folded back into
`RationalMap.order`, which is by definition `WithZero.log (Ring.ordFrac _ _)`. -/
theorem Scheme.divOf_apply_eq_rationalMap_order (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] [IsLocallyNoetherian X]
    [LocallyOfFiniteType f] [QuasiCompact f]
    (g : X.functionFieldˣ) (Y : X.PrimeDivisor) (hY : Y.point ≠ genericPoint X)
    [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)] :
    @DFunLike.coe ({x : X // x ≠ genericPoint X} →₀ ℤ) _ _ _ (Scheme.divOf f g) ⟨Y.point, hY⟩
      = Scheme.RationalMap.order Y (g : X.functionField) := by
  rw [Scheme.divOf_apply f g hY]
  exact Scheme.ordZ_toAdd_eq_log_ordFrac f g hY

end AlgebraicGeometry
