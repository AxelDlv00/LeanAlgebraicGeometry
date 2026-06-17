## Files to audit
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GlueDescent.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Focus
- Confirm every remaining `sorry` is genuinely open (none silently closed by an unsound/circular lemma).
- Axiom honesty: flag any decl that closes via a vacuous hypothesis, `Classical`-abuse, or an unproved `have` re-asserted as fact.
- New helpers this session (GlueDescent triple-overlap block: glueData_triple_square, glueData_preimage_image_eq₃, glueTripleBaseChangeIso, glueTripleFactor_transpose/_mate, glueLeg{A,B}_component_transpose, glueChartFamily_pullback_map_π; GrassmannianQuot: chartMorphism_glue_compat, comp_chartMorphism, presentedMatrix_comp, chart_point_eq, imageMatrix_map_ringHom, chartComposite_rqPullback) — check for drift/duplication vs GrassmannianCells.lean private copies.
- `set_option maxHeartbeats 800000` blocks in GrassmannianQuot (L3665,3806,3884,3951): are they masking a genuine perf/kernel problem, and do they carry explanatory comments?

## Constraints
Read-only. Report per-file checklist + flagged issues with severity. No strategy context needed.
