The minimal stable wrapper is to package the canonical comparison family into a context and delegate:

```lean
theorem pic0FiniteStageAffineTripleTransition_fac_of_canonical
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (D : Pic0FiniteStageTransitionModelsData C F)
    (T : Pic0FiniteStageTripleTransitionFamilyData C D.L D.n D.m D.relation D.M D.mapM
      (Pic0FiniteStageGlueContext.canonicalComparisonFamily C D))
    (U V W : Pic0FiniteStageChartIndex C) :
    ... := by
  let G := Pic0FiniteStageGlueContext.ofCanonical C D T
  exact pic0FiniteStageAffineTripleTransition_fac_of_context C G
    (fun p => G.triple.comparison p) U V W
```

The conclusion is the existing context theorem’s conclusion with `D.models.*` replaced by `D.*`, and `D.triple.N`/`D.triple.thetaN` replaced by `T.N`/`T.thetaN`.

This removes explicit `hmapM` and `hcomparison` binders. `ofCanonical` is transparent and pins `Q` to the canonical family, so the proof is definitional. A kernel compile was unavailable because `GlueDataFace.olean` and `FinalBaseChange.olean` are missing.
