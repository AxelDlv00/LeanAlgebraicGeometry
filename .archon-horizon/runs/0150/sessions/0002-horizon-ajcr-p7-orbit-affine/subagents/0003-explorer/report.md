## Progress

- The finite-stage glue has no unconditional `GrpObj`. Given the exact representation already required by [Pic0FiniteStageOrbitAffine.lean:45](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:45), it can immediately acquire one:
  ```lean
  noncomputable def pic0FiniteStageGrpObj
      (P : Pic0FiniteStageGluePackage Ck F)
      [Algebra K P.N.1]
      (rep :
        (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver) :
      GrpObj P.gluedOver :=
    GrpObj.ofRepresentableBy P.gluedOver
      (pic0Functor ((baseChange K P.N.1).obj C) ⋙
        forget₂ CommGrpCat GrpCat) rep
  ```
  This is exactly the pattern in [PicRepDatum.lean:113](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepDatum.lean:113). Without `rep`, the package contains no multiplication, unit, inverse, or descended curve-level universal property.

- `LocallyOfFiniteType P.gluedMap` is not currently named, but appears immediately provable chartwise. The chart rings are iterated base changes of finitely presented `FiniteRelationAlgebra`s from [FinitePresentationAlgebraFiniteStage.lean:30](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/FinitePresentationAlgebraFiniteStage.lean:30) and [Pic0FiniteStageScalarExtendedAtlas.lean:46](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageScalarExtendedAtlas.lean:46). The existing chart equation is [Pic0FiniteStageChartBaseChange.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageChartBaseChange.lean:39). The expected proof is:
  ```lean
  theorem Pic0FiniteStageGluePackage.locallyOfFiniteType_gluedMap (P : ...) :
      LocallyOfFiniteType P.gluedMap := by
    refine IsZariskiLocalAtSource.of_openCover
      (P := @LocallyOfFiniteType) P.glueData.openCover fun U => ?_
    rw [glueData_ι_gluedMap Ck P U]
    infer_instance
  ```
  This follows the established proof at [JacobianDataCharts.lean:154](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean:154).

- No declaration gives `ConnectedSpace P.glueData.glued`, `IrreducibleSpace P.glueData.glued`, or `GeometricallyIrreducible P.gluedMap`. The exact separably closed representer likewise currently has group structure, local finite presentation, and quasi-compactness, but no connectedness or irreducibility theorem.

## Blockers

`GroupAffineOpen` cannot close the finite-Galois gate even if those geometric properties are added. Its final theorem [GroupAffineOpen.lean:162](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162) requires:
```lean
[GrpObj G] [IsAlgClosed K]
[LocallyOfFiniteType G.hom] [IrreducibleSpace G.left]
```
For `G := P.gluedOver`, the base is `P.N.1`, a finite stage, with no `IsAlgClosed P.N.1`. Geometric irreducibility would supply ordinary irreducibility via `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`, but it would not remove the algebraically-closed-field requirement. Connectedness alone is also insufficient.

The sibling project has the stronger, axiom-clean identity-component theorem [IdentityComponent.lean:1374](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/IdentityComponent.lean:1374):
```lean
IdentityComponent.isFiniteTypeGeometricallyIrreducible
  (G : Over (Spec (.of k))) [GrpObj G] [LocallyOfFiniteType G.hom] :
  LocallyOfFiniteType (IdentityComponent G).hom ∧
  QuasiCompact (IdentityComponent G).hom ∧
  GeometricallyIrreducible (IdentityComponent G).hom
```
and [IdentityComponent.lean:768](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/IdentityComponent.lean:768) supplies its group object. These do not apply until `P.gluedOver` is identified as an identity component. The sibling is a separate project with the same library name, so this requires a port rather than an import.

## Isomorphism Audit

Currently [Pic0FiniteStageGluingBaseChange.lean:37](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:37) identifies the base change of the finite-stage glue with a locally base-changed gluing, and line 52 identifies individual charts. There is still no landed global comparison with the exact atlas gluing.

Once that middle diagram iso exists, the exact atlas gluing maps isomorphically to the separably closed representer via Mathlib’s `OpenCover.fromGlued` at [Gluing.lean:350](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Gluing.lean:350). That target is not currently known projective or honestly quasi-projective.

The divisor source’s closed immersion into a Grassmannian pair at [Pic0AdmissibleDivisorQuasiProjective.lean:278](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AdmissibleDivisorQuasiProjective.lean:278) does not help: the Abel morphism from that source to Pic0 is surjective, not an isomorphism or immersion. The file explicitly records that projectivity is absent.

The newly landed [Pic0FiniteStageOrbitAffine.lean:45](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:45) therefore uses the correct currently available route:
```lean
hproj : P.gluedMap.IsProjective
```
but no producer of `hproj` exists. As of inspection, this new file is also not yet imported by `Pic0CriticalPath`.

No files were edited, and no build was run.
