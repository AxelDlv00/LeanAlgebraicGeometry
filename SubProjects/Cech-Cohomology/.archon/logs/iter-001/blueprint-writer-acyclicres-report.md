# Blueprint Writer Report

## Slug
acyclicres

## Status
COMPLETE

All four required content blocks were written into the new chapter, each grounded in
verbatim Stacks Project source text retrieved this session. One significant
infrastructure gap (no long-exact-sequence API for `Functor.rightDerived` in
Mathlib) is flagged under "Notes for Plan Agent" — it does not block the blueprint
but the planner must know it before scaffolding/proving.

## Target chapter
blueprint/src/chapters/Cohomology_AcyclicResolution.tex  (NEW — created)

## Changes Made
- **Created chapter** `Cohomology_AcyclicResolution.tex` with
  `\label{chap:Cohomology_AcyclicResolution}` and the
  `% archon:covers AlgebraicJacobian/Cohomology/AcyclicResolution.lean` line.
- **Added Mathlib anchor** `\lemma`/`\label{lem:right_derived_injective_resolution}`/
  `\lean{CategoryTheory.InjectiveResolution.isoRightDerivedObj}` `\mathlibok` —
  `(R^n G)(X) ≅ Hⁿ(G(I•))` for an injective resolution. **Verified to exist** in
  Mathlib (`Mathlib/CategoryTheory/Abelian/RightDerived.lean:112`); signature
  confirmed by `lean_hover_info`.
- **Added Mathlib anchor** `\label{lem:right_derived_vanishes_injective}`/
  `\lean{CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ}` `\mathlibok`
  — higher derived functors vanish on injectives. **Verified** (`RightDerived.lean:151`).
- **Added Mathlib anchor** `\label{lem:right_derived_zero_iso_self}`/
  `\lean{CategoryTheory.Functor.rightDerivedZeroIsoSelf}` `\mathlibok` — `R⁰G ≅ G`
  for left-exact `G`. **Verified** (`RightDerived.lean:366`); requires
  `[PreservesFiniteLimits G]` (i.e. `G` left exact), which holds for any right
  adjoint such as a pushforward `f_*`.
- **Added definition** `\definition`/`\label{def:right_acyclic}`/
  `\lean{CategoryTheory.Functor.IsRightAcyclic}` — `J` is right-`G`-acyclic when
  `(R^k G)(J) = 0` for all `k ≥ 1`. Noted the Mathlib-idiomatic `IsZero` /
  index-shifted `(R^{k+1}G)(J)` form for the planner. (Project-to-be-proved; NOT
  marked `\mathlibok`.)
- **Added sub-lemma** `\lemma`/`\label{lem:acyclic_dimension_shift}`/
  `\lean{CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic}` — the dimension
  shift across a short exact sequence `0 → A → J → Z → 0` with `J` acyclic:
  `(R^k G)(Z) ≅ (R^{k+1} G)(A)` for `k ≥ 1`, and `(R^1 G)(A) ≅ coker(G(J) → G(Z))`.
  Proof sketch added (Y) from the long exact sequence + acyclic vanishing.
  (Project-to-be-proved; expected Lean name — the scaffolder creates the stub.)
- **Added theorem** `\theorem`/`\label{lem:acyclic_resolution_computes_derived}`/
  `\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}` — the abstract
  comparison theorem `(R^n G)(A) ≅ Hⁿ(G(J•))` for an acyclic resolution. Full
  classical dimension-shifting proof sketch added (Y): cosyzygy short exact
  sequences `(S_m)`, base degrees `n=0,1` via left-exactness, the staircase of
  connecting isomorphisms for `n ≥ 1`, and reduction of the base case to the Mathlib
  injective-resolution seed.

## Cross-references introduced
- `\uses{lem:right_derived_injective_resolution}` in `def:right_acyclic` — target in
  this chapter (anchor). OK.
- `\uses{def:right_acyclic, lem:right_derived_zero_iso_self}` in
  `lem:acyclic_dimension_shift` (and its proof) — targets in this chapter. OK.
- `\uses{def:right_acyclic, lem:right_derived_injective_resolution,
  lem:right_derived_vanishes_injective, lem:right_derived_zero_iso_self,
  lem:acyclic_dimension_shift}` in `lem:acyclic_resolution_computes_derived` (and its
  proof) — all targets in this chapter. OK. (Directive's `\uses` skeleton asked for
  def + anchor; I added the additional real edges the proof genuinely consumes.)
- Prose-only cross-chapter `\ref{chap:Cohomology_CechHigherDirectImage}` and
  `\ref{lem:cech_acyclic_affine}` in the motivation section — both labels exist in
  the sibling chapter. No `\uses` edge created across chapters (intentional: the
  consuming direction lives in the sibling).

## References consulted
- `references/homological-acyclic-derived.tex` — Stacks Project `derived.tex`
  (retrieved this session by the reference-retriever I dispatched). Verbatim quotes
  copied character-by-character for: `def:right_acyclic` (Tag 0157
  `definition-derived-functor` items 3–4, L5264–5269; Tag 015C `lemma-F-acyclic`,
  L5594–5617); `lem:acyclic_dimension_shift` (Tag 015D `lemma-F-acyclic-ses`
  statement + proof, L5619–5654); `lem:acyclic_resolution_computes_derived` (Tag
  015E Leray's acyclicity lemma, L5692–5705; Tag 05TA `proposition-enough-acyclics`,
  L5785–5811; proof quote from the 05TA proof body, L5831–5853).
- `references/summary.md` — read the index (and the new entry the retriever appended).

## Macros needed (if any)
- None. The chapter uses only standard LaTeX/AMS (`\mathcal`, `\mathbb`,
  `\operatorname{coker}`, `\ker`, `\xrightarrow`, `\twoheadrightarrow`, `\frac`,
  etc.). `\mathlibok` is already defined in `blueprint/src/macros/print.tex`. No new
  shared macro required.

## Reference-retriever dispatches (if any)
- slug `homological-acyclic`: requested the acyclic-resolution comparison theorem
  from Stacks Project Homological Algebra / Derived Categories (primary) and Weibel
  §2.4 (secondary). Status: **COMPLETE** for Stacks (downloaded `derived.tex` +
  `homology.tex`, verified LaTeX); **NOT_FOUND** for Weibel (paywalled; only an
  unclear-authorization third-party PDF existed, so it was not downloaded — correct
  no-piracy behaviour). The Stacks source is self-contained for every citation in
  this chapter. Summary at `references/homological-acyclic.md`; sources at
  `references/homological-acyclic-derived.tex` (+ `-homology.tex`).

## Notes for Plan Agent

1. **`content.tex` must be updated to include the new chapter — I cannot do this.**
   `blueprint/src/content.tex` currently `\input`s only
   `Cohomology_HigherDirectImage` and `Cohomology_CechHigherDirectImage`. Until the
   planner adds `\input{chapters/Cohomology_AcyclicResolution}`, `leandag` does not
   parse my chapter, and the sibling chapter's existing
   `\uses{lem:acyclic_resolution_computes_derived}` (on
   `lem:cech_computes_cohomology`) shows as an `unknown_uses`. Adding the `\input`
   resolves that edge.

2. **MAJOR Mathlib-API gap — no long exact sequence / δ-functor for
   `Functor.rightDerived`.** I verified (`grep` over `Mathlib/`, plus
   `lean_local_search`) that `Mathlib/CategoryTheory/Abelian/RightDerived.lean`
   provides ONLY: `Functor.rightDerived` (def), `InjectiveResolution.isoRightDerivedObj`
   (the seed), `Functor.isZero_rightDerived_obj_injective_succ` (vanishing on
   injectives), `Functor.rightDerivedZeroIsoSelf` (`R⁰ ≅ F`, left-exact), plus
   naturality/`rightDerived_map_eq`. There is **no** connecting homomorphism, **no**
   long exact sequence of a short exact sequence, and **no** `DeltaFunctor`
   structure for `Functor.rightDerived` anywhere in Mathlib (searched
   `DeltaFunctor`, `deltaFunctor`, `rightDerived.*ShortComplex|ShortExact|
   homologySequence|exact` — empty). The dimension-shift sub-lemma
   `lem:acyclic_dimension_shift` is exactly where this missing infrastructure is
   consumed. **Before scaffolding/proving, the planner should decide how to supply
   the LES**, e.g. one of:
   - build the `δ`-functor / LES for `Functor.rightDerived` from the
     injective-resolution definition (the snake lemma on `G(I•)` for a SES that lifts
     to a degreewise-split SES of injective resolutions — the horseshoe lemma);
   - or route the whole theorem through Mathlib's `Abelian.Ext` / derived-category
     machinery, which *does* carry long exact sequences, and relate `R^n G` to it;
   - or restrict to what `isoRightDerivedObj` gives directly (compare the acyclic
     resolution `J•` to an injective resolution `I•` of `A` via the comparison
     theorem for resolutions, and use `isZero_rightDerived_obj_injective_succ` to see
     the comparison is a `G`-quasi-isomorphism) — this is closer to the Stacks
     Tag 015E proof and may avoid building a general LES.
   I wrote the proof sketch in the classical dimension-shifting form (matching the
   directive) and added an explicit "Remark on the base case and the Mathlib seed"
   tying it back to `isoRightDerivedObj`; the prover may prefer the third route
   above, which is the more Mathlib-native path.

3. **Exact Mathlib names — all three anchors verified present** (so the directive's
   tentative `isoRightDerivedObj` name was correct):
   - `CategoryTheory.InjectiveResolution.isoRightDerivedObj` ✓
   - `CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ` ✓
   - `CategoryTheory.Functor.rightDerivedZeroIsoSelf` ✓ (needs `[PreservesFiniteLimits G]`)
   The project's own to-be-created names
   (`CategoryTheory.Functor.IsRightAcyclic`,
   `CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic`,
   `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`) are placeholders for
   the scaffolder; confirm/adjust namespace (`CategoryTheory.Functor` vs a
   project-local namespace) at scaffold time.

4. **Left-exactness hypothesis.** The clean statement `(R^n G)(A) ≅ Hⁿ(G(J•))` for
   *all* `n` (including the `R⁰ ≅ G` identification in degree 0) needs `G` left
   exact, not merely additive. I stated the theorem for `G` additive **and left
   exact**, which is satisfied by the intended application `G = f_*` (a right
   adjoint, hence left exact). The Stacks Leray lemma (Tag 015E) is stated for `G`
   merely additive because it lands in `D⁺(B)` where the degree-0 subtlety is
   absorbed; our object-level `Hⁿ` statement wants left-exactness. Flagging so the
   scaffolded signature carries the `PreservesFiniteLimits`/left-exact instance.

5. **Sibling-chapter consistency (not edited by me).** The sibling
   `Cohomology_CechHigherDirectImage.tex` proof of `lem:cech_computes_cohomology`
   still narrates the **spectral-sequence** argument (Čech-to-cohomology + Leray) in
   its prose/`% SOURCE QUOTE PROOF`, while its `\uses` already points at
   `lem:acyclic_resolution_computes_derived`. If the project has fully pivoted to the
   acyclic-resolution route, that sibling proof prose likely needs rewriting by its
   own writer to invoke this chapter's theorem instead of the two spectral sequences.
   Out of my scope — flagging for the planner to dispatch the sibling writer.

## Strategy-modifying findings
None. The acyclic-resolution theorem is provable as stated and is the correct
abstract replacement for the two spectral sequences. The only friction is the
*Lean-infrastructure* gap in Note 2 (missing LES for `Functor.rightDerived`), which
is an implementation concern for scaffolding/proving, not a flaw in the strategy: the
mathematics is sound and the gap is fillable by one of the routes listed. No
STRATEGY.md change is required on mathematical grounds.
