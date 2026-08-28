Audit complete; no source files were edited or committed.

The stable package API is:

- `Pic0FiniteStageStableGluePackage C F`:
  `context : Pic0FiniteStageGlueContext C F`
  and
  `presentation : AffineRingGluePresentation P.context.triple.N.1`.
- Constructors:
  `Pic0FiniteStageStableGluePackage.ofContext C D pres`
  and `Pic0FiniteStageGlueContext.ofPresentation C D pres`.
- Stable projections include `glueData`, `mapData`, `gluedMap`, `asOver`, and `chartMap_factor`.
- `StableGluedOver` adds `GluedOverData`, `gluedOverData`, `gluedOver`, and `gluedOver_hom`.

The mismatch is that [Pic0FiniteStageStableAffineCover.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableAffineCover.lean:36) and all eight wrappers still accept `Pic0FiniteStageGluePackage`, while [Pic0FiniteStageOrbitAffine.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:43) also requires the legacy package. There is no legacy/stable adapter, and the types are not definitionally compatible.

Smallest migration: add stable variants of the four orbit producers (`isImmersion`, `isProjective`, algebraically closed irreducible, algebraically closed connected), using `P.presentation.glueData.glued`, `P.gluedOver`, and `P.gluedMap`; then switch the eight StableAffineCover wrappers to those variants. Reconstructing or casting a legacy package would defeat the pinned presentation boundary.

Verification succeeded with:

```text
lake build AlgebraicJacobian.Picard.Pic0FiniteStageFinalBaseChange
lake env lean /dev/stdin
```

The initial failure was only a missing stale `.lake` OLean, not a source diagnostic. Findings were sent to task `ajcr-finite-stage-api-redesign` as inbox item `I-2113`.
