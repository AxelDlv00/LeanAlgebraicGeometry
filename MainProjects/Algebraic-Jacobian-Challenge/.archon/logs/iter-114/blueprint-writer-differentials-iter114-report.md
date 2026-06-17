# Blueprint Writer Report

## Slug
differentials-iter114

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Differentials.tex

## Changes Made

- **Added lemma** `\begin{lemma}…\end{lemma}` / `\label{lem:relative_kaehler_isSheafUniqueGluing}` /
  `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheafUniqueGluing_type}` —
  states the unique-gluing characterisation of the sheaf condition for the
  underlying type-valued presheaf of `relativeDifferentialsPresheaf f`.
  - Marked `\leanok` on the **statement line** only (per directive Item 1; the
    Lean declaration exists with a `sorry` body, so blueprint convention says
    `\leanok` on the statement). The proof block carries no `\leanok`.
  - Block placed BETWEEN `\def:relative_kaehler_presheaf` and
    `\thm:relative_kaehler_isSheaf` (chapter L20–L86), i.e. *before* the
    theorem that delegates to it. The directive offered "between L54 and L56"
    as a position but explicitly noted "the new block should logically
    precede the proof"; placing it before the theorem makes the narrative
    flow strictly forward and keeps the dependency graph readable. The
    `\uses{...}` graph is unaffected by the choice.
  - Proof sketch added: 3-step recipe transcribed from directive — (Step 1)
    structure-sheaf gluing of compatible families via `KaehlerDifferential.span_range_derivation`
    + `Scheme.ringCatSheaf` sheaf property; (Step 2) descent of the universal
    derivation along the glued ring sections via
    `PresheafOfModules.DifferentialsConstruction.isUniversal'` and
    `ModuleCat.Derivation.desc`; (Step 3) uniqueness via
    `span_range_derivation` + `TopCat.Presheaf.Sheaf.eq_of_locally_eq`.
  - `\uses{def:relative_kaehler_presheaf, def:universal_derivation}` on the
    proof block.

- **Revised** `\thm:relative_kaehler_isSheaf` proof body (chapter L96–L113) —
  Replaced the iter-112 Route (a) sketch (refinement-cofinality against
  `isSheaf_iff_isSheafOpensLeCover`) with the Option (i) delegation: a short
  proof that applies `TopCat.Presheaf.isSheaf_iff_isSheaf_comp` along the
  forgetful chain `ModuleCat 𝒪_X → AddCommGrp → Type`, then invokes
  `TopCat.Presheaf.isSheaf_of_isSheafUniqueGluing_types` to reduce to
  `\lem:relative_kaehler_isSheafUniqueGluing`.
  - Removed the `[gap]` callout (the iter-112 "basis-to-opens descent gap"
    is no longer load-bearing in this proof).
  - Removed the stale "Differentials.lean, lines~113--122" file pointer
    (was tied to the old Route (a) stub).
  - Removed the obsolete paragraph about `SheafOfModules.IsQuasicoherent` /
    `IsSheaf.isSheafUniqueGluing` direction (no longer relevant after
    Option (i)).
  - Preserved the existing `\leanok` marker on the proof block (per
    directive: do not add/remove `\leanok` outside Item 1; the
    `sync_leanok` phase will reconcile).

- **Removed three stale `% NOTE (iter-112 review)` blocks**:
  - Block above `\thm:smooth_iff_locally_free_omega` (was: signature
    mismatch on `Smooth f` + free `n`; the iter-113 refactor landed
    `IsSmoothOfRelativeDimension n f`).
  - Block above `\cor:cotangent_at_section` (same signature concern;
    iter-113 refactor landed).
  - Block above `\thm:serre_duality_genus` (was: `H^0 = H^0` Lean equation
    + missing `geometrically irreducible`; iter-113 refactor landed
    `H^0(Ω) = H^1(O_C)` with `IsIntegral`).

- **Revised** `\thm:serre_duality_genus` statement (chapter L282–L292) —
  Replaced "smooth proper geometrically irreducible curve over a field $k$"
  with "smooth proper integral curve over a field $k$" to match the Lean
  signature `[IsIntegral C.left] [IsProper C.hom] (hsmooth : Smooth C.hom)`.

- **Added remark** `\begin{remark}…\end{remark}` / `\label{rem:serre_duality_geom_irred_gap}` —
  one-paragraph note immediately after `\thm:serre_duality_genus` recording
  that the classical Serre-duality statement assumes geometric
  irreducibility but Mathlib b80f227 lacks the scheme-level predicate, so
  `IsIntegral` is the closest available stand-in; the dimension equation
  still holds under integrality alone.

- **Softened** `\def:relative_kaehler_sheaf` — replaced the bare assertion
  "It is quasi-coherent" with a parenthetical noting the sheaf is morally
  quasi-coherent (locally a Mathlib `KaehlerDifferential` module) but the
  Lean object does not carry the `IsQuasicoherent` typeclass on the sheaf.

## Cross-references introduced
- `\uses{lem:relative_kaehler_isSheafUniqueGluing, def:relative_kaehler_presheaf}`
  in proof of `\thm:relative_kaehler_isSheaf` — `lem:relative_kaehler_isSheafUniqueGluing`
  is the new lemma in this same chapter; `def:relative_kaehler_presheaf` is at L13.
- `\uses{def:relative_kaehler_presheaf, def:universal_derivation}` in the new
  lemma's proof — `def:universal_derivation` lives at L130 of the same
  chapter (forward reference; the dependency-graph tool tolerates these).
- `\ref{lem:relative_kaehler_isSheafUniqueGluing}` in the proof body of
  `\thm:relative_kaehler_isSheaf` — matches the new label.
- `\ref{def:universal_derivation}` in the new lemma's proof body — matches
  the existing label at L130.

## Macros needed (if any)
None. All commands used (`\struct`, `\Spec`, `\Jac`, `\bigvee`, `\sharp`)
were already present in the chapter or in `macros/common.tex`.

## Reference-retriever dispatches (if any)
None. Per directive: the recipe is grounded in Mathlib idiomatic names
already verified upstream by the iter-113 prover lane and re-verified by
the iter-114 reviewer. No external source was needed.

## Notes for Plan Agent

- **Chapter introduction at L4–L9** still describes $\Omega_{X/S}$ as a
  "quasi-coherent sheaf of $\struct{X}$-modules". This is a top-level
  introductory sentence (not a declaration block) and was outside the
  directive's explicit scope, so I left it. If the iter-114 review wants
  consistency with the softened `\def:relative_kaehler_sheaf`, a future
  writer pass can adjust.
- **`def:cotangent_alpha` / `def:cotangent_beta` / `lem:cotangent_exact_structure`
  / `thm:cotangent_exact_sequence`** still describe their morphisms as
  living in "quasi-coherent $\struct{X}$-modules". Same observation as
  above: outside this directive's scope, but tracking the Lean object
  shape these are also in `X.Modules` without an `IsQuasicoherent` field.
- **The `\uses{def:universal_derivation}` in the new lemma's proof** is a
  forward reference (the universal derivation is defined later in the
  chapter at L130). LaTeX/`leanblueprint` handles this fine; flagging only
  in case the dependency-graph generator's expectations differ.
- **`lem:cotangent_exact_seq_beta_hη` (chapter L191–L197)** still carries an
  in-paragraph % NOTE (iter-086+iter-087) at L139 which is genuine
  upstream-deferral commentary on the cotangent-exactness route, distinct
  from the three iter-112-review NOTE blocks I removed. I left it intact
  as it remains live (the stalkwise-detection lemma is still deferred
  pending Mathlib `SheafOfModules.stalkFunctor`).
- **Iter-115 follow-up readiness**: after the mathlib-analogist-iter114
  dispatch returns, if it surfaces an off-the-shelf Mathlib API for the
  affine-basis-of-modules → sheaf bridge that supersedes the 3-step
  recipe I transcribed into `\lem:relative_kaehler_isSheafUniqueGluing`'s
  proof, the lemma's proof body should be re-written to delegate to that
  API (and a `\uses{...}` updated). The lemma statement and `\lean{...}`
  hint do not need to change.

## Strategy-modifying findings
None. All edits land within the iter-114 plan; no new strategy-level
issues surfaced during writing.
