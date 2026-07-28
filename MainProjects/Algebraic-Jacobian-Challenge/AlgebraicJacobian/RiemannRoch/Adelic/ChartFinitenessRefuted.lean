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

/-- **`Γ(U, 𝒪(0))` as a `k`-subalgebra of the function field.**  The multiplicative closure
`sectionSub_mul_mem_zero` plus `1 ∈ Γ(U, 𝒪(0))` upgrade the `k`-submodule to a subalgebra.
Its being a *ring* is what converts a finiteness binder into a field, which is the whole
mechanism of this file. -/
def chartAlg (U : X.Opens) : Subalgebra k X.functionField where
  carrier := sectionSub k U (0 : X.WeilDivisor)
  mul_mem' := sectionSub_mul_mem_zero k U
  one_mem' := one_mem_sectionOfDivisor_zero U
  add_mem' := (sectionSub k U (0 : X.WeilDivisor)).add_mem
  zero_mem' := (sectionSub k U (0 : X.WeilDivisor)).zero_mem
  algebraMap_mem' := fun c => by
    have h1 : (1 : X.functionField) ∈ sectionSub k U (0 : X.WeilDivisor) :=
      one_mem_sectionOfDivisor_zero U
    have := (sectionSub k U (0 : X.WeilDivisor)).smul_mem c h1
    rwa [Algebra.smul_def, mul_one] at this

@[simp] theorem mem_chartAlg {U : X.Opens} {f : X.functionField} :
    f ∈ chartAlg k U ↔ f ∈ sectionSub k U (0 : X.WeilDivisor) := Iff.rfl

/-- **If `Γ(U, 𝒪(0))` is a field, it is the whole function field.**  On a nonempty affine
chart, `K(X) = Frac Γ(X, U)` (`chartRing_isFractionRing`), so every `f : K(X)` is `a/b` with
`a, b ∈ Γ(X, U) ⊆ chartAlg`.  Inside a field, `b⁻¹` is available, so `f = a·b⁻¹` lies in
`chartAlg` too. -/
theorem chartAlg_eq_top_of_isField {U : X.Opens} (hU : IsAffineOpen U) [Nonempty U]
    (hfield : IsField (chartAlg k U)) : chartAlg k U = ⊤ := by
  haveI hfr : IsFractionRing Γ(X, U) X.functionField := chartRing_isFractionRing hU
  refine Algebra.eq_top_iff.mpr fun f => ?_
  obtain ⟨a, b, hb, hab⟩ := IsFractionRing.div_surjective (A := Γ(X, U)) f
  have ha' : algebraMap Γ(X, U) X.functionField a ∈ chartAlg k U :=
    algebraMap_chart_mem_sectionSub_zero k a
  have hb' : algebraMap Γ(X, U) X.functionField b ∈ chartAlg k U :=
    algebraMap_chart_mem_sectionSub_zero k b
  have hbne : algebraMap Γ(X, U) X.functionField b ≠ 0 := fun h =>
    (nonZeroDivisors.coe_ne_zero ⟨b, hb⟩) (IsFractionRing.to_map_eq_zero_iff.mp h)
  obtain ⟨c, hc⟩ := hfield.mul_inv_cancel (a := (⟨_, hb'⟩ : chartAlg k U))
    (by simpa [Subtype.ext_iff] using hbne)
  have hbinv : (algebraMap Γ(X, U) X.functionField b)⁻¹ ∈ chartAlg k U := by
    have hval : algebraMap Γ(X, U) X.functionField b * (c : X.functionField) = 1 := by
      have := congrArg (fun z : chartAlg k U => (z : X.functionField)) hc
      simpa using this
    rw [← eq_inv_of_mul_eq_one_right hval]; exact c.2
  rw [← hab, div_eq_mul_inv]
  exact Subalgebra.mul_mem _ ha' hbinv

/-- **THE MAIN RESULT — chart finiteness at the ZERO divisor already forces `K(X)/k` finite.**

One instance of the binder that `ChiUnconditional.lean`'s refutations quantify over the whole
divisor family — `Module.Finite k (sectionSub k U 0)` at a single nonempty affine chart — is
enough to collapse the function field onto a finite extension of `k`.

Chain: `Γ(U, 𝒪(0))` is a `k`-finite domain (`chartAlg`), hence a field
(`fieldOfFiniteDimensional`); a field between `Γ(X, U)` and its own fraction field is
everything (`chartAlg_eq_top_of_isField`); so `K(X)` *is* that finite `k`-module.

**Why this is the sharp statement.** `ell_le_finrank_chart_along_tower` says chart finiteness
bounds `ℓ` along a tower and calls that "a substantive geometric restriction". It is not a
restriction on the *cover* at all — no cover appears in this statement. It is a restriction on
`k ⊆ K(X)`, which no choice of charts can change. -/
theorem module_finite_functionField_of_chart_finite {U : X.Opens} (hU : IsAffineOpen U)
    [Nonempty U] (hfin : Module.Finite k (sectionSub k U (0 : X.WeilDivisor))) :
    Module.Finite k X.functionField := by
  haveI hfd : FiniteDimensional k (chartAlg k U) := hfin
  have htop : chartAlg k U = ⊤ :=
    chartAlg_eq_top_of_isField k hU (fieldOfFiniteDimensional k (chartAlg k U)).toIsField
  exact Module.Finite.equiv
    ((Subalgebra.equivOfEq _ _ htop).toLinearEquiv.trans
      (Subalgebra.topEquiv (R := k) (A := X.functionField)).toLinearEquiv)

/-- **The binder is EQUIVALENT to a statement with no cover, no chart and no divisor in it.**
Forward is `module_finite_functionField_of_chart_finite`; backward, a `k`-submodule of a
`k`-finite space is `k`-finite.  Stating the equivalence is the point: it makes visible that
supplying the chart-finiteness binder is *exactly* assuming `K(X)/k` finite, and therefore that
no cleverness about covers or charts can ever satisfy it on a curve. -/
theorem chart_finiteness_iff_module_finite_functionField {U : X.Opens} (hU : IsAffineOpen U)
    [Nonempty U] :
    Module.Finite k (sectionSub k U (0 : X.WeilDivisor)) ↔ Module.Finite k X.functionField := by
  refine ⟨fun h => module_finite_functionField_of_chart_finite k hU h, fun h => ?_⟩
  exact Module.Finite.of_injective (sectionSub k U (0 : X.WeilDivisor)).subtype
    Subtype.val_injective

omit [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X] [IsConstantField k X] in
/-- **What closing this costs, as one hypothesis.**  If some `f : K(X)` is transcendental over
`k` then `K(X)/k` is not finite, so — by
`chart_finiteness_iff_module_finite_functionField` — the chart-finiteness binder fails at
*every* nonempty affine chart, and with it every §5–§6 refutation of `ChiUnconditional.lean`.

The hypothesis is exactly "the curve has a nonconstant function". AJC constructs such a
function in `NonconstantToP1.lean` for its own curve; wiring that in is downstream of this
module and is deliberately left as this named input rather than assumed here.

Pure field theory — no geometry is used, hence the `omit`. -/
theorem not_module_finite_functionField_of_transcendental
    (f : X.functionField) (hf : ¬ IsAlgebraic k f) :
    ¬ Module.Finite k X.functionField := fun hfin => by
  haveI : FiniteDimensional k X.functionField := hfin
  exact hf (Algebra.IsIntegral.isIntegral f).isAlgebraic

/-- **The refutations' binder is unsatisfiable on a curve with a nonconstant function.**  The
contrapositive form a consumer wants: no nonempty affine chart of such a curve has
finite-dimensional `Γ(U, 𝒪(0))`, so `ChiUnconditional.not_bump_of_notMem_left` and
`ledger_refuted_of_notMem_left` have unsatisfiable hypotheses there and refute nothing about a
curve. `hbump` and the closed ledger are **open** at a curve, not false. -/
theorem not_chart_finite_of_transcendental {U : X.Opens} (hU : IsAffineOpen U) [Nonempty U]
    (f : X.functionField) (hf : ¬ IsAlgebraic k f) :
    ¬ Module.Finite k (sectionSub k U (0 : X.WeilDivisor)) := fun hfin =>
  not_module_finite_functionField_of_transcendental k f hf
    (module_finite_functionField_of_chart_finite k hU hfin)

end ChartFiniteness

end Adelic
end AlgebraicGeometry
