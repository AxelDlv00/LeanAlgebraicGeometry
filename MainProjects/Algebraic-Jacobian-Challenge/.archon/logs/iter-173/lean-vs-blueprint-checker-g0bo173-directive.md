# Lean ↔ Blueprint Checker — Genus0BaseObjects.lean × AbelianVarietyRigidity.tex

## Slug
g0bo173

## Iteration
173

## File pair

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex` (per `% archon:covers` declaration)

## Iter-173 prover edits to verify

- `awayι_comp_PLB_hom` (private lemma, ~L795–L807) — NEW
- `gmScalingP1_cover_X_iso` (private noncomputable def, ~L851–L883) — NEW
- `gmScalingP1_chart` body filled at L911 (previously a top-level sorry) — KEY ADVANCE

Three top-level scaffold sorries remain:
- `gmScalingP1_chart_agreement` at L944
- `gmScalingP1_over_coherence` at L961
- `gmScalingP1_collapse_at_zero` at L1025

The other 5 sorries are carry-over from earlier iters and are not the focus of this round.

## Verification questions

1. **Lean → Blueprint**: Does `gmScalingP1_chart` (now concrete) match the blueprint's `def:gmscaling_chart` pin (L1306) signature?
2. **Blueprint → Lean**: Do the `def:gmscaling_chart_agreement` (L1347) and `lem:gmscaling_over_coherence` (L1383) pins guide the iter-174 closure plan documented in the prover's task result?
3. Are the two new helpers (`awayι_comp_PLB_hom`, `gmScalingP1_cover_X_iso`) referenced in the chapter? If not, is that acceptable (they are internal lemmas of the body of `gmScalingP1_chart`)?
4. Verify HARD GATE consequence: does the chapter remain `complete + correct` for the next iter's Lane A on this file?

## Output

`task_results/lean-vs-blueprint-checker-g0bo173.md`
