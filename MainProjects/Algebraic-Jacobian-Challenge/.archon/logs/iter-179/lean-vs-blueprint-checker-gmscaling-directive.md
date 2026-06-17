# Lean ↔ Blueprint Checker Directive

## Slug
gmscaling-iter179

## Lean file
AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean

## Blueprint chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Known issues
- The blueprint chapter `AbelianVarietyRigidity.tex` is a CONSOLIDATED chapter
  (carries `% archon:covers` covering several files including `GmScaling.lean`).
  Focus on the GmScaling-section content and its `\lean{...}` blocks.
- 2 TEMP project axioms `gmScalingP1_chart_data_temp` (L193) +
  `gmScalingP1_collapse_at_zero_temp` (L336) exist as known iter-177 HARD STOP
  scaffold; their downstream usage in `gmScalingP1_chart_agreement` (L280) and
  `gmScalingP1_collapse_at_zero` (L363) is laundering and is project-known.
  Flag them only if the laundering has spread to NEW declarations this iter, or
  if the blueprint claims kernel-clean closure that the Lean code can't deliver.
- `gmScalingP1_chart_PLB_eq` (L213) gained a partial body this iter; the
  trailing residual is one `sorry` after 4 successful rewrite steps. Verify
  the partial body claims match the blueprint's planned recipe.
- The `gmScalingP1_cover_X_iso` was refactored plan-phase to a uniform-in-`i`
  form (no longer `match i with | ⟨0,_⟩ => … | ⟨1,_⟩ => …`); the blueprint may
  still describe the old `match` form.
