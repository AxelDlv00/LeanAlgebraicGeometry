Implemented and committed a canonical-context adapter theorem for the legacy finite-stage face equation:

- File: `AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataFace.lean`
- Commit: `fb2e564c86`
- Adapter derives the dependent comparison certificate via `Pic0FiniteStageCanonicalGlueContext.comparison_of_models`.

LSP reported no errors before timing out. The Horizon kernel check was attempted but stalled on shared, concurrent compilation of the heavy dependency; this was reported to `/root`.
