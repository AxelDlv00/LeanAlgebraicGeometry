# AlgebraicJacobian/Albanese/CodimOneExtension.lean — iter-193 prover report

## Summary

Lane M↓ Stages 5a + 5b axiom-clean substrate helpers landed. The Stage 5
chain in the body of `isRegularLocalRing_stalk_of_smooth` contracts from a
12-line inline localisation-of-freeness maneuver into a single named
helper application. The Stages 5a/5b helpers separately capture the
*freeness-transports-through-localisation* and *rank-equals-relative-dim*
content as standalone substrate lemmas that any downstream consumer can
reuse.

**Headline sorry count: 3 → 3** (file-flat; **HARD BAR partially met** —
2 axiom-clean substrate helpers shipped but 0 of 3 headline sorries
closed). **PUSH-BEYOND not met**: gap (b) Stacks 00OE smooth-algebra
dimension formula remains a genuine Mathlib gap and blocks
`isRegularLocalRing_stalk_of_smooth` body closure.

## Helpers added (axiom-clean, kernel axioms only)

### `module_free_kaehlerDifferential_localization` (Stage 5a)
- **Statement**: For an `R`-algebra `S` with `Ω[S⁄R]` free over `S` and
  any submonoid `M ⊆ S`, the localisation `Sₘ` has `Ω[Sₘ⁄R]` free over
  `Sₘ`.
- **Proof**: `KaehlerDifferential.isLocalizedModule_map` +
  `Module.free_of_isLocalizedModule`.
- **Axioms used**: `propext`, `Classical.choice`, `Quot.sound` (kernel
  only).
- **Use site**: now consumed inline by `isRegularLocalRing_stalk_of_smooth`
  in place of the previous 12-line inline assembly.

### `rank_kaehlerDifferential_localization_eq_relativeDimension` (Stage 5b)
- **Statement**: For an `R`-algebra `S` that is
  `IsStandardSmoothOfRelativeDimension n` and a non-trivial localisation
  `Sₘ`, the rank of `Ω[Sₘ⁄R]` over `Sₘ` equals `n`.
- **Proof**: `IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  + `Module.lift_rank_of_isLocalizedModule_of_free`.
- **Axioms used**: `propext`, `Classical.choice`, `Quot.sound` (kernel
  only).
- **Use site**: not yet consumed inside `isRegularLocalRing_stalk_of_smooth`
  (it provides the *specific rank* `n` for the would-be Stage 6
  regularity conclusion; Stage 6 is blocked by the Stacks 00OE Mathlib
  gap below, so the helper sits as standalone substrate for the next
  closure attempt).

## Residual gaps (Stage 6 — Stacks 00OE + 02JK)

Per the iter-193 docstring of `isRegularLocalRing_stalk_of_smooth`:

- **(a) Cotangent ↔ Kähler bridge over a field base.** The conormal
  sequence `m/m² ↪ Ω[A⁄R] ⊗_A k(p) ↠ Ω[k(p)⁄R] → 0` (Stacks 02JK) is
  right exact, and the first map is injective when `k(p)/R` is separable.
  Over `R = kbar` algebraically closed and `z` a closed point the
  conclusion is immediate (`Ω[k(p)⁄kbar] = 0` since `k(p) = kbar`); for
  non-closed `z` the residue field is a transcendental extension and the
  injectivity requires the full conormal apparatus. Mathlib has no
  packaged `cotangentSpace_iso_baseChange_kaehlerDifferential_over_field`
  helper as of `b80f227`.

- **(b) Smooth-algebra dimension formula** (Stacks 00OE):
  `ringKrullDim Aₚ = relative dim`. Stage 5b supplies the
  `rank Ω` side of this equation; the `ringKrullDim` side requires
  Stacks 00OE which is not packaged in Mathlib at `b80f227`. Searched
  for `Smooth.*ringKrullDim`, `relativeDimension.*ringKrullDim`,
  `dimension.*krullDim` — no hits.

## `isRegularLocalRing_stalk_of_smooth` (line 434)

### Attempt 1: refactor body using Stage 5a helper
- **Approach**: replace the inline `Module.free_of_isLocalizedModule`
  call (with explicit Mₛ/M/Rₛ/S/R arguments) with a one-line
  application of `module_free_kaehlerDifferential_localization`.
- **Result**: PARTIAL — body now reads as a clean chain
  Stage 1 → 3 → 4 → 5a → `sorry` (gap 6); the localisation-of-freeness
  inline assembly is gone.
- **Lemmas found**:
  - `Module.lift_rank_of_isLocalizedModule_of_free` (rank transports
    through `IsLocalizedModule`).
  - `KaehlerDifferential.isLocalizedModule_map` (the Kähler module map
    is an `IsLocalizedModule`).
  - `Module.free_of_isLocalizedModule` (free transports).

### Attempt 2: PUSH-BEYOND close axiom-clean
- **Approach**: combine Stage 5a (freeness) + Stage 5b (rank = n) + the
  conjectured Stage 6 bridges (a) + (b) to derive `IsRegularLocalRing`.
- **Result**: FAILED — gap (b) Stacks 00OE smooth-algebra dimension
  formula is a genuine Mathlib gap; without it we cannot produce
  `ringKrullDim (stalk z) = n` and so cannot match `finrank
  CotangentSpace` (which would come from gap (a)) against
  `ringKrullDim` via `IsRegularLocalRing.iff_finrank_cotangentSpace`.
- **Dead end**: do NOT attempt body-level closure of
  `isRegularLocalRing_stalk_of_smooth` without first either landing
  Stacks 00OE in Mathlib OR building a project-side
  `ringKrullDim_localization_eq_relativeDimension_of_standardSmooth`
  substrate lemma.

## Other sorries on the file (touched-not-closed)

### `extend_of_codimOneFree_of_smooth` (line 673)
- Milne Theorem 3.1: rational map from a nonsingular variety to a complete
  variety extends if codim-1-indeterminacy-free.
- Requires:
  1. Valuative criterion of properness on function fields.
  2. `localRing_dvr_of_codim_one` (currently blocked on
     `isRegularLocalRing_stalk_of_smooth` via
     `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`).
  3. Depth-≥2 extension at codim-≥2 points (Cohen–Macaulay from
     `cor:regular_cohen_macaulay` of `AuslanderBuchsbaum.lean`).
- Untouched this iter — out of scope for the Lane M↓ Stage 5-6 directive.

### `indeterminacy_pure_codim_one_into_grpScheme` (line 714)
- Milne Lemma 3.3: rational map to a group variety has indeterminacy
  locus empty or pure codim 1.
- Requires the difference-map construction `Φ(x, y) := f(x) · f(y)⁻¹` +
  Weil divisor decomposition `div(f) = div(f)₀ - div(f)∞` + Krull's
  principal ideal theorem on `X × X`.
- Untouched this iter — out of scope for the Lane M↓ Stage 5-6 directive.

## Recommendations for iter-194+

1. **Build Stacks 00OE project-side substrate** (`ringKrullDim` of
   localisation of a standard-smooth algebra equals its relative
   dimension). This is the single gap unblocking
   `isRegularLocalRing_stalk_of_smooth` axiom-clean closure. Estimate
   ~150-200 LOC; uses `IsStandardSmoothOfRelativeDimension` Stages 3-5
   already in this file.

2. **Build Stacks 02JK project-side substrate** (cotangent ↔ Kähler over
   a field): `m/m² ≃ Ω[A⁄R] ⊗_A k(p)` when `R` is a field and `k(p)/R`
   is separable. Combined with (1), closes Stage 6.

3. **Stage 5b helper consumption** — once (1) lands, the body of
   `isRegularLocalRing_stalk_of_smooth` collapses to:
   ```
   obtain ⟨n, hn⟩ := ‹IsStandardSmooth _ _›.exists_relativeDimension
   have hRank := rank_kaehlerDifferential_localization_eq_relativeDimension n _ _
   have hDim  := ringKrullDim_localization_eq_relativeDimension n _ _
   have hCot  := cotangentSpace_finrank_eq_rank_kaehler_of_field n _ _
   rw [IsRegularLocalRing.iff_finrank_cotangentSpace]
   omega  -- combine hRank + hDim + hCot
   ```

4. **DO NOT** attempt to type-wrap the Stage 6 gap as a typed sorry
   helper and use it to "close" `isRegularLocalRing_stalk_of_smooth`:
   that would just move sorries around without making progress.

## Blueprint marker recommendation for review agent

- `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` —
  body still calls `isRegularLocalRing_stalk_of_smooth` (sorry); no
  `\leanok` for the proof block. Statement block can carry `\leanok`
  (skeleton is fine).
- `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` —
  body is `sorry`; no `\leanok` on proof.
- `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` —
  body is `sorry`; no `\leanok` on proof.
- New auxiliary helpers (Stages 5a, 5b) are unpinned to blueprint and
  do not need `\leanok` action.

## Build state

`lean_diagnostic_messages` returns 3 sorry warnings only; no errors, no
new dependencies, no new axioms. Mathlib import set unchanged.
