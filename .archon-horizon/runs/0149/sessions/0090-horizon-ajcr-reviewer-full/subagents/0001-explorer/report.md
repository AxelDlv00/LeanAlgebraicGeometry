The current comparison is not yet kernel-landed: `.olean` files are missing for `Pic0FiniteStageGluingOverlapIsoPreSnd`, `...IsoSnd`, and `Pic0FiniteStageGluedComparison`, and `Pic0CriticalPath.lean` does not import them. The immediate prerequisite remains:

`gluingOverlapIso_pre_snd` → `gluingOverlapIso_snd` → `gluingGluedIso` → `finiteStageBaseChangeIso`.

After that, the smallest genuine next unit is an over-category lift of [`finiteStageBaseChangeIso`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:284):

```lean
theorem finiteStageBaseChangeIso_hom_structureMap :
  (finiteStageBaseChangeIso C P).hom ≫ J.hom =
    pullback.snd P.gluedMap q

def finiteStageBaseChangeOverIso :
  (Over.pullback q).obj P.gluedOver ≅ J :=
  Over.isoMk (finiteStageBaseChangeIso C P)
    (finiteStageBaseChangeIso_hom_structureMap C P)
```

Here `q := Spec.map (algebraMap P.N.1 k)` and `J` is the separably closed representative. Then transport representability using [`RepresentableBy.ofObjectIso`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentableByTransport.lean:32):

```lean
def finiteStageBaseChangedRepresentableBy :
  (pic0TypeFunctor C).RepresentableBy ((Over.pullback q).obj P.gluedOver) :=
  RepresentableBy.ofObjectIso sepRep
    (finiteStageBaseChangeOverIso C P).symm
```

Proof dependencies are bounded:

- `baseChangeGluingIso` compatibility is `limit.isoLimitCone_hom_π ... WalkingCospan.right`.
- Prove chart compatibility from the existing private [`chartBaseChangeIso_hom_ι`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:257), `SpecMap_appLE_fromSpec`, `AlgEquiv.commutes`, `pullbackSpecIso_hom_fst`, and pullback symmetry.
- Use `Multicoequalizer.hom_ext`, `gluingGluedHom_ι`, and `OpenCover.ι_fromGlued` to show `gluingGluedIso` respects the base map.
- Compose those two equations through the definition of `finiteStageBaseChangeIso`.

This gives the first honest universal natural equivalence, but only after scalar extension. It does not imply `finiteStageRepresentableBy` over `P.N.1`: [`Pic0FiniteStageGluePackage`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:39) stores atlas rings and gluing equations, not the universal Picard class or its canonical Amitsur compatibility. [`pic0RepresentabilityDescentData`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean:398) packages the canonical cocycle, but no Scheme-stack/effectivity consumer exists.

The eventual theorem should specialize

```lean
P : Pic0FiniteStageGluePackage ((baseChange K k).obj C₀) K
```

rather than retain an independent `Ck`. The direct/iterated curve comparison is already available through `baseChange.compIso` and `eCurve`; the remaining genuine work is simultaneous descent of the universal affine-chart classes and overlap equalities. Galois enlargement and orbit affineness remain separate downstream gates.

No files or workspace state were modified.
