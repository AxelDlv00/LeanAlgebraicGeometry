The group-scheme route is mathematically valid, but the exact arbitrary-field primitive is missing from Lean.

A conditional bridge already works:

```lean
letI : GrpObj P.gluedOver :=
  GrpObj.ofRepresentableBy P.gluedOver
    (pic0Functor ((baseChange K P.N.1).obj C) ⋙ forget₂ CommGrpCat GrpCat) rep

exact Scheme.orbitsInAffineOpen_of_finiteInAffine _
  (GroupScheme.finiteInAffine_of_isAlgClosed_of_irreducible P.gluedOver)
```

Relevant declarations:

- [`GroupScheme.finiteInAffine_of_isAlgClosed_of_irreducible`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162)
- Translation infrastructure `rightMulIso`, `leftMulIso`, and `point_comp_rightMul_eq_point_comp_leftMul` in [GroupAffineOpen.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:37)
- Mathlib’s underlying [`GrpObj.mulRight`](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Monoidal/Grp.lean:275)
- The identical representability-to-group-object pattern in [`PicRepDatum.grpObj`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepDatum.lean:108)
- [`Pic0FiniteStageGluePackage.instLocallyOfFiniteTypeGluedMap`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGeometry.lean:49)
- [`instQuasiCompactGluedMap`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGeometry.lean:76)
- [`Scheme.orbitsInAffineOpen_of_finiteInAffine`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteInAffine.lean:66)

The conditional theorem cannot currently be applied because it requires:

```lean
[IsAlgClosed P.N.1]
[IrreducibleSpace P.glueData.glued]
```

Neither is available. `P.N.1` is the finite Galois descent field, not an algebraically closed field. No irreducibility theorem for the glued carrier exists either, although that part could plausibly follow later from a verified base-change identification. Per I-2004, the quarantined gluing-diagram draft cannot supply it.

The precise useful missing primitive is therefore:

```lean
theorem GroupScheme.finiteInAffine_of_finiteType
    (G : Over (Spec (.of K))) [GrpObj G]
    [LocallyOfFiniteType G.hom] [QuasiCompact G.hom] :
    Scheme.FiniteInAffine G.left
```

This is the direct finite-in-affine consequence of the theorem that every algebraic group scheme over a field is quasi-projective. The mathematical result holds over arbitrary fields ([Stacks 39.8.7](https://stacks.math.columbia.edu/tag/0BF7)), but Mathlib has no corresponding group-scheme quasi-projectivity or descent theorem at this pin.

The existing translation proof only handles rational points over an algebraically closed field. Its translations are indexed by sections `𝟙_ (Over (Spec k)) ⟶ G`, so they cannot directly translate arbitrary closed or nonclosed points over `P.N.1`.

Once the missing theorem exists, the exact orbit proof needs no projective-space immersion and no compatibility proof between the Galois action and multiplication: `FiniteInAffine` applies to every finite action through `orbitsInAffineOpen_of_finiteInAffine`.

No files were edited or builds run.
