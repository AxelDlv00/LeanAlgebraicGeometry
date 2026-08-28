Read-only audit complete. The post-`GlueData` cone is:

1. Finite-stage scheme over `N`

- Define `pic0FiniteStageGluedMap : D.glued ⟶ Spec N` using `Multicoequalizer.desc` from the chart structure maps.
- Prove `D.ι U ≫ pic0FiniteStageGluedMap = chartMap U`.
- Package `pic0FiniteStageGluedOver : Over (Spec N)`.

The exact template is `gluedQuotientMap` and `quotientGlueData_ι_gluedQuotientMap` in `Descent/GaloisQuotientOverlap.lean`.

Next define component comparisons
```lean
k ⊗[N] (N ⊗[M] MModel j) ≃ₐ[k] exactRing j
```
by composing `Algebra.TensorProduct.cancelBaseChange` with `pic0FiniteStageModelBaseChangeEquiv`, and prove naturality using `AlgebraicJacobian.cancelBaseChange_naturality`.

Glue the induced local Spec isomorphisms into
```lean
pic0FiniteStageGluedBaseChangeIso :
  (baseChange N k).obj pic0FiniteStageGluedOver ≅
    (pic0_sepClosed_representableBy C).1
```
first against `pic0SepClosedAtlasGlueData.glued`, then compose with
`asIso (pic0SepClosedAtlasOpenCover C).fromGlued`. There is no generic `Scheme.GlueData.baseChange`; copy the local-open-cover proof pattern around `gluedQuotientBaseChangeLift` and `gluedQuotientBaseChangeIso` in `GaloisQuotientOverlap.lean`.

LFT follows locally from finite-type chart rings. QC follows from the finite affine `D.openCover`, analogously to `quasiCompact_gluedHom` in `JacobianDataCharts.lean`.

2. Geometry alone does not yield a finite-stage representer

The glued `J_N` is only a model whose scalar extension is the separably closed representer. One must also descend the canonical universal Picard element/Yoneda equivalence. The intended route is `informal/spec-datg0.md`:

- prove `Pic0PreservesFilteredBaseColimit C`;
- descend the universal class to some `DatG0.FinSubext`;
- construct `pic0FiniteStageHomEquiv` and its naturality;
- package `pic0FiniteStageRepresentableBy`;
- package `picRepDatumKprime`.

Relevant APIs are:

- `PicRepColimitCompat.lean`: `Pic0PreservesFilteredBaseColimit`, `preservesColimit_pic0TypeFunctor_baseChange`;
- `PicRepColimitResidual.lean`: `DatG0.FinSubext`, directedness, union/top, finite-dimensional and separability instances;
- `PicRepColimitMountain.lean`: `deltaRingDiagram`, `deltaIsColimit`, `deltaSchemeDiagram`, `preservesColimit_deltaScheme_of_residual`;
- Mathlib Yoneda: `Functor.representableByEquiv`, `RepresentableBy.toIso`, `RepresentableBy.homEquiv_eq`.

`pic0PreservesFilteredBaseColimit_of_representableBy` is circular here: it assumes the arbitrary-field locally finitely presented representer being constructed. No non-circular proof of `Pic0PreservesFilteredBaseColimit` currently exists.

`Pic0RepresentabilityDescentData.lean` supplies canonical Amitsur descent data, but there is no effective scheme-descent theorem in the tree, so it does not close this gap.

3. Arbitrary-field `pic0_representableBy`

After obtaining a finite separable-stage representer:

- enlarge `N/F` to a finite Galois normal closure `E/F`;
- transport the representation to `E` using the pattern in `JacobianDataBaseChange.lean`;
- form `pic0SemilinearGalActionOfRepresentableBy`;
- invoke `pic0RepresentableBy_finiteGaloisDescent`.

The quotient/invariant engine is already complete:

- `Pic0GaloisAction.lean`: `pic0SemilinearGalActionOfRepresentableBy`;
- `Pic0FiniteGaloisDescent.lean`: `StableAffineOpen.gluedQuotientOverHomEquiv`;
- `Pic0GaloisInvariantMatch.lean`: `pic0GaloisInvariantEquivGaloisEquivariantOver`;
- `Pic0FiniteGaloisRepresentable.lean`: `pic0RepresentableBy_finiteGaloisDescent`.

A second genuine gate remains: the required
```lean
[(pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen]
```
has no producer. Existing routes are `orbitsInAffineOpen_of_finiteInAffine` and `finiteInAffine_of_isProjective`, but projectivity/quasi-projectivity or `FiniteInAffine` has not been proved for this Picard representer. A finite affine cover alone is insufficient.

4. Jacobian headline

Once the arbitrary-field representation, LFT, and QC are available, package it with `JacobianData.ofRepresentableBy` or `PicRepDatum.toJacobianData`. LFT descends using `PicEtSeparated.locallyOfFiniteType_of_baseChange`; QC can descend from the compact finite-stage quotient using surjectivity plus `CompactImageQc.quasiCompact_of_surjective`.

That closes the core `Challenge.lean` headline definitions `Jacobian`, its `GrpObj`, `ofCurve`, composition with Abel, and the base-change iso through existing `JacobianDataAbel` and `JacobianDataBaseChange` APIs. It does not by itself close the separate smoothness, properness, geometric irreducibility, dimension, `AbelSourceData`, or Albanese-universal-property sorries.

The smallest next implementable proof after `GlueData` is therefore the glued structure map, its chart triangle, and `pic0FiniteStageGluedOver`. The two honest downstream blockers are non-circular Pic0 filtered-colimit compatibility and the orbit-in-affine instance. No files were edited.
