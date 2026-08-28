## Progress

Read-only audit completed; no source, roadmap, or inbox changes.

- Strongest finite-stage producer: [`exists_pic0FiniteStageGluePackage`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:113), graph node `dab86149bd06`, `lean_ok`. It produces `Nonempty (Pic0FiniteStageGluePackage C F)` from the simultaneous finite-subextension transition/triple-model producers.
- Strongest finite-stage geometric comparison: [`finiteStageBaseChangeIso`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:284), graph node `42ac125f0f1e`, `lean_ok`:
  `pullback P.gluedMap (Spec.map (algebraMap P.N.1 k)) ≅ (pic0_sepClosed_representableBy C).1.left`.
  It is only a scheme isomorphism after scalar extension; it does not provide the missing finite-field `RepresentableBy` certificate.
- Exact sep-closed representation is already axiom-clean and `lean_ok`: [`pic0_sepClosed_representableBy`](.../AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:443), graph node `7d0f7475e4ec`; its lft/lfp/qc consumers are also landed.

## Missing Producer

All current finite-Galois wrappers require the finite-stage representation as an explicit input:

```lean
rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver
```

This occurs in:

- [`pic0RepresentableBy_finiteStageGaloisDescent_of_isImmersion`](.../AlgebraicJacobian/Picard/Pic0FiniteStageStableAffineCover.lean:93), node `4ce1430fdc29`.
- [`pic0RepresentableBy_finiteStageGaloisDescent_of_isProjective`](.../AlgebraicJacobian/Picard/Pic0FiniteStageStableAffineCover.lean:134), node `f406f57da14b`.
- [`jacobianData_finiteStageGaloisDescent_of_isProjective`](.../AlgebraicJacobian/Picard/Pic0FiniteGaloisJacobianData.lean:147), node `e3923f64f5ce`.

The orbit-affine declarations are likewise consumers of `rep`; e.g. [`pic0FiniteStageOrbitsInAffineOpen_of_isImmersion`](.../AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:131). Therefore none is an arbitrary-field producer.

Recommended first target:

```lean
theorem pic0FiniteStageRepresentableBy
    (P : Pic0FiniteStageGluePackage Ck F)
    ... :
    (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver
```

Its genuine content is the universal Picard equivalence over the finite stage, using `finiteStageBaseChangeIso` plus a base-colimit/functorial descent argument. The existing `pic0RepresentableBy_of_baseChangeObjectIso` only transports representation upward across a field extension and cannot reverse this step.

## Non-Circular Headline Consumer

Once that producer exists, use the already-landed constructor:

[`JacobianData.ofRepresentableBy`](.../AlgebraicJacobian/Picard/JacobianDataCharts.lean:71)

```lean
JacobianData.ofRepresentableBy C J rep hlft hqc
```

It directly packages `RepresentableBy`, local finite type, and quasi-compactness. [`PicRepDatum.toJacobianData`](.../AlgebraicJacobian/Picard/JacardDataHandoff.lean:39) is the lighter handoff when a `PicRepDatum K K C` has already been built. `JacobianData.ofCharts` is also clean but requires the full chart-family/coverage input and is not a shortcut.

The Horizon graph reports `lean_ok` for these declarations, but Lean-node dependency arrays are empty; dependencies above were confirmed from imports and declaration bodies.
