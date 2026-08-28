## Audit Result

The smallest credible next declaration is a purely categorical specialization of the existing flattening iso. It avoids all dependent tensor-ring instance reconstruction that caused the quarantined attempts to stall.

Suggested declaration in [Pic0FiniteStageOverlapBaseChange.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOverlapBaseChange.lean:30):

```lean
noncomputable def gluingOverlapFlatteningIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).V (U, V) ≅
    pullback
      (P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap)
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) := by
  let g : Spec (.of k) ⟶ Spec (.of P.N.1) :=
    Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))
  exact nestedPullbackFlatteningIso
    (P.glueData.ι U) (P.glueData.ι V) P.gluedMap g
    (P.glueData.f U V)
    (P.glueData.t U V ≫ P.glueData.f V U)
    (by
      simpa only [Category.assoc] using
        (P.glueData.glue_condition U V).symm)
    (P.glueData.vPullbackConeIsLimit U V)
```

Dependencies are already rooted:

- Generic flattening and its three projection laws: [Pic0FiniteStageOverlapBaseChange.lean:30](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOverlapBaseChange.lean:30).
- Actual finite-stage `GlueData`: [Pic0FiniteStageGlueDataAssembly.lean:55](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataAssembly.lean:55).
- Package and computed datum: [Pic0FiniteStageGluePackage.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:39), [line 98](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:98).
- `gluedMap`/`gluedOver`: [Pic0FiniteStageGluedOver.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:39), [line 85](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:85).

This declaration mentions no chart/overlap ring aliases, so it should avoid the exact `Semiring`/`CommRing` synthesis failures seen in prior attempts.

## Following Edge

The next small algebraic declaration should isolate the right-leg ring square:

```lean
(overlapFinalBaseChangeEquiv C P U V).toAlgHom.comp
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := P.N.1) (K := k)
      (rightRestrictionBaseChangeAlgHom C P U V)) =
  (pic0FiniteStageRestrictionRight C U V).comp
    (chartFinalBaseChangeEquiv C P V).toAlgHom
```

Proof skeleton:

```lean
rw [rightRestrictionBaseChangeAlgHom_eq_direct C P U V]
exact pic0FiniteStageFinalBaseChangeEquiv_naturality
  C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
    (Sum.inl (Sum.inr (U, V)))
```

The ingredients are at [Pic0FiniteStageRightRestrictionAlgHom.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRightRestrictionAlgHom.lean:39) and [Pic0FiniteStageRightLegEquality.lean:119](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRightLegEquality.lean:119). Once named, it feeds `affineBaseChangeIso_trans_naturality` exactly as the existing left square does at [Pic0FiniteStageRestrictionNaturality.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionNaturality.lean:39).

## Global Target

The eventual scheme comparison is:

```lean
pullback P.gluedMap
    (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
  (pic0_sepClosed_representableBy (C := C)).1.left
```

and the honest slice-level endpoint is:

```lean
(Over.pullback
  (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).obj P.gluedOver ≅
  (pic0_sepClosed_representableBy (C := C)).1
```

Assembly should be:

1. `baseChangeGluingIso` from [Pic0FiniteStageGluingBaseChange.lean:37](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:37).
2. A natural iso of multispan diagrams, with chart components `gluingChartIso` and overlap components built from the flattening iso plus `overlapBaseChangeIso`.
3. `HasColimit.isoOfNatIso`.
4. `asIso (pic0SepClosedAtlasOpenCover C).fromGlued`.

The two diagram naturality obligations are precisely the rooted left restriction square and the missing right restriction square.

## Handoff Evidence

`Pic0CriticalPath` imports the current boundary at [lines 78-84](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:78) and records the missing specialization/right-leg/global assembly at [line 287](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:287).

Relevant commits:

- `4b0a56c689`: generic flattening.
- `109980ff4c`: its three projection laws.
- `9002d90676`: exact/finite/scalar-extended right-leg equality.
- `e9480e1322`: named right-restriction composite.
- `b983187a58`: removed the unverified `Pic0FiniteStageGluingDiagramIso.lean`.

The latest quarantined comparison is at [attempt 0001](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/runs/0149/sessions/0040-horizon-ajcr-reviewer-full/attempts/0001-fully-inferred-scalar-extension-map-removes-ever/files/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:51). It was LSP-clean but ran for over 12 minutes and roughly 7 GiB without producing an artifact. The right-square draft similarly exceeded 13 minutes.

There is no source-path overlap with live task `ajcr-p7-orbit-affine`; it owns `GroupAffineOpen`, `FiniteInAffine`, `Pic0FiniteStageOrbitAffine`, and `Pic0FiniteStageStableAffineCover`. The overlap is downstream only: both lanes eventually feed finite-Galois representability. No source files were edited and no build was run.
