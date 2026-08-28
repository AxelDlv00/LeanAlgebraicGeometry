Read-only diagnosis complete. Runs `0164`–`0189` are other projects/tasks; the relevant AJCR evidence is concentrated in run `0163`, with run `0190` only relaunching this task.

The concrete unstable API is the legacy glue boundary:

- [`Pic0FiniteStageGlueDataFace.lean:205`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataFace.lean:205) accepts an independently supplied `hthetaN`, while rebuilding the comparison family from `D.models.comparison` at lines 218–224. `Pic0FiniteStageGlueContext` stores arbitrary `D.Q` and `D.triple.comparison` is indexed by that `Q`, so the theorem can be disconnected from the context’s own certificate. This is a genuine dependent-index mismatch, not merely slow elaboration.
- [`Pic0FiniteStageGlueDataAssembly.lean:55`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataAssembly.lean:55) exposes a giant function with `e`, `hmapM`, `thetaN`, `hthetaN`, repeated dependent tensor carriers, and local `Algebra`/`IsScalarTower` instances at lines 98–107. It returns only raw `Scheme.GlueData`, losing the pinned presentation/map package.
- [`Pic0FiniteStageGluePackage.lean:152`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:152) repeats all stage data and coherence fields, then reconstructs ring/algebra instances through multiple `@[reducible]` global instances (lines 202–318) and another large dependent `glueData` constructor at line 324. This is the primary elaboration hotspot.
- The stable facade [`Pic0FiniteStageStableGluePackage.lean:42`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableGluePackage.lean:42) has the right shape: context plus one pinned `AffineRingGluePresentation`, with projection-based `glueData`, `mapData`, and `gluedMap`. However, it is additive only; legacy `GluePackage`, `GlueDataFace`, and `GluedOver` do not consume it.

Timeout evidence is consistent across attempts:

- `GluePackage` reached `[9369/9372]` and timed out after 1800 seconds.
- Standalone `GlueDataFace` reached `[9370/9370]` and timed out after 1800 seconds, with no diagnostics or fresh artifact.
- Presentation/Assembly retries timed out after 600–1200 seconds, or 900 seconds at the missing `GlueDataFace` prerequisite.
- The direct `canonicalTripleData`/`ofCanonicalModels` producer timed out after 300 seconds at the dependent finite-subextension producer.
- Several source drafts were preserved as rejected attempts because they had no `.olean`; current source has substantial unrelated dirty/untracked work, so no edits should be made without coordinating with the parent.

Bounded refactor target: make `Q` canonical in the context by threading the already bundled `D.triple`/comparison certificate through `GlueDataFace` and Assembly, then add one constructor returning `AffineRingGluePresentation` (or a package storing the presentation directly). Migrate only `GluePackage.glueData` and `GluedOver` to project from that package; leave compatibility theorem names as adapters. Remove the duplicated `letI`/priority instances from the migrated path.

Expected verification: serialized Horizon checks in order `Pic0FiniteStageGlueDataFace.lean`, `Pic0FiniteStageGlueDataAssembly.lean`, `Pic0FiniteStageGluePackage.lean`, then `Pic0FiniteStageGluedOver.lean`; require fresh `.olean` artifacts and no timeout before attempting downstream naturality.
