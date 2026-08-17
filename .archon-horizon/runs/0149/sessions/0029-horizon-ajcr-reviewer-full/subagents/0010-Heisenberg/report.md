Audit result: literal gate (a) is available over a separably closed base, but it does not discharge the DAT-G0 gate over the original field. Gate (b) has no producer for the finite-stage Pic0 model.

**(a) Filtered colimits**

This compiled unchanged:

```lean
example {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] [IsSepClosed k] :
    Pic0PreservesFilteredBaseColimit C := by
  letI := locallyOfFinitePresentation_pic0_sepClosed_representableBy C
  exact pic0PreservesFilteredBaseColimit_of_representableBy C
    (pic0_sepClosed_representableBy (C := C)).1
    (pic0_sepClosed_representableBy (C := C)).2
```

The declarations are:

- [Pic0SepClosedRepresentable.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:426): `pic0_sepClosed_representableBy`
- [Pic0SepClosedJacobianData.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:112): its `LocallyOfFinitePresentation`
- [Pic0RepresentableColimit.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentableColimit.lean:28): representability plus LFP implies preservation.

This is non-circular relative to arbitrary-field representability. It is nevertheless the wrong statement for DAT-G0: [PicRepColimitMountain.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepColimitMountain.lean:244) needs `Pic0PreservesFilteredBaseColimit C` for the original `C/k`, on the diagram `Spec k'' → Spec k`. Finite subfields are not objects over `Spec k_s`, so preservation for `C_{k_s}` cannot be applied. `pic0ThetaType` only compares after restricting tests by base change and does not reverse this mismatch.

Indexed type search found no other producer of the required original-base proposition. The named ring/scheme finite-presentation lemmas only spread morphisms and affine opens; no theorem makes `PicEtAff`, its plus construction, or `pic0Subgroup` commute with the filtered colimit. Using `pic0PreservesFilteredBaseColimit_of_representableBy` over arbitrary `k` is circular.

**(b) Orbit/affine gate**

[Pic0FiniteGaloisRepresentable.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisRepresentable.lean:35) still requires exactly:

```lean
[(pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen]
```

Available producers are:

- [FiniteInAffine.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteInAffine.lean:66): `FiniteInAffine X → rho.OrbitsInAffineOpen`
- [QuasiProjectiveFiniteInAffine.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/QuasiProjectiveFiniteInAffine.lean:64): projective over affine implies `FiniteInAffine`
- Full AJC additionally has `finiteInAffine_of_isHQuasiProjective` and `orbitsInAffineOpen_of_isProjective` at lines 484 and 516.
- [GroupAffineOpen.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162) proves it only for an irreducible finite-type group over an algebraically closed field.
- [GaloisQuotientNonVacuity.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientNonVacuity.lean:135) handles the canonical pullback action, but applying it would require already knowing the model is a pullback from the desired descended scheme.

No `FiniteInAffine`, projective, quasi-projective, or orbit instance is attached to any `Pic0FiniteStage` declaration in either project. The apparent AJC `Scheme.Pic0.isProjective_for_kleimanQppAndP` proves projectivity of `C.hom`, not of Pic0.

The shortest honest current route is to prove geometry of the finite-stage model, preferably `IsHQuasiProjective`/`IsProjective`, then use the landed producer chain. The alternative is extending `GroupScheme.finiteInAffine_of_isAlgClosed_of_irreducible` through arbitrary fields and components, after furnishing the finite-stage model with its group structure and finite type.

**Effective descent**

`pic0RepresentabilityDescentData` is already packaged at [Pic0RepresentabilityDescentData.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean:412). Mathlib’s `Pseudofunctor.isEquivalence_toDescentData` would make it effective given an `IsStack` instance. LSP `#synth` fails for `Over.pullbackPseudofunctor` with both `Scheme.fpqcTopology` and `Scheme.fppfTopology`; indexed and local searches found no such instance.

Mathlib’s fpqc `EffectiveEpi` instances descend morphisms into a fixed scheme, not scheme objects. The project’s `Algebra.DescentDatum.baseChangeIso` handles affine schemes only, requiring the stable affine cover that the orbit gate supplies. Thus effective descent cannot currently bypass (b), and even a future scheme-stack theorem would not bypass (a), which is needed to find the finite stage.

No files were edited.
