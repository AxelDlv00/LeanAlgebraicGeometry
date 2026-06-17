# Blueprint Writer Report

## Slug
gr-cov

## Status
COMPLETE — all three coverage-debt blocks added; 1-to-1 Lean↔blueprint correspondence restored for the three new GR-glue declarations.

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Changes Made
- **Added definition** `\definition`/`\label{def:gr_the_glue_data}`/`\lean{AlgebraicGeometry.Grassmannian.theGlueData}` — the `Scheme.GlueData` bundle indexed by `{I : Finset (Fin r) // I.card = d}`, listing each field (U/V/f/f_id/t/t_id/t'/t_fac/cocycle) and noting `f_mono`/`f_hasPullback` are discharged by instance synthesis. Placed immediately before `def:gr_glued_scheme` in §"The glued Grassmannian scheme".
- **Added lemma** `\lemma`/`\label{lem:gr_chartTransition'_cocycle}`/`\lean{AlgebraicGeometry.Grassmannian.chartTransition'_cocycle}` — the scheme-level cocycle coherence `t'_{I,J,K} ∘ t'_{J,K,I} ∘ t'_{K,I,J} = 𝟙`. Proof sketch added: cancel the two internal `awayPullbackIso` conjugating pairs, collapse the six `Spec`-arrows into one `Spec Φ`, apply `cocyclePhiId` (Φ = id). Placed between `lem:gr_chartTransition'_fac` and `lem:gr_cocycle_phi_id`.
- **Added lemma** `\lemma`/`\label{lem:gr_awayMulCommEquiv_comp_awayInclLeft}`/`\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv_comp_awayInclLeft}` — the order-swap identity `swap_{x,y} ∘ ι^L_{x,y} = ι^R_{y,x}` as ring maps `R[1/x] → R[1/(yx)]`. Proof sketch added: ring-hom extensionality on `powers x`, both sides collapse to structure maps via the three `_comp_algebraMap` lemmas. Placed after `lem:gr_awayMulCommEquiv_comp_algebraMap` in the away-localisation pullback subsection.
- **Revised** `def:gr_glued_scheme` — added `def:gr_the_glue_data` and `lem:gr_chartTransition'_cocycle` to its statement `\uses{}` (correcting the dependency direction so the glued scheme uses the glue datum, not vice versa, per directive).

No `\leanok`/`\mathlibok` markers were added by me (per descriptor; the three new blocks carry no marker and the sync phase will manage `\leanok`). No `% SOURCE` lines were added — all three are project-bespoke results.

## Cross-references introduced
All verified against the on-disk chapter via `leandag build --json` (`unknown_uses: []`):
- `def:gr_the_glue_data` `\uses{def:gr_affine_chart, def:gr_chart_overlap, def:gr_chart_incl, def:gr_chart_transition, def:gr_chart_transition', lem:gr_chartIncl_isOpenImmersion, lem:gr_chartIncl_self_isIso, lem:gr_chartTransition_self, lem:gr_chartTransition'_fac, lem:gr_chartTransition'_cocycle}` — all existing labels.
- `lem:gr_chartTransition'_cocycle` `\uses{def:gr_chart_transition', lem:gr_cocycle_phi_id, def:gr_away_pullback_iso, def:gr_cocycle_theta_ij, def:gr_away_mul_comm_equiv}` — all existing labels.
- `lem:gr_awayMulCommEquiv_comp_awayInclLeft` `\uses{def:gr_away_mul_comm_equiv, def:gr_away_incl_left, def:gr_away_incl_right, lem:gr_awayInclLeft_comp_algebraMap, lem:gr_awayMulCommEquiv_comp_algebraMap, lem:gr_awayInclRight_comp_algebraMap, lem:mathlib_away_lift}` — all existing labels.
- `def:gr_glued_scheme` `\uses{}` now additionally references `def:gr_the_glue_data` and `lem:gr_chartTransition'_cocycle`.

## Labels I had to invent
None. Every `\uses{}` target is an existing label in the chapter, confirmed by `leandag` (no `unknown_uses`).

Two deviations from the directive's literal `\uses{}` lists, both toward greater accuracy (no invented labels):
- **Block 1 (`def:gr_the_glue_data`)**: the directive's sample list named `def:gr_transition` (the *ring-level* transition θ). The `Scheme.GlueData` record actually bundles the **scheme-level** fields, so I wired it to the scheme-level labels that match the record's fields: `def:gr_chart_incl` (f), `def:gr_chart_transition` (t), `def:gr_chart_transition'` (t'), plus the field-witnesses `lem:gr_chartIncl_isOpenImmersion`/`lem:gr_chartIncl_self_isIso`/`lem:gr_chartTransition_self`. This is faithful to the Lean `theGlueData` definition (verified at `GrassmannianCells.lean:1141-1152`).
- **Block 2 (`lem:gr_chartTransition'_cocycle`)**: the directive named `def:gr_transition`; I used `def:gr_chart_transition'` (the t'-field the lemma is about) plus the constituents the proof actually cancels/collapses (`def:gr_away_pullback_iso`, `def:gr_cocycle_theta_ij`, `def:gr_away_mul_comm_equiv`), alongside `lem:gr_cocycle_phi_id` as directed.

## Verification (leandag)
`leandag build --json` after edits:
- `unknown_uses: []` — no broken references introduced.
- The three target Lean declarations (`theGlueData`, `chartTransition'_cocycle`, `awayMulCommEquiv_comp_awayInclLeft`) are no longer in `unmatched_lean` — coverage debt cleared. `lean_aux_nodes` dropped to 6.
- None of the three new blocks appears in `leandag show isolated`; all are wired into the DAG. The 7 remaining isolated nodes are pre-existing (a Quot lemma + 6 `lean_aux` helpers from FBC/Quot), none in this chapter.

## References consulted
None — all three blocks are project-bespoke (Archon-original) results with no external source, so no citation blocks were written. (I read `AlgebraicJacobian/Picard/GrassmannianCells.lean` to confirm declaration names/signatures, not as a reference source.)

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- `AlgebraicGeometry.Grassmannian.isSeparated` and `...isProper` still appear in `leandag`'s `unmatched_lean` even though `lem:gr_separated`/`lem:gr_proper` carry the matching `\lean{}` hints. This was pre-existing and out of scope for this directive (directive explicitly said not to edit those blocks); flagging it in case the matcher needs attention — possibly the blocks' `\lean{}` targets or the Lean names diverge in a way worth a reviewer check.
- The `def:gr_glued_scheme` block still carries a long iter-031 status `% NOTE` and a near-complete prose restatement of the cocycle construction; that prose overlaps the new `lem:gr_chartTransition'_cocycle` block. Left untouched (NOTE cleanup is the review agent's job per directive), but a future pass could trim the inline cocycle narrative now that it has a dedicated block.

## Strategy-modifying findings
None.
