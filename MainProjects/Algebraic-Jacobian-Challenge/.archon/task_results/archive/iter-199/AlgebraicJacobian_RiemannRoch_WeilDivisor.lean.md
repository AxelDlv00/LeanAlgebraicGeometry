# AlgebraicJacobian/RiemannRoch/WeilDivisor.lean

## Session summary

Lane WD-A4a-Noeth, iter-199. **Substrate-only delivery**. The HARD BAR
(`rationalMap_order_finite_support_of_isNoetherian` under `[IsNoetherian X]`)
was scoped, audited against Mathlib substrate, and ultimately **NOT
ADDED** because the recipe in the planner's directive requires
project-side infrastructure that does not exist in current Mathlib
(`b80f227`). The Hartshorne II.6.1 / Stacks 02RV proof needs the
open-immersion stalk-bridge and the affine-chart prime-divisor ↔
height-1-prime correspondence; these are themselves multi-hundred-LOC
sub-builds.

PUSH-BEYOND substrate sharpening LANDED axiom-clean:

- Added `Scheme.RationalMap.order_neg` (§2 sign-flip identity).
- Added `Scheme.RationalMap.order_pow_of_ne_zero` (§2 power identity).

Sorry count: 3 → 3 (no change). Axioms: 0 → 0.

## Substrate additions

### `Scheme.RationalMap.order_neg` (line ~290)
- **Approach**: `(-f)^2 = f^2` ⟹ `ordFrac (-f)^2 = ordFrac f^2` ⟹
  `log (ordFrac (-f)^2) = log (ordFrac f^2)` ⟹ via `WithZero.log_pow`
  ⟹ `2 • order(-f) = 2 • order f` ⟹ via `smul_right_injective ℤ`
  with `2 ≠ 0` ⟹ `order(-f) = order f`.
- **Result**: RESOLVED — axiom-clean
  (`{propext, Classical.choice, Quot.sound}`).
- **Use cases**:
  - Sign-flip identity for Hartshorne II.6.10 non-constant branch
    (constant function in `k̄ \ {0}` analysis).
  - Substrate for `principal_hom` extensions to `f ↦ -f` symmetry.
  - Substrate for divisor-of-`-f` symmetry in linear-equivalence
    derivations.

### `Scheme.RationalMap.order_pow_of_ne_zero` (line ~308)
- **Approach**: Induction on `n` via `pow_succ` + `order_mul_of_ne_zero`
  (existing iter-198 lemma) + `pow_ne_zero` for the nonzero hypothesis
  on `f^k`.
- **Result**: RESOLVED — axiom-clean
  (`{propext, Classical.choice, Quot.sound}`).
- **Use cases**:
  - Hartshorne II.6.9 ramification-inertia chase
    (`degree_positivePart_principal_eq_finrank` body, gated on
    Route C RR.1).
  - `div(f^n) = n · div(f)` identity for classical
    divisor-of-power computations.
  - Substrate for the multiplicativity-of-degree-under-finite-pullback
    bridge (Hartshorne II.6.9).

## `rationalMap_order_finite_support_of_isNoetherian` (NOT ADDED)

### HARD BAR analysis

The planner's directive cited Stacks 02RV + `Ideal.finite_minimalPrimes_of_isNoetherianRing`,
with the recipe: "pick affine open `U = Spec R` where `f` regular ⟹
height-1 primes containing `f` are minimal primes of `(f)`; use
`CompactSpace X` (consequence of `[IsNoetherian X]`) to bound the
irreducible components of `X \ U`."

### Mathlib substrate audit (verified during scouting)

**Available in `b80f227`:**
- `AlgebraicGeometry.IsNoetherian` (with `toCompactSpace`, `toIsLocallyNoetherian`).
- `AlgebraicGeometry.IsNoetherian.noetherianSpace` (NoetherianSpace on `X.carrier`).
- `TopologicalSpace.NoetherianSpace.finite_irreducibleComponents`
  (finitely many irreducible components on Noetherian topological
  spaces).
- `TopologicalSpace.NoetherianSpace.set` (subspaces of Noetherian
  spaces are Noetherian).
- `Ideal.finite_minimalPrimes_of_isNoetherianRing`
  (Krull's Hauptidealsatz: finitely many minimal primes).
- `Scheme.OpenCover.finiteSubcover` (CompactSpace ⟹ finite subcover).
- `Scheme.affineCover` (canonical affine open cover).
- `IsOpenImmersion.iff_isIso_stalkMap` (open immersion stalks).
- `instIsFractionRingCarrierStalkCommRingCatPresheafFunctionField`
  (stalks of integral scheme are fraction-ring-of-function-field).

**NOT in `b80f227` (structural gaps):**
- **Open-immersion-induced bijection from height-1 primes of the
  affine chart to prime divisors of `X` with point in the chart's
  image**: requires building the iso transport for
  `Order.coheight = 1` ↔ ideal height 1 across the open immersion.
  No direct Mathlib lemma.
- **Compatibility of `Ring.ordFrac` across open-immersion stalk
  isomorphisms**: requires `RingEquivClass` transport that respects
  the `MonoidWithZeroHom` structure of `Ring.ordFrac`. The
  `IsLocalization`-level analogue exists but the scheme-level
  transport via `Scheme.Hom.stalkMap` is not packaged.
- **Codim-1 generic point + open immersion ⟹ prime divisor of
  source corresponds to prime divisor of target**: the
  topological-coheight-to-ring-height bridge is itself a
  Mathlib-pending substrate (Stacks 02IZ / 005X). The project
  encountered this same gap in `RR.1` Lane I closure
  (`isRegularInCodimOneProjectiveLineBar`).

### Attempted approaches (none completed axiom-clean)

**Approach 1: Affine cover + finite subcover + per-chart bound.**
The strategy `X.affineCover.finiteSubcover` (CompactSpace ⟹
finite) + per-chart Krull min-primes (Ideal.finite_minimalPrimes_of_isNoetherianRing)
+ union over finitely many charts. Blocked by per-chart bound
infrastructure gaps (the open-immersion stalk-bridge above).

**Approach 2: Hartshorne split via single affine open U.**
Bound primes in U via Krull + bound primes outside U via
NoetherianSpace.finite_irreducibleComponents on X \ U. Blocked by:
(a) topological coheight ↔ algebraic height bridge for the
"in U" case (same gap as Approach 1); (b) the injection
"codim-1 generic points outside U ↪ codim-1 irreducible components
of X \ U" needs a careful chain-of-codim-1-closures injection that
itself requires substantial topology infrastructure on
`Order.coheight`.

**Approach 3: Black-box invocation of existing `rationalMap_order_finite_support`.**
The existing lemma at L307 has the weaker `[IsLocallyNoetherian X]`
hypothesis, so calling it under `[IsNoetherian X]` would work
SIGNATURE-WISE, but the existing lemma has a `sorry` body. Inheriting
this `sorry` would violate axiom-cleanliness. Aborted.

**Approach 4: Reduce to a weaker statement on a different carrier.**
Considered defining a weaker statement that bypasses the full
Hartshorne 6.1 — but the helper's signature is fixed by the planner.

### Informal agent

Not called this iter (substrate-only delivery; the obstruction is
infrastructure-level, not a single-step proof gap that an informal
suggestion would unblock).

## Next-iter recommendations

The HARD BAR (full Hartshorne II.6.1 closure) requires substantial
project-side infrastructure that is itself worth multiple iter-budgets:

### Sub-build 1 (priority): open-immersion stalk-bridge for prime divisors

**Statement**: For an open immersion `g : U → X` of schemes and
`y : U`, the bijection between primes of the chart and prime divisors
of `X` with point in `g`'s image, with compatibility for
`Order.coheight` (= 1 ⟺ ideal height = 1) and stalk-level `Ring.ordFrac`
transport via `IsOpenImmersion.iff_isIso_stalkMap`.

**Recipe**: ~150-250 LOC. Reference: Stacks 02IZ / 005X (topological
coheight ↔ algebraic ideal height bridge), plus
`AlgebraicGeometry.Scheme.stalkMap` naturality.

### Sub-build 2 (paired): affine prime-divisor structure for the chart

**Statement**: For a Noetherian integral affine scheme `Spec R`, the
prime divisors of `Spec R` are exactly the height-1 primes of `R`.

**Recipe**: ~50-100 LOC. Reference: Stacks 02RW. Maps
`X.PrimeDivisor (Spec R)` ↔ `{p : Ideal R | p.IsPrime ∧ p.height = 1}`.

### Sub-build 3 (final closure): re-attempt `rationalMap_order_finite_support_of_isNoetherian`

Once Sub-builds 1 and 2 land, the recipe becomes:
1. Use `X.affineCover.finiteSubcover` (~5 LOC).
2. For each chart, apply Sub-build 1 + Sub-build 2 + Krull min-primes
   (~30 LOC per chart).
3. Union over finite charts ⟹ finite support (~10 LOC).

**Total**: ~40-50 LOC of "glue" code, given Sub-builds 1 + 2 land.

### Alternative: USER directive amendment

Strengthening the public signature of `rationalMap_order_finite_support`
from `[IsLocallyNoetherian X]` to `[IsNoetherian X]` (with consumer
propagation through L538/L1108) is currently blocked by USER directive
"Route C scoped" on those consumers. A USER amendment enabling this
strengthening would let the project close the helper transparently
(once Sub-builds 1 + 2 land).

## Summary

- **Declarations added**: 2 (`order_neg`, `order_pow_of_ne_zero`),
  both axiom-clean.
- **Declarations blocked**: 1
  (`rationalMap_order_finite_support_of_isNoetherian`); structural
  infrastructure gap (open-immersion stalk-bridge for prime
  divisors).
- **Sorry count**: 3 → 3 (no change).
- **Axiom count**: 0 → 0 (kernel-only, 19th consecutive zero-axiom
  build streak).

## Why I stopped

`Partial progress`: 2 axiom-clean substrate lemmas added
(`order_neg` @ L290, `order_pow_of_ne_zero` @ L308), realizing the
"PUSH-BEYOND: scan §1-§2 for additional A.4.a substrate sharpening"
goal of the planner. The HARD BAR
(`rationalMap_order_finite_support_of_isNoetherian` axiom-clean) is
not landed.

`Blocked — alternatives exhausted`: The HARD BAR requires the
open-immersion stalk-bridge for prime divisors (Sub-build 1 above),
which is a Mathlib-pending substrate that no single-iter helper budget
can deliver. All 4 closure approaches above were scoped and rejected
for infrastructure-soundness reasons. The realistic-band projection
from PROGRESS.md ("78 → ~76-77, −1 to −2") was already conditional on
the helper closing — without it, we land at 78 → 78 (no change in
sorry count, but 2 axiom-clean PUSH-BEYOND substrate lemmas added).

### Routes for planner

1. **Re-dispatch with sub-build directive**: ask for Sub-build 1
   (open-immersion stalk-bridge for prime divisors) as an isolated
   ~150-250 LOC lane in iter-200. This is itself the genuine
   bottleneck for `rationalMap_order_finite_support_of_isNoetherian`,
   and would be a substantial Route A advance.

2. **USER directive amendment**: request enabling the strengthening
   of the public signature of `rationalMap_order_finite_support`
   from `[IsLocallyNoetherian X]` to `[IsNoetherian X]`, with
   consumer propagation through L538/L1108 (Route C RR.1). Without
   the amendment, even closing the helper would not propagate to
   the public sorry at L325 because the public signature stays at
   the weaker hypothesis.

3. **Mathlib upstream PR**: contribute the open-immersion stalk-bridge
   for prime divisors to Mathlib upstream, with the project picking it
   up on next Mathlib bump. This is the cleanest long-term solution.

## Blueprint notes for review agent

- `lem:rationalMap_order_finite_support` in
  `chapters/RiemannRoch_WeilDivisor.tex` is the blueprint pin for
  this helper. It was added iter-199 plan-phase. Status this iter:
  unchanged. No `\leanok` to add (sync_leanok handles this).
- Two new declarations `order_neg`, `order_pow_of_ne_zero` are
  unpinned in the blueprint (project-bespoke §2 substrate, not
  Hartshorne-pinned). The review agent may add `\lean{...}` pins
  if desired, or leave them as anonymous helpers in the file.
