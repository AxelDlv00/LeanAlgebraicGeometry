Audit complete; no files edited.

Key findings:

- An arbitrary [`Pic0FiniteStageGlueContext`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueContext.lean:42) cannot support the desired face theorem. Its `Q` is arbitrary and carries no face compatibility law. `D.triple.comparison` only certifies descent relative to that arbitrary `Q`.
- The canonical wrapper now present at [`Pic0FiniteStageCanonicalGlueContext`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageCanonicalGlueContext.lean:116) fixes this with `q_spec`.
- Its normalized certificate [`comparison`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageCanonicalGlueContext.lean:180) and explicit legacy-shaped [`comparison_of_models`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageCanonicalGlueContext.lean:200) are the correct bounded API boundary.
- Exact current-source verification passed:

```bash
timeout 300s lake env lean /dev/stdin \
  < AlgebraicJacobian/Picard/Pic0FiniteStageCanonicalGlueContext.lean
```

Exit 0 in approximately 157 seconds. This imported neither `GlueDataFace` nor `GlueDataAssembly`.

The targeted proof strategy is important:

```lean
rw [← Pic0FiniteStageGlueContext.canonicalComparisonFamily_spec C D.context.models,
    ← D.q_spec]
exact D.context.triple.comparison p
```

A broad `simpa` version timed out at 180 seconds. A direct structure containing `models` and a dependent canonical `triple` field also timed out; wrapping the existing context plus `q_spec` is materially cheaper.

One blocker remains in [`pic0FiniteStageAffineTripleTransition_fac_of_context`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataFace.lean:205): its `hthetaN` binder closes after the map type at line 212, leaving a top-level arrow before the equation. A minimal Lean grammar probe rejects that shape. The intended canonical adapter should instead take `D : Pic0FiniteStageCanonicalGlueContext C F` and pass:

```lean
D.context.triple.thetaN
D.comparison_of_models C
```

to the raw face theorem.

The remaining unstable legacy surface is concentrated in:

- [`Pic0FiniteStageTripleBaseChangeRing`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueData.lean:81): public carrier constructed through six local instances.
- [`pic0FiniteStageAffineRingGlueData`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataAssembly.lean:55): giant raw assembly boundary.
- [`Pic0FiniteStageGluePackage`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:152): repeated dependent witnesses and global reducible instance shims.
- The stable replacement is already correctly shaped at [`Pic0FiniteStageStableGluePackage`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableGluePackage.lean:42).

Recommended bounded cut: rebuild the canonical-context artifact, expose it through the existing [`FiniteStageApi`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteStageApi.lean:12), and defer the legacy affine face adapter until its malformed signature is repaired.
