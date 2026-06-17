# Blueprint Writer Report

## Slug
coheightbridge-skeleton

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Albanese_CoheightBridge.tex (NEW file, 477 lines)

## Changes Made

Created the new chapter `Albanese_CoheightBridge.tex` from scratch with the
following structure:

- **`\chapter{Coheight--Krull dim bridge for scheme points}`** /
  `\label{chap:Albanese_CoheightBridge}` — opening strategy note + chapter
  metadata `% archon:covers AlgebraicJacobian/Albanese/CoheightBridge.lean`.
- **Section `Setup and motivation`** — frames the two-invariant identification
  (Krull dim of stalk = topological coheight), explains why the bridge is
  needed (the two downstream consumers), and orients the reader to the
  chapter's structure.
- **Section `Coheight is preserved by open immersions`** with:
  - `\begin{lemma}` `\label{lem:coheight_eq_of_isOpenEmbedding}` /
    `\lean{Order.coheight_eq_of_isOpenEmbedding}` — block 1 per directive.
  - Informal proof sketch via the chain bijection
    (`Subtype.val` embedding + `Specializes.mem_open` for the chain-lifting
    direction).
- **Section `Coheight on Spec equals height in PrimeSpectrum`** with:
  - `\begin{lemma}` `\label{lem:coheight_spec_eq_height_primeSpectrum}` /
    `\lean{Order.coheight_spec_eq_height_primeSpectrum}` — block 2.
  - Proof via the dual-order identification + `coheight_orderIso` +
    `height_toDual`, pinned to `spec_le_iff` in Mathlib's
    `AffineSpace.lean:438-447`.
- **Section `The coheight = Krull-dim-of-stalk bridge`** with:
  - `\begin{theorem}` `\label{thm:ringKrullDim_stalk_eq_coheight}` /
    `\lean{AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight}` —
    block 3 (the headline).
  - `\uses{lem:coheight_eq_of_isOpenEmbedding, lem:coheight_spec_eq_height_primeSpectrum}`.
  - Five-step assembly proof per the analogist recipe Decision 2 L280-296:
    pick affine open → name prime → stalk = localisation → ringKrullDim =
    height → lift back to coheight via blocks 1+2.
- **Section `Codim-1 specialisation`** with:
  - `\begin{lemma}` `\label{lem:ringKrullDimLE_of_coheight_eq_one}` /
    `\lean{AlgebraicGeometry.Scheme.ringKrullDimLE_of_coheight_eq_one}` —
    block 4 (the consumer-facing wrapper).
  - `\uses{thm:ringKrullDim_stalk_eq_coheight}`.
  - One-paragraph proof: unfold `Ring.KrullDimLE 1` to
    `ringKrullDim ≤ 1`, apply the bridge.
- **Section `Consumer wiring and the Stacks 00TT carve-out`** —
  three consumer paragraphs (a) the `hreg_dim` refactor in
  `Albanese_CodimOneExtension` (explains the conjunction-halving, with the
  `IsRegularLocalRing` half explicitly carved out as the iter-200+ Stacks
  00TT sub-project); (b) the `Scheme.RationalMap.order` threading hygiene
  in `RiemannRoch_WeilDivisor`; (c) general future codim-1 infrastructure.
- **Section `Lean encoding`** — prover-facing summary of the 4 declarations
  to introduce in `AlgebraicJacobian/Albanese/CoheightBridge.lean`, with
  signature hints, Mathlib API surface (decl paths + line numbers at
  commit `b80f227`), and LOC estimates per block. Plus a Mathlib readiness
  audit listing every Mathlib decl the chapter relies on.
- **Section `Out of scope`** — explicit carve-outs: Stacks 00TT (separate
  iter-200+ sub-project); Milne 3.3 difference-map (separate); the
  `Scheme.RationalMap.order` refactor itself (downstream consequence, not
  performed here); Mathlib upstream PRs (flagged as observations only);
  general codim-$n$ specialisations (only the codim-1 case is packaged here).

## Cross-references introduced

`\uses{...}` declarations cross-referencing OTHER chapters:

- `\cref{chap:Albanese_CodimOneExtension}` — verified present at
  `Albanese_CodimOneExtension.tex` (label exists).
- `\cref{chap:RiemannRoch_WeilDivisor}` — verified present at
  `RiemannRoch_WeilDivisor.tex` (label exists).
- `\cref{lem:smooth_codim_one_dvr}` — verified present in
  `Albanese_CodimOneExtension.tex` L188.
- `\cref{lem:milne_codim1_indeterminacy}` — verified present in
  `Albanese_CodimOneExtension.tex` L377.

All four cross-references resolve to existing labels in the project's
blueprint. The new chapter's `\uses{...}` declarations inside the proof
blocks are all to its OWN new labels (`lem:coheight_eq_of_isOpenEmbedding`,
`lem:coheight_spec_eq_height_primeSpectrum`,
`thm:ringKrullDim_stalk_eq_coheight`) — internally consistent.

## References consulted

- `analogies/stacks-00tt-coheight.md` (full file, the directive's primary
  source recipe): used Decision 2 sketch L246-257 for block 1, L259-268 for
  block 2, L280-296 for block 3 (proof assembly), L298-307 for block 4,
  L319-340 for the consumer-wiring refactor of `hreg_dim`.
- `references/summary.md` (index): consulted to confirm what's available
  under `references/`. Found that `stacks-algebra.tex` is the only Stacks
  chapter present that *could* contain Krull-dimension foundations, but its
  catalogued tag (00T7, standard smooth) is unrelated to the coheight bridge.
- `blueprint/src/chapters/Albanese_CodimOneExtension.tex` (full file): read
  to confirm the cross-reference targets `\label{chap:...}`, `\label{lem:smooth_codim_one_dvr}`,
  `\label{lem:milne_codim1_indeterminacy}` exist, and to match the
  project's chapter style (sectioning, `% STRATEGY NOTE`, Lean encoding
  section, out-of-scope section).
- `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (first 200 lines):
  read to confirm citation conventions and Lean encoding format.
- `blueprint/src/content.tex`: read to confirm chapter input list (the new
  chapter is NOT added by me per directive — the plan agent adds the
  `\input{chapters/Albanese_CoheightBridge}` line manually).

No external retrievals were necessary (the directive forbade the new
chapter from citing Stacks 00TT directly, and no other external source's
verbatim quote is needed for the four assembly blocks).

## Macros needed (if any)

None. The chapter uses only macros already present in
`blueprint/src/macros/common.tex` (`\Spec`, `\codim`, `\div`, `\Pic`,
standard math operators).

## Reference-retriever dispatches (if any)

None. No mid-session retrieval was required; every referenced source is
either (a) already in the project (`analogies/stacks-00tt-coheight.md`,
sibling chapters) or (b) named only as a Mathlib decl path / line number,
which is a comment-level pointer, not a citation requiring verbatim quote.

## Notes for Plan Agent

1. **`% SOURCE QUOTE:` blocks intentionally omitted (Archon-original
   classification).** The four blocks in this chapter are project-side
   assembly of Mathlib API; no external published source states any of
   them under the exact formulation used. Per the writer descriptor's
   "Archon-original / project-bespoke" rule (source lines omitted when no
   external source is named for the block), I have used plain LaTeX
   comments (`% Source pointer: analogies/...` + Mathlib decl paths) in
   each section rather than `% SOURCE QUOTE:` blocks backed by
   `references/`. The directive's mention of `% SOURCE QUOTE:` from the
   analogist recipe is in tension with the citation-discipline rule that
   `% SOURCE QUOTE:` must come from a `references/<file>.md` (the
   analogist recipe lives at `analogies/`, not `references/`). I chose
   the descriptor's classification rather than fabricate citations.

   If the plan agent (or the reviewer in the same iter) wants the four
   blocks to carry formal `% SOURCE QUOTE:` blocks pointing at Stacks
   tags (e.g.\ Stacks 00KE for Krull dim of a ring, Stacks 02IZ for the
   scheme-level version), a follow-up reference-retriever dispatch can
   fetch those tags into `references/stacks-algebra.tex` (which is the
   already-present Stacks ch.10 file but currently catalogued only for
   tag 00T7) or into a new `references/stacks-krull-dim.tex`. I did
   not dispatch a retriever this round because (i) the analogist recipe
   sketches the assembly entirely from Mathlib API without quoting
   Stacks, and (ii) the directive's expected length (~80-150 lines)
   suggested four light declaration blocks rather than fully-cited ones.

2. **Chapter length exceeds the directive estimate (477 vs ~80-150).** I
   followed the project convention from sibling chapters
   (`Albanese_CodimOneExtension.tex` at 775 lines,
   `Albanese_AuslanderBuchsbaum.tex` at 200+ lines) and added the
   consumer-wiring + Lean-encoding + out-of-scope sections after the four
   declaration blocks. The four declaration blocks themselves are ~250
   lines; the remaining ~227 lines are strategy notes, motivation, and
   prover-facing scaffolding that mirrors the sibling-chapter style. If
   the plan agent prefers a leaner chapter, trimming the consumer-wiring
   section and the Lean-encoding section's audit list could bring the
   chapter under 300 lines without losing mathematical content.

3. **`content.tex` integration needed.** Per the directive, I did NOT
   add `\input{chapters/Albanese_CoheightBridge}` to `content.tex` (out
   of my write-domain). The plan agent should add that line for the
   chapter to render in the typeset blueprint.

4. **Specialisation-preorder convention.** The chapter consistently uses
   the Mathlib convention that the generic point is the strict maximum
   in the specialisation preorder (matching `specializationPreorder`
   from `Mathlib.Topology.Defs.Filter:228`). This matches the convention
   already in use by `Albanese_CodimOneExtension.tex` for `Order.coheight`
   on prime divisors, so the chapters are mutually consistent.

5. **Suggested upstream-PR observations (no action required from plan
   agent).** Two of the four blocks have natural Mathlib homes:
   `Order.coheight_eq_of_isOpenEmbedding` belongs in
   `Mathlib.Order.KrullDimension` (next to `coheight_orderIso`), and
   `AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight` could
   anchor a new `Mathlib.AlgebraicGeometry.Coheight` file. These are
   pointed out in the chapter's out-of-scope section as future PR
   targets, not project-side work.

## Strategy-modifying findings

None. The chapter is a faithful expansion of `analogies/stacks-00tt-coheight.md`
Decision 2's scaffold sketch into prover-ready blueprint content. No
strategic re-evaluation is needed: the Stacks 00TT carve-out remains a
separate iter-200+ sub-project, and the coheight bridge is a clean
~60-100 LOC project-side assembly per the analogist recipe.
