## Result

- Exact build: `lake build AlgebraicJacobian.Picard.Pic0FiniteStageGluingOverlapIsoPreSnd`
- Bounded stop after `1183.80s` (19m43.8s), exit `130`; no Lean error was emitted.
- The build produced `Pic0FiniteStageGlueDataAssembly.olean` (1,192,432 bytes).
- `Pic0FiniteStageGluePackage.olean`, `Pic0FiniteStageGluingOverlapIsoPreSnd.olean`, `Pic0FiniteStageGluingOverlapIsoSnd.olean`, and `Pic0FiniteStageGluedComparison.olean` remain absent.

`IsoSnd` directly imports `PreSnd`, and `GluedComparison` imports `IsoSnd`, so neither downstream module is ready yet. The next compile frontier is GluePackage, then refreshed PreSnd dependencies and PreSnd itself. No files were edited or committed.
