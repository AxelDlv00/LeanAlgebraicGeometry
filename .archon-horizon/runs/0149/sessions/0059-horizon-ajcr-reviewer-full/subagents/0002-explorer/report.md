## Progress

Actual HEAD is `fafc249cc6`. Since `b914523466`, two verified commits landed:

- `663dea427f`: `gluingOverlapIso`
- `51baf6e6bc`: three specialized flattening projection identities

The best next new declaration is the left multispan compatibility:

```lean
theorem gluingOverlapIso_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f U V ≫
        (gluingChartIso C P U).hom =
      (gluingOverlapIso C P U V).hom ≫
        (pic0SepClosedAtlasGlueData C).f U V := by
  ...
```

This is the naturality orientation needed for a multispan natural isomorphism.

Dependencies are now available:

- [`gluingOverlapIso_pre_fst`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:108)
- [`gluingOverlapIso`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:135)
- [`restrictionBaseChangeMap_naturality`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionNaturality.lean:38)
- [`exactRestrictionAlgHom_fromSpec`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:89)
- `IsPullback.isoPullback_hom_fst`, `Scheme.homOfLE_ι`, and `IsAffineOpen.isoSpec_inv_ι`

Likely proof:

1. Apply `rw [← cancel_mono U.1.1.ι]`.
2. Unfold only `gluingChartIso`, `chartBaseChangeIso`, `gluingOverlapIso`, and `overlapBaseChangeIso`, normalizing `Iso.trans_hom` and `Category.assoc`.
3. Rewrite with `gluingOverlapIso_pre_fst`.
4. Rewrite with `restrictionBaseChangeMap_naturality`.
5. Use `exactRestrictionAlgHom_fromSpec`.
6. Close the canonical overlap projection using `isoPullback_hom_fst`, `homOfLE_ι`, and `isoSpec_inv_ι`.

## Issues

`fafc249cc6` integrated `gluingOverlapIso_pre_fst` without an observed post-edit kernel build. The current `Pic0FiniteStageGluingDiagramIso.olean` predates that integration. A build of the proposed theorem’s module would certify both declarations together.

`Pic0FiniteStageRightRestrictionNaturality.lean` was also integrated, but is not imported by `Pic0CriticalPath`, has no `.olean`, and its standalone kernel check was interrupted. Therefore the right multispan compatibility should follow the left theorem, not precede it.

Known failed approaches:

- Explicit dependent scalar-extension carriers caused missing `Semiring`/`CommRing`/`Algebra` instances.
- Fully inferred monolithic proofs consumed about 7 GB and ran 12–15 minutes without results.
- Reassociation-only `pullback.congrHom` rewrites produced type mismatches.
- Broad `simpa` failed on parenthesized terminal projections; explicit inside-out `rw` sequences are required.

No files or Horizon state were modified, and no build was run during this read-only audit.
