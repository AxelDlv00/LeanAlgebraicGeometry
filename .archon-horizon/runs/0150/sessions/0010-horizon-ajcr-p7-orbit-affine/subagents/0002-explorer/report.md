No existing indirect chain fires at `P.gluedMap`/`P.gluedOver`.

- Live AJCR now has `pic0FiniteStageFiniteInAffine_of_isAlgClosed_of_connected` in [Pic0FiniteStageOrbitAffine.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:87):
  ```lean
  [IsAlgClosed P.N.1] [ConnectedSpace P.glueData.glued] →
  RepresentableBy ... P.gluedOver →
  Scheme.FiniteInAffine P.glueData.glued
  ```
  It specializes `GroupScheme.finiteInAffine_of_isAlgClosed_of_connected` from [GroupAffineOpen.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:310). This weakens `IrreducibleSpace` to `ConnectedSpace`, but still consumes both connectedness and `IsAlgClosed`.

- The exact available carrier inputs remain:
  `pic0FiniteStageGrpObjOfRepresentableBy` at OrbitAffine line 43; `locallyOfFiniteType_gluedMap` and `quasiCompact_gluedMap` at [Pic0FiniteStageGeometry.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGeometry.lean:39) and line 58. No exact-carrier occurrence produces an immersion, projectivity, H-quasi-projectivity, or connectedness.

- AJC provides only downstream adapters:
  `IsProjective.isHQuasiProjective` at `Picard/ProjectiveMorphismBasic.lean:53`;
  `finiteInAffine_of_isProjective` and `finiteInAffine_of_isHQuasiProjective` at `Picard/QuasiProjectiveFiniteInAffine.lean:471,484`.
  Its actual H-quasi-projective producers cover projective spaces and Grassmannians. `Scheme.Grassmannian.d4Locus_isHQuasiProjective_over` at `Projective/DemandLedger.lean:189` still requires an explicit immersion. No signature accepts `GrpObj + RepresentableBy + LocallyOfFiniteType + QuasiCompact`.

- AJC’s apparently relevant identity-component facts do not transfer:
  `IdentityComponent.isFiniteTypeGeometricallyIrreducible` at `Picard/IdentityComponent.lean:1374` concludes properties of `IdentityComponent G`, while no declaration identifies `P.gluedOver` with that object. Its `ConnectedSpace (IdentityComponent G).left` instance at line 399 is `private`.

- AJCR’s indirect `JacobianData` route also stops. `JacobianData.ofRepresentableBy` at `Picard/JacobianDataCharts.lean:71` packages exactly representation, LFT, and QC, but `geometricallyIrreducible_of_abelSource` at `AbelianVariety/AbelSource.lean:139` additionally requires `AbelSourceData d`; no producer of that structure exists.

- The base-change interface supplies only `baseChangeGluingIso` and chartwise `gluingChartIso` in `Pic0FiniteStageGluingBaseChange.lean:37,52`. There is no global iso to a carrier with known connectedness. The separably closed representer itself has public LFT/QC results but no `ConnectedSpace` or `IrreducibleSpace` result.

Therefore `ConnectedSpace P.glueData.glued` is not derivable from current public declarations. Generic group structure cannot supply it: disconnected finite constant group schemes are counterexamples.

The strongest next theorem remains:
```lean
theorem GroupScheme.finiteInAffine_of_finiteType
    {K : Type u} [Field K] (G : Over (Spec (.of K)))
    [GrpObj G] [LocallyOfFiniteType G.hom] [QuasiCompact G.hom] :
    Scheme.FiniteInAffine G.left
```
All three carrier inputs already fire for `P.gluedOver`; this removes both `IsAlgClosed` and connectedness/irreducibility. No files or ledger state were changed.
