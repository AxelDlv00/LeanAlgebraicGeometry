Verdict: the shared-presentation design is correct, but `P.presentation` must be a transparent `noncomputable def`, not Lean `opaque`. `AffineRingGluePresentation` hides the concrete chart index inside `glueData`; if opaque, terms such as `P.glueData.f U V` cannot establish that `U : Pic0FiniteStageChartIndex C` has type `P.presentation.glueData.J`. A propositional equality lemma cannot repair that pre-elaboration mismatch.

One blocking issue already exists in [Pic0FiniteStageGluedOver.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:167): `GluedOverData.chartMap` asserts the canonical chart map for arbitrary `Q : GluedOverData C P`, although the record only stores an unconstrained `GluedMapData`. Its `rfl` proof at line 176 is not valid generically. Restrict this theorem to `P.gluedOverData`/`P.gluedMapData`, or add the chart-map equation as a record field.

No source explicitly runs `unfold glueData`, `simp [glueData]`, or corresponding commands for `gluedMapData`. The reduction-sensitive API is:

- `Pic0FiniteStageRestrictionBaseChange.lean:60-67`: `glueData_f`, proved by `rfl`.
- `Pic0FiniteStageGluingOverlapIsoPreSndCore.lean:37-45`: `glueData_t`, proved by `rfl`.
- `Pic0FiniteStageGluedOver.lean:202-211`: `gluedMapData_chartMap`, proved by `rfl`.
- `Pic0FiniteStageGluedOver.lean:167-176`: the invalid generic chart-map theorem above.
- `Pic0FiniteStageChartBaseChange.lean:40-50`: `glueData_ι_gluedMap` expands `gluedMap` and uses the chart-map theorem.
- `Pic0FiniteStageGeometry.lean:61-70`: deep `change` steps require `openCover.I₀` and `openCover.X U` to reduce to the concrete chart index and affine spectrum.
- `Pic0FiniteStageOrbitAffine.lean:68,99`: `change` relies on `P.gluedOver.left` reducing to `P.glueData.glued`.

All semantic `P.glueData` consumers in the current source, grouped by file and line:

```text
Pic0FiniteStageChartBaseChange.lean:44
Pic0FiniteStageGeometry.lean:42,44,61,64,71,72,74
Pic0FiniteStageGluedComparison.lean:36,242
Pic0FiniteStageGluedOver.lean:43,134,143,149,183,198
Pic0FiniteStageGluingBaseChange.lean:42,45,56
Pic0FiniteStageGluingDiagramIso.lean:114,129,264,281,303,311,337,478
Pic0FiniteStageGluingOverlapIsoPreSnd.lean:41,43
Pic0FiniteStageGluingOverlapIsoPreSndBridge.lean:40
Pic0FiniteStageGluingOverlapIsoPreSndCore.lean:41
Pic0FiniteStageGluingOverlapIsoPreSndFst.lean:41,43,71,103,114,116,135
Pic0FiniteStageGluingOverlapIsoPreSndSndCommon.lean:34,37,39
Pic0FiniteStageGluingOverlapIsoPreSndSndSource.lean:34,36,54,58,60,62,66,68
Pic0FiniteStageGluingOverlapIsoPreSndSndTarget.lean:70,89
Pic0FiniteStageGluingOverlapIsoPreSndTFstFst.lean:39,41,44,48,50,51,53
Pic0FiniteStageGluingOverlapIsoPreSndTFstSnd.lean:39,41,44,46,49,52
Pic0FiniteStageGluingOverlapIsoSnd.lean:42,44
Pic0FiniteStageOrbitAffine.lean:59,61,68,79,90,92,99,110,121,123,136
Pic0FiniteStageOverlapBaseChange.lean:143,146,151-157,171-187,201-218,232-247
Pic0FiniteStageRestrictionBaseChange.lean:64
Pic0FiniteStageStableAffineCover.lean:44,57,71,96,110,124
integration_probe.lean:24
```

Direct `gluedMapData` consumers are only `Pic0FiniteStageGluedOver.lean:192,206` and `Pic0FiniteStageChartBaseChange.lean:50`, besides its definition at line 40. `Pic0CriticalPath.lean:807,1060` only checks/prints `glueData`.

Recommended compatibility surface:

- Keep the pending legacy `pic0FiniteStageAffineRingGlueData := (...Presentation...).glueData` projection.
- Add package-level `[simp]`/`rfl` projection lemmas relating `P.presentation.glueData` to `P.glueData` and `P.presentation.mapData` to `P.gluedMapData`.
- Preserve and reverify `glueData_f`, `glueData_t`, `gluedMapData_chartMap`, and `glueData_ι_gluedMap`; these shield nearly all downstream proofs from the constructor body.
- Keep the current `GluedOverData` wrapper only for compatibility, or replace its invalid generic `chartMap` theorem with a canonical `gluedOverData_chartMap`.

Minimum meaningful verification order is Assembly, GluePackage, GluedOver, RestrictionBaseChange, GluingOverlapIsoPreSndCore, Geometry, GluingDiagramIso, then StableAffineCover or CriticalPath. Graph edges for `glueData`, `gluedMapData`, `glueData_f`, and `glueData_t` are currently empty, so hgraph does not capture this definitional dependency surface.

No files were edited.
