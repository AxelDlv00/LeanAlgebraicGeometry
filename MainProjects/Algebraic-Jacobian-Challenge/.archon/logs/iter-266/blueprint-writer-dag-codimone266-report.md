# Blueprint Writer Report

## Slug
dag-codimone266

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Albanese_CodimOneExtension.tex

## Changes Made
- **Added proof block** for `lem:smooth_algebra_krull_dim_formula` (Stage 6.A,
  Stacks 00OE) — closes the empty-proof ∞-node. The block:
  - carries a `% SOURCE QUOTE PROOF:` immediately before `\begin{proof}` with
    the verbatim Stacks proof of `lemma-dimension-at-a-point-finite-type-field`,
    copied character-by-character from `references/stacks-algebra.tex`.
  - contains an informal citation-level proof: reduces to Stacks 00OE via
    Noether normalisation + catenary dimension theory of finite-type
    \(k\)-algebras, giving \(\dim_x = \dim S_{\mathfrak q} +
    \mathrm{trdeg}_k\kappa(\mathfrak q)\); then the closed-point
    specialisation over \(\bar k\) (Nullstellensatz \(\Rightarrow
    \mathrm{trdeg}=0\), so \(\dim S_{\mathfrak q} = \dim_x = n\)).
- **Moved dependency** `\uses{lem:rank_kaehler_localization_eq_relative_dim}`
  from the lemma's *statement* line into the `\begin{proof}\uses{...}` line.
  Rationale: the pure 00OE statement is a field-dimension-theory fact that does
  not involve Kähler differentials; the rank lemma is invoked only in the proof,
  to pin \(\dim_x(\mathrm{Spec}\,S) = n\) for the standard-smooth presentation
  that matches the Lean target
  `...IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`.
  Node-level edge is unchanged, so the DAG connectivity is preserved.

## Decision on \mathlibok anchor
Did **not** author a Mathlib dependency anchor. The 00OE
dimension-at-a-point formula (\(\dim_x = \dim S_{\mathfrak q} +
\mathrm{trdeg}_k\kappa\)) is not, to my knowledge, shipped as a single
faithful Mathlib declaration I could name with confidence. Per the
anti-hallucination rule, the proof is left as an informal citation of Stacks
00OE rather than a possibly-invented `\mathlibok` block.

## Cross-references introduced
- `\uses{lem:rank_kaehler_localization_eq_relative_dim}` in the new proof —
  target exists in this same chapter (Stage 5b lemma); verified live by leandag.

## Verification (leandag)
- `leandag build --json`: parsed 543 declarations, **0 conflicts**,
  **0 unknown_uses** (filtered for `krull` / `rank_kaehler`: none).
- `leandag query --isolated --chapter Albanese_CodimOneExtension`: **0 isolated
  nodes**. `lem:smooth_algebra_krull_dim_formula` remains connected (incoming
  from 6.B `lem:cotangent_kahler_over_field` and 6.C
  `lem:stage6_regular_stalk_assembly`; outgoing to
  `lem:rank_kaehler_localization_eq_relative_dim`).

## References consulted
- `references/stacks-algebra.tex` — L28206–28280: verbatim statement (already
  quoted in the existing `% SOURCE QUOTE`) and verbatim **proof** of
  `lemma-dimension-at-a-point-finite-type-field` (tag 00OE), used for the new
  `% SOURCE QUOTE PROOF:` block.

## Macros needed (if any)
- None.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- The lemma's informal *statement* is the general 00OE formula, but its
  `\lean{}` target
  (`...ringKrullDim_localization_eq_relativeDimension`) is the standard-smooth
  *specialisation* (Krull dim of the localisation = relative dimension \(n\)).
  The proof now bridges both (general formula via citation, then specialisation
  via the rank lemma). If a future reviewer prefers the informal statement to
  match the Lean target exactly, the statement could be narrowed to the
  standard-smooth case — but that is a statement change, out of scope here.
- The two sibling Stage-6 lemmas (`lem:cotangent_kahler_over_field` 6.B,
  `lem:stage6_regular_stalk_assembly` 6.C) both already carry proof blocks; only
  6.A was the empty-proof ∞-node. No sibling needed touching.

## Strategy-modifying findings
None.
