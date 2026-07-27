/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Adelic.GlobalGeneration

/-!
# Adelic Riemann–Roch — closing the ledger from the one-point bump

Every conditional statement of the vanishing and generation lane
(`Adelic/SectionBounds.lean` §3, `Adelic/BoundedVanishing.lean`,
`Adelic/GlobalGeneration.lean`) takes the **closed ledger**

`hledger : ∀ D : X.WeilDivisor, χ(D) = χ(0) + deg_k D`

as a hypothesis quantified over **all** Weil divisors.  `chi_telescope_list` establishes
it for *effective* divisors from the one-point bump, and the sibling docstrings record
that "extending from list-effective divisors to all divisors additionally needs the
negative part" as an open item.

This file settles **half** of that extension and states the other half exactly.

## What is proved

`chi_eq_of_bump_of_nonneg` — the ledger holds at **every effective divisor**, from the
one-point bump alone, with the list eliminated from the statement.  This is a real
strengthening of `chi_telescope_list`: every effective divisor is list-effective
(`exists_divisorOfList_of_nonneg`), so a consumer no longer has to produce a list.

## What is *not* proved, stated precisely

`chi_eq_iff_step_of_bump` — given the bump, the ledger at an arbitrary `D` is
**equivalent** to the single identity `χ(D⁺) − χ(D) = deg_k (−D)⁺`.  It is deliberately an
`iff` and not a one-directional "reduction": the two sides are interderivable by
arithmetic, so a `←`-only version would be a theorem that re-indexes its own conclusion.
That failure mode is exactly what inbox memory I-0399 records for this task, and the
`iff` is how this file avoids repeating it.

## Why the naive route fails

The lattice identity `D + (−D)⁺ = D⁺` — pointwise `n + max(−n,0) = max(n,0)` — writes any
divisor as a difference of two effective ones, and the effective case above handles both
pieces.  But that does not close the ledger, because the two transport mechanisms the lane
owns do not apply:

* `χ` is **not additive** in the divisor.  Only `deg_k` is (`degKHom`), which is why the
  arithmetic above goes through on the degree side and stops on the `χ` side.
* `D` and `D⁺` are **not linearly equivalent** in general, so the class-invariance
  transport of `ClassInvariance.lean` cannot move `χ` between them.

So the negative part is not bookkeeping that a more careful induction would absorb; it
needs an input the project does not have.  Recorded here rather than left implicit, because
the sibling docstrings describe it as merely "additionally needs the negative part", which
understates it.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits IsDedekindDomain
open scoped WithZero

namespace AlgebraicGeometry
namespace Adelic

section Positive

variable {X : Scheme.{u}} [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X]

omit [IsIntegral X] [IsLocallyNoetherian X] [X.IsRegularInCodimensionOne] in
/-- **The coefficients of the positive part.** -/
theorem positivePart_apply (D : X.WeilDivisor) (P : X.PrimeDivisor) :
    (show X.PrimeDivisor →₀ ℤ from Scheme.WeilDivisor.positivePart D) P =
      max ((show X.PrimeDivisor →₀ ℤ from D) P) 0 := by
  change (Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp)
    (show X.PrimeDivisor →₀ ℤ from D)) P = _
  rw [Finsupp.mapRange_apply]

omit [IsIntegral X] [IsLocallyNoetherian X] [X.IsRegularInCodimensionOne] in
/-- **The positive part is effective.** -/
theorem positivePart_nonneg (D : X.WeilDivisor) (P : X.PrimeDivisor) :
    0 ≤ (show X.PrimeDivisor →₀ ℤ from Scheme.WeilDivisor.positivePart D) P := by
  rw [positivePart_apply]; omega

omit [IsIntegral X] [IsLocallyNoetherian X] [X.IsRegularInCodimensionOne] in
/-- **The canonical decomposition `D = D⁺ − (−D)⁺`.**  Pointwise
`n = max(n,0) − max(−n,0)`, the integer fact behind the decomposition of a Weil divisor
into a difference of effective divisors. -/
theorem eq_positivePart_sub_negativePart (D : X.WeilDivisor) :
    D = Scheme.WeilDivisor.positivePart D -
      Scheme.WeilDivisor.positivePart (-D) := by
  apply Finsupp.ext
  intro P
  rw [show (show X.PrimeDivisor →₀ ℤ from Scheme.WeilDivisor.positivePart D -
        Scheme.WeilDivisor.positivePart (-D)) P =
      (show X.PrimeDivisor →₀ ℤ from Scheme.WeilDivisor.positivePart D) P -
        (show X.PrimeDivisor →₀ ℤ from Scheme.WeilDivisor.positivePart (-D)) P from
    Finsupp.sub_apply _ _ _, positivePart_apply, positivePart_apply]
  rw [show (show X.PrimeDivisor →₀ ℤ from -D) P =
      -(show X.PrimeDivisor →₀ ℤ from D) P from Finsupp.neg_apply _ _]
  -- `omega` treats `(show _ from D) P` and `D P` as distinct atoms, so name the value
  set n : ℤ := (show X.PrimeDivisor →₀ ℤ from D) P with hn
  omega

end Positive

section LedgerFromBump

variable (k : Type u) [Field k] {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X]
    [Algebra k X.functionField] [IsConstantField k X] (U₀ U₁ : X.Opens)

/-- **The ledger holds on every effective divisor, from the one-point bump.**
`chi_telescope_list` gives it on list-effective divisors and
`exists_divisorOfList_of_nonneg` says every effective divisor is list-effective, so the
two combine to remove the list from the statement.

This is the first half of closing the ledger: the effective cone is done, with no
hypothesis beyond the bump. -/
theorem chi_eq_of_bump_of_nonneg
    (hbump : ∀ (P : X.PrimeDivisor) (E : X.WeilDivisor),
      chi k U₀ U₁ (pointDivisor P + E) = chi k U₀ U₁ E + residueDeg k P)
    {D : X.WeilDivisor}
    (hD : ∀ P : X.PrimeDivisor, 0 ≤ (show X.PrimeDivisor →₀ ℤ from D) P) :
    chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D := by
  obtain ⟨L, rfl⟩ := exists_divisorOfList_of_nonneg D hD
  exact chi_divisorOfList_eq_degK k U₀ U₁ L hbump

/-- **What the negative part actually costs: an equivalence, not a reduction.**

Given the bump, the ledger at an arbitrary `D` is **equivalent** to the single identity

`χ(D⁺) − χ(D) = deg_k (−D)⁺`,

i.e. to "`χ` drops by the weighted degree of the removed negative part".  Both directions
are proved, so this is *not* a theorem that reduces the ledger to something cheaper — it is
a statement of exactly what the remaining content is.

**Why it is phrased as an `iff`.**  It would be easy to state the `←` direction alone,
"bump + hstep ⟹ ledger at `D`", and present it as progress.  That would be misleading in
the specific way I-0399 records for this task: given `hbump` (which pins the ledger at
`D⁺` via `chi_eq_of_bump_of_nonneg`) and the additivity of `deg_k`, `hstep` and the
conclusion are interderivable by pure arithmetic — so such a theorem would re-index its own
conclusion rather than reduce it.  The `→` direction below is what makes that visible.

So the honest ledger of this file is: the effective cone is **done** from the bump
(`chi_eq_of_bump_of_nonneg`, unconditional); extending to all divisors is **open**, and its
entire content is the one identity above, for which no argument in this project is
available.  `χ` is not additive in the divisor, and `D` is not linearly equivalent to `D⁺`
in general, so neither of the two transport mechanisms the lane already owns applies. -/
theorem chi_eq_iff_step_of_bump
    (hbump : ∀ (P : X.PrimeDivisor) (E : X.WeilDivisor),
      chi k U₀ U₁ (pointDivisor P + E) = chi k U₀ U₁ E + residueDeg k P)
    (D : X.WeilDivisor) :
    chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D ↔
      chi k U₀ U₁ (Scheme.WeilDivisor.positivePart D) - chi k U₀ U₁ D =
        degK k (Scheme.WeilDivisor.positivePart (-D)) := by
  have hpos := chi_eq_of_bump_of_nonneg k U₀ U₁ hbump (positivePart_nonneg D)
  have hdec : degK k D = degK k (Scheme.WeilDivisor.positivePart D) -
      degK k (Scheme.WeilDivisor.positivePart (-D)) := by
    rw [← degK_sub, ← eq_positivePart_sub_negativePart D]
  constructor
  · intro h; omega
  · intro h; omega

end LedgerFromBump

end Adelic
end AlgebraicGeometry
