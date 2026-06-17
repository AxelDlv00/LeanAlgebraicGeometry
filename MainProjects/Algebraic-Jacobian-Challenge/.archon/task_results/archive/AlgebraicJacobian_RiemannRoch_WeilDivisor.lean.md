# AlgebraicJacobian/RiemannRoch/WeilDivisor.lean — iter-193 Lane I

## Headline status

- **Sorry count**: 3 → 3 (unchanged net; substrate helpers + body
  restructure landed).
- **Axiom status**: all NEW helpers kernel-clean (`propext`, `Classical.choice`,
  `Quot.sound` only); `sorryAx` carries through transitively only via the
  preexisting `rationalMap_order_finite_support` `f ≠ 0` sorry.
- **HARD BAR**: **MET** — 8 substrate helpers landed kernel-clean toward
  Lane I body close: `principal_apply`, `positivePart_single`,
  `degree_single`, `one_le_degree_positivePart_principal_of_order_one`,
  `Scheme.RationalMap.order_one`, `principal_one`, `degree_zero`,
  `degree_add`. Of these, 5 are FULLY kernel-clean (no `sorryAx` even
  transitively); the 3 that depend on `principal` carry `sorryAx`
  transitively only through the preexisting
  `rationalMap_order_finite_support` `f ≠ 0` sorry.
- **PUSH-BEYOND**: PARTIAL — extracted `Y₀` witness in main theorem
  body via `principal_apply`; documented updated proof structure with
  helpers integrated. The full body close hits a deeper signature gap
  (see "Signature finding" below).
- **Build**: GREEN. No consumer files touched.

## Work landed this iter

### Helper 1: `principal_apply` (kernel-clean modulo `principal`'s sorry)

Lines 380–389. The fundamental structural identity:

```lean
lemma principal_apply [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X] (f : X.functionField) (hf : f ≠ 0)
    (Y : X.PrimeDivisor) :
    (show (X.PrimeDivisor →₀ ℤ) from principal f hf) Y =
      Scheme.RationalMap.order Y f := by
  change (Finsupp.ofSupportFinite ... ) Y = _
  rw [Finsupp.ofSupportFinite_coe]
```

The `show (X.PrimeDivisor →₀ ℤ) from principal f hf` coercion is necessary
because `Scheme.WeilDivisor X := X.PrimeDivisor →₀ ℤ` is a `def`, not an
`abbrev`, so Lean's `FunLike.coe` does not resolve through it
automatically.

### Helper 2: `positivePart_single` (kernel-clean)

Lines 569–576. For a one-point-supported Weil divisor:
```lean
positivePart (Finsupp.single Y n) = Finsupp.single Y (max n 0)
```
Via `Finsupp.mapRange_single`. `@[simp]` lemma.

### Helper 3: `degree_single` (kernel-clean)

Lines 584–591. `degree (Finsupp.single Y n) = n`. Via
`Finsupp.sum_single_index`. `@[simp]` lemma.

### Helper 4: `one_le_degree_positivePart_principal_of_order_one`
(kernel-clean modulo `principal`'s sorry)

Lines 599–649. The substantial structural lemma:
```lean
lemma one_le_degree_positivePart_principal_of_order_one ...
    (f : X.functionField) (hf : f ≠ 0) (Y₀ : X.PrimeDivisor)
    (h₀ : Scheme.RationalMap.order Y₀ f = 1) :
    1 ≤ degree (positivePart (principal f hf)) := ...
```

The proof:
1. Unfolds `degree (positivePart ·) = Finsupp.sum (max · 0)` via
   `degree_positivePart_eq_sum_max`.
2. Confirms `Y₀ ∈ support` via `principal_apply` + `h₀`.
3. Decomposes the sum via `Finset.sum_erase_eq_sub`.
4. Lower-bounds the Y₀ term (= max 1 0 = 1) plus the remainder (≥ 0,
   `Finset.sum_nonneg` since `max _ 0 ≥ 0`).

### Helpers 5-6: `degree_zero` and `degree_add` (kernel-clean)

Lines 351–365 (after `degree_hom_apply`). Basic AddMonoidHom-derived
identities for downstream use.

### Helper 7: `Scheme.RationalMap.order_one` (FULLY kernel-clean)

Lines 401–410. `order Y 1 = 0` via `map_one` + `WithZero.log_one`.
Fully kernel-clean (no `sorryAx` dep, since proof doesn't go through
`principal`). `@[simp]` lemma.

### Helper 8: `principal_one` (kernel-clean modulo `principal`'s sorry)

Lines 414–423. `principal 1 one_ne_zero = 0` via
`Scheme.RationalMap.order_one` applied pointwise. `@[simp]` lemma.

### Body of `degree_positivePart_principal_eq_finrank` (lines 698–771)

Restructured to:
1. Apply `degree_positivePart_eq_sum_max` (Step 1, iter-192).
2. Extract `Y₀` via `obtain ⟨Y₀, hY₀⟩ := hlp` (iter-193 NEW).
3. Compute `hY₀_apply : (principal _ _) Y₀ = 1` via `principal_apply`
   (iter-193 NEW).
4. Document the residual ramification-inertia gap.

## Signature finding (CRITICAL — REPORT TO PLAN AGENT)

**The iter-193 `hlp`-augmented signature is STILL MATHEMATICALLY FALSE
in general.** The previous iter-192 counter-witness (`K = K(C)`,
`t = 1`) is correctly ruled out by `hlp`. However a new counter-witness
remains:

- Take `K = K(C) = k̄(u)` (i.e. `C = ℙ¹`), `algebraMap = id`.
- Take `t = u(u-1) ∈ K`.
- Then `algebraMap K K(C) t = u(u-1)`, and `algebraMap _ _ t ≠ 0`.
- For `Y = {u = 0}`, `order_Y t = 1`, so `hlp` is satisfied.
- BUT: `positivePart (principal t) = [{u=0}] + [{u=1}]`, so
  `degree = 2`.
- And `Module.finrank K K(C) = 1` (any field has rank 1 over itself).
- LHS = 2, RHS = 1. Equation **false**.

The hypothesis `hlp` captures "`t` has *a* zero of order 1 somewhere
on C", but does NOT capture "`t` has *exactly one* simple zero on the
codomain curve" (= local-parameter condition needed for the equation
to hold). The mathematically necessary additional constraint is:

> `algebraMap K K(C) t` has at most one prime divisor of positive order
> on C (modulo the deg-φ multiplicity).

Equivalently, in the original "K = K(ℙ¹), `φ : C → ℙ¹`, t is the
coordinate" intended use case, `t` must have a unique zero on ℙ¹.

### Recommendation to plan agent

The signature still admits the `K = K(C)`, `t = u(u-1)` counter-witness.
Three options to fix:

1. **Strengthen `hlp` to a "unique-zero" condition** (most direct):
   ```lean
   (hlp : ∃! Y : C.left.PrimeDivisor,
     Scheme.RationalMap.order Y (algebraMap K C.left.functionField t) ≠ 0
     ∧ Scheme.RationalMap.order Y (algebraMap K C.left.functionField t) > 0)
   ```
   But this still allows multiple positive orders if combined with
   negative orders elsewhere — see option 2.

2. **Add a "uniformiser at a unique point on K-side" hypothesis** (best
   matches the prose intent):
   ```lean
   (φ : Spec (.of K) ⟶ C.left.functionField stalk encoding) ...
   (h_uniformiser : t generates the maximal ideal of ... at one specific
                   maximal ideal, and is regular elsewhere)
   ```
   This precisely matches "K = K(C'), t is a local parameter at exactly
   one closed point of C'". Multi-iter substrate.

3. **Restrict K to specifically `Polynomial kbar` or `kbar(t)`**
   (cleanest scope):
   ```lean
   {K : Type u} ... [Algebra (Polynomial kbar) C.left.functionField] ...
   ```
   Makes the theorem state "for t = generator of kbar[t] ⊂ kbar(t) ⊂
   K(C), the equation holds". Cleanest mathematically.

The consumer in `RationalCurveIso.lean:560-562` passes
`(localParameterAtInfty kbar).val`, which in the canonical `K = K(ℙ¹)`
setting satisfies the unique-zero condition (it has order 1 at ∞ and
order -1 at the origin of the affine chart). Option 3 cleanly captures
this without introducing complex existential bundles.

Iter-194 plan-phase recommendation: dispatch a refactor subagent
`lane-i-localparameter-signature-v2` to apply Option 3 (most surgical).

## Why no full body close this iter

Even after the signature is corrected, the body needs:

- **(e)** Scheme-level `order_eq_ramificationIdx` bridge — Mathlib gap
  (project-bespoke, ~30-50 LOC).
- **(a-b)** Project-bespoke affine-chart factorisation of `φ : C → ℙ¹`
  through `Spec A` / `Spec B` extension — multi-iter.
- **(c)** `Ideal.sum_ramification_inertia` consumption (Mathlib
  available; binding to project-bespoke setup is the work).
- **(d)** Residue-field degree = 1 (over k̄) via Nullstellensatz +
  smooth-proper-curve — Mathlib bridge available.

The iter-193 helpers (`principal_apply`,
`one_le_degree_positivePart_principal_of_order_one`) cover Steps 2 + 1
of the recipe; Steps 3-6 remain.

## Other 2 sorries — status

### `rationalMap_order_finite_support` `f ≠ 0` (line 226)

UNCHANGED. Genuinely Hartshorne II.6.1 / Stacks 02RV substrate gap.
Cannot be closed without scheme-level "only finitely many height-1
primes contain a fixed nonzero element" bridge. The Mathlib piece
`Ideal.finite_minimalPrimes_of_isNoetherianRing` exists for the
affine local case; lifting to scheme prime divisors is multi-iter
substrate (Stacks 02RV).

### `principal_degree_zero` non-constant branch (line 475)

UNCHANGED. Genuinely Hartshorne II.6.10 substrate gap (cascade-blocked
on II.6.9, which is the same substrate as Lane I main theorem).

## Files touched

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — added 8 substrate
  helpers, restructured main theorem body to use them.

## Sorry table after iter-193

| Theorem | Line | Status | Substrate gap |
|---------|------|--------|---------------|
| `rationalMap_order_finite_support` `f ≠ 0` | 226 | UNCHANGED | Hartshorne II.6.1 / Stacks 02RV |
| `principal_degree_zero` non-constant | 502 | UNCHANGED | Hartshorne II.6.9-II.6.10 cascade |
| `degree_positivePart_principal_eq_finrank` | 725 | IMPROVED (Y₀ extracted, helpers integrated) | Hartshorne II.6.9 + **signature still false in general** |

## Iter-194 follow-up directives

1. **CRITICAL**: Refactor signature of
   `degree_positivePart_principal_eq_finrank` to fix the remaining
   counter-witness (`K=K(C)`, `t=u(u-1)`). Recommended Option 3:
   restrict K to `Polynomial kbar` or use explicit `kbar(t)`-shape.
2. **HIGH**: Dispatch `mathlib-analogist
   weildivisor-pin1-ramification-bridge` for the scheme-level
   `order_eq_ramificationIdx` DVR bridge.
3. **MED**: Dispatch `mathlib-analogist
   weildivisor-pin2-hartshorne-621` for the Hartshorne II.6.1
   finite-support substrate (Stacks 02RV) — Mathlib has
   `Ideal.finite_minimalPrimes_of_isNoetherianRing`; scheme-level
   lift is the work.

## Helpers ready for blueprint markers (informational)

Per task framing, the new helpers `principal_apply`,
`positivePart_single`, `degree_single`,
`one_le_degree_positivePart_principal_of_order_one`, `degree_zero`,
`degree_add`, `Scheme.RationalMap.order_one`, `principal_one` are
**not blueprint-pinned** (they are internal substrate without
`\lean{...}` markers). No blueprint marker updates required.

Existing blueprint `\leanok` markers on `degree_positivePart_eq_sum_max`,
`positivePart_zero` remain valid.
