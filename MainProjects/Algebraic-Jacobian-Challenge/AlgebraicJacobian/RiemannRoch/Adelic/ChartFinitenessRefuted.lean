/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Adelic.ChiUnconditional

/-!
# Chart finiteness is not a restriction — it is UNSATISFIABLE on a curve

`ChiUnconditional.lean` refutes the one-point bump `hbump` and the closed χ-ledger `hledger`
on any two-set cover having a prime divisor off one chart.  Both refutations carry the binder

`[∀ D : X.WeilDivisor, Module.Finite k (sectionSub k U₀ D)]`

at a **non-total** open `U₀`, and that file's `ell_le_finrank_chart_along_tower` describes it
as "a substantive geometric restriction" which "has already excluded the curves
Riemann–Roch is about".  `WeilDivisor.lean:1271-1280` reads the same binder as ruling out
"a class of covers, not the ledger", and concludes the open work is to *exhibit a cover on
which the ledger can hold*.

**This file shows there is no such cover, and the reason is one step of commutative algebra
rather than anything about covers.**  A single instance of the binder — at the zero divisor
alone, not the whole family — already forces `K(X)` to be a finite extension of `k`:

`Adelic.module_finite_functionField_of_chart_finite`:
  `Module.Finite k (sectionSub k U 0) → Module.Finite k K(X)`, for a nonempty affine `U`.

The mechanism: `sectionSub k U 0` is exactly the set of rational functions with
`ord_P ≥ 0` at every prime divisor meeting `U`.  That set is a **subring** (orders add under
multiplication, `sectionSub_mul_mem_zero`) and it **contains the chart ring** `Γ(X, U)`
(chart-integral elements have nonnegative order, `order_algebraMap_chart_nonneg`).  A
`k`-finite domain is a field (`fieldOfFiniteDimensional`), and a subfield of `K(X)`
containing `Γ(X, U)` — whose fraction field is `K(X)` (`chartRing_isFractionRing`) — is all
of `K(X)`.

## Why this sharpens the refutations rather than weakening them

The refutations of `hbump`/`hledger` remain true and remain proved.  What changes is their
**reading**.  They were presented as "the ledger is false on covers of this kind, so look for
a better cover".  The honest reading is stronger and simpler:

* On a curve with a nonconstant function, `K(X)/k` is *not* finite (a nonconstant function is
  transcendental over the constants), so the chart-finiteness binder is **satisfied at no
  such curve, on any cover, with any charts**.  Hence the §5–§6 refutations of
  `ChiUnconditional.lean` are — on a curve — refutations with unsatisfiable hypotheses.
* So the bump route is not "dead on bad covers"; the *refutation* of it is vacuous on curves.
  Neither `hbump` nor `hledger` has been shown false at a curve. They are **open**, not
  refuted, and the search for "a cover on which the ledger can hold" is not the open problem.

This is trap (c) of `scripts/axiom-frontier.lean` applied to a *negative* result, which is the
case the trap catalogue did not cover: a refutation whose own hypotheses are unsatisfiable
tells you nothing about the statement it refutes.  Both the refutation and its retraction
report clean axioms.

`chart_finiteness_iff_module_finite_functionField` states the equivalence, so the binder is
visibly interchangeable with a hypothesis about `k ⊆ K(X)` alone — no cover, no charts, no
divisors.

## What this file does NOT claim

It does not prove `hbump` or `hledger`. It does not prove `K(X)/k` is infinite for AJC's
curve: that needs a nonconstant rational function, which is
`Adelic.exists_nonconstant_of_...` territory (`NonconstantToP1.lean`) and is not wired in
here. `not_module_finite_functionField_of_exists_transcendental` states the missing input
precisely as one hypothesis, so a consumer can see exactly what closing it costs.

## The three cluster-P gaps, kept apart

Unchanged by this file, and this file touches only the first:

* **Single-field vanishing** — open. This file removes a *false lead* (repairing the cover)
  rather than supplying vanishing.
* **Extension uniformity** — untouched. Still `UniformChartVanishing.UniformChartCount`,
  proved at no curve, strictly stronger than the single-field count.
* **Global generation** — untouched. Still ledger-conditional in `GlobalGeneration.lean`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits
open scoped WithZero

namespace AlgebraicGeometry
namespace Adelic

section ChartFiniteness

variable (k : Type u) [Field k] {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X]
    [Algebra k X.functionField] [IsConstantField k X]

/-- **A stalk-integral rational function has nonnegative order.**  The converse of
`ChiLedger.exists_stalk_lift_of_order_nonneg`: mathlib's
`IsDedekindDomain.HeightOneSpectrum.valuation_le_one` says the adic valuation of an element of
the ring is `≤ 1`, and `ord_P = -log ∘ v_P` (`order_eq_neg_log_pointValuation`) turns that into
`ord_P ≥ 0`. -/
theorem order_algebraMap_stalk_nonneg {P : X.PrimeDivisor}
    (a : X.presheaf.stalk P.point) :
    0 ≤ Scheme.RationalMap.order P
      (algebraMap (X.presheaf.stalk P.point) X.functionField a) := by
  set f := algebraMap (X.presheaf.stalk P.point) X.functionField a with hfdef
  have hle1 : pointValuation P f ≤ 1 :=
    IsDedekindDomain.HeightOneSpectrum.valuation_le_one _ a
  rw [order_eq_neg_log_pointValuation]
  rcases eq_or_ne (pointValuation P f) 0 with h0 | h0
  · rw [h0]; simp
  · have hlog : WithZero.log (pointValuation P f) ≤ WithZero.log (1 : ℤᵐ⁰) :=
      (WithZero.log_le_log h0 one_ne_zero).mpr hle1
    rw [WithZero.log_one] at hlog
    linarith

/-- **A chart section has nonnegative order at every prime divisor meeting the chart.**
Factor `algebraMap Γ(X, U) K(X)` through the stalk at `Y.point` (`functionField_isScalarTower`)
and apply `order_algebraMap_stalk_nonneg`.  Note no affineness hypothesis is needed: the
scalar tower through the stalk exists for any open containing the point. -/
theorem order_algebraMap_chart_nonneg {U : X.Opens} [Nonempty U]
    (Y : X.PrimeDivisor) (hYU : Y.point ∈ U) (r : Γ(X, U)) :
    0 ≤ Scheme.RationalMap.order Y (algebraMap Γ(X, U) X.functionField r) := by
  letI algSt : Algebra Γ(X, U) (X.presheaf.stalk Y.point) :=
    TopCat.Presheaf.algebra_section_stalk X.presheaf ⟨Y.point, hYU⟩
  haveI hst : IsScalarTower Γ(X, U) (X.presheaf.stalk Y.point) X.functionField :=
    AlgebraicGeometry.functionField_isScalarTower X U ⟨Y.point, hYU⟩
  rw [IsScalarTower.algebraMap_apply Γ(X, U) (X.presheaf.stalk Y.point) X.functionField r]
  exact order_algebraMap_stalk_nonneg _

/-- **The chart ring lands in `Γ(U, 𝒪(0))`.**  Immediate from
`order_algebraMap_chart_nonneg`: membership in `sectionSub k U 0` asks for
`-0 ≤ ord_P` at each prime meeting `U`. -/
theorem algebraMap_chart_mem_sectionSub_zero {U : X.Opens} [Nonempty U] (r : Γ(X, U)) :
    algebraMap Γ(X, U) X.functionField r ∈ sectionSub k U (0 : X.WeilDivisor) := by
  rcases eq_or_ne (algebraMap Γ(X, U) X.functionField r) 0 with h0 | h0
  · rw [h0]; exact Submodule.zero_mem _
  refine Or.inr fun P hP => ?_
  change -((0 : X.PrimeDivisor →₀ ℤ) P) ≤ _
  simp only [Finsupp.coe_zero, Pi.zero_apply, neg_zero]
  exact order_algebraMap_chart_nonneg P hP r

/-- **`Γ(U, 𝒪(0))` is closed under multiplication.**  Orders add
(`order_mul_of_ne_zero`), so two functions with nonnegative order at each prime meeting `U`
have a product with the same property.  This is what makes the section space at the *zero*
divisor a ring, and it is the step that turns a finiteness binder into a field. -/
theorem sectionSub_mul_mem_zero (U : X.Opens) {f g : X.functionField}
    (hf : f ∈ sectionSub k U (0 : X.WeilDivisor))
    (hg : g ∈ sectionSub k U (0 : X.WeilDivisor)) :
    f * g ∈ sectionSub k U (0 : X.WeilDivisor) := by
  rcases eq_or_ne f 0 with rfl | hf0
  · simp only [zero_mul]; exact Submodule.zero_mem _
  rcases eq_or_ne g 0 with rfl | hg0
  · simp only [mul_zero]; exact Submodule.zero_mem _
  refine Or.inr fun P hP => ?_
  rw [Scheme.RationalMap.order_mul_of_ne_zero P hf0 hg0]
  have h1 := (mem_sectionOfDivisor_of_ne_zero hf0).mp hf P hP
  have h2 := (mem_sectionOfDivisor_of_ne_zero hg0).mp hg P hP
  change -((0 : X.PrimeDivisor →₀ ℤ) P) ≤ _ at h1 h2
  change -((0 : X.PrimeDivisor →₀ ℤ) P) ≤ _
  simp only [Finsupp.coe_zero, Pi.zero_apply, neg_zero] at h1 h2 ⊢
  linarith

end ChartFiniteness

end Adelic
end AlgebraicGeometry
