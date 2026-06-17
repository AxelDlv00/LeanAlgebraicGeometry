# AlgebraicJacobian/RiemannRoch/OCofP.lean

Iter-195 Lane A (#6) — unconditional fallback objectives on substrate
helpers L1209 + L1323; cascade objective L1147 if Lane H lands.

3 sorries entering the iter; 3 sorries on exit. Substantive structural
advance on the L1323 substrate helper (`exists_nonconstant_rational_from_dim_eq_two`).

## L1323 `exists_nonconstant_rational_from_dim_eq_two`

### Attempt 1 — substantive structural advance (PARTIAL, ~50 LOC)

- **Approach:** Decompose the existing `s₁`-only partial setup into
  the full linear-algebra extraction chain spelled out in the
  helper's docstring.

- **Substantive new content (axiom-clean, no new sorries introduced):**

  1. `htF_zero : toFunctionField (C := C) P hP hPcoh 0 = 0` —
     proved via `simp only [toFunctionField, map_zero, Functor.map_zero]; rfl`.
     The `Functor.map_zero` simp lemma fires through `sheafToPresheaf.map`,
     and the `Subtype.val` projection of the zero element of the
     `carrierSubmoduleSheaf` is `0 : K(C)`.

  2. `htF_smul : ∀ c s, toFunctionField (c • s) = c • toFunctionField s` —
     kbar-linearity in the scalar argument, one-liner via
     `simp only [toFunctionField, map_smul]; rfl`.

  2b. `htF_add : ∀ a b, toFunctionField (a + b) = toFunctionField a +
     toFunctionField b` — kbar-additivity, one-liner via
     `simp only [toFunctionField, map_add, Functor.map_add]; rfl`.
     Together with `htF_smul`, this establishes that `toFunctionField`
     is a kbar-linear map `H⁰ → K(C)` (committed as separate `have`s
     rather than bundled as a `LinearMap`; bundling is straightforward
     follow-up if needed).

  3. `hs₁_ne : s₁ ≠ 0` — derived from `hs₁ : toFunctionField s₁ = 1`
     via the (now proved) `htF_zero` and `one_ne_zero`. Renamed
     `_s₁`/`_hs₁` (unused underscore-prefixed) → `s₁`/`hs₁` since they
     are now consumed below.

  4. `Module.Finite kbar H⁰` instance derived from `_hdim = 2 > 0`
     via `Module.finite_of_finrank_pos`.

  5. `hN : Module.finrank kbar (Submodule.span kbar {s₁}) = 1` via
     `finrank_span_singleton hs₁_ne` (Mathlib).

  6. Extracted `s : H⁰` with `∀ r ≠ 0, r • s ∉ Submodule.span kbar {s₁}`
     via `Submodule.exists_of_finrank_lt` (Mathlib
     `Mathlib/LinearAlgebra/Dimension/RankNullity.lean`) at the
     dimension count `1 < 2`. Specialised to `r = 1` to extract
     `hs_not_const : s ∉ Submodule.span kbar {s₁}`.

  7. Defined `f := toFunctionField (C := C) P hP hPcoh s` as the
     candidate non-constant rational function.

- **Result:** PARTIAL — 6 axiom-clean sub-steps committed; 1 typed
  sorry remains at the closure point. The body now spells out the
  full structural recipe: only the substantive non-zeroness +
  principal-divisor non-vanishing remain.

- **Remaining gap (3 mathematical sub-claims):**

  (a) **`f ≠ 0`**: requires `Function.Injective toFunctionField`.
      The chain `H⁰ →[HModule_zero_linearEquiv] (constSheaf ⟶ F)
      →[sheafToPresheaf.map] (constPresheaf ⟶ F.val)
      →[evaluation at op ⊤ on one_image]→[Subtype.val] K(C)` is
      bijective on the first three steps (LinearEquiv chain via
      `constantSheafAdj.homEquiv` + `M = ModuleCat.of kbar kbar` is
      free of rank 1) and injective on the last (`Subtype.val`).
      Formalisation requires packaging the chain as a single LinearEquiv;
      ~30-50 LOC unfolding.

  (b) **Order conditions**: once `(a)` provides `hf : f ≠ 0`, apply
      `globalSections_iff_mpr P hP f hf hPcoh ⟨s, hf_def.symm⟩` to
      read off the order pair. Mechanical.

  (c) **`Scheme.WeilDivisor.principal f hf ≠ 0`**: requires Hartshorne
      II.6.7 (Stacks 02P0) — `principal f = 0 ⟹ f ∈ Γ(C, 𝒪_C^×) = kbar^×`
      on a complete geom-irred curve over alg-closed `kbar`. The
      contrapositive route: assuming `principal f = 0`, the rational
      function `f` is a global unit and (by Stacks 02P0) a constant; but
      `s ∉ kbar · s₁` together with kbar-linearity of `toFunctionField`
      (committed) + injectivity (a) shows `f ∉ image of constants`,
      contradiction.

- **Dead-end warnings:**

  - **Direct simp on `toFunctionField` definition** — does *not*
    immediately discharge the chain to a clean LinearMap. The `let`-bound
    `g := sheafToPresheaf.map ...` and `one_image := unit.hom 1`
    intermediates make `simp [toFunctionField]` produce a residual
    `(0 : LinearMap) (...) = 0` shape that needs `rfl` finalization.
    `Functor.map_zero` is the load-bearing simp lemma; without it the
    `sheafToPresheaf.map 0` does not reduce.

  - **Injectivity via `Subtype.ext_iff` alone** — does NOT close. The
    issue is that `((g.app ⊤).hom one_image).1 = 0` reduces to
    `(g.app ⊤).hom one_image = 0` in the submodule, but the further step
    `g.app ⊤ = 0` requires that `one_image` generate the source kbar-module,
    which is a constantSheafAdj structural fact, not a pure simp/lemma.

## L1209 `h0_sub_h1_lineBundleAtClosedPoint_eq_two` — NOT TOUCHED

Per directive: substrate helper for χ-arithmetic at `D = [P]`.
- **Mathematical content**: needs the bridge `lineBundleAtClosedPoint P hP hPcoh
  ≅ Scheme.WeilDivisor.sheafOf (Finsupp.single ⟨P, hPcoh⟩ 1)` followed by
  the χ-identity of `RR.2`
  (`Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus`).
- **Substrate gates**: `Scheme.WeilDivisor.sheafOf` body is in
  `OcOfD.lean` — **STRUCTURALLY BLOCKED** (iter-187 finding, standing
  deferral, DO NOT DISPATCH). `Scheme.eulerCharacteristic_*_sheafOf_*`
  bridges are in `RRFormula.lean` with 1 residual sorry on
  `eulerCharacteristic_shortExact_add`.
- **Verdict**: Closure requires upstream substrate currently parked.
  This helper is the natural single point at which both upstream gates
  flow into the consumer `dim_eq_two_of_genusZero`; it remains an honest
  typed sorry until those gates lift.

## L1147 `h1_vanishing_genusZero` — NOT TOUCHED (cascade target)

Per directive: cascade target if Lane H lands `SAb.Exact` axiom-clean.
- **Mathematical content**: `H¹(C, 𝒪_C(P)) = 0` via the closed-point SES
  `0 → 𝒪_C → 𝒪_C(P) → k(P) → 0` and the LES of cohomology, killing
  `H¹(C, 𝒪_C(P))` via `H¹(C, 𝒪_C) = 0` (genus zero) and `H¹(C, k(P)) = 0`
  (skyscraper / flasque).
- **Substrate gates**: Requires the entire Lane H cohomology
  pipeline — `HModule_flasque_eq_zero` (closed transitively at iter-194,
  but its body is gated on the `injective_flasque` substrate); plus the
  SES + LES machinery + `eulerCharacteristic_shortExact_add`.
- **Verdict**: cascade-shaped; closure requires Lane H exit and the
  closed-point SES infrastructure. Untouched this iter.

## Why I stopped

`Partial progress`: substantive structural advance on L1323
(`exists_nonconstant_rational_from_dim_eq_two`). 6 axiom-clean
sub-steps committed (~50 LOC), spelling out the linear-algebra
extraction chain from `_hdim = 2` to the existence of a candidate
non-constant section `s` and the resulting candidate function `f`.
Remaining gap is documented as 3 well-isolated mathematical sub-claims:
(a) injectivity of `toFunctionField` via the LinearEquiv chain
(formalisation, ~30-50 LOC), (b) mechanical application of
`globalSections_iff_mpr`, and (c) Stacks 02P0 (principal-divisor
non-vanishing from non-constancy on a complete geom-irred curve over
alg-closed kbar).

HARD BAR MET: ≥1 substantive structural advance on the 2 substrate
helpers (specifically L1323). PUSH-BEYOND not achieved: did not close
2 of 3 sorries. The remaining content on L1323 is gated on a non-trivial
injectivity formalisation (~30-50 LOC of LinearEquiv chain unfolding)
which would consume the rest of the helper budget without confidently
landing axiom-clean.

L1147 is left as cascade-only (Lane H landing first); L1209 is left
as upstream-gated (`OcOfD.lean` STRUCTURALLY BLOCKED + RRFormula
χ-additivity).

File still compiles GREEN with 3 sorries (no new ones introduced; no
sorry counts changed). All committed steps are kernel-clean
(zero axioms introduced).
