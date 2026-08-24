## Audit Result

`Pic0FiniteStageGluedComparison.lean` is currently an orphan leaf: no Lean module imports it. Therefore `gluingGluedIso` and `finiteStageBaseChangeIso` are not root-reachable and have no downstream consumers.

### Public Declarations

Under the common context `{k} [Field k] (C : Over (Spec (.of k)))`, curve hypotheses, and `[IsSepClosed k]`:

- [Pic0FiniteStageGluePackage.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:39)
  - `structure Pic0FiniteStageGluePackage (C) (F : Type u) [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]`
  - Fields: `L`, `n`, `m`, `relation`, `e`, `M`, `mapM`, `hmapM`, `hOpen`, `N`, `thetaN`, `hthetaN`.
  - `Pic0FiniteStageGluePackage.glueData (P) : Scheme.GlueData`
  - `exists_pic0FiniteStageGluePackage : Nonempty (Pic0FiniteStageGluePackage C F)`

- [Pic0FiniteStageGluingOverlapIsoPreSnd.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingOverlapIsoPreSnd.lean:37)
  - `gluingOverlapIso_pre_snd (P) (U V)` identifies the base-changed gluing right leg, after `pullback.congrHom`, with `gluingOverlapFlatteningIso.hom` followed by `rightRestrictionBaseChangeMap`.
  - `exactRightRestrictionAlgHom_fromSpec (U V)`:
    ```lean
    Spec.map (CommRingCat.ofHom
        (exactRightRestrictionAlgHom C U V).toRingHom) ≫ V.1.2.fromSpec =
      (pic0FiniteStageAffineOverlap C U V).2.fromSpec
    ```

- [Pic0FiniteStageGluingOverlapIsoSnd.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingOverlapIsoSnd.lean:38)
  - `gluingOverlapIso_snd (P) (U V)`:
    ```lean
    (baseChangedGluing.t U V ≫ baseChangedGluing.f V U) ≫
        (gluingChartIso C P V).hom =
      (gluingOverlapIso C P U V).hom ≫
        ((pic0SepClosedAtlasGlueData C).t U V ≫
          (pic0SepClosedAtlasGlueData C).f V U)
    ```

- [Pic0FiniteStageGluedComparison.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:239)
  - `gluingGluedIso (P)` identifies the glued base-changed finite-stage datum with `(pic0SepClosedAtlasGlueData C).glued`.
  - `finiteStageBaseChangeIso (P)`:
    ```lean
    pullback P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (pic0_sepClosed_representableBy (C := C)).1.left
    ```

[Pic0CriticalPath.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:1) declares no mathematical object; it is an import, `#check`, and `#print axioms` audit module.

### Imports And Consumers

The endpoint dependency cone, where arrows mean “imports”, is:

```text
GluedComparison -> GluingOverlapIsoSnd -> GluingOverlapIsoPreSnd
  -> Fst branch / Snd branch -> PreSndCore
  -> GluingDiagramIso + GluingRightBaseChange
  -> restriction/base-change and right-leg chains
  -> GluedOver / RightLegEquality
  -> GluePackage
```

Semantic consumption is limited:

- `Pic0FiniteStageGluePackage` and `P.glueData` are widely consumed.
- `exists_pic0FiniteStageGluePackage` is only audited by `#check/#print`; no proof chooses its witness downstream.
- `gluingOverlapIso_pre_snd` and `exactRightRestrictionAlgHom_fromSpec` are consumed only by `gluingOverlapIso_snd`.
- `gluingOverlapIso_snd` is consumed only internally by `GluedComparison`.
- `gluingGluedIso` is consumed only by `finiteStageBaseChangeIso`.
- `finiteStageBaseChangeIso` has zero call sites.

The library root imports `Pic0CriticalPath`, `Pic0FiniteStageGeometry`, and `Pic0FiniteStageStableAffineCover` at [AlgebraicJacobian.lean:815](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian.lean:815). None imports `GluedComparison`.

### Representability

There is no binder-free arbitrary-field `RepresentableBy` producer from this chain.

- `exists_pic0FiniteStageGluePackage` produces only `Nonempty`.
- `finiteStageBaseChangeIso` produces only a scheme isomorphism after scalar extension.
- Every finite-stage/Galois `RepresentableBy` endpoint still takes an explicit
  `rep : (...).RepresentableBy P.gluedOver`, plus geometric/Galois inputs.
- The sole binder-free Picard-zero producer is the pre-existing separably closed result:
  `pic0_sepClosed_representableBy : Σ J, (pic0TypeFunctor C).RepresentableBy J`.

Thus importing the comparison does not close the missing descent of the universal natural equivalence.

### Minimal Root Change

A single root import of `Pic0FiniteStageGluedComparison` would technically expose the declarations. The more honest integration is to import it from `Pic0CriticalPath`, update lines 297–305 that still claim the right-leg and global glued comparison are missing, and add corresponding `#check/#print axioms`; the root already imports that audit module.

Caution: the shared index currently stages deletion of `Pic0CriticalPath.lean` and `Pic0FiniteStageGluingOverlapIsoPreSnd.lean` while live copies are untracked. I made no edits or commits. No build was run, as requested.
