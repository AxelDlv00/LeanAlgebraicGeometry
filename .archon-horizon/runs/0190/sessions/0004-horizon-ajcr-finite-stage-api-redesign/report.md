## Progress

- Diagnosed the finite-stage loop as provenance erasure and proof-sensitive reconstruction across `GlueDataFace`, `GlueDataAssembly`, and the legacy `GluePackage`.
- Committed `43d20ef90e`: `AffineRingGluePresentation.ofMapData` now lets dependent map data infer its exact glue datum, and `toPresentation`/`pin` no longer rebuild that datum.
- Committed `df4ff46299`: added `Pic0FiniteStageCanonicalGlueContext`, retaining canonical comparison provenance with `q_spec` and exposing normalized `comparison` and legacy-shaped `comparison_of_models` certificates.
- Committed `42b2565308`: migrated `Pic0FiniteStageStableGluePackage` to the canonical context and reduced `Pic0FiniteStageStableGlueProducer` to an import-compatible facade.
- Committed `36021657aa`: removed the ambiguous package-level stored-`Q` comparison accessor after ground review; consumers use the canonical certificate at `P.context.comparison C p`.

## Verification

- Exact foreground kernel checks passed for `AffineRingGlueData.lean` and the current `Pic0FiniteStageCanonicalGlueContext.lean` source.
- `horizon check` passed for `Pic0FiniteStageStableGluedOver.lean` in 29.53 seconds.
- `horizon check AlgebraicJacobian.Descent.FiniteStageApi` passed all 9370 jobs in 114.745 seconds, covering the canonical context, stable package, producer facade, glued-over facade, and restriction facade.
- After the final unused-accessor deletion, three bounded facade reruns timed out under shared-host contention without Lean diagnostics. The deleted symbol has no in-tree references, and the fully verified pre-deletion facade differs only by that deletion.

## Issues

- `Pic0FiniteStageGlueDataFace.lean` still contains the malformed general-context adapter. It accepts an unrelated fresh `hthetaN`, reconstructs the canonical comparison from `D.models`, and cannot justify that comparison from an arbitrary `D.Q`.
- `GlueDataFace` and `GlueDataAssembly` artifacts remain absent, while the legacy `GluePackage` artifact is stale. Their raw constructors and repeated instance reconstruction remain the expensive boundary.
- `Pic0FiniteStageFinalBaseChange.lean` still has the open final base-change naturality proof.
- The ignored `hgraph/` tree predates this session and is stale. It should be synchronized only after the parallel runs quiesce.
- The final ledger scan still shows unrelated concurrent or pre-existing changes in `.archon-horizon/blueprints/Mumford.json`, `FormalizedSources/StacksProject/**`, `README.md`, `references/**`, and other live-run state; none were staged for this task.

## Why I stopped

The canonical provenance boundary and stable package cut are verified and committed, but the legacy face/assembly chain has not yet been migrated and the mathematical naturality producer remains open. The task therefore remains `running`.

## Next

Replace `pic0FiniteStageAffineTripleTransition_fac_of_context` with a canonical-context adapter using `D.context.triple.thetaN` and `D.comparison_of_models C`. Then migrate `GlueDataAssembly`, the legacy package consumers, and the Galois finite-stage consumer to project from `Pic0FiniteStageStableGluePackage` before resuming the final naturality proof.
