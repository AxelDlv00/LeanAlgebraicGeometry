# Mathlib Analogist Report

## Mode
api-alignment

## Slug
dvr-rationalmap-order

## Iteration
175

## Question
For the body of `AlgebraicGeometry.Scheme.RationalMap.order`
(`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` L140), what is the correct
Mathlib API path to (a) extract the discrete valuation at a codim-1 point of
a (locally noetherian, regular-in-codim-1) integral scheme, (b) extend that
valuation from the local ring to the fraction field, and (c) handle the
junk-on-`f = 0` convention?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Use `Ring.ordFrac` for the order extension to fraction field | ALIGN_WITH_MATHLIB | critical |
| 2. Use `WithZero.log` for junk-on-`f = 0` → `ℤ` | ALIGN_WITH_MATHLIB | critical |
| 3. Bridge `Order.coheight = 1` → `Ring.KrullDimLE 1` on stalk | NEEDS_MATHLIB_GAP_FILL | informational |

## Major

Both ALIGN_WITH_MATHLIB verdicts apply to the in-proposal body (current
state: `sorry`), not to shipped code — the planner can adopt the idiom
directly. Concretely the iter-175 prover should:

- **Decision 1**: Make the body of `order` invoke `Ring.ordFrac
  (X.presheaf.stalk Y.point) f`. This is the Mathlib API for the
  fraction-field extension of the order/valuation function on a Noetherian
  Krull-dim-≤-1 ring (defined at `Mathlib.RingTheory.OrderOfVanishing.Basic:324`,
  Stacks `02MD`). Its hypothesis set
  (`[Nontrivial], [IsNoetherianRing], [Ring.KrullDimLE 1]`) is exactly
  Hartshorne's `(*)` minus regularity (regularity merely promotes the local
  ring to a DVR; for `ordFrac` the bare Krull-dim-1 suffices, since
  `Ring.ord r = length(R/(r))` already coincides with the DVR valuation
  whenever the local ring IS a DVR — `IsDiscreteValuationRing.addVal` and
  `Ring.ord` agree on uniformizers via `ord_of_irreducible : ord R ϖ = 1`).
  Avoiding this idiom forces a parallel build of 4–6 bridge lemmas
  (`addVal` → `Valuation` → `extendToLocalization` → `ℕ∞ → ℤ` junk choice
  → algebraic identities for `principal_hom`); aligning saves all of that.
- **Decision 2**: Project `ℤᵐ⁰` to `ℤ` via `WithZero.log` (at
  `Mathlib.Algebra.GroupWithZero.WithZero:394`). `log_zero` supplies the
  junk-on-`f = 0` convention; `log_mul`/`log_pow` supply the additive
  identities `thm:principal_hom` will consume.

**Proposed body** (iter-175 prover lane, copied from the persistent file):

```lean
noncomputable def order {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] (Y : X.PrimeDivisor)
    [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]
    (f : X.functionField) : ℤ :=
  WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)
```

## Informational

- **Decision 3** (NEEDS_MATHLIB_GAP_FILL): Mathlib does NOT ship a direct
  bridge from `Order.coheight x = 1` (topological coheight in the
  specialisation preorder of `X.carrier`) to `Ring.KrullDimLE 1
  (X.presheaf.stalk x)`. The intermediate step "ideal-height → stalk
  Krull-dim" IS in Mathlib
  (`IsLocalization.AtPrime.ringKrullDim_eq_height` +
  `IsAffineOpen.isLocalization_stalk`); the missing piece is the
  topological-to-prime-spectrum identity
  `Order.coheight (x : Spec R) = (asIdeal x).height` (Stacks `02IZ`/`005X`).
  - **Workaround for iter-175**: thread `[Ring.KrullDimLE 1
    (X.presheaf.stalk Y.point)]` as an *explicit* typeclass argument on
    `order` (and downstream consumers). This is local enough that the
    blueprint pin is unaffected and lets `Ring.ordFrac` typecheck.
  - **Long-term**: a small Mathlib PR pinning the bridge would let the
    project synthesise the codim-1 stalk Krull-dim purely from the
    structure carrier `Order.coheight Y.point = 1` — but this is NOT on
    the iter-175 critical path.
- **Blueprint amendment**: `def:order_at_point` in
  `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` should grow a
  "Lean encoding" paragraph stating `order Y f := WithZero.log (Ring.ordFrac
  (X.presheaf.stalk Y.point) f)` plus the `[Ring.KrullDimLE 1 _]`
  thread; this closes the lean-vs-blueprint-checker iter-174
  `weildivisor-iter174` MAJOR finding. (The blueprint-writer dispatch in
  parallel this plan-phase should pick this up.)
- **Forward-looking**: the same `Ring.ordFrac` + `WithZero.log`
  combination is the right shape for the body of
  `Scheme.WeilDivisor.principal` (L258) and `principal_hom` (L273) — the
  algebra identities `log_mul`/`log_one` close `principal_hom` in a
  handful of lines once the orderwise sum-over-prime-divisors framework
  exists. This means a single API alignment closes three pins, not just
  one.

## Persistent file
- `analogies/dvr-rationalmap-order.md` — design rationale captured for
  iter-176+ (includes Mathlib citations with paths + line numbers,
  proof-skeleton, downstream impact on `principal_hom`).

Overall verdict: use `Ring.ordFrac` + `WithZero.log` for the body
(`Mathlib.RingTheory.OrderOfVanishing.Basic:324` + `Mathlib.Algebra.GroupWithZero.WithZero:394`);
thread `[Ring.KrullDimLE 1 _]` as an explicit instance argument until the
topological-coheight-to-stalk-Krull-dim Mathlib bridge is closed.
