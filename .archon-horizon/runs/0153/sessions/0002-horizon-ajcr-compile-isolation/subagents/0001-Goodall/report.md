Read-only probe complete; no files were changed.

The first missing artifact is `Pic0FiniteStageGluingDiagramIso.olean`. Historical fresh compilation reached all 9,380 jobs, then timed out after about 610s at 12.8M heartbeats in private theorem `overlapBaseChangeIso_hom_ι`, specifically its simp calculation at line 286. This blocks the stale Core/Bridge/Fst/Snd artifacts from yielding a faithful top `PreSnd` build.

Downstream evidence identifies `glueData_t_comp_f_eq_spec_rightRestriction` in `Pic0FiniteStageGluingOverlapIsoPreSndBridge.lean:36` as the next dependent bottleneck: prior top `PreSnd` ran 1,183.80s without producing an artifact, and composed projection experiments ran up to 69 minutes.

Recommended isolation order:

1. `overlapBaseChangeIso_hom_ι`
2. `gluingOverlapIso_pre_fst`
3. `gluingOverlapIso_fst`
4. `glueData_t_comp_f_eq_spec_rightRestriction`

The smallest durable remedy is to serialize explicit typed projection equalities into opaque helper declarations, using explicit pullback legs plus `Eq.trans`/`congrArg`, avoiding a monolithic `pullback.hom_ext` or `rw` through dependent `.J` transports.

Current measurements also show the cached `GluePackage.olean` imports in about 7.11s, while recompiling the live source fails before proof bodies after about 72s at roughly 7.13GB RSS due to the current `hOpen`/`mapM` field mismatch. The sibling AJC project has no matching chain declarations.
