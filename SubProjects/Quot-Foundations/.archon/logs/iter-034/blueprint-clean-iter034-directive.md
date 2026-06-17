# Directive — blueprint-clean `iter034`

## Scope
Purity pass over the blueprint chapters edited this iteration (and by the interrupted iter-034 phase):

- `blueprint/src/chapters/Picard_QuotScheme.tex` — 3 new gap1-C/P1 coverage blocks
  (`def:over_restrict_unit_iso`, `def:over_restrict_presentation`,
  `def:presentation_pullback_iota_of_quasicoherentData`).
- `blueprint/src/chapters/Picard_GrassmannianCells.tex` — 6 new `sec:gr_separated` ring-heart coverage
  blocks (`lem:gr_transitionPreMap_minorDet_swap_mul`, `def:gr_diagonalRingMap`,
  `lem:gr_diagonalRingMap_left/right`, `lem:gr_diagonalRingMap_surjective`, `def:gr_pullbackιIso`).
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — the conjugate-side re-encoding of
  `lem:base_change_mate_codomain_read_legs` and the H⁰-equalizer / eqLocus FBC-B blocks.
- `blueprint/src/chapters/Picard_FlatteningStratification.tex` and
  `blueprint/src/chapters/Picard_RelativeSpec.tex` — substantially expanded by the interrupted phase;
  run purity over them as well.

## What to do
Strip any Lean tactic syntax / Lean leakage, project-history / per-iter narrative verbosity
(e.g. "(iter-033)", "ABANDONED after N iters", planner-note residue) from PROSE bodies, and validate
that every `% SOURCE`/`% SOURCE QUOTE` block that claims an external citation has its verbatim quote
present and correctly attributed. Do NOT remove the structural `% NOTE:` markers that record genuine
formalization status. Do NOT add or remove `\leanok`. Keep the math content intact — these are coverage
blocks for already-built axiom-clean helpers; the statements are correct as written.

## Out of scope
No new mathematical content. Do not alter `\lean{}` pins or `\uses{}` edges (the writers wired them
deliberately this iter). You MAY spawn `reference-retriever` if a `% SOURCE QUOTE` is flagged missing.
