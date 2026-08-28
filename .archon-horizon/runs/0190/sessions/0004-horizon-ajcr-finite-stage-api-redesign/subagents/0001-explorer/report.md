Recommended bounded refactor: add `Pic0FiniteStageCanonicalGlueData` and `comparison_of_models` to [Pic0FiniteStageCanonicalGlueContext.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageCanonicalGlueContext.lean:44).

This retains canonicality structurally, which `ofCanonical` currently erases when returning the general context. That directly repairs the mismatch in [Pic0FiniteStageGlueDataFace.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataFace.lean:205), where `_fac_of_context` accepts a fresh certificate unrelated to `D.Q`.

The exact prototype is `/tmp/ajcr_canonical_probe.lean`. It imports the current canonical-context `.olean` and passed:

```text
timeout 180s lake env lean /tmp/ajcr_canonical_probe.lean
exit 0, no diagnostics
```

The key bridge proof is only:

```lean
have h := D.triple.comparison p
rw [Pic0FiniteStageGlueContext.canonicalComparisonFamily_spec C D.models] at h
simpa only [pic0FiniteStageTransportedTripleTransitionOfModels] using h
```

This avoids compiling `GlueDataFace` or `GlueDataAssembly`, whose prior checks repeatedly timed out at 900–1800 seconds. No project or blueprint files were edited.
