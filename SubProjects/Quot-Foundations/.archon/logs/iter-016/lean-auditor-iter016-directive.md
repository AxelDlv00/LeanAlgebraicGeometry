# lean-auditor — iter-016

Audit the project's Lean code as Lean (no strategy bias). Two files received prover work this
iter; audit them with extra care, and do a lighter pass on the rest.

## Files (absolute paths)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean  (PROVER-TOUCHED)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean (PROVER-TOUCHED)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/RegroupHelper.lean

## Focus areas
- New decl `AlgebraicGeometry.pullbackPushforward_unit_comp` (FlatBaseChange.lean ~1140): is the
  statement honest (not vacuous / not over-specialised), proof real, no hidden `sorry`?
- Closed decl `AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower`
  (FlatteningStratification.lean ~1160): real proof? In particular check the witness is `f := g·a`
  (the SINGLE product), NOT `f²` — a prior plan note worried `hf0 hf0` would give freeness at `f²`.
- Two `set_option synthInstance.maxHeartbeats 1000000` added in FlatteningStratification.lean: are
  they honest (genuine expensive instance search) or masking a looping/ill-posed elaboration?
- Sorry bodies that are scaffolding vs. excuse-comments / fake statements.
- Stale or cross-project comments (e.g. iter-NNN STATUS lines, dead imports).

Report a per-file checklist + a flagged-issues block with severities.
