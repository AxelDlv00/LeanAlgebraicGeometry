# Blueprint Writer Report

## Slug
codimone-stacks-00tt

## Status
COMPLETE — both MF-1 (Stacks 00TT bridge sub-lemma) and MF-2 (mem_domain reshuffle block) landed in `blueprint/src/chapters/Albanese_CodimOneExtension.tex`. Cosmetic I-3 clarification also added to the existing `lem:smooth_codim_one_dvr` proof block (no `\leanok` markers added/removed).

## Target chapter
`blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## Changes Made

- **Added lemma block** `\begin{lemma} \label{lem:smooth_to_regular_local_ring}` (L189–231)
  — packages the Stacks 00TT Jacobian-criterion direction (smooth-over-`k̄`
    ⟹ regular local stalk). Carries `% SOURCE:` pointer (`Stacks Project`,
    tag 00TT, read from `references/stacks-algebra.tex` L38593–38611,
    cross-checked against the Stacks website `tag/00TT` page), `% SOURCE QUOTE:`
    with the verbatim three-clause TFAE statement plus the "moreover" regular-
    local clause, visible `\textit{Source: [Stacks Project], tag 00TT.}` first
    prose line, a derivation sketch listing the four Mathlib hooks the prover
    must assemble (`Algebra.FormallySmooth`, the cotangent-complex side of
    `Algebra.Smooth`, the closed-point-specialisation routing,
    localisation-preserves-regularity), the load-bearing `[IsAlgClosed kbar]`
    note, and a backup pointer to Matsumura Ch. 19. NO `\lean{...}` pin (per
    directive's out-of-scope rule). NO `\leanok` (per writer descriptor rule).
- **Added proof block** for `lem:smooth_to_regular_local_ring` (L233–268)
  — Source-line first, then the affine-chart reduction to the cited algebra
    statement, then the four Mathlib-hook list, then the Matsumura backup.
    NO `% SOURCE QUOTE PROOF:` block — the Stacks tag 00TT proof itself is
    not used here (we cite the statement and sketch the scheme-level
    translation, which is project-bespoke prose, not a verbatim source
    extract).
- **Added introductory paragraph** (L184–187) bridging the existing
  `\section{Smoothness yields a DVR at every codim-1 point}` opening to the
  new sub-lemma, motivating why the smooth-implies-regular bridge is split
  out as its own block.
- **Revised** `lem:smooth_codim_one_dvr` proof block prose (L298–323)
  — added a `% NOTE (iter-185 writer)` documenting that the `\leanok` marker
    on the proof block reflects the Krull-dim half (Tier-1 axiom-clean iter-184
    via `Scheme.ringKrullDim_stalk_eq_coheight`) while the `IsRegularLocalRing`
    half is tracked separately as the Stacks 00TT gap now packaged in
    `\cref{lem:smooth_to_regular_local_ring}`. The visible prose's first
    sentence was rewritten to cite `\cref{lem:smooth_to_regular_local_ring}`
    instead of "by smoothness" with Hartshorne I.5.1; the rest of the proof
    body is unchanged.
- **Added lemma block** `\begin{lemma} \label{lem:mem_domain_partial_map_reshuffle}`
  (L743–759) — pins `AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point`
  (the iter-179 Lane-D-honest-fallback declaration at
  `AlgebraicJacobian/Albanese/CodimOneExtension.lean:492`). NO `% SOURCE:` /
  `% SOURCE QUOTE:` / `\textit{Source: ...}` (project-bespoke / Archon-original
  per directive). Statement and one-paragraph proof (the reshuffle is a
  conjunct-reorder of Mathlib `Scheme.RationalMap.mem_domain`; forward and
  backward immediate).
- **Added remark** `\begin{remark} \label{rmk:mem_domain_partial_map_reshuffle_scope}`
  (L772–786) — relates the new lemma to `thm:weil_divisor_obstruction`,
  documents the iter-179 Lane D scope (substantive `ord_W ≥ 0` form deferred
  to a future lemma requiring `Scheme.RationalMap`→function-field pullback
  machinery not in Mathlib at commit `b80f227`).
- **Revised** `\section{Lean encoding}` item 6 (L824–842) — added a
  `% NOTE (iter-185 writer)` and rewrote the prose to reference the new
  `\cref{lem:mem_domain_partial_map_reshuffle}` block instead of the
  iter-184-era "iter-185+ blueprint-writer follow-up" placeholder.

## Cross-references introduced
- `\cref{lem:smooth_to_regular_local_ring}` introduced in the chapter at three
  sites: the section opening paragraph (L184–187), the rewritten first
  sentence of `lem:smooth_codim_one_dvr`'s proof (L319), and (implicitly via
  the `% NOTE`) the iter-185 marker note. Label is defined in this chapter at
  L191, no cross-chapter dependency.
- `\cref{lem:mem_domain_partial_map_reshuffle}` introduced in two sites: the
  new `\section{Lean encoding}` item 6 prose (L836, L830 in comment), and the
  new remark `rmk:mem_domain_partial_map_reshuffle_scope` (L775). Label is
  defined in this chapter at L745, no cross-chapter dependency.
- `\cref{chap:Albanese_CoheightBridge}` referenced in the iter-185 NOTE inside
  the `lem:smooth_codim_one_dvr` proof block (L305). The chapter
  `chap:Albanese_CoheightBridge` exists per
  `blueprint/src/chapters/Albanese_CoheightBridge.tex` L4 — verified.
- `\cref{chap:Albanese_AuslanderBuchsbaum}` referenced in the new
  `lem:smooth_to_regular_local_ring` proof block (L266) as a backup pointer
  for regular-local-ring theory. The chapter exists per
  `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — verified.
- `\uses{}` is intentionally empty on `lem:smooth_to_regular_local_ring`
  (with a documented `% NOTE` explaining why). The Stacks 00TT prerequisites
  (`Algebra.Smooth`, `IsRegularLocalRing`) live in Mathlib as typeclasses
  and are not packaged as blueprint-labeled definitions in this project;
  adding broken `\uses{def:smooth_morphism, def:regular_local_ring}` refs
  would corrupt the leanblueprint dep graph. The directive's "typically"
  example labels do not exist in this project (verified via Grep on
  `blueprint/src/chapters/**`).

## References consulted
- `references/summary.md` — index of project references; cross-checked that
  `stacks-algebra.md`, `matsumura-commutative-ring-theory.md`, and
  `stacks-varieties.md` are the relevant cards for this chapter.
- `references/stacks-algebra.md` — confirmed Chapter 10 ("Commutative Algebra")
  is the home of `algebra.tex` in the project's local Stacks files;
  established that tag 00TT is NOT listed in the card's tag map (the card
  only inventories 00T7) so a direct `references/stacks-algebra.tex` quote
  is needed.
- `references/stacks-algebra.tex` L37100–37300 (definitions around standard
  smooth and the smooth ring map section opening), L38450–38600 (around
  `lemma-characterize-smooth-kbar` and the section §10.140 boundary), and
  primarily L38590–38670 — the verbatim `lemma-characterize-smooth-over-field`
  statement (L38593–38611) and its proof prologue. The `\label{...}` is
  `lemma-characterize-smooth-over-field`; the tag mapping to 00TT was
  confirmed by fetching `https://stacks.math.columbia.edu/tag/00TT` (header
  "Lemma 10.140.3 (00TT)") via Bash + curl.
- `references/stacks-varieties.md` — confirmed tag 056T
  (`lemma-smooth-geometrically-normal`) is the geometric-regularity refinement
  of the smoothness-implies-regularity story, used as the
  "without-algebraic-closure" pointer in the new sub-lemma's `[IsAlgClosed kbar]`
  load-bearing note.
- `references/matsumura-commutative-ring-theory.md` — confirmed Ch. 19
  ("Regular Rings") is the textbook backup citation for the
  regular-local-ring infrastructure invoked in step (iv) of the new sub-lemma's
  proof sketch.
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean` L195–286 (the existing
  `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` private helper, to
  match the Mathlib-hook naming and the iter-184 sorry split exactly) and
  L440–510 (the `mem_domain_iff_exists_partialMap_through_point` declaration
  body, to phrase the reshuffle's prose accurately).
- `blueprint/src/chapters/Albanese_CoheightBridge.tex` L1–80 (the iter-183
  bridge chapter, to confirm `\cref{chap:Albanese_CoheightBridge}` exists and
  carries the `Scheme.ringKrullDim_stalk_eq_coheight` content referenced in
  the iter-185 NOTE inside `lem:smooth_codim_one_dvr`'s proof block).
- `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (Grep only) —
  confirmed `cor:regular_cohen_macaulay` exists at L437 (the existing
  cross-reference target in this chapter's `thm:codim_one_extension` proof).

## Macros needed (if any)
None. All new prose uses standard LaTeX + `\cref`, `\texttt`, `\emph`,
`\mathcal`, `\Spec`, `\ord_W` macros already in scope (the chapter and
sibling chapters use them throughout).

## Reference-retriever dispatches (if any)
None. The Stacks 00TT statement was already in
`references/stacks-algebra.tex` (the local file is the full algebra.tex
master; the project's `stacks-algebra.md` card had not catalogued tag 00TT
specifically but the underlying .tex contained the verbatim statement at
L38593–38611). Tag-to-label mapping was confirmed via one Bash + curl call
to the Stacks Project website's `tag/00TT` page (returns
"Lemma 10.140.3 (00TT)" matching `lemma-characterize-smooth-over-field`).

## Notes for Plan Agent
- The project's `references/stacks-algebra.md` index card does NOT currently
  list tag 00TT in its tag map. Since this chapter and several sibling files
  (`AlgebraicJacobian/Albanese/CodimOneExtension.lean` L204, L240, L246) now
  cite Stacks 00TT, the card would benefit from an entry adding tag 00TT
  alongside the existing 00T7 row. This is outside this writer's
  write_domain (`blueprint/src/chapters/*.tex` only); flagging for a future
  reference-retriever or doctor pass.
- The new `lem:smooth_to_regular_local_ring` block carries no `\lean{...}`
  pin (per directive). When the prover eventually formalises this as a
  stand-alone Lean theorem (vs. inlining its content into the existing
  private `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` helper),
  a `\lean{...}` pin should be added then by a future writer / review pass.
- The chapter's `\uses{...}` graph remains sparse (this chapter does not
  use `\uses{...}` on its other blocks either). If the reviewer / plan agent
  wants a denser dep graph, a separate cleanup pass would add `\uses{...}`
  lines to the existing blocks (`def:indeterminacy_locus`,
  `def:codim_one_indeterminacy`, `thm:codim_one_extension`,
  `lem:milne_codim1_indeterminacy`, `thm:weil_divisor_obstruction`)
  pointing at their internal cross-references. Out of this directive's scope.

## Strategy-modifying findings
None. The chapter prose now correctly attributes the `IsRegularLocalRing`
half of the smooth-DVR claim to the Stacks 00TT Jacobian criterion and
documents the `[IsAlgClosed kbar]` hypothesis as load-bearing, but neither
fact changes the project strategy: this is a Mathlib-gap-bridge sub-lemma
the prover will fill in an iter-185+ round, exactly as STRATEGY.md already
anticipates (per the iter-184 NOTE preserved at L854–869).
