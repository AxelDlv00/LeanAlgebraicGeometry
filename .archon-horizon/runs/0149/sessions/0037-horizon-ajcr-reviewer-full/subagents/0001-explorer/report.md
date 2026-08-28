Best honest next edge: add the projection API for `nestedPullbackFlatteningIso`, not another package-level tensor-ring wrapper.

The required declarations are:

```lean
@[reassoc]
theorem nestedPullbackFlatteningIso_hom_fst_a
    {U V X Y Z W : Scheme.{u}}
    (iU : U ⟶ X) (iV : V ⟶ X) (f : X ⟶ Z) (g : Y ⟶ Z)
    (a : W ⟶ U) (b : W ⟶ V)
    (hab : a ≫ iU = b ≫ iV)
    (hW : IsLimit (PullbackCone.mk a b hab)) :
    (nestedPullbackFlatteningIso iU iV f g a b hab hW).hom ≫
        pullback.fst (a ≫ iU ≫ f) g ≫ a =
      pullback.fst (pullback.fst (iU ≫ f) g ≫ iU) iV ≫
        pullback.fst (iU ≫ f) g

@[reassoc]
theorem nestedPullbackFlatteningIso_hom_fst_b ... :
    (nestedPullbackFlatteningIso iU iV f g a b hab hW).hom ≫
        pullback.fst (a ≫ iU ≫ f) g ≫ b =
      pullback.snd (pullback.fst (iU ≫ f) g ≫ iU) iV

@[reassoc]
theorem nestedPullbackFlatteningIso_hom_snd ... :
    (nestedPullbackFlatteningIso iU iV f g a b hab hW).hom ≫
        pullback.snd (a ≫ iU ≫ f) g =
      pullback.fst (pullback.fst (iU ≫ f) g ≫ iU) iV ≫
        pullback.snd (iU ≫ f) g
```

Why this is the right edge:

- The flattening isomorphism is already kernel-clean at [Pic0FiniteStageOverlapBaseChange.lean:30](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOverlapBaseChange.lean:30), but it exposes no projection equations.
- Those three equations are exactly what turns the nested overlap’s `fst` and `t ≫ f` into ordinary affine base-change maps. The source gluing uses those two legs definitionally in Mathlib’s pullback gluing construction.
- The left affine square is already proved by `restrictionBaseChangeMap_naturality` at [Pic0FiniteStageRestrictionNaturality.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionNaturality.lean:39).
- Commit `9002d90676` now supplies the formerly missing ring identity through the final scalar stage at [Pic0FiniteStageRightLegEquality.lean:35](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRightLegEquality.lean:35) and [Pic0FiniteStageRightLegEquality.lean:119](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRightLegEquality.lean:119). Thus no new right-restriction algebra-map wrapper is mathematically needed.

Likely proof shape: reproduce the local comparison
`e := hW.conePointUniqueUpToIso (pullback.isLimit iU iV)`, obtain both
`e.inv ≫ a = pullback.fst _ _` and
`e.inv ≫ b = pullback.snd _ _` from
`IsLimit.conePointUniqueUpToIso_inv_comp`, unfold `nestedPullbackFlatteningIso`, and simplify the `pullback.map`, `pullbackAssoc`, and `pullbackSymmetry` projections. This is pure category theory and avoids all finite-stage tensor instances.

After these lemmas, the actual Pic0 overlap component should compose with:

```lean
noncomputable def pic0FiniteStageAffineOverlapPullbackIso
    (U V : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageAffineOverlap C U V).1.toScheme ≅
      (pic0SepClosedAtlasGlueData C).V (U, V) := by
  change (U.1.1 ⊓ V.1.1).toScheme ≅ pullback U.1.1.ι V.1.1.ι
  exact (isPullback_opens_inf U.1.1 V.1.1).isoPullback
```

The need for this bridge follows from [Pic0FiniteStageAffineIntersections.lean:103](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageAffineIntersections.lean:103): the exact glue datum uses a categorical pullback, while `overlapBaseChangeIso` currently ends at the chosen affine intersection [Pic0FiniteStageGluingBaseChange.lean:66](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:66).

Do not revive attempts `0001`-`0005` unchanged. Their public declarations exposed `Pic0FiniteStageFinalModelRing` or chart/overlap tensor aliases, and standalone elaboration repeatedly failed to reconstruct dependent `Semiring`/`CommRing`/`Algebra P.N.1` instances despite clean LSP results. Keep the next file’s public signatures scheme-only; use the compiled `gluingChartIso`, `overlapBaseChangeIso`, left naturality theorem, and scalar right-leg equality internally.

Once the two specialized projection equations exist, `WalkingMultispan.functorExt` gives the diagram isomorphism, and the global comparison is formally:

```lean
baseChangeGluingIso C P ≪≫
  HasColimit.isoOfNatIso (finiteStageGluingDiagramIso C P) ≪≫
  asIso (pic0SepClosedAtlasOpenCover C).fromGlued
```

This matches the currently documented missing boundary at [Pic0CriticalPath.lean:283](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:283). No files or Horizon state were modified.
