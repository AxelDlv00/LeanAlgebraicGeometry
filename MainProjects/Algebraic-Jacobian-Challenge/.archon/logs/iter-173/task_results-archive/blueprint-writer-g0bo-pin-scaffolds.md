# Blueprint Writer Report

## Slug
g0bo-pin-scaffolds

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made
Four new blocks inserted immediately after `\end{definition}` of `def:gaTranslationP1`
(former L1266), under a new `\subsection*{Scaffolds for the body of $\sigma_\times =
\mathtt{gmScalingP1}$ (iter-171 chart-glue split)}`:

- **Added definition** `def:gmscaling_cover` / `\lean{AlgebraicGeometry.gmScalingP1_cover}` —
  pins the pullback-along-`pullback.fst` two-chart affine open cover of `(ℙ¹ ⊗ 𝔾_m).left`
  that the chartwise body of `σ_×` is built on. Anchors the three required pins below.
  `\uses{def:projlinebar_affine_cover, def:gm}`.
- **Added definition** `def:gmscaling_chart` / `\lean{AlgebraicGeometry.gmScalingP1_chart}` —
  the per-chart-`i` scheme morphism `(gmScalingP1_cover).X i ⟶ ProjectiveLineBarScheme`,
  with prose recipe: `pullbackSpecIso ⋙ Spec.map (ringMap) ⋙ chart-ring iso ⋙ Proj.away ι`.
  References `analogies/chart-bridge.md` (iter-173 in flight) and
  `analogies/gmscaling-deep.md` (existing). Pulls in the iter-172 axiom-clean chart-ring iso
  via `\cref{def:proj_chart_ring_iso}` and the surjectivity helper
  `\cref{lem:mvPoly_to_homogeneousLocalization_away_surjective}`.
  `\uses{def:gmscaling_cover, def:proj_chart_ring_iso, def:projlinebar_affine_cover, def:gm}`.
- **Added lemma** `lem:gmscaling_chart_agreement` / `\lean{AlgebraicGeometry.gmScalingP1_chart_agreement}` —
  the cocycle on pairwise pullbacks of cover charts. Diagonal cases trivial via
  `pullback.condition`; cross cases reduce on `D₊(X₀·X₁)` to the unit identity `t·u = 1` in
  `Localization.Away t ⊗_k̄ GmRing k̄`. `\uses{def:gmscaling_chart, def:gmscaling_cover}`.
- **Added lemma** `lem:gmscaling_over_coherence` / `\lean{AlgebraicGeometry.gmScalingP1_over_coherence}` —
  the `Over (Spec k̄)`-side coherence: the glued scheme morphism intertwines the structure
  maps. Reduces via `Scheme.Cover.hom_ext` to chart-wise checks, each automatic from the
  way `gmScalingP1_chart i` factors through `Spec.map (algebraMap k̄ _)`.
  `\uses{def:gmscaling_chart, lem:gmscaling_chart_agreement, def:gmscaling_cover}`.

Each block carries:
- The single `\lean{...}` pin pointing at the named Lean declaration (verified to exist
  at `AlgebraicJacobian/Genus0BaseObjects.lean:823, 845, 855, 871`; all four are present
  in the current file and named exactly as pinned).
- A `\uses{...}` dependency graph reflecting the iter-171 chart-glue split.
- No `\leanok` or `\mathlibok` markers (per the writer descriptor and directive).
- No external `% SOURCE QUOTE` (the four blocks are Archon-original Lean encodings of
  project-bespoke scaffolds, not external claims).
- A brief explanatory NOTE at the top of the new subsection documenting why the four pins
  exist (the iter-172 `g0bo172` lean-vs-blueprint-checker MAJOR finding) and what iter-173
  prover work targets via them.

Also cleaned up an awkward `\mathrm{Proj.aw\!ay\iota}` rendering in my own new blocks to
`\mathrm{Proj.away}\,\iota` (3 occurrences within the new blocks).

## Cross-references introduced
- `def:gmscaling_cover \uses def:projlinebar_affine_cover` — exists in the same chapter.
- `def:gmscaling_cover \uses def:gm` — exists in the same chapter.
- `def:gmscaling_chart \uses def:gmscaling_cover` — new label, just added.
- `def:gmscaling_chart \uses def:proj_chart_ring_iso` — exists in the same chapter.
- `def:gmscaling_chart \uses def:projlinebar_affine_cover` — exists in the same chapter.
- `def:gmscaling_chart \uses def:gm` — exists in the same chapter.
- `lem:gmscaling_chart_agreement \uses def:gmscaling_chart` — new label, just added.
- `lem:gmscaling_chart_agreement \uses def:gmscaling_cover` — new label, just added.
- `lem:gmscaling_over_coherence \uses def:gmscaling_chart` — new label, just added.
- `lem:gmscaling_over_coherence \uses lem:gmscaling_chart_agreement` — new label, just added.
- `lem:gmscaling_over_coherence \uses def:gmscaling_cover` — new label, just added.
- New forward references from the prose body of `def:gmscaling_cover` to
  `def:gmscaling_chart`, `lem:gmscaling_chart_agreement`, `lem:gmscaling_over_coherence`
  (and reciprocally from each new block to `def:gaTranslationP1`).
- New forward references to `def:proj_chart_ring_iso` and
  `lem:mvPoly_to_homogeneousLocalization_away_surjective` from the construction-recipe
  paragraph of `def:gmscaling_chart`.

Verified that all `\begin{...}/\end{...}` pairs balance globally in the chapter after the
edit (definition: 13/13, lemma: 18/18, theorem: 1/1, proposition: 2/2, proof: 16/16,
remark: 6/6).

## References consulted
No `references/<file>.md` opened this session — the four new blocks are Archon-original
Lean encodings of project-bespoke iter-171 chart-glue scaffolds, so per the writer
descriptor they require no `% SOURCE QUOTE`. The prose recipe is grounded in the existing
on-disk file `AlgebraicJacobian/Genus0BaseObjects.lean` (read at lines 790–900 for the
declaration signatures and dockstring narratives) and in the existing analogy
`analogies/gmscaling-deep.md` (referenced by file name from the new blocks, not opened
this session — its existence was confirmed via `ls analogies/`).

## Macros needed (if any)
None — the new blocks use only `\fatsemi` (already provided locally by the chapter's
`\providecommand`) and standard math macros (`\mathrm`, `\mathtt`, `\Spec`, `\bar k`,
`\otimes`, `\iota`, `\colon`, `\cref`, `\cdot`).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **Optional pins deferred.** The directive listed four nice-to-have optional pins
  (`gmScalingP1_chart0_ringMap`, `gmScalingP1_chart1_ringMap`,
  `projectiveLineBar_isProper`, and a stand-alone block for the cover). I landed the cover
  as `def:gmscaling_cover` because the three required pins all reference it directly and
  the chapter is cleaner with the cover anchored independently. The two chart-side ring
  maps are *mentioned* by name in the prose body of `def:gmscaling_chart` (so the iter-173
  prover lane and downstream `lean-vs-blueprint-checker` can locate them), but I did not
  add separate pin blocks for them this iter — the prose mention is sufficient to keep
  them traceable without ballooning the chapter. Similarly, `projectiveLineBar_isProper`
  remains an unpinned auxiliary instance — promotable in a follow-up if the
  blueprint-doctor flags it. The directive explicitly marked these as "nice-to-have, not
  required this iter".
- **Forward reference to `analogies/chart-bridge.md`.** The directive instructed me to
  reference this file as the iter-173 analogist note (in flight). It does not yet exist
  on disk (I verified `ls analogies/`); the existing nearest analog is
  `analogies/gmscaling-deep.md`. The two new lemma bodies and the chart def cite
  `chart-bridge.md` with an explicit "(iter-173 in flight)" parenthetical so the chapter
  remains honest about its forward-reference status; if the analogist completes
  `chart-bridge.md` this iter, the parenthetical can be dropped in a future cleanup.
- **`sync_leanok` will mark only `lem:gmscaling_chart_agreement` and
  `lem:gmscaling_over_coherence` and `def:gmscaling_chart` as un-`\leanok` next sync**
  (they are typed sorries in Lean), and will mark `def:gmscaling_cover` as `\leanok`
  (the cover is axiom-clean iter-171). This is a deterministic-phase concern, mentioned
  here only so the plan agent knows what to expect after the next sync.
- **Iter-172 lean-vs-blueprint-checker `g0bo172` MAJOR finding is now addressed.** The
  three named top-level scaffold sorries that the iter-171 chart-glue split factored
  out — `gmScalingP1_chart`, `gmScalingP1_chart_agreement`,
  `gmScalingP1_over_coherence` — now each have their own `\lean{...}` pin and a
  free-standing blueprint block. The dependency graph can resolve iter-173 prover
  obligations against these three labels directly.

## Strategy-modifying findings
None. The four new blocks pin existing Lean scaffolds and do not alter the strategic
arc of the chapter or the project.
