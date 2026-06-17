# Blueprint Writer Report

## Slug
cov274-cechhdi

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:push_pull_unit_mate}`/`\lean{AlgebraicGeometry.pushPull_unit_mate}` —
  the base-change unit (mate) identity for the push--pull head: for composable
  `f : A → B`, `p : B → Z` and a `Z`-module `N`, the unit `η^p_N` followed by
  `p_*(η^f)` and the pushforward comparison equals `η^{f∘p}_N` followed by
  `(f∘p)_*` of the inverse pullback comparison. One-line statement + `\begin{proof}`
  body "Proved directly in Lean." (no `\leanok`, per scope).
- **Added lemma** `\lemma`/`\label{lem:push_pull_transport_cancel}`/`\lean{AlgebraicGeometry.pushPull_transport_cancel}` —
  the over-triangle transport cancellation for the push--pull tail: with the
  over-triangle `ḡ∘p₁ = p₂` as a free hypothesis, the pullback-comparison leg
  conjugated by the two `eqToHom` coercions collapses to the transport-light form.
  One-line statement + `\begin{proof}` body "Proved directly in Lean."
- **Fixed dependencies** `lem:push_pull_functor` — hoisted the two new labels into
  its statement-level `\uses{...}` (now
  `\uses{def:push_pull_obj, def:push_pull_map, def:cech_nerve, lem:push_pull_unit_mate, lem:push_pull_transport_cancel}`),
  because `pushPullMap_comp` (one of that block's `\lean{}` pins) is the consumer of
  both helper bricks. This is the WIRING hoist that gives each helper an incoming edge.

## Cross-references introduced
- `\uses{def:push_pull_map}` in each new block — `def:push_pull_map` exists in this
  same chapter (outgoing edge, so neither helper is isolated).
- `\uses{lem:push_pull_unit_mate, lem:push_pull_transport_cancel}` added to
  `lem:push_pull_functor` (incoming edge from the covered consumer).

## References consulted
None — these are internal project helper lemmas with no external mathematical
source. No `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source}` citation blocks were added
(per directive: internal helpers, omit all citation blocks).

## leandag verification
- `leandag build --json`: both `AlgebraicGeometry.pushPull_unit_mate` and
  `AlgebraicGeometry.pushPull_transport_cancel` no longer appear in
  `unmatched_lean` (uncovered lean-aux for the file dropped to zero).
- `leandag query --isolated --chapter Cohomology_CechHigherDirectImage`: 0 results —
  neither new block is isolated.
- No new `unknown_uses` touching any `push_pull` label. The sole project-wide
  `unknown_uses` (`thm:rational_map_to_av_extends → lem:av_isIntegral_and_codimOneFree`)
  is in a different chapter and predates these edits.

## Notes for Plan Agent
- The pre-existing `% NOTE (iter-264)` on `lem:push_pull_functor` still flags that
  the block carries two `\lean{}` pins (`pushPullMap_id`, `pushPullMap_comp`) where
  `pushPullMap_comp` is not yet a Lean declaration. That note is unchanged by this
  pass and remains for a future split/stub decision; it was out of scope here.

## Macros needed (if any)
None.
