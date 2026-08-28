Inspected the finite-stage API; no source edits were made.

Concrete instability: [`Pic0FiniteStageGlueDataFace.lean:205`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataFace.lean:205) names a theorem “of context” but still requires an explicit `hthetaN`, while the context already stores `D.triple.thetaN` and its comparison certificate. Its conclusion reconstructs transport using `D.models.comparison`, ignoring arbitrary `D.Q` ([`GlueContext.lean:42`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueContext.lean:42), [`TripleTransitionModels.lean:294`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageTripleTransitionModels.lean:294)).

Recommended safe refactor: rename it to indicate the canonical-comparison requirement, then add a genuinely context-native wrapper only for `ofCanonical` contexts. Generalizing to arbitrary `D.Q` would require changing the lower-level transition theorem too.

`FiniteStageApi.lean` checked without diagnostics. The face-file check was blocked because its imported `Pic0FiniteStageGlueData.olean` is not built yet.
