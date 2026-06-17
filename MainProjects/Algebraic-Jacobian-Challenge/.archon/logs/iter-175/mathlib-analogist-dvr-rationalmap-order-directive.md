# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
dvr-rationalmap-order

## Design question

For the body of `AlgebraicGeometry.Scheme.RationalMap.order`
(`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` L140), what is the correct
Mathlib API path to (a) extract the discrete valuation at a codim-1 point of
a (locally noetherian, regular-in-codim-1) integral scheme, (b) extend that
valuation from the local ring to the fraction field, and (c) handle the
junk-on-`f = 0` convention?

The Lean signature is:

```lean
noncomputable def order [IsIntegral X]
    (Y : X.PrimeDivisor) (f : X.functionField) : ℤ := sorry
```

(no `f ≠ 0` hypothesis — junk on `f = 0`).

The blueprint chapter (`RiemannRoch_WeilDivisor.tex`, `def:order_at_point`)
informally describes the construction as: at a codim-1 point `Y` with local
ring `O_{X,Y}` a discrete valuation ring (after the regular-in-codim-1
hypothesis), the valuation `v_Y : O_{X,Y} → ℤ ∪ {∞}` extends to the
fraction field `K(X)` by `v_Y(f/g) := v_Y(f) − v_Y(g)`. Junk-on-`f = 0`
convention chosen so the Lean signature matches the blueprint's
`f ∈ K(X)^×` pin without an explicit `f ≠ 0` argument.

## Project artifact(s) under question

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`:140-142 — `RationalMap.order` declaration with body `sorry`.
- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`, `def:order_at_point` block.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`:80-91 — `Scheme.PrimeDivisor` structure (`coheight 1` field).

## Why now

iter-175 Lane D's prover target is the body of `RationalMap.order`. The
iter-174 lean-vs-blueprint-checker `weildivisor-iter174` MAJOR finding was
that `def:order_at_point` is under-specified for the next-iter body (no
Mathlib API pinning, no junk-on-`f = 0` convention statement). A writer
dispatch this plan-phase is closing the blueprint-side gap; the prover
side needs a Mathlib API recipe from you so Lane D can fire iter-175.

The bridge from "codim-1 point `Y` on an integral scheme with `X.PrimeDivisor`'s
`coheight 1` hypothesis" to "the local ring at `Y` is a DVR" is itself
non-trivial — please name the Mathlib instance / lemma chain (e.g.,
`IsDiscreteValuationRing.of_height_one_dvr` or analog; if absent, name the
gap).

## Hints

Mathlib has `IsDiscreteValuationRing.addVal` (the additive valuation on a
DVR). The extension to the fraction field is via `IsFractionRing.fieldEquiv`
or `IsLocalization.AtPrime.localRingHom`-style lifts; the exact name we want
is the one that gives an `addVal_extension : K → WithTop ℤ` (or `ℤ ∪ {∞}`).

For "junk on `f = 0`", Mathlib's idiom is typically `Multiplicative` of
`WithBot ℤ` (with `bot` = `0`-valuation), or unbundled "`if f = 0 then ⊥
else …`". Per the Lane D directive, we want the `ℤ` codomain (matching
the blueprint), so the junk value would be `0` (or a project-defined
sentinel). What is Mathlib's canonical pattern for codim-1 valuations in
this exact setting (Weil divisors at scheme level)?

Note that Mathlib's `Multiplicity` / `Polynomial.rootMultiplicity` and the
DVR `addVal` have different return types (`PartENat` vs. `WithTop ℤ`); the
right Mathlib idiom may involve `addVal.toMonoidHom` or unbundled extraction.

## Severity expectation

high-stakes — this is the core RR.1 order function; gets reused in
`principal_hom` and ultimately in `principal_degree_zero`'s Hartshorne 6.10
sketch.

Please persist your recommendation to `analogies/dvr-rationalmap-order.md`
with: (i) the Mathlib API chain for valuation extraction, (ii) the
DVR-from-codim-1-point chain (or the gap to fill), (iii) the junk-on-`f = 0`
convention recommendation, and (iv) a concrete proof skeleton for the body.
