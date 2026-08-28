Ranked audit, no files edited:

1. **Context face facade is semantically disconnected from stored `Q`.**  
   [Pic0FiniteStageGlueDataFace.lean:205](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataFace.lean:205) accepts an extra `hthetaN` and reconstructs the canonical comparison family from `D.models.comparison` at lines 218–220. But [Pic0FiniteStageGlueContext.lean:42](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueContext.lean:42) stores arbitrary `D.Q`, and `D.triple.comparison` is certified against that `Q`. The facade therefore cannot consume the context’s own certificate without an additional equality.

   Recommended repair: thread `D.Q` through the face theorem and use `D.triple.comparison` directly, eliminating the extra `hthetaN`; alternatively make `Q` canonical in the context.

2. **`AffineRingGluePackage` still exposes proof-sensitive carriers.**  
   [AffineRingGlueData.lean:258](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/AffineRingGlueData.lean:258) types `mapData` using `affineRingGlueData ... fId fOpen tauId thetaFac thetaCocycle`; [AffineRingGlueData.lean:391](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/AffineRingGlueData.lean:391) repeats all proof arguments in `toPresentation`. Propositionally equal coherence proofs thus produce non-definitional `GlueData` types, undermining the pinned API.

   Recommended repair: add a constructor over an already-pinned `D : Scheme.GlueData` and `M : GluedMapData D ...`, or store `glueData` directly in the package.

Focused Lean checks produced no diagnostics but exceeded 35 seconds and were terminated to avoid the known dependent timeout.
