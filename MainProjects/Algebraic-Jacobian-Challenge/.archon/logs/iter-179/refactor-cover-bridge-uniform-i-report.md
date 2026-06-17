# Refactor Report

## Slug
cover-bridge-uniform-i

## Status
COMPLETE

## Directive

**Problem.** `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:120-160` defined
`gmScalingP1_cover_X_iso` via a `match i with | ⟨0, _⟩ => … | ⟨1, _⟩ => …`. Two
structural defects compounded to defeat the chart-bridge proof chain
(`gmScalingP1_chart_PLB_eq`, `gmScalingP1_chart_agreement`,
`gmScalingP1_collapse_at_zero`) — which now stand only via the temporary
project axioms `gmScalingP1_chart_data_temp` and
`gmScalingP1_collapse_at_zero_temp`:

1. `⟨0, _⟩` vs `(0 : Fin 2)` — Lean's elaborator does NOT reduce
   `(![X 0, X 1]) ⟨0, _⟩` to `X 0`, breaking the `pullback.congrHom`
   defeq chain.
2. Inline `by`-tactic proof closures in
   `projectiveLineBarAffineCover` (`BareScheme.lean:175-221`) timed
   out at 200k–800k heartbeats during downstream `whnf`.

**Changes requested.**
- Step 1 (`BareScheme.lean`): hoist `f_deg` / `hm` to top-level named
  declarations (`projectiveLineBarAffineCover_fDeg`,
  `projectiveLineBarAffineCover_hm`).
- Step 2 (`GmScaling.lean`): rewrite `gmScalingP1_cover_X_iso` as a
  single uniform-in-`i` expression with target type using
  `((![X 0, X 1]) i)` instead of `MvPolynomial.X i`. Update
  `gmScalingP1_chart` type-args to match. Two TEMP axioms remain
  load-bearing — Step 3 retires them next iter.

## Changes Made

### File: `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`

- **What:** Added two top-level declarations immediately before
  `projectiveLineBarAffineCover`:
  - `projectiveLineBarAffineCover_fDeg (kbar) : ∀ i, (![X 0, X 1]) i ∈ 𝒜 ((![1, 1] : Fin 2 → ℕ) i)`
  - `projectiveLineBarAffineCover_hm : ∀ i, 0 < (![1, 1] : Fin 2 → ℕ) i`

  Refactored `projectiveLineBarAffineCover` to consume these by name,
  replacing the inline `fun i => by fin_cases i <;> simp [...]` tactic
  closures with direct references. The irrelevant-LESpan proof
  (`by classical … intro p hp … `) is preserved VERBATIM as required.

- **Visibility note:** the directive prescribed `private` for both helpers,
  but `private` in Lean 4 is file-scoped — the consumer in
  `GmScaling.lean` (different file) could not see them, so I dropped
  the `private` keyword on both declarations. This is necessary for the
  refactor to function and matches the only viable cross-file
  configuration. No new names beyond the two the directive explicitly
  authorised; only the access modifier diverges.

- **Why:** removes the kernel's need to `whnf` tactic-built proof closures
  during downstream defeq in `gmScalingP1` (per
  `analogies/gmscaling-cover-bridge.md` Step 1, the second compounding
  factor of the iter-178 diagnosis).

- **Cascading:** none — the cover's value is unchanged, by definition.
  All downstream consumers continue to compile.

### File: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`

- **What (Step 2a — `awayι_comp_PLB_hom` generalisation):** added
  `{m : ℕ} (hm : 0 < m)` arguments and replaced the implicit `m = 1` /
  `Nat.one_pos` with the bound `m` / `hm`. The proof body (`change`,
  `rw`, `rfl`) is unchanged — it never depended on `m = 1` (verified
  via `Proj.awayι_toSpecZero` hover: also generic over `m`).

  Required to apply the lemma in the new uniform-in-`i` iso, where the
  cover's `.f i` uses `m = (![1, 1]) i` and `hm =
  projectiveLineBarAffineCover_hm i` — these are propositionally but
  NOT definitionally `1` / `Nat.one_pos` for generic `i`.

- **What (Step 2b — `gmScalingP1_cover_X_iso` uniform-in-`i`):**
  replaced the `match i with | ⟨0, _⟩ => … | ⟨1, _⟩ => …` with a
  single expression. The target type now carries
  `((![MvPolynomial.X 0, MvPolynomial.X 1] : Fin 2 → MvPolynomial (Fin 2) kbar) i)`
  instead of `MvPolynomial.X i`. The `awayι_comp_PLB_hom` invocation
  passes the hoisted `projectiveLineBarAffineCover_hm i` and
  `projectiveLineBarAffineCover_fDeg kbar i`.

- **What (Step 2c — `gmScalingP1_chart` body):** replaced the two
  `MvPolynomial.isHomogeneous_X kbar (·)` arguments to
  `HomogeneousLocalization.Away.isLocalizationElem` with the hoisted
  `projectiveLineBarAffineCover_fDeg kbar (·)` (for `i` and `otherFin i`).
  This makes the intermediate `isLocalizationElem` result live in
  `Away 𝒜 ((![X 0, X 1]) i)`, matching the new iso target. The chart's
  return type and overall composition shape (`(iso).hom ≫ Spec.map(...)
  ≫ Proj.awayι 𝒜 (X i) ...`) are unchanged.

  The composition typechecks because `isLocalizationElem` is generic in
  both degrees (Mathlib `{e d : ℕ}`), so different `m`s on the two
  witnesses (`(![1, 1]) i` and `(![1, 1]) (otherFin i)`, both ≡ 1
  propositionally) do not block.

- **Why:** per `analogies/gmscaling-cover-bridge.md` Decision 1 +
  Decision 3 (verdict: ALIGN_WITH_MATHLIB). Uniform-in-`i` means
  `pullbackSpecIso` applies generically and `pullback.congrHom` has
  syntactic targets, eliminating the `match`-on-`i` per-branch
  specialisation that defeated the bridge chain.

- **Cascading:** none. The chart return type `(gmScalingP1_cover kbar).X i
  ⟶ ProjectiveLineBarScheme kbar` is unchanged; the only mutation is
  internal (iso target tensor LHS, `isLocalizationElem` witness types).
  Both TEMP axioms (`gmScalingP1_chart_data_temp`,
  `gmScalingP1_collapse_at_zero_temp`) and the three lemmas they
  ground (`gmScalingP1_chart_PLB_eq`, `gmScalingP1_chart_agreement`,
  `gmScalingP1_collapse_at_zero`) compile unchanged — their statements
  quantify over `i : Fin 2` and propagate the new type-args
  transparently.

## New Sorries Introduced

None. The four existing sorries are unchanged:
- `BareScheme.lean:156` — `projectiveLineBar_geomIrred` (pre-existing scaffold)
- `BareScheme.lean:163` — `projectiveLineBar_smoothOfRelDim` (pre-existing scaffold)
- `GmScaling.lean:386` — `gm_geomIrred` (pre-existing scaffold)
- `GmScaling.lean:418` — `projGm_isReduced` (pre-existing scaffold)
- `Points.lean:251` — `gm_grpObj` (pre-existing scaffold)

The two TEMP project axioms `gmScalingP1_chart_data_temp` (L193) and
`gmScalingP1_collapse_at_zero_temp` (L289) remain in place and remain
load-bearing for `gmScalingP1_chart_PLB_eq`, `gmScalingP1_chart_agreement`,
and `gmScalingP1_collapse_at_zero`. Step 3 (iter-179 prover lane) is the
agent that retires them, per directive.

## Compilation Status

- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`: ✅ green (2 pre-existing sorries)
- `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`: ✅ green
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean`: ✅ green (1 pre-existing sorry)
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`: ✅ green (2 pre-existing sorries; 2 TEMP axioms still loaded)
- Full `lake build`: ✅ green (8355/8355 jobs, no errors)

## Notes for Plan Agent

- **Visibility divergence from directive.** The directive prescribed
  `private` on the two hoisted declarations
  (`projectiveLineBarAffineCover_fDeg`, `projectiveLineBarAffineCover_hm`),
  but `private` in Lean 4 is file-scoped — the consumer in
  `GmScaling.lean` couldn't see them, blocking Step 2. I dropped the
  `private` modifier. No other names or signatures changed from the
  directive's exact spec.

- **`awayι_comp_PLB_hom` was generalised.** The directive's
  Step 2 expected `awayι_comp_PLB_hom kbar ((![X 0, X 1]) i) (fDeg kbar i)`
  to type-check, but the lemma was previously specialised to `m = 1` /
  `Nat.one_pos`. Since `fDeg kbar i : _ ∈ 𝒜 ((![1, 1]) i)` (NOT
  `_ ∈ 𝒜 1` definitionally for generic `i`), the lemma needed
  generalisation to `{m : ℕ} (hm : 0 < m)`. This is consistent with
  the directive's "modify existing — do not add new helpers" envelope:
  no new helper was added; one existing helper's `m` was made
  parametric. The proof body (`change ... ≫ Proj.toSpecZero ≫ Spec.map _
  = _; rw [← Category.assoc, Proj.awayι_toSpecZero, ← Spec.map_comp, ←
  CommRingCat.ofHom_comp]; rfl`) is invariant under this change, and
  `Proj.awayι_toSpecZero` (Mathlib) is itself generic over `m`.

- **Chart body update minimal and uniform.** Only the two
  `isLocalizationElem` witness arguments were touched in
  `gmScalingP1_chart`; the surrounding composition (iso ≫ Spec.map ≫
  Proj.awayι) is structurally identical, including the inner `match i
  with | ⟨0, _⟩ => … | ⟨1, _⟩ => …` for the GmRing-side `λ` / `λ⁻¹`
  branch (this match is on the `GmRing`-element selection, NOT on the
  cover's `f`, so it is orthogonal to the refactor's defeq concerns).

- **End-state for Step 3 (iter-179 prover lane).** The two TEMP axioms
  are still in place and load-bearing. The uniform-in-`i` iso now
  makes `pullbackSpecIso_hom_base` fire syntactically through
  `pullback.congrHom` (per the iter-178 consult verification), so the
  prover lane's chart-bridge body construction (`gmScalingP1_chart_PLB_eq`,
  `gmScalingP1_chart_agreement`, `gmScalingP1_collapse_at_zero`) should
  proceed against the recipe in `analogies/chart-bridge-shared-helper.md`
  Decision 3 + `analogies/gmscaling-deep.md` Q4.

- **No reversal trigger fired.** Step 2 landed cleanly on the first
  uniform-in-`i` attempt; the `Fin.cases` fallback (directive's
  reversal trigger) was unnecessary.
