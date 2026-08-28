No existing unconditional producer closes the gate.

The exact missing proposition is:

```lean
Scheme.FiniteInAffine P.glueData.glued
```

The best reusable producer to add is the full Stacks 0B7S theorem:

```lean
theorem GroupScheme.finiteInAffine_of_locallyOfFiniteType
    (G : Over (Spec (.of K))) [GrpObj G] [LocallyOfFiniteType G.hom] :
    Scheme.FiniteInAffine G.left
```

[GroupAffineOpen.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162) already proves its algebraically closed, irreducible core and explicitly leaves arbitrary-field/reducible descent open.

At `P.gluedOver`, the remaining inputs are already available once `rep` exists:

- `GrpObj P.gluedOver` comes from `GrpObj.ofRepresentableBy`, exactly as in [PicRepDatum.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepDatum.lean:108).
- `LocallyOfFiniteType P.gluedMap` is [instLocallyOfFiniteTypeGluedMap](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGeometry.lean:49).
- [orbitsInAffineOpen_of_finiteInAffine](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteInAffine.lean:66) then produces the desired instance directly.

Thus [Pic0FiniteStageOrbitAffine.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:54) can gain a binder-free geometric producer from `rep`, without constructing projectivity or an immersion.

Search found no full group theorem or projectivity/quasi-projectivity fpqc-descent theorem in mathlib. The four commits only add conditional consumers: `5ee5a7f` requires projectivity, `7d861b2` requires an immersion, `da5bb57` proves only LFT and QC, and `679c29e` is the sibling project’s conditional H-quasi-projective route.

End-to-end representability still separately needs `RepresentableBy P.gluedOver`. Per I-2004, the current gluing-diagram draft and captured commit `aee6c39cf3` are unverified and must not be counted as that producer. No source files were edited.
