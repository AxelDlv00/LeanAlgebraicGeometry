# Blueprint Writer Report

## Slug
g0bo-helper-pins

## Status
COMPLETE — both required `\lean{...}` blocks added; LaTeX env balance verified
(`lemma` / `definition` / `theorem` / `proof` / `description` all balance to 0).
File grew from 1901 → 2026 lines.

## Target chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Changes Made

- **Added lemma** `\label{lem:chart_ring_iso_preserves_algebraMap}` /
  `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap}` —
  the `kbar`-algebra-preservation half of the chart-ring iso of
  `\cref{def:proj_chart_ring_iso}`. States that composing
  `algebraMap kbar (Away A X_i)` with the forward direction of the chart-ring
  iso recovers `algebraMap kbar (MvPolynomial Unit kbar)`. Inserted
  **immediately after** `lem:mvPoly_to_homogeneousLocalization_away_surjective`
  (now at file lines 1184–1239), keeping the chart-ring iso section's flow
  intact: `def:proj_chart_ring_iso` → `aux_left` → `surjective` →
  `preserves_algebraMap` → `projlinebar_isReduced`.
  - Proof sketch added: Y, ~12 lines. Routes through
    `HomogeneousLocalization.algebraMap_eq` (Mathlib structural unfolding of
    the `Algebra.compHom` wiring), the axiom-clean forward round-trip
    `forward ∘ inverse = id` from `lem:proj_chart_ring_iso_aux_left`, and the
    surjectivity of `inverse_i` from
    `lem:mvPoly_to_homogeneousLocalization_away_surjective` to lift the
    pointwise check on constants `r ∈ kbar` to a ring-map equality.

- **Added lemma** `\label{lem:gmscaling_chart_PLB_eq}` /
  `\lean{AlgebraicGeometry.gmScalingP1_chart_PLB_eq}` — the per-chart
  certificate `chart_i ≫ PLB.hom = (cover).f i ≫ (PLB ⊗ Gm).hom` consumed
  by `lem:gmscaling_over_coherence` after `Cover.hom_ext` /
  `ι_glueMorphisms_assoc`. Inserted **between**
  `lem:gmscaling_chart_agreement` and `lem:gmscaling_over_coherence`
  (now at file lines 1438–1503), so the per-chart bridge appears
  immediately upstream of its consumer.
  - Proof sketch added: Y, three explicit `\item[(A)…] / (B) / (C)`
    description steps matching the iter-174 analogist `chart-bridge-shared-helper`
    recipe (Decision 3). Step (A) collapses `Proj.awayι ≫ PLB.hom` via the
    project chart-bridge `awayι_comp_PLB_hom`; Step (B) merges `Spec.map`s
    via `Spec.map_comp` + `\cref{lem:chart_ring_iso_preserves_algebraMap}` +
    `MvPolynomial.eval₂Hom_C`; Step (C) chases the source-side pullback isos
    via `pullbackSpecIso_hom_base`, `pullbackRightPullbackFstIso_hom_fst`,
    `pullbackSymmetry_hom_comp_fst`, `Over.tensorObj_hom`,
    `pullback.condition`.
  - Includes an `\emph{Status (iter-174 → iter-175)}` paragraph
    documenting that Steps (A) + (B) are axiom-clean as of iter-174 and
    that Step (C) carries two residual scaffold `sorry`s on `i=0`/`i=1`
    due to a `MvPolynomial.X (0 : Fin 2)` vs `MvPolynomial.X ⟨0, _⟩`
    syntactic mismatch, scheduled for closure on the iter-175 Lane A
    chart-bridge structural pivot.

## Cross-references introduced

- `\uses{def:proj_chart_ring_iso, lem:proj_chart_ring_iso_aux_left,
  lem:mvPoly_to_homogeneousLocalization_away_surjective}` in
  `lem:chart_ring_iso_preserves_algebraMap` — all three labels already
  exist in the chapter (verified via `grep -n` at lines 1086, 1119, 1142
  pre-edit).
- `\uses{def:gmscaling_chart, def:gmscaling_cover,
  lem:chart_ring_iso_preserves_algebraMap, def:gaTranslationP1}` in
  `lem:gmscaling_chart_PLB_eq` — all four labels exist (the new label is
  defined by this same edit; the others at pre-edit lines 1306, 1281,
  1208).
- Prose `\cref{lem:gmscaling_over_coherence}` in
  `lem:gmscaling_chart_PLB_eq` body — label at pre-edit line 1383
  (existing).
- Prose `\cref{lem:gmscaling_chart_PLB_eq}` (forward reference) in
  `lem:chart_ring_iso_preserves_algebraMap` body — resolves to the
  block created by this same edit.
- The directive flagged a potential `\uses{lem:gmscaling_awayι_comp_PLB_hom}`
  citation in the new `gmscaling_chart_PLB_eq` block. After grepping the
  chapter (`awayι|PLB|chart-bridge` — see Notes for Plan Agent), I found
  the chapter does **not** carry a labeled lemma block for the chart-bridge
  helper `awayι_comp_PLB_hom`. Per the directive's instruction
  ("if the chapter already documents the chart-bridge inline without a
  labeled lemma, leave it alone and replace the `\uses{}` reference with
  a prose citation"), I cited the helper in prose ("the project-side
  chart-bridge `awayι_comp_PLB_hom` (`Genus0BaseObjects.lean`, post-iter-175
  split moves to `Genus0BaseObjects/ChartBridge.lean`)…") and did **not**
  introduce a new label.

## References consulted

- `analogies/chart-bridge-shared-helper.md` (iter-174 api-alignment) —
  the chart-bridge 10-step recipe (Decision 3) for
  `gmScalingP1_chart_PLB_eq`'s proof prose; the recipe for the
  `homogeneousLocalizationAwayIso_algebraMap` sub-lemma (Decision 3 row 3)
  including the `HomogeneousLocalization.algebraMap_eq` /
  `Algebra.compHom` structural cite.

(Note: no `% SOURCE QUOTE` blocks were drafted — both new lemmas are
Archon-original Lean encodings of project-bespoke results. The header
comments explicitly state this. The cited Mathlib lemma
`HomogeneousLocalization.algebraMap_eq` is a structural unfolding
referenced in the proof prose, not the subject of a `% SOURCE QUOTE`:
the project does not mirror Mathlib source files under `references/`,
and the proof body's appeal to it is a standard structural fact, not a
textbook claim. This matches the existing pattern of the surrounding
chart-ring-iso blocks at lines 1117–1182.)

## Macros needed (if any)

None. Both blocks use only macros already present in the chapter
(`\fatsemi`, `\Spec`, `\cref`, `\mathtt`, `\mathrm`).

## Reference-retriever dispatches (if any)

None.

## Notes for Plan Agent

- The chapter does **not** currently document the chart-bridge
  `awayι_comp_PLB_hom` (project Lean helper, `Genus0BaseObjects.lean:796-805`)
  as a labeled lemma. The iter-174 analogist note
  `analogies/chart-bridge-shared-helper.md` (Decision 3 row 2) treats this
  helper as load-bearing for `gmScalingP1_chart_PLB_eq`'s Step (A). Per
  the directive's contingency clause ("if the chapter already documents
  the chart-bridge inline without a labeled lemma, leave it alone and
  replace the `\uses{}` reference with a prose citation"), I cited
  `awayι_comp_PLB_hom` in prose only. If the plan agent wants the
  blueprint↔Lean graph to track `awayι_comp_PLB_hom` independently as a
  `\lean{...}`-pinned lemma in a future iteration, this is an obvious
  candidate — its signature is stable, it is axiom-clean, and it has
  several downstream consumers in the chart-glue scaffolds. **Not in
  scope this iter** per the directive's "Out of scope" list.
- The `\emph{Status ...}` paragraph in `lem:gmscaling_chart_PLB_eq` will
  go stale once iter-175 Lane A lands the `i=0`/`i=1` Step (C) closures.
  When that happens, the plan agent (or next blueprint-writer dispatch)
  should refresh the paragraph to reflect that the lemma is fully
  axiom-clean. The deterministic `sync_leanok` phase will pick up the
  `\leanok` marker automatically; only the prose `Status` paragraph
  needs a human/agent refresh.
- The chart-bridge subsection (~lines 1278–1503 post-edit) is becoming
  long. Not a blocker, but if the chapter grows further the plan agent
  might consider splitting the `Genus0BaseObjects`-coverage portion into
  a dedicated subsection (e.g. `\subsection*{Genus-0 base objects:
  chart-ring iso, chart-glue scaffolds, and the per-chart bridge}`).

## Strategy-modifying findings

None. The two pins document existing Lean helpers; the strategy is
unaffected.
