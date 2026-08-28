## Verdict

Neither remaining gate is a bounded honest producer with the current APIs.

- Gate A needs a new global finite-presentation object-spread theorem plus the still-unproved Picard colimit mountain.
- Gate B has working reduction theorems, but the Pic0 carrier satisfies none of their decisive geometric hypotheses.

## Gate A: Finite-Stage Spread

The smallest anti-vacuous target is approximately:

```lean
noncomputable def picRepDatumFiniteStage
    (hβ : Pic0PreservesFilteredBaseColimit C) :
    Σ L : DatG0.FinSubext k (SeparableClosure k),
      PicRepDatum k L.1 ((baseChange k L.1).obj C)
```

For “the exact representative/universal element,” this should additionally carry an isomorphism between the base change of `datum.J` and the carrier of `pic0_sepClosed_representableBy`, with compatibility of the two universal elements. A later bounded step can enlarge `L` to its normal closure, following [Pic0FiniteSeparablePoint.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteSeparablePoint.lean:174).

Suggested file: `AlgebraicJacobian/Picard/Pic0FiniteStageSpread.lean`

Required imports:

```lean
import AlgebraicJacobian.Picard.Pic0SepClosedJacobianData
import AlgebraicJacobian.Picard.PicRepColimitMountain
import AlgebraicJacobian.Picard.PicRepDatum
import Mathlib.AlgebraicGeometry.AffineTransitionLimit
import Mathlib.FieldTheory.Galois.Basic
```

Current ingredients:

- The exact carrier is LFP, QC, and QS at [Pic0SepClosedJacobianData.lean:101](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:101), [line 112](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:112), and [line 122](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:122).
- The finite-subextension diagram and `Spec Ω` limit are complete in [PicRepColimitMountain.lean:165](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepColimitMountain.lean:165).
- `Pic0PreservesFilteredBaseColimit` is only a proposition, not a producer, at [PicRepColimitCompat.lean:136](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepColimitCompat.lean:136).
- [PicRepColimitMountain.lean:244](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepColimitMountain.lean:244) merely consumes that proposition.

The true missing mathlib theorem is global descent of a finitely presented qcqs scheme object along an affine cofiltered limit. `AffineTransitionLimit.lean` only supplies morphism factorization/equality and affine-open spreading: `exists_π_app_comp_eq_of_locallyOfFinitePresentation` at line 1177, `exists_hom_hom_comp_eq_comp_of_locallyOfFiniteType` at 686, and affine-cover results at 1058/1078. It has no object-spread producer.

## Gate B: Orbit in Affine

The final reduction is already present:

- `Scheme.orbitsInAffineOpen_of_finiteInAffine` at [FiniteInAffine.lean:66](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteInAffine.lean:66).
- Projectivity supplies `FiniteInAffine` at [QuasiProjectiveFiniteInAffine.lean:64](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/QuasiProjectiveFiniteInAffine.lean:64).
- The group argument supplies it only under `[IsAlgClosed L] [IrreducibleSpace G.left]` at [GroupAffineOpen.lean:162](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162).

The Pic0 representation canonically supplies `GrpObj` through [PicRepDatum.lean:108](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepDatum.lean:108), but no `IsProjective`, immersion/quasi-projectivity certificate, or `IrreducibleSpace` instance is produced. A finite Galois stage is also not algebraically closed.

The old AJC module explicitly records this gap at [QuasiProjectiveFiniteInAffine.lean:57](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean:57): the reduction exists, but no H-quasi-projective witness is available for the Picard component.

The pullback-action instance in `GaloisQuotientNonVacuity` is not a solution: it applies when the acted scheme is already the base change of a scheme over `k`, which is precisely the quotient/descent conclusion being constructed.

Thus the smallest actual missing producer is either:

```lean
theorem finiteInAffine_pic0FiniteStage :
    Scheme.FiniteInAffine d.J.left
```

proved from a genuine projective/quasi-projective immersion of `d.J`, or a new arbitrary-field finite-type group theorem strong enough to imply it. A theorem merely assuming `FiniteInAffine`, projectivity, or irreducibility would be another conditional wrapper.

No source files or project metadata were edited.
