# Blueprint Writer Report

## Slug
gr-existence

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Changes Made

Restructured `\section{Properness}` (`sec:gr_proper`) into three subsections —
"Cheap ingredients and the reduction to existence", "The existence obligation:
chart selection by minimal valuation", and "Properness" — adding blocks for the
7 landed scaffold declarations plus the E1–E4 + existence decomposition, and
reframing `lem:gr_proper` as the one-liner over the reduction + existence.

### 7 coverage-debt blocks for the landed properness scaffold (all `\lean{}` matched in Lean)
- **Added lemma** `\label{lem:gr_compactSpace_scheme}` / `\lean{...Grassmannian.compactSpace_scheme}` — `CompactSpace (scheme d r)`: finite chart index, each chart `Spec`-affine ⟹ compact. `\uses{def:gr_the_glue_data, def:gr_affine_chart, def:gr_glued_scheme}`.
- **Added lemma** `\label{lem:gr_quasiCompact_toSpecZ}` / `\lean{...quasiCompact_toSpecZ}` — `Spec ℤ` affine + compact total space. `\uses{def:gr_to_specZ, lem:gr_compactSpace_scheme}`.
- **Added lemma** `\label{lem:gr_locallyOfFiniteType_toSpecZ}` / `\lean{...locallyOfFiniteType_toSpecZ}` — local-on-source via chart cover + `ι_toSpecZ`, each `ℤ → R^I` of finite type. `\uses{def:gr_to_specZ, def:gr_the_glue_data, def:gr_affine_chart, lem:gr_ι_toSpecZ}`.
- **Added lemma** `\label{lem:gr_quasiSeparated_toSpecZ}` / `\lean{...quasiSeparated_toSpecZ}` — separated ⟹ quasi-separated. `\uses{def:gr_to_specZ, lem:gr_separated_toSpecZ}`.
- **Added lemma** `\label{lem:gr_valuativeUniqueness_toSpecZ}` / `\lean{...valuativeUniqueness_toSpecZ}` — uniqueness free from separatedness. `\uses{def:gr_to_specZ, lem:gr_separated_toSpecZ}`.
- **Added lemma** `\label{lem:gr_transitionPreMap_minorDet_mul}` / `\lean{...transitionPreMap_minorDet_mul}` — minor-ratio identity `θ̃_{I,J}(P^J_K)·P^I_J = P^I_K`, generalises `transitionPreMap_minorDet_swap_mul`. Full proof sketch via `transitionPreMap_minorDet` + `mul_submatrix_col` + det multiplicativity + Cramer cancellation. Carries verbatim Nitsure §1 source quote (L878–L883).
- **Added lemma** `\label{lem:gr_isProper_of_valuativeExistence}` / `\lean{...isProper_of_valuativeExistence}` — the keystone reduction bundling the four cheap ingredients via `IsProper.of_valuativeCriterion` + `ValuativeCriterion.iff`. `\uses{lem:gr_compactSpace_scheme, lem:gr_quasiCompact_toSpecZ, lem:gr_locallyOfFiniteType_toSpecZ, lem:gr_quasiSeparated_toSpecZ, lem:gr_valuativeUniqueness_toSpecZ, def:gr_to_specZ}`.

### E1–E4 + existence decomposition (intended scaffold targets — see Notes)
- **Added lemma** `\label{lem:gr_existence_chart_factorization}` (E1, the PRIMARY missing ingredient / iter-036 prover target) — `Spec K` single point ⟹ `i₁` factors through one chart `ι_I` as `Spec(f) ∘ ι_I`. `\uses{def:gr_the_glue_data, def:gr_glued_scheme, def:gr_affine_chart, lem:gr_chartIncl_isOpenImmersion}`. Verbatim Nitsure §1 quote (L868–L870). Flags the Mathlib gap (factor a morphism out of `Spec K` through an open-immersion member of the cover) in prose + LEAN SIGNATURE comment.
- **Added lemma** `\label{lem:gr_existence_minimal_valuation}` (E2) — maximise `v(f(P^I_J))` over the finite index; `I` candidate, `P^I_I=1` ⟹ max `≥ 1 > 0` ⟹ `f(P^I_J) ≠ 0`. `\uses{lem:gr_existence_chart_factorization, def:gr_minor_det, lem:gr_minorDet_self}`. Verbatim Nitsure quote (L870–L876). Notes the multiplicative-vs-additive convention (Nitsure's minimal ν = maximal v).
- **Added lemma** `\label{lem:gr_existence_factor_through_valuation_ring}` (E3) — `g := f' ∘ θ̃_{I,J}` with `f'` the `Away.lift` of `f`; `g(P^J_{K'}) = f(P^I_{K'})/f(P^I_J)` has `v ≤ 1` by maximality, entries are `± P^J_{K'}`, so `g` factors as `(R↪K)∘g'`. `\uses{lem:gr_transitionPreMap_minorDet_mul, lem:gr_existence_minimal_valuation, lem:gr_transitionPreMap_minorDet, lem:gr_isUnit_incl_transitionPreMap_cross, lem:mathlib_away_lift, def:gr_transition_pre, def:gr_minor_det}`. Verbatim Nitsure quote (L881–L887). Calls out the entry-as-minor sign bookkeeping as the one sub-step with no existing scaffold.
- **Added lemma** `\label{lem:gr_existence_lift}` (E4) — filler `Spec(g') ∘ ι_J`; top triangle from E1 + `g = (R↪K)∘g'`, bottom from terminality of `Spec ℤ` via `ι_toSpecZ`. `\uses{lem:gr_existence_chart_factorization, lem:gr_existence_factor_through_valuation_ring, def:gr_the_glue_data, def:gr_to_specZ, lem:gr_ι_toSpecZ}`. Verbatim Nitsure quote (L887–L889).
- **Added lemma** `\label{lem:gr_valuativeExistence_toSpecZ}` — top-level `ValuativeCriterion.Existence (toSpecZ d r)` assembled from E1–E4. `\uses{def:gr_to_specZ, lem:gr_existence_chart_factorization, lem:gr_existence_minimal_valuation, lem:gr_existence_factor_through_valuation_ring, lem:gr_existence_lift}`. Verbatim Nitsure quote (L866–L889).

### Reframed keystone
- **Revised** `lem:gr_proper` — statement `\uses` changed to `{def:gr_to_specZ, lem:gr_isProper_of_valuativeExistence, lem:gr_valuativeExistence_toSpecZ}`; proof body rewritten as the one-liner feeding `lem:gr_valuativeExistence_toSpecZ` into `lem:gr_isProper_of_valuativeExistence`, with a prose walk-through of E1–E4. The existing verbatim Nitsure §1 `% SOURCE QUOTE` (statement) and `% SOURCE QUOTE PROOF` comments are preserved untouched.
- Added a section-intro paragraph reframing properness as "reduce to the existence half".

## Cross-references introduced
All `\uses{}` targets verified present in this chapter (grep + leandag `unknown_uses` empty):
- `def:gr_the_glue_data`, `def:gr_glued_scheme`, `def:gr_affine_chart`, `def:gr_to_specZ`, `def:gr_transition_pre`, `def:gr_minor_det` — definitions, all present.
- `lem:gr_separated_toSpecZ`, `lem:gr_ι_toSpecZ`, `lem:gr_chartIncl_isOpenImmersion`, `lem:gr_minorDet_self`, `lem:gr_transitionPreMap_minorDet`, `lem:gr_transitionPreMap_minorDet_swap_mul`, `lem:gr_mul_submatrix_col`, `lem:gr_universalMinorInv_identities`, `lem:gr_isUnit_incl_transitionPreMap_cross`, `lem:mathlib_away_lift` — all present.
- All intra-section forward refs among the 12 new blocks resolve.

leandag `build --json` after edits: `unknown_uses = []`, `isolated = []` (no new broken or orphaned nodes from this chapter). Environment balance: 63/63 lemma, 58/58 proof, 148/148 begin/end.

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (L865–L891, "Properness") — verbatim source quotes for `lem:gr_transitionPreMap_minorDet_mul`, E1 (`lem:gr_existence_chart_factorization`), E2 (`lem:gr_existence_minimal_valuation`), E3 (`lem:gr_existence_factor_through_valuation_ring`), E4 (`lem:gr_existence_lift`), and `lem:gr_valuativeExistence_toSpecZ`. Each block's `% SOURCE QUOTE` is a character-by-character copy of the relevant fragment of this paragraph; the existing `lem:gr_proper` already carries the full L865–L891 quote, which I left intact and split across the sub-lemmas per the directive.
- `AlgebraicJacobian/Picard/GrassmannianCells.lean` (L1422–L1540) — read to confirm the exact landed Lean names + proof structure of the 7 scaffold declarations (`compactSpace_scheme`, `quasiCompact_toSpecZ`, `locallyOfFiniteType_toSpecZ`, `quasiSeparated_toSpecZ`, `valuativeUniqueness_toSpecZ`, `transitionPreMap_minorDet_mul`, `isProper_of_valuativeExistence`) so the `\lean{}` hints and proof sketches match.

## Macros needed (if any)
None. All prose uses existing macros (`\Spec`, `\grass` only inside verbatim quotes, standard `\det`, `\mathrm`). The body uses `\(...\)` / `\[...\]` throughout; the only `$...$` occurrences are inside `% SOURCE QUOTE` comments (verbatim Nitsure, required).

## Reference-retriever dispatches (if any)
None — the Nitsure §1 source was already present and sufficient.

## Notes for Plan Agent
- **The 5 E1–E4 + existence blocks are intended scaffold targets**, not yet landed in Lean, so leandag reports them under `unmatched_lean`:
  `lem:gr_existence_chart_factorization` → `...existence_chart_factorization`,
  `lem:gr_existence_minimal_valuation` → `...existence_minimal_valuation`,
  `lem:gr_existence_factor_through_valuation_ring` → `...existence_factor_through_valuationRing`,
  `lem:gr_existence_lift` → `...existence_lift`,
  `lem:gr_valuativeExistence_toSpecZ` → `...valuativeExistence_toSpecZ`.
  These are the iter-036 prover targets; each block carries a `% LEAN SIGNATURE (intended scaffold target)` comment giving the prover the precise intended signature. The lean-scaffolder should create these declarations (E1 first — it gates E2–E4). Once landed, the `unmatched_lean` entries clear automatically.
- **E1 is the genuine Mathlib gap.** The block's prose + LEAN SIGNATURE comment flag the missing API: factoring a morphism out of `Spec` of a field through an open-immersion member of an open cover whose range contains the image point. If no direct `Scheme.OpenCover`/`IsOpenImmersion` lift API exists, the fallback is the topological-point + `Scheme.Hom.appLE`/stalk construction. This is the one place where the prover may need a new Mathlib-style helper.
- **E3 entry-as-minor sign bookkeeping** is the one algebraic sub-step with no existing matrix-algebra scaffold (cofactor expansion of a column-substituted identity minor). Flagged in the E3 proof prose. May warrant its own helper lemma if the prover finds it heavy.
- I chose the Lean name `existence_factor_through_valuationRing` (camelCase `valuationRing`) to match Mathlib's `ValuationRing` spelling; the blueprint label uses the chapter's snake convention `factor_through_valuation_ring`. The plan/scaffolder should keep that pairing.

## Strategy-modifying findings
None. The decomposition is faithful to Nitsure §1 and to the landed `isProper_of_valuativeExistence` reduction; no strategy-level inconsistency surfaced.
