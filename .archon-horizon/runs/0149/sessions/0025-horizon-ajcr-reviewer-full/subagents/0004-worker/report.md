Implemented and verified the bounded finite-stage unit.

Changed:

- `FinitePresentationAlgebraFiniteStage.lean`: added `exists_finSubext_finitePresentation_algebra_model_finite`.
- `Pic0FiniteStageAtlas.lean`: added the canonical chart-ring wrapper, its finite-presentation theorem, and `exists_finSubext_pic0FiniteStageAtlas_chartRing_models`.

Verification:

- Final LSP diagnostics: clean.
- `lake build AlgebraicJacobian.Picard.Pic0FiniteStageAtlas`: passed, 9336 jobs.
- All three new theorems use exactly `[propext, Classical.choice, Quot.sound]`.
- Source scans found no suspicious constructs.
- No commit made.
