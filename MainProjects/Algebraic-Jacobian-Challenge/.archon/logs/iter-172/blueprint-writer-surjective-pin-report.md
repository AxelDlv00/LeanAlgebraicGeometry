# Blueprint Writer Report

## Slug
surjective-pin

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made

### Task 1 — New sub-lemma pinning `mvPolyToHomogeneousLocalizationAway_surjective`
- **Added lemma** `\lemma`/`\label{lem:mvPoly_to_homogeneousLocalization_away_surjective}`/
  `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}` —
  pins the new substantive sub-lemma at `AlgebraicJacobian/Genus0BaseObjects.lean:372`
  (statement: surjectivity of the inverse chart-ring map
  `MvPolynomial Unit kbar →+* HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (MvPolynomial.X i)`).
  Includes `\uses{def:proj_chart_ring_iso}` and a proof sketch in the project's
  prose: image equals `Algebra.adjoin 𝒜₀ {X_{1-i}/X_i}` (since `MvPolynomial Unit kbar`
  is generated as a `kbar`-algebra by its single generator `u` and the base map
  `kbar → 𝒜₀` is bijective); this adjoin is `⊤` by Mathlib
  `Away.adjoin_mk_prod_pow_eq_top` specialised to `d = 1`, `ι' = Fin 2`,
  `v = (X_0, X_1)`, `dv = (1, 1)`.
  - Inserted UNDER `lem:proj_chart_ring_iso_aux_left` (line ~1140 of edited chapter).

### Task 2 — Refreshed stale NOTE on `def:proj_chart_ring_iso`
- **Revised** the iter-171 NOTE inside `def:proj_chart_ring_iso` (formerly L1091-1100)
  to reflect the iter-172 state: the reverse round-trip body is REAL (a real
  cancel-surjective proof), and the residual `sorryAx` taint of the iso now flows
  entirely through the named new helper
  `\cref{lem:mvPoly_to_homogeneousLocalization_away_surjective}` rather than through
  the previous bare `aux_left` sorry. Mathlib lemma name preserved in the new NOTE.

### Task 3 — Encoding clarification for `def:gm`
- **Revised** `def:gm` (lines ~957-980 of edited chapter):
  - Added a multi-line `% NOTE (iter-172 encoding clarification):` LaTeX comment
    ABOVE the `\begin{definition}` block, recording the affine-Spec vs basic-open
    encoding choice and listing the two downstream consumers that require an affine
    carrier (`def:gaTranslationP1`, `lem:hom_additivity_over_product`).
  - Added a one-line visible-prose note INSIDE the definition body: "In Lean this
    is encoded as the **affine** scheme `Spec(Localization.Away t)` ... **not** as
    the basic open subscheme `D(t) ⊂ A¹`; the two are canonically isomorphic but
    downstream consumers ... require an affine carrier."

## Cross-references introduced
- `\uses{def:proj_chart_ring_iso}` in the new `lem:mvPoly_to_homogeneousLocalization_away_surjective`
  — `def:proj_chart_ring_iso` is the immediate sibling above and is already pinned.
- `\cref{lem:mvPoly_to_homogeneousLocalization_away_surjective}` referenced from the
  refreshed NOTE on `def:proj_chart_ring_iso` and from the now-refreshed body of
  `lem:proj_chart_ring_iso_aux_left`. The forward ref to the just-added lemma is
  intentional — placement of the surjectivity sub-lemma immediately below
  `aux_left` keeps both blocks adjacent.
- `\cref{lem:hom_additivity_over_product}` referenced from both the new
  Task-3 `% NOTE:` comment and the visible Task-3 prose addition — this label is
  already an existing block in this chapter (referenced from the chapter intro,
  L48).

## References consulted

This is an Archon-original block (Mathlib-internal lemma `Away.adjoin_mk_prod_pow_eq_top`
is the external authority but is NOT mirrored in `references/`; only the Mathlib
source path is cited in the LaTeX block, and no verbatim `% SOURCE QUOTE:` is
included — per the directive's "flag and skip the quote" clause). I did NOT open
any reference file under `references/` for this iter; the citation block in
`lem:mvPoly_to_homogeneousLocalization_away_surjective` documents the Mathlib
source path explicitly and flags that no verbatim quote is on disk.

The single Lean file I read in this session to ground the new block:

- `AlgebraicJacobian/Genus0BaseObjects.lean` (L250-410) — read for the exact
  Lean signature, type, and existing docstring of
  `mvPolyToHomogeneousLocalizationAway` + its `_surjective` variant + the
  surrounding chart-ring iso construction. Used to verify that the prose
  blueprint statement matches the Lean ring-hom signature (sends generator
  `u ↦ X_{1-i}/X_i`; base map `kbar → 𝒜₀ → Away`).

## Macros needed (if any)

None. The `\fatsemi` macro is already locally `\providecommand`'d at the top of
the chapter (L8), and all other constructs use existing Mathlib-style
roman-name macros that the chapter already uses (`\mathrm{Away}`,
`\mathrm{MvPolynomial}`, `\mathrm{Algebra.adjoin}`, etc.).

## Reference-retriever dispatches (if any)

None. The directive itself authorized me to "flag and skip the quote" for
the Mathlib lemma `Away.adjoin_mk_prod_pow_eq_top` if no verbatim source
exists under `references/`. I confirmed via grep that this lemma name does
not appear in any file under `references/` and so omitted the
`% SOURCE QUOTE:` line per directive.

## Notes for Plan Agent

- The Mathlib citation `Away.adjoin_mk_prod_pow_eq_top` carries an explicit
  Mathlib path `Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean:1064`
  but no verbatim `% SOURCE QUOTE:` (per directive). If you want full citation
  hygiene for this block in a future iter, you could dispatch a
  reference-retriever for the Mathlib source extract (slug e.g.
  `mathlib-homogeneous-localization-1064`). Not on this iter's critical path.
- The placement of the new sub-lemma is just below `lem:proj_chart_ring_iso_aux_left`,
  preserving the existing "chart cover & chart-ring iso" subsection structure
  and keeping the lemmas in the order
  `def:proj_chart_ring_iso → lem:proj_chart_ring_iso_aux_left →
  lem:mvPoly_to_homogeneousLocalization_away_surjective → lem:projlinebar_isReduced`.
- I did NOT touch `def:gaTranslationP1` (L1148-1208), `lem:gmScaling_fixes_zero`
  (L1210+), or any other block flagged "already-landed iter-171 review NOTEs to
  LEAVE ALONE" by the directive.
- I did NOT add or remove any `\leanok` / `\mathlibok` markers (per writer
  descriptor; `sync_leanok` will add `\leanok` to the new sub-lemma's
  statement block this iter since the Lean target has a typed `sorry`).

## Strategy-modifying findings

None. This iter's edits are pure prose alignment with the Lean state and do
not surface any strategy-level issue.
