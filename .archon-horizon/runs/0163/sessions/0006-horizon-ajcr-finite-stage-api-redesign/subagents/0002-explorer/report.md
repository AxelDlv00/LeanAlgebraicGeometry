Read-only diagnosis complete; no source files were edited.

The best bounded redesign is to consume the already-existing `AffineRingGluePresentation` wrapper at the `GluePackage` boundary:

```lean
noncomputable def presentation
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.AffineRingGluePresentation P.N.1
```

Its body should call `pic0FiniteStageAffineRingGluePresentation` from [Pic0FiniteStageGlueDataAssembly.lean:55](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataAssembly.lean:55), using the existing `P` fields and the two-semiring `hOpen` bridge currently in [Pic0FiniteStageGluePackage.lean:318](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:318).

Then replace the two independent reconstructions with:

```lean
noncomputable def glueData ... (P : Pic0FiniteStageGluePackage C F) :
    Scheme.GlueData :=
  P.presentation.glueData

noncomputable def gluedMapData ... (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.GluedMapData P.glueData (Spec (.of P.N.1)) := by
  change AlgebraicJacobian.GluedMapData
    P.presentation.glueData (Spec (.of P.N.1))
  exact P.presentation.mapData
```

This directly targets the timeout: `glueData` currently constructs the affine presentation in [GluePackage.lean:318-339], while `gluedMapData` reconstructs all chart/overlap algebras and the map package again in [GluedOver.lean:40-123]. The generic wrapper already exists in [AffineRingGlueData.lean:364-375](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/AffineRingGlueData.lean:364), so the change is localized to `GluePackage` and `GluedOver`. Keep `presentation` transparent (`noncomputable def`, not `opaque`), because downstream `change` proofs rely on the concrete chart index reducing.

A second, slightly deeper cleanup is available but should follow that boundary: `Pic0FiniteStageGluePackage` duplicates the existing `Pic0FiniteStageTripleTransitionFamilyData` from [Pic0FiniteStageTripleTransitionModels.lean:294-315]. Its raw fields `N`, `thetaN`, and `hthetaN` at [GluePackage.lean:181-187] can be replaced by one dependent `triple` field:

```lean
triple :
  Pic0FiniteStageTripleTransitionFamilyData C L n m relation M mapM
    (pic0FiniteStageTripleModelComparisonFamily C L n m relation e M mapM hmapM)
```

Expose transparent `N`/`thetaN` projection aliases and an `hthetaN` adapter using `triple.comparison`. The existing `of_comparisons` constructor at [TripleTransitionModels.lean:348-367] already supplies exactly this package. This removes the repeated `choose thetaN hthetaN` block in [GluePackage.lean:357-375] and gives `GlueDataFace` a single stable certificate object.

The tensor refactors are already in the right shape: `FiniteStageTensorEqualityFamilyData` now pins `map` and `map_spec` ([TensorFiniteSubextension.lean:325-378]), but its bundled APIs currently have no downstream consumers beyond checks. The main remaining instability is therefore the duplicated gluing presentation/map construction, not the tensor equality structures.

Verification should be ordered: `GlueDataAssembly`, `GluePackage`, `GluedOver`, then `ChartBaseChange`. Current Horizon evidence confirms GlueData builds freshly, while GluePackage/DataFace still time out at the dependent gluing boundary; no fresh artifacts currently certify those top modules.
