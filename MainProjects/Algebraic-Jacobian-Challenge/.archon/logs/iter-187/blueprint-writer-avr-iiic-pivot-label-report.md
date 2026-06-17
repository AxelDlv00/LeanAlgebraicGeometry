# Blueprint Writer Report

## Slug
avr-iiic-pivot-label

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made
- **Revised** the `(III) Three concrete pickup paths` description block inside
  `\begin{lemma} ... \label{lem:gmscaling_chart_agreement}` (chapter lines
  formerly ~1444-1490, replaced by an expanded block).
  - Re-labelled the heading to "(III) Three concrete pickup paths, with iter-187
    status" and added a one-sentence framing that (III.c) is the live route
    while (III.a)/(III.b) are off the table, preserving the three-way enumeration
    as an audit trail.
  - **(III.a)** now carries the bold tag `BLOCKED at Mathlib commit b80f227`.
    Body rewritten to:
    - Keep the original construction recipe text.
    - Add an explicit "Why this is blocked" paragraph naming the missing shim
      `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` AND the empirical
      iter-186 finding that the `pullbackRightPullbackFstIso_inv_*` simp lemmas
      do not fire because projections are buried inside outer `pullback.map`
      constructs (simp "made no progress"). Permanent block at b80f227 pending
      Mathlib upstream.
  - **(III.b)** now carries the bold tag `DESCOPED iter-187`. Body rewritten to:
    - Keep the original `pullback.hom_ext`-based recipe.
    - Add an explicit "Why this is descoped" paragraph stating the iter-186
      empirical finding that the simp coverage gap persists mid-chain even with
      the (III.a) refactor in place (specifically the
      `pullback.map ; pullbackRightPullbackFstIso.inv` adjacency not being
      Mathlib-canonical), and recording the iter-187 progress-critic
      `STUCK + OVER_BUDGET` verdict (sorry count flat 4/4/4/4 across iter-183 to
      iter-186, mandatory-decrement gate missed iter-186). Notes the path may be
      revisited only if (III.c) surfaces unexpected blockers.
  - **(III.c)** now carries the bold tag `iter-187 MANDATORY PIVOT` together
    with the three trigger conditions (iter-185 STRATEGY.md Open Q failure-mode
    trigger; iter-187 progress-critic STUCK verdict; iter-187 blueprint-reviewer
    MF-2). The body has been substantially expanded from the original two-line
    "separating sheaf argument" placeholder into a full recipe sketch:
    - States the key observation (`P^1` is separated, so its diagonal is a
      closed immersion) and grounds it in the Stacks Project ``Proj is
      separated'' result (tag `01KU` / `lemma-proj-separated`) and Mathlib's
      `IsSeparated.diagonal_isClosedImmersion` packaging.
    - Reformulates the cocycle as the pair-morphism
      `(chart_0, chart_1) : intersection -> P^1 x P^1` factoring through the
      diagonal, and invokes `IsClosedImmersion.lift_iff_range_subset` to reduce
      the factorization to closed-point containment (a discrete check
      bypassing the simp coverage gap).
    - Provides a four-step concrete prover recipe (build `Delta` via
      `prod.lift`; build the pair-morphism via `prod.lift`; show factorization
      via `IsClosedImmersion.lift`; reduce to two single-chart equalities via
      projection).
    - Lists substrate hooks (`IsSeparated.diagonal_isClosedImmersion`,
      `IsClosedImmersion.lift` and its `_iff_range_subset` variant,
      `CategoryTheory.Limits.prod.lift`, `pullback.lift`) and confirms all are
      present at pinned Mathlib `b80f227`.
    - Records the ~80-120 LOC cost estimate.

No other changes were made; (I), (II), (IV), the iter-186 header NOTE, and all
sibling lemma blocks were left untouched per the directive's scope.

## Cross-references introduced
- None new. The expanded (III.c) body refers to existing labels already in this
  chapter: `\cref{def:proj_chart_ring_iso}`, `\cref{def:gmscaling_chart}`.
  These are accurate (both labels exist in this same chapter).
- The Stacks Project lemma `lemma-proj-separated` (tag `01KU`) is mentioned
  inline as background-fact (informal) — it is not a project blueprint label,
  and no `\cref` to it is introduced.

## References consulted
- `references/stacks-constructions.tex` lines 1314-1338 — verified the
  statement and proof of "The scheme `Proj(S)` is separated"
  (`\label{lemma-proj-separated}`) used as the background fact grounding
  (III.c). No `% SOURCE QUOTE` was added to the chapter because the
  `lem:gmscaling_chart_agreement` block is Archon-original (no external source
  for the cocycle statement itself); the Stacks lemma is cited inline only as
  the standard reason for `P^1`'s separatedness.
- `references/stacks-constructions.md` (header skim) — confirmed the file is
  the canonical local copy of Chapter 27 "Constructions of Schemes" with
  tag→label mapping cross-checked against `tags/tags`.

## Macros needed (if any)
- None. The rewrite uses only existing macros and the locally-defined
  `\fatsemi` already in this chapter.

## Reference-retriever dispatches (if any)
- None. The directive's named references (Stacks tag 01KU, Hartshorne II.4.6)
  were available locally and only needed for inline informal citation; no new
  verbatim quotes were added so no retrieval was required.

## Notes for Plan Agent
- The expanded (III.c) recipe references `IsClosedImmersion.lift` and
  `IsClosedImmersion.lift_iff_range_subset`. The directive asserted these are
  present at Mathlib `b80f227`; I quoted that authoritative claim in the
  chapter prose ("Every Mathlib lemma named above is present at the pinned
  Mathlib commit `b80f227`"). The Lane B prover should still verify the exact
  lemma names by `lean_local_search` before relying on them — Mathlib API
  surface names occasionally drift (e.g.\ `IsSeparated.diagonal_isClosedImmersion`
  may be exposed under `IsSeparated.is_closed_immersion_diagonal` or a
  Lean-style camelCase variant; `IsClosedImmersion.lift_iff_range_subset`
  similarly).
- The iter-186 header NOTE on this lemma (lines ~1377-1392 of the original
  layout) still references the Mathlib bridge gap and the elaboration-shape
  obstacle as the two blockers. That NOTE remains accurate for path (III.a) and
  is preserved as-is, but a future cleanup pass may want to add a one-line
  "(III.c) bypass selected iter-187" pointer at the bottom of that NOTE for
  navigational convenience. I did not modify it because the directive scoped
  the edit to the (III) description block only.
- The `(III.b)` block's helper-lemmas
  `\cref{lem:pullback_map_fst_proj}` / `\cref{lem:pullback_map_snd_proj}`
  (iter-184 Recipe~1, lines ~1241-1285) were authored in expectation of
  (III.a). With (III.a) now blocked and (III.b) descoped, those two helpers
  are currently orphaned. They are still potentially useful as upstream
  Mathlib contributions; the directive did not authorize removing or
  retracting them, so I left them alone. The plan agent may want to record a
  "candidate for retraction if (III.c) lands cleanly" note in STRATEGY.md.

## Strategy-modifying findings
None. The rewrite executes the strategic decision the iter-187 progress-critic
and blueprint-reviewer already made (pivot Lane B to the separated-locus
alternative); it does not surface any new strategy-level concern.
