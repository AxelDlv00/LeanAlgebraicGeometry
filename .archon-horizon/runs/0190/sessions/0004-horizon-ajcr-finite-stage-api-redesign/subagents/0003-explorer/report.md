Read-only audit complete; no files changed.

Key result: a lightweight facade importing only `Pic0FiniteStageCanonicalGlueContext` is viable. The reliable conversion is:

```lean
rw [Pic0FiniteStageGlueContext.canonicalComparisonFamily_spec C D] at T
exact T
```

This probe passed in about 87 seconds. Avoid `simpa`, which timed out. It resolves the canonical-versus-concrete comparison-family mismatch without importing `GlueDataFace`.

`CanonicalGlueContext.olean` is current and importable. `FiniteStageApi.olean` is stale; recheck with:

```bash
horizon check --timeout 1800 --json AlgebraicJacobian.Descent.FiniteStageApi
```

The legacy `GlueDataFace`, `GlueDataAssembly`, and `GluingDiagramIso` artifacts are missing; `GluePackage.olean` is stale. The safest high-impact migration target is `Pic0FiniteGaloisJacobianData`, moving it onto `Pic0FiniteStageStableGluePackage` and stable orbit APIs. Horizon graph `lean_ok` labels are source-scan results and are not reliable build evidence here.
