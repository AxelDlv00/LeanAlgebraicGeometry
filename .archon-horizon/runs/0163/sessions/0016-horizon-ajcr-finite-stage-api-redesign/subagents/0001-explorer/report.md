Audit complete; no source edits made.

The highest-value unstable boundary is the missing legacy-to-stable presentation bridge:

- Legacy assembly: [Pic0FiniteStageGluePackage.lean:324](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:324) exposes only `Scheme.GlueData` and re-elaborates the dependent construction.
- Stable API: [Pic0FiniteStageStableGluePackage.lean:42](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableGluePackage.lean:42) requires an explicit `AffineRingGluePresentation`.
- Current producer: [Pic0FiniteStageStableGlueProducer.lean:41](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableGlueProducer.lean:41) only accepts an already-selected presentation.

Suggested patch: add `Pic0FiniteStageGlueContext.toPresentation` or `Pic0FiniteStageStableGluePackage.ofContextCanonical`, invoking `affineRingGluePresentation` with the context’s model/triple certificates; add `exists_pic0FiniteStageStableGluePackage`; then migrate [Pic0FiniteStageStableAffineCover.lean:36](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableAffineCover.lean:36), which still uses the legacy package. Preserve legacy projections for compatibility.

Main risk is elaboration: the assembly is guarded by a 25.6M heartbeat limit and nested tensor instances may time out. The lower-level `GlueData` and `GlueDataFace` declarations are already stable and are not the migration bottleneck.
