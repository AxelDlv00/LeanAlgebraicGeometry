# AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean — iter-195 Lane RCI `?hLPUnif` structural lift

**Result**: HARD BAR PARTIAL — `?hLPUnif` inline sorry at `Hom.poleDivisor_degree_eq_finrank` body was structurally lifted to a named, file-private typed-sorry helper `localParameterAtInfty_uniformiser_witness` (helper budget 1/1) with a documented 3-step closure path. Net sorry count unchanged (3 → 3, 1:1 swap inline → named). Consumer body `Hom.poleDivisor_degree_eq_finrank` is now sorry-free at the body level (delegates to helper). Axiom-clean closure was not achievable within budget given the substrate gap on `(ProjectiveLineBar kbar).left` prime-divisor construction + `Ring.ordFrac` chart bridge.

**Build state**: GREEN (`success: true`). Sorries: 3 (all named typed sorries: `localParameterAtInfty_uniformiser_witness` (L463 — NEW); `phi_left_locallyQuasiFinite_of_finrank_one` (L870); `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` (L938)). No new project axioms — `lean_verify` on `Hom.poleDivisor_degree_eq_finrank` + `localParameterAtInfty_uniformiser_witness` confirms `[propext, sorryAx, Classical.choice, Quot.sound]` (kernel only).

**Net sorry delta vs entering iter-195 prover phase**: 3 → 3 (0; 1:1 swap inline `?hLPUnif` sorry → named helper sorry; the substrate need is now exposed as a single named declaration with a documented 3-step closure path, rather than inline in the consumer).

**Sorry-warning lines (post-change)**:
- L463 `localParameterAtInfty_uniformiser_witness` (NEW — substrate-gated helper).
- L870 `phi_left_locallyQuasiFinite_of_finrank_one` (pre-existing helper (a), gated on per-fibre LQF substrate per iter-195 PROGRESS Lane RCI scope).
- L938 `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` (pre-existing helper (d), gated on `IsNormalScheme` substrate per iter-195 PROGRESS Lane RCI scope).

The L571 inline `?hLPUnif` sorry that entered iter-195 prover-phase is now closed via `exact localParameterAtInfty_uniformiser_witness kbar`; the consumer body `Hom.poleDivisor_degree_eq_finrank` is sorry-free at the body level.

## `?hLPUnif` substrate analysis (iter-195)

### Goal (`?hLPUnif` typed-sorry surface)

```
case hLPUnif
...
⊢ ∃ Y₀,
    RationalMap.order Y₀ ↑(localParameterAtInfty kbar) = 1 ∧
      ∀ (Y : (ProjectiveLineBar kbar).left.PrimeDivisor),
        RationalMap.order Y ↑(localParameterAtInfty kbar) > 0 → Y = Y₀
```

### Attempt 1 — direct closure attempts
- **Approach:** Trial `exact ⟨Classical.arbitrary _, sorry, sorry⟩`, `tauto`, `exact?`.
- **Result:** FAILED.
  - `Classical.arbitrary _` fails: cannot synthesize `Nonempty (ProjectiveLineBar kbar).left.PrimeDivisor` (no instance / no project-side substrate).
  - `tauto` cannot construct the existential witness (the `Y₀` substrate is missing).
  - `exact?` returns no candidate (no Mathlib lemma supplies the uniformiser witness for `Proj k̄[X₀,X₁]`).
- **Dead end:** No tactic-based axiom-clean closure exists in `b80f227` Mathlib for this goal — the witness `Y₀` (prime divisor at infinity on `Proj k̄[X₀, X₁]`) is genuine project-side substrate.

### Attempt 2 — structural lift via named helper (RESOLVED at structural level)
- **Approach:** Extract the inline `?hLPUnif` sorry to a named, file-private typed-sorry helper `localParameterAtInfty_uniformiser_witness` at L429–L463 (just before `Hom.poleDivisor`'s `/-! ### Iter-190` substrate block). Document the 3-step closure path in the helper docstring. Discharge the consumer site via `exact localParameterAtInfty_uniformiser_witness kbar`.
- **Result:** RESOLVED (structural).
  - Consumer `Hom.poleDivisor_degree_eq_finrank` body is now sorry-free at the body level.
  - Substrate need is exposed at a single named declaration (was buried inline in the consumer).
  - 1:1 sorry-count swap (no inflation).
  - `lean_verify` on both `Hom.poleDivisor_degree_eq_finrank` + `localParameterAtInfty_uniformiser_witness` confirms `[propext, sorryAx, Classical.choice, Quot.sound]` (kernel only).
- **Helper budget consumed:** 1/1.

### Closure path documented in helper (iter-196+ work)

The helper docstring at L391–L460 enumerates the 3-step substantive close:

1. **Witness construction** — `Y₀ : (ProjectiveLineBar kbar).left.PrimeDivisor` is the closed point at `∞ ∈ ℙ¹` corresponding to the homogeneous prime ideal `(X 0) · 𝒜 ⊂ k̄[X₀, X₁]`. Equivalently the image under `Proj.awayι 𝒜 (X 1)` of the maximal ideal `(X 0 / X 1) ⊂ HomogeneousLocalization.Away 𝒜 (X 1)`. The `Order.coheight = 1` witness needs project-side `coheight`-on-`Proj`-substrate (Stacks `01OL`) OR an affine-chart transfer via `Proj.basicOpenIsoAway` (chart `≅ Spec k̄[t]` is a PID; maximal-ideal coheight is 1).

2. **Order computation** — `ord_{Y₀}(t) = 1`. Via the chart isomorphism, the stalk at `Y₀` (on `(ProjectiveLineBar kbar).left`) is isomorphic to `(Away 𝒜 (X 1))_{(X 0 / X 1)}`, a DVR with uniformiser `X 0 / X 1`. Then `Ring.ordFrac` of `X 0 / X 1` at the DVR equals 1.

3. **Uniqueness** — `∀ Y, ord_Y(t) > 0 → Y = Y₀`. The function `t = X 0 / X 1` has poles at all other prime divisors; in particular it has the opposite pole at the "origin" `[0]`. Routes through the affine description of `Proj 𝒜` charts + the fact that `X 0 / X 1` is a unit on `D₊(X 0)`.

### Substrate gap cascade

All three steps cascade from the broader substrate gap on `Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left` (typed-sorry instance at `WeilDivisor.lean:746-772`, per-stalk DVR property at codim-1 points). Coordinated closure: the same affine-chart bridge (via `Proj.basicOpenIsoAway`) that closes the IsRegularInCodimensionOne instance also unlocks the stalk-to-DVR isomorphism needed by step 2 + the chart-unit fact needed by step 3.

The witness construction (step 1) is currently the most isolated piece — it requires building the explicit `Y₀` from the homogeneous prime `(X 0)` and proving its `Order.coheight = 1` on `Proj 𝒜`. Affine-chart route via `Proj.basicOpenIsoAway` is the cleanest entry: the chart `Spec(Away 𝒜 (X 1))` is `Spec(k̄[X 0 / X 1])`, a PID, and the maximal ideal `(X 0 / X 1)` corresponds to the closed point of coheight 1; pushforward to `Proj 𝒜` via `awayι` produces a point of coheight 1 (since `awayι` is an open immersion).

## Negative search results

- `lean_leansearch "order of an element along a prime divisor on Proj scheme"` returned no relevant results — Mathlib has `ProjectiveSpectrum.isPrime` etc. but no `Scheme.RationalMap.order`-style API for `Proj`-schemes specifically.
- `lean_leansearch "uniformizer order one in discrete valuation ring"` returned `IsDiscreteValuationRing.addVal_uniformizer` and `Valuation.IsUniformizer` — applicable to abstract DVRs but not to the project's `Ring.ordFrac`-based `Scheme.RationalMap.order` directly without a DVR-stalk bridge (which is exactly the substrate gap).
- No `Proj.basicOpenIsoAway`-to-`ord` bridge in Mathlib at `b80f227`.

## Dead ends + iter-194+ context

- The PROGRESS L196 directive ("Discharge via destructuring the `localParameterAtInfty` construction's uniformiser/unique-zero property") is mathematically aspirational — the iter-189 `localParameterAtInfty` construction at L304-389 provides ONLY a non-zero witness (`{ t : functionField // t ≠ 0 }`); the uniformiser/unique-zero property is genuine new project-side content, not present in the construction. The directive's intent is best read as "the *intended Y₀* derives from the same chart-1 construction used by `localParameterAtInfty`" — but actually constructing that Y₀ + closing the order/uniqueness claims requires substrate that is not in `b80f227`.
- Iter-194 refactor `lane-i-localparameter-signature-v2` explicitly noted in its directive (L199-201): "the new `?hLPUnif` is genuinely owed: producing the prime divisor at `∞ ∈ ℙ¹` and proving uniqueness of its zero of order 1 is genuine Hartshorne content. The iter-194+ body-close is the work." So the substrate gap was acknowledged at the refactor's design time.

## Blueprint markers

- `lem:degree_one_morphism_iso` (`AlgebraicGeometry.Scheme.iso_of_degree_one`): unchanged from iter-193 (body sorry-free, transitively depends on helpers (a)+(d) typed sorries). `sync_leanok` decides `\leanok` based on sorry counts.
- `lem:degree_via_pole_divisor` (`AlgebraicGeometry.Scheme.morphism_degree_via_pole_divisor`): unchanged (body sorry-free, transitively depends on `Hom.poleDivisor_degree_eq_finrank` which now depends on the new helper).
- `Hom.poleDivisor_degree_eq_finrank`: body is sorry-free post-iter-195 (delegates to `localParameterAtInfty_uniformiser_witness`).
- New helper `localParameterAtInfty_uniformiser_witness`: file-private; not blueprint-pinned; no `\lean{...}` cross-reference; no `\leanok` decision needed.

## Iter-196+ candidate work

1. **Close `localParameterAtInfty_uniformiser_witness` (this iter's new helper)** — the focused substrate target carved out by iter-195. Recipe per docstring 3-step path.
2. **Coordinate with iter-196 `IsRegularInCodimensionOne (ProjectiveLineBar kbar).left` instance close** (`WeilDivisor.lean:746-772`) — same chart-bridge substrate unlocks both.
3. **Close helper (a) `phi_left_locallyQuasiFinite_of_finrank_one`** (L870) — gated on `mathlib-analogist` dispatch for "smooth-dim-1 ⟹ fibre is 0-dim" per iter-195 PROGRESS active monitor.
4. **Close helper (d) `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`** (L938) — gated on `IsNormalScheme` substrate per iter-195 PROGRESS active monitor (iter-196+ Route B analogist).

## Why I stopped

**Partial progress.** The iter-195 PROGRESS directive's HARD BAR was "close `?hLPUnif` axiom-clean", which is a 3-step substantive close requiring substrate not in `b80f227` (construction of the prime divisor at infinity, stalk-to-DVR chart bridge, `Ring.ordFrac` computation). After confirming via tactic experiments (`Classical.arbitrary`, `tauto`, `exact?`) that no axiom-clean tactic path exists, I committed the helper budget (1/1) to a structural lift: extracted the `?hLPUnif` content to a named file-private typed-sorry helper `localParameterAtInfty_uniformiser_witness` with a fully documented 3-step closure path, and discharged the consumer site via `exact`. The consumer `Hom.poleDivisor_degree_eq_finrank` is now sorry-free at the body level; the substrate need is exposed as a single named declaration suitable for iter-196+ targeted closure (no longer buried inline in the consumer). Net sorry count is unchanged (1:1 swap), so the HARD BAR is NOT met in the strict sense — but the structural lift is a measurable, no-regression advance that improves iter-196+ closability and aligns with the iter-195 PROGRESS scope ("Lane RCI `?hLPUnif` close only (SCOPED)" with PUSH-BEYOND explicitly NONE).
