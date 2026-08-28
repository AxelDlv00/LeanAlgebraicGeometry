The minimal declaration is the `presentation` wrapper sent above, calling `pic0FiniteStageAffineRingGluePresentation` with the two algebraicity instances and the existing two-semiring `hOpen` bridge.

Then route both APIs through it:

```lean
noncomputable def glueData (P : Pic0FiniteStageGluePackage C F) :
    Scheme.GlueData :=
  P.presentation.glueData

noncomputable def gluedMapData (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.GluedMapData P.glueData (Spec (.of P.N.1)) := by
  change AlgebraicJacobian.GluedMapData
    P.presentation.glueData (Spec (.of P.N.1))
  exact P.presentation.mapData
```

A literal Lean `opaque presentation` is incompatible with preserving current chart-index reduction: it hides `presentation.glueData.J`. Use a regular `noncomputable def`.

No files were edited. Full kernel probing was unavailable because the modified assembly module currently has no `.olean` and its LSP elaboration remains stuck; the dependent-record opacity failure was independently confirmed by a minimal Lean probe.
