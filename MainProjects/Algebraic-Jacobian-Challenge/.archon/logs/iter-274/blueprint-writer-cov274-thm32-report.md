# Blueprint Writer Report

## Slug
cov274-thm32

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex

## Changes Made
Added a new section `\section{Internal Lean helper lemmas}`
(`\label{sec:thm32_lean_helpers}`), inserted just before the existing
`\section{Out of scope}`, containing one additive `\lemma` block per uncovered
Lean declaration. No citation blocks (internal helpers, no external source, per
directive). Each block carries a `\begin{proof}` body "Proved directly in Lean."

- **Added lemma** `\label{lem:isReduced_of_smooth_over_field}` /
  `\lean{AlgebraicGeometry.Scheme.RationalMap.isReduced_of_smooth_over_field}`
  — a scheme smooth over a field is reduced (`A.left` reduced when `A.hom`
  smooth). Root of the chain; wired by the incoming edge from
  `lem:av_isIntegral_of_smooth_geomIrred`.
- **Added lemma** `\label{lem:av_isIntegral_of_smooth_geomIrred}` /
  `\lean{...av_isIntegral_of_smooth_geomIrred}` — `A.left` is integral for an
  abelian variety over `\bar k`. `\uses{lem:isReduced_of_smooth_over_field}`.
- **Added lemma** `\label{lem:codimOneFree_of_indeterminacyLocus_eq_empty}` /
  `\lean{...codimOneFree_of_indeterminacyLocus_eq_empty}` — empty indeterminacy
  locus ⟹ `CodimOneFree`. Wired by the incoming edge from
  `lem:av_codimOneFree_of_indeterminacy`.
- **Added lemma** `\label{lem:av_codimOneFree_of_indeterminacy}` /
  `\lean{...av_codimOneFree_of_indeterminacy}` — `f : X ⇢ A` into an abelian
  variety is `CodimOneFree`.
  `\uses{lem:av_isIntegral_of_smooth_geomIrred, lem:codimOneFree_of_indeterminacyLocus_eq_empty, lem:milne_codim1_indeterminacy}`.
- **Added lemma** `\label{lem:av_isIntegral_and_codimOneFree}` /
  `\lean{...av_isIntegral_and_codimOneFree}` — conjunction
  `IsIntegral A.left ∧ CodimOneFree f`.
  `\uses{lem:av_isIntegral_of_smooth_geomIrred, lem:av_codimOneFree_of_indeterminacy}`.
- **Fixed dependencies** `thm:rational_map_to_av_extends` — hoisted
  `lem:av_isIntegral_and_codimOneFree` into its statement-level `\uses{}`
  (the chain root), wiring the whole helper cluster into the existing chapter
  cone (`extend_to_av` consumes the conjunction).

## Cross-references introduced
- `\uses{lem:av_isIntegral_and_codimOneFree}` added to
  `thm:rational_map_to_av_extends` (this chapter) — connects cluster root.
- `\uses{lem:milne_codim1_indeterminacy}` from
  `lem:av_codimOneFree_of_indeterminacy` — `lem:milne_codim1_indeterminacy`
  lives in `Albanese_CodimOneExtension.tex` (verified present, line 1793),
  matching the Lean dependency `indeterminacy_pure_codim_one_into_grpScheme`.
- Intra-cluster edges all resolve within this chapter.

## References consulted
None — internal project helpers, no external source (per directive). No citation
blocks written.

## Verification
- `leandag build --json`: `unknown_uses: []` (no broken refs); all five Lean
  names now matched to `lem:` blueprint nodes with correct fully-qualified
  `lean_name`.
- `leandag query --isolated --chapter Albanese_Thm32RationalMapExtension`:
  0 results (none of the new blocks isolated).
- Uncovered lean-aux count for
  `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` is now zero: each
  of the five previously-uncovered declarations is matched to its blueprint
  block.

## Notes for Plan Agent
- None. All five declarations are `private` typed-sorry/proved helpers feeding
  the existing covered `extend_to_av` (`thm:rational_map_to_av_extends`); the
  blueprint cluster mirrors their Lean dependency structure exactly.

## Strategy-modifying findings
None.
