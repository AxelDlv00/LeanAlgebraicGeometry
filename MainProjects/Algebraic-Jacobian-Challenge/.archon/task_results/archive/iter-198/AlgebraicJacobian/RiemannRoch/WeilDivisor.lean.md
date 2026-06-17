# AlgebraicJacobian/RiemannRoch/WeilDivisor.lean — iter-198 prover report

## Summary

- **Declarations added (6, all axiom-clean)**:
  - `Scheme.RationalMap.order_zero` (L233, §2 substrate)
  - `Scheme.RationalMap.order_mul_of_ne_zero` (L242, §2 substrate)
  - `Scheme.RationalMap.order_inv` (L258, §2 substrate)
  - `Scheme.RationalMap.order_units_inv` (L274, §2 substrate)
  - `Scheme.WeilDivisor.degree_neg` (L488, §4 substrate)
  - `Scheme.WeilDivisor.degree_sub` (L497, §4 substrate)
- **Declarations blocked (1)**: `rationalMap_order_finite_support` (L325) non-zero branch — genuine mathematical blocker. The statement is stated under `[IsLocallyNoetherian X]` but the proof (Stacks 02RV / Hartshorne II.6.1) requires `[IsNoetherian X]` (= `[IsLocallyNoetherian X]` + `[CompactSpace X]`).
- **Sorry count**: 3 → 3 (unchanged; structural blocker on L249, now relabelled L325 after substrate additions).
- **f = 0 branch cleanup**: refactored to use the new `order_zero` lemma instead of in-line unfolding. Net cleaner code.

## Sections

### Scheme.RationalMap.order_zero (L233)
- **Approach**: `unfold` + `map_zero` (for `Ring.ordFrac _` being a monoid-with-zero hom) + `WithZero.log_zero`. 4 lines.
- **Result**: RESOLVED — axiom-clean ({propext, Classical.choice, Quot.sound}).

### Scheme.RationalMap.order_mul_of_ne_zero (L242)
- **Approach**: `unfold` + `map_mul` (monoid-with-zero hom) + `WithZero.log_mul` (requires both factors nonzero; provided by `map_ne_zero` and the hypotheses).
- **Result**: RESOLVED — axiom-clean ({propext, Classical.choice, Quot.sound}).
- **Reuse**: can refactor `principal_hom.map_mul'` body (L484-L504) to invoke this lemma — left as iter-199+ optional cleanup.

### Scheme.RationalMap.order_inv (L258)
- **Approach**: `unfold` + `map_inv₀` (for `Ring.ordFrac _ : K →*₀ ℤᵐ⁰` and `K` a field/group-with-zero) + `WithZero.log_inv` (junk-zero convention).
- **Result**: RESOLVED — axiom-clean ({propext, Classical.choice, Quot.sound}). Notably works without `f ≠ 0` hypothesis.

### Scheme.RationalMap.order_units_inv (L274)
- **Approach**: bridge `((u⁻¹ : K(X)ˣ) : K(X)) = (u : K(X))⁻¹` via `simp`, then apply `order_inv`.
- **Result**: RESOLVED — axiom-clean ({propext, Classical.choice, Quot.sound}).
- **Reuse**: useful for `principal_hom.map_inv'` analogue if/when bundled.

### Scheme.WeilDivisor.degree_neg (L488)
- **Approach**: rewrite via `degree_hom_apply`, invoke `map_neg` on the `AddMonoidHom degree_hom`. 3 lines.
- **Result**: RESOLVED — axiom-clean ({propext, Classical.choice, Quot.sound}).

### Scheme.WeilDivisor.degree_sub (L497)
- **Approach**: rewrite via `degree_hom_apply` three times, invoke `map_sub` on the `AddMonoidHom degree_hom`. 3 lines.
- **Result**: RESOLVED — axiom-clean ({propext, Classical.choice, Quot.sound}).

### rationalMap_order_finite_support L249 → L325 (non-zero branch)
- **Approach 1 — Affine open + minimal primes**: Pick a nonempty affine open `U ⊂ X`, get `R = Γ(U, O_X)` Noetherian integral domain, write `f = a/b ∈ Frac(R) = K(X)`. Bound prime divisors with `Y.point ∈ U` via `Ideal.finite_minimalPrimes_of_isNoetherianRing` on `(a * b) ⊂ R`. **STALLED**: prime divisors with `Y.point ∉ U` correspond to irreducible components of the closed set `X \ U` of codim 1 in `X`. Bounding their cardinality requires `X \ U` to be Noetherian as a topological space — equivalently, `X` must be globally Noetherian (`AlgebraicGeometry.isNoetherian_iff`: `IsNoetherian X ↔ IsLocallyNoetherian X ∧ CompactSpace X`). The current signature has only `[IsLocallyNoetherian X]`.
- **Approach 2 — Dedekind-domain Mathlib analogue**: `IsDedekindDomain.HeightOneSpectrum.Support.finite` gives the analogue for `R` Dedekind, `k ∈ Frac(R)`. Adapting to schemes requires the affine-chart bridge `ord_Y(f) ≠ 0 ↔ height-1 prime in chart-ring divides numerator or denominator`. **STALLED**: requires the same Noetherian-X-as-topological-space gap.
- **Approach 3 — Try to derive `[IsNoetherian X]` from existing hypotheses**: `[IsIntegral X]` + `[IsLocallyNoetherian X]` does NOT imply `[CompactSpace X]` (counter-example: infinite-dim integral locally Noetherian scheme without quasi-compactness). The bridge `[IsRegularInCodimensionOne X]` is independent of compactness. No clean derivation path.
- **Approach 4 — Informal agent consultation**: attempted `archon-informal-agent.py --provider kimi` and `--provider auto`; both returned `API error 401: Invalid Authentication` (Moonshot key in env is stale). No working LLM key available for sketch.
- **Result**: NOT ADDED (sorry preserved from iter-192). Existing comment expanded with a precise structural-blocker analysis (~30 lines) documenting the affine-open / outside-set / Dedekind bridge and the iter-199+ resolution path.
- **Next step**: iter-199+ planner should consider strengthening `rationalMap_order_finite_support`'s typeclass to `[IsNoetherian X]` and propagate to all consumers (`principal`, `principal_apply`, `principal_one`, `principal_hom`, `principal_degree_zero`, `degree_positivePart_principal_eq_finrank`, `LinearEquivalence`). The propagation is mechanical for the curve-side consumers because `[IsProper C.hom]` over `Spec(.of kbar)` gives `CompactSpace C.left` for free. Per the iter-198 USER directive, those declarations are Route C PAUSED — so the signature strengthening is itself gated.
- **Dead end**: Do not retry the proof under `[IsLocallyNoetherian X]` alone — the statement is mathematically false in that generality (any non-quasi-compact integral locally Noetherian scheme with infinitely many disjoint codim-1 irreducible components is a counter-example).

## Blueprint markers

New declarations added in §2 and §4 of the chapter `RiemannRoch_WeilDivisor.tex`. The 6 new lemmas should be added to the chapter informally by the planner (blueprint writes are read-only for provers). The deterministic `sync_leanok` phase will manage `\leanok` markers next iter.

## Mathlib gaps documented

- `[IsNoetherian X]` vs `[IsLocallyNoetherian X]` for `rationalMap_order_finite_support` (the central blocker).
- `Ring.isUnit_iff_ordFrac_one_of_isDiscreteValuationRing` is available for per-Y bridges (DVR stalk case) — can be used for refactoring `order Y u = 0 for u : (stalk Y.point)ˣ` if needed in iter-199+.

## Why I stopped

**Real progress**: 6 axiom-clean substrate lemmas added in §2/§4. Verified via `lean_verify`:
- `AlgebraicGeometry.Scheme.RationalMap.order_zero` — axiom-clean.
- `AlgebraicGeometry.Scheme.RationalMap.order_mul_of_ne_zero` — axiom-clean.
- `AlgebraicGeometry.Scheme.RationalMap.order_inv` — axiom-clean.
- `AlgebraicGeometry.Scheme.RationalMap.order_units_inv` — axiom-clean.
- `AlgebraicGeometry.Scheme.WeilDivisor.degree_neg` — axiom-clean.
- `AlgebraicGeometry.Scheme.WeilDivisor.degree_sub` — axiom-clean.

**Blocked — alternatives exhausted**: `rationalMap_order_finite_support` L249 non-zero branch genuinely requires `[IsNoetherian X]` (= `[IsLocallyNoetherian X]` + `[CompactSpace X]`), but the existing signature only has `[IsLocallyNoetherian X]`. Tried:
1. Direct affine-open + minimal-primes (FAILED — "outside" bound needs global Noetherian).
2. Dedekind-domain HeightOneSpectrum analogue (FAILED — same gap).
3. Type-class derivation of `[IsNoetherian X]` from existing hypotheses (FAILED — no such derivation; counter-examples exist).
4. Informal agent consultation (FAILED — no working LLM API key in env, 401 Invalid Authentication on Moonshot/auto).

Strengthening the signature requires propagating `[IsNoetherian X]` to the (Route C PAUSED) consumers `principal_degree_zero` and `degree_positivePart_principal_eq_finrank` — which the USER directive forbids touching this iter. So the resolution path is iter-199+ planner work under USER approval.

**Sorry count**: 3 → 3 (no net change in sorries; pure substrate growth).
