# Blueprint Writer Report

## Slug
codimoneext-stage6-pins

## Status
COMPLETE

All three iter-194 blueprint-reviewer HARD GATE blockers (M-1, M-2, M-3) addressed in `blueprint/src/chapters/Albanese_CodimOneExtension.tex`. The file grew from 954 to 1054 lines; begin/end environment pairs remain balanced (verified by Grep).

## Target chapter
blueprint/src/chapters/Albanese_CodimOneExtension.tex

## Changes Made

### M-1: NOTE inside `lem:smooth_to_regular_local_ring`
- **Revised** `lem:smooth_to_regular_local_ring` (existing block, no `\leanok` change) — added a 12-line iter-194 NOTE immediately after the existing iter-186 plan NOTE and before `\textit{Source: [Stacks Project], tag 00TT.}`. The NOTE records that:
  - The Lean body `isRegularLocalRing_stalk_of_smooth` remains a typed sorry.
  - Iter-193 landed Stages 5a + 5b axiom-clean (the two named private helpers).
  - Stage 6 closure depends on the 00OE (smooth-algebra dimension formula) + 02JK (cotangent / Kähler-over-a-field) Mathlib gaps tracked iter-200+.
- No `\leanok` added or removed (managed by `sync_leanok`).

### M-2: New `\subsection` with Stage 5a/5b lemma blocks
- **Added subsection** `\subsection{Stages 5a/5b: K\"ahler-differentials localisation substrate (iter-193)}` at `\label{subsec:kaehler_localisation_substrate}`, placed in section `\sec:smooth_dvr` between the introductory paragraphs and the existing `lem:smooth_to_regular_local_ring` lemma block. The subsection intro paragraph documents the six-stage chain (Stages 1--4 axiom-clean since iter-191/192, Stages 5a/5b iter-193, Stage 6 the remaining Mathlib gap).
- **Added lemma** `\lemma`/`\label{lem:module_free_kaehler_localization}`/`\lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}` — Stage 5a: if `\Omega_{S/R}` is `S`-free, then for any submonoid `M \subseteq S` and localisation `S_M`, `\Omega_{S_M/R}` is `S_M`-free. Proof sketch: composes Stacks 02JK (`KaehlerDifferential.isLocalizedModule_map`) with `Module.free_of_isLocalizedModule`.
- **Added lemma** `\lemma`/`\label{lem:rank_kaehler_localization_eq_relative_dim}`/`\lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}` — Stage 5b: under `IsStandardSmoothOfRelativeDimension n R S` and nontriviality of `S_M`, `rank_{S_M}(\Omega_{S_M/R}) = n`. Proof sketch: composes `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` with `Module.lift_rank_of_isLocalizedModule_of_free`; observes that `Cardinal.lift` is harmless because `n` is a natural number.
- Verified Lean namespaces by reading `AlgebraicJacobian/Albanese/CodimOneExtension.lean`: both helpers are `private theorem` declarations between `end RationalMap` at L183 and `namespace RationalMap` at L635, so they sit in `AlgebraicGeometry.Scheme`. See **Notes for Plan Agent** below regarding the `private` access modifier.

### M-3: iter-194 NOTE inside `thm:weil_divisor_obstruction`
- **Revised** `thm:weil_divisor_obstruction` (existing block, `\lean{...}` field remains absent) — followed the directive's documented-gap fallback: a corresponding Lean declaration *genuinely does not exist*. The iter-179 NOTE on this block already documented this in detail; I added a 12-line iter-194 NOTE immediately after the iter-179 NOTE and before the `% SOURCE:` line, summarising that:
  - The iter-179 detach was structural (not a `\lean{...}` typo).
  - The substantive Hartshorne-II.6 `ord_W >= 0` statement requires `Scheme.RationalMap`-to-function-field pullback machinery not in Mathlib at b80f227 and not built in this project.
  - The honest fallback Lean decl `mem_domain_iff_exists_partialMap_through_point` is blueprint-pinned at `\cref{lem:mem_domain_partial_map_reshuffle}` (already in place from a prior iter).
  - `thm:weil_divisor_obstruction` remains unpinned at the `\lean{...}` level until the genuine pullback decl lands.

## Cross-references introduced
- `\uses{lem:module_free_kaehler_localization}` added in the new `lem:rank_kaehler_localization_eq_relative_dim` lemma block — Stage 5b consumes Stage 5a as a typeclass-search prerequisite (`Module.Free S (\Omega[S/R])`), so the dependency is real.
- `\cref{lem:module_free_kaehler_localization}` and `\cref{lem:rank_kaehler_localization_eq_relative_dim}` referenced from the iter-194 NOTE inside `lem:smooth_to_regular_local_ring`.
- `\cref{lem:mem_domain_partial_map_reshuffle}` referenced from the iter-194 NOTE inside `thm:weil_divisor_obstruction`. Verified that the target label is defined elsewhere in the same chapter (line ~848 in the post-edit file, the iter-179 honest-fallback lemma block).

## References consulted

No new citation blocks were authored from external sources in this edit. The new Stage 5a/5b lemma blocks are Archon-original composite-of-Mathlib statements (per the writer rules: "For Archon-original / project-bespoke results — the directive does not name an external source for this block — the source lines are omitted; the block stands on the proof sketch alone."). The blocks gesture at Stacks tags 02JK and 00T7(2) inside the proof sketches as Mathlib provenance, but they do not include `% SOURCE QUOTE:` verbatim text because (a) the directive did not name an external source for these composite blocks, and (b) the project does not currently have a verbatim-quote-bearing local file for Stacks 02JK or 00T7(2) in `references/` keyed to these particular Mathlib re-exports.

Files I opened/read during this edit:
- `blueprint/src/chapters/Albanese_CodimOneExtension.tex` — to locate the three edit anchors and verify the existing chapter structure.
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean` — to verify the namespaces of the iter-193 Stage 5a/5b helpers (both sit in `AlgebraicGeometry.Scheme` between `end RationalMap` at L183 and `namespace RationalMap` at L635) and to confirm that no substantive Hartshorne-II.6 `ord_W >= 0` theorem matching `thm:weil_divisor_obstruction` exists in the file (only the iter-179 reshuffle `mem_domain_iff_exists_partialMap_through_point`, which is already pinned to `lem:mem_domain_partial_map_reshuffle`).

## Macros needed (if any)
None. The new content uses only existing macros (`\cref`, `\texttt`, `\(...\)` math mode, `\linebreak`, `\emph`).

## Reference-retriever dispatches (if any)
None. No new external source material was needed: the chapter already carries verbatim Stacks 00TT, Hartshorne II.6, and Milne §I.3 quotes from the pre-existing reference files, and the new Stage 5a/5b blocks are Archon-original composites.

## Notes for Plan Agent

1. **Stage 5a/5b helpers are `private theorem` declarations.** I pinned them at `\lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}` and `\lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}` per directive. Both declarations are `private theorem` in `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (L325, L351). In Lean 4 the elaborator mangles the names of `private` declarations with a `_private.<Module>.0.` prefix when they are referenced from outside the file; **`sync_leanok` may or may not resolve these names depending on how it issues its `lake env lean` lookups.** If sync_leanok fails to resolve them, the iter-195+ plan agent has two options: (a) re-pin to the mangled name (probably `_private.AlgebraicJacobian.Albanese.CodimOneExtension.0.AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization` and its sibling); or (b) ask the prover to make the helpers non-private (drop `private` so they get the unmangled fully-qualified name). I judged (b) the cleaner downstream choice but left the decision out of my scope. Flagging here so the plan agent can verify after the next `sync_leanok` run.

2. **The `\subsection{...}` is new to this chapter.** Pre-edit, the chapter used only `\section{...}`. The added subsection introduces depth 2 numbering inside `\sec:smooth_dvr`. plastex / lean-blueprint should handle it transparently; the LaTeX is standard. If the chapter ends up with multiple `\subsection`s in future writer dispatches, the placement convention can be left as-is.

3. **`thm:weil_divisor_obstruction` substantive lemma remains unformalised.** The directive's Edit 3 has been resolved via the documented-gap fallback, but the underlying mathematical content — Hartshorne II.6's "regular = no pole" Weil-divisor reformulation — has no Lean correspondent in the project. The plan agent should consider whether iter-195+ wants to:
   (a) commission a new Lean lemma `extend_iff_pullback_order_nonneg` building the `Scheme.RationalMap`-to-function-field pullback machinery (substantial — would need its own A.4.a sub-row in PROGRESS); or
   (b) accept that `thm:weil_divisor_obstruction` is "blueprint-only" and document this fact in the chapter's `Out of scope` section.
   The current state (NOTE explaining the gap, no Lean pin) is honest but leaves the chapter with one block that `sync_leanok` will never mark `\leanok`. The downstream consumer `Albanese/Thm32RationalMapExtension.lean` (A.4.c) currently consumes only `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy`, so the absence of `thm:weil_divisor_obstruction` on the Lean side does NOT block A.4.c.

4. **Iter-179 NOTE is preserved verbatim.** I did NOT remove or rewrite the existing iter-179 detach NOTE on `thm:weil_divisor_obstruction`. The two NOTEs (iter-179 + iter-194) now coexist, with the iter-194 NOTE adding the explicit "no corresponding Lean declaration found" line per the directive. This double-NOTE may be longer than ideal but each addresses different review iterations and is informative.

## Strategy-modifying findings
None. The chapter additions reflect the iter-193 Lane M↓ Stage 5a/5b axiom-clean substrate landing and the iter-179 detach decision on `thm:weil_divisor_obstruction`. No statement in STRATEGY.md needs revision: the smooth-→-regular Stacks 00TT chain remains the same 6-stage decomposition strategy, and the codim-1 obstruction A.4.a consumer (A.4.c) still consumes only `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy`.
