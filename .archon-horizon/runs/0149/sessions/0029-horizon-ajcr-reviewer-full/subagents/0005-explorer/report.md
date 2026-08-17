The shortest construction is a new `Pic0FiniteStageGlueData.lean` importing:

```lean
import AlgebraicJacobian.Descent.AffineRingGlueData
import AlgebraicJacobian.Picard.Pic0FiniteStageScalarExtendedAtlas
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionFaceReflection
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionEquations
```

`thetaN` must be conjugated. It acts on
`N.1 ⊗[M.1] Pic0FiniteStageTripleModelRing`, while `affineRingGlueData` requires the literal N-stage pushout `B U V ⊗[A U] B U W`.

Define these instance-stable abbreviations:

```lean
rM U V := pic0FiniteStageRestrictionLeftModel ... U V
rN U V := pic0FiniteStageRestrictionBaseChange ... N U V
tauN U V := pic0FiniteStageTransitionBaseChange ... N U V

TN U V W :=
  Pic0FiniteStageTensorPushoutRing (rN U V) (rN U W)

beta U V W :
    N.1 ⊗[M.1] Pic0FiniteStageTripleModelRing ... U V W ≃ₐ[N.1]
      TN U V W :=
  finiteStageTensorPushoutScalarExtension_named
    (K := N.1) (rM U V) (rM U W)

theta U V W : TN V W U →ₐ[N.1] TN U V W :=
  (beta U V W).toAlgHom.comp
    ((thetaN (U, (V, W))).comp (beta V W U).symm.toAlgHom)
```

Then prove:

```lean
theta_fac :
  (theta U V W).comp
      (finiteStageTensorPushoutFaceRight (rN V W) (rN V U)) =
    (finiteStageTensorPushoutFaceLeft (rN U V) (rN U W)).comp (tauN U V)

theta_cocycle :
  (theta U V W).comp
      ((theta V W U).comp (theta W U V)) =
    AlgHom.id N.1 (TN U V W)
```

For `theta_fac`, bind the existing inferred package:

```lean
let P := pic0FiniteStageTripleTransitionFacePackage
  C L n m relation e M mapM hmapM N U V W thetaN hthetaN
have hP := pic0FiniteStageTripleTransitionModel_fac
  C L n m relation e M mapM hmapM N U V W thetaN hthetaN
```

Use `P`’s projections throughout the pointwise proof. Rewrite the source and target faces with:

- `finiteStageTensorPushoutScalarExtension_faceRight_map`
- `finiteStageTensorPushoutScalarExtension_faceLeft_map`

Then use `P.face`. A pointwise proof avoids reconstructing the dependent tensor-product instances.

For `theta_cocycle`, specialize [Pic0FiniteStageTripleTransitionEquations.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageTripleTransitionEquations.lean:97) with:

```lean
Q := pic0FiniteStageTripleModelComparisonFamily
  C L n m relation e M mapM hmapM
```

Convert `hthetaN` using:

```lean
simpa only [pic0FiniteStageTransportedTripleTransitionOfModels]
  using hthetaN p
```

The conjugated cocycle is then a pointwise cancellation of adjacent `beta.symm_apply_apply`, followed by the N-stage cocycle and `beta.apply_symm_apply`.

Finally define the actual glue datum. Install exactly the map-selected instances so `TN` is definitionally `AffineTripleTensor`:

```lean
let A U := Pic0FiniteStageChartBaseChangeRing ... N U
let B U V := Pic0FiniteStageOverlapBaseChangeRing ... N U V
let r U V := rN U V

letI (U V) : Algebra (A U) (B U V) :=
  pic0FiniteStageAlgebraOfMap (r U V)
letI (U V) : IsScalarTower N.1 (A U) (B U V) :=
  pic0FiniteStageTowerOfMap (r U V)
```

Apply [affineRingGlueData](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/AffineRingGlueData.lean:183) with:

- `fId`: `isIso_pic0FiniteStageRestrictionBaseChange_diagonal`
- `fOpen`: `isOpenImmersion_pic0FiniteStageRestrictionBaseChange`
- `tauId`: `pic0FiniteStageTransitionBaseChange_self`
- `thetaFac`: the conjugated face theorem
- `thetaCocycle`: the conjugated cocycle theorem

The inverse-transition component returned by `exists_finSubext_pic0FiniteStageTransition_models` is not needed for this constructor.

For assembling witnesses, invoke `exists_finSubext_pic0FiniteStageTripleTransition_models_of_comparisons` only with the canonical comparison family above; the new face-reflection theorem is specialized to that family. Preserve `L/M/N`, maps, comparisons, and the resulting `GlueData` in a dependent package for the subsequent base-change theorem rather than returning a bare existential `Scheme.GlueData`.

No files were edited or builds run in this read-only lane.
