No existing projectivity, quasi-projectivity, or closed-immersion theorem currently instantiates for `Pic0FiniteStageGluePackage.gluedMap`. The shortest usable tail needs only a global immersion into projective space, but that immersion is absent from the package.

**Constructor Trace**

The finite-stage object starts with arbitrary affine opens of the exact separably closed representer:

- `pic0FiniteStageAtlas` selects a finite affine atlas using only quasi-compactness, quasi-separatedness, and local finite presentation in [Pic0FiniteStageAtlas.lean:112](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageAtlas.lean:112).
- `Pic0FiniteStageChartRing C U := Γ(J,U)` is at [line 137](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageAtlas.lean:137).
- Pairwise affine intersections come from `pic0FiniteStageAtlas_inter_isAffine` and `pic0FiniteStageAffineOverlap` in [Pic0FiniteStageAffineIntersections.lean:44](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageAffineIntersections.lean:44).
- `Pic0FiniteStageRingIndex` tags chart and overlap rings; `exists_finSubext_pic0FiniteStageAtlas_ring_models` spreads these rings out in [Pic0FiniteStageOverlapRings.lean:73](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOverlapRings.lean:73) and line 167.
- `exists_finSubext_pic0FiniteStageTransition_models` spreads out restrictions/transitions and retains open-immersion certificates in [Pic0FiniteStageTransitionModels.lean:198](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageTransitionModels.lean:198).
- Final chart and overlap rings are tensor extensions `Pic0FiniteStageChartBaseChangeRing` and `Pic0FiniteStageOverlapBaseChangeRing` in [Pic0FiniteStageScalarExtendedAtlas.lean:46](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageScalarExtendedAtlas.lean:46).

`pic0FiniteStageAffineRingGlueData` calls `AlgebraicJacobian.affineRingGlueData` in [Pic0FiniteStageGlueDataAssembly.lean:55](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataAssembly.lean:55). That constructor explicitly sets every chart to `Spec (A i)` and every overlap to `Spec (B i j)` in [AffineRingGlueData.lean:183](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/AffineRingGlueData.lean:183).

The package fields in [Pic0FiniteStageGluePackage.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:39) retain rings, restriction maps, `hOpen`, and cocycles. They retain no global morphism to an ambient scheme, line bundle, properness proof, group law, or projective coordinates. `gluedMap` is subsequently created solely by `Multicoequalizer.desc` in [Pic0FiniteStageGluedOver.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:39).

**Shortest Honest Tail**

Rebuild already has:

```lean
Scheme.finiteInAffine_of_isImmersion
  (f : X ⟶ Y) [IsImmersion f]
  (hY : FiniteInAffine Y) :
  FiniteInAffine X
```

at [QuasiProjectiveFiniteInAffine.lean:44](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/QuasiProjectiveFiniteInAffine.lean:44), and `finiteInAffine_projectiveSpace` at line 55. Therefore the minimal new geometric certificate is just:

```lean
i : P.glueData.glued ⟶ ProjectiveSpace n (Spec (.of P.N.1))
[IsImmersion i]
```

Then:

```lean
have hfin : Scheme.FiniteInAffine P.glueData.glued :=
  Scheme.finiteInAffine_of_isImmersion i
    (Scheme.finiteInAffine_projectiveSpace n (Spec (.of P.N.1)))

letI : ρ.OrbitsInAffineOpen :=
  Scheme.orbitsInAffineOpen_of_finiteInAffine ρ hfin
```

This requires neither properness nor a factorization equation with `P.gluedMap`.

If a closed immersion is constructed instead, `IsImmersion` is inferred. Alternatively, a full witness for `P.gluedMap.IsProjective` feeds `finiteInAffine_of_isProjective` at line 64.

**Candidate APIs And Why They Stop**

Rebuild’s projectivity API in [ProjectiveMorphism.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Projective/ProjectiveMorphism.lean:27) offers:

- `IsProjective.comp_isClosedImmersion` at line 59: needs an actual closed immersion into an already projective scheme.
- `IsProjective.baseChange` at line 76: only preserves projectivity under base change; it does not reflect it.
- `IsProjective.of_isProper_of_immersion` at line 99: needs `IsProper P.gluedMap`, a global projective-space immersion, and its factorization equation.
- `ProjectiveSpace.isProjective_over` at line 115.

None of those hypotheses is available for `P`.

The finite-map construction `P1FiniteMap.FiniteMapGenerators.isImmersion_toProjectiveSpace` and `isProjective` in [FiniteMapToP1.lean:128](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Projective/FiniteMapToP1.lean:128) requires a finite map to `P¹` and properness. No such map exists for the finite-stage glue, and this cannot be the general higher-dimensional Picard route.

The closed immersions `isClosedImmersion_carveSchemeι` and `isClosedImmersion_divSchemeι` in `Picard/DivScheme.lean` concern divisor/carve schemes. The available Abel map goes from the divisor representer onto Pic0; it is not an immersion of Pic0 into that ambient Grassmannian.

**H-Quasi-Projectivity Port**

Porting the original definition from [ProjectiveMorphismBasic.lean:44](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/ProjectiveMorphismBasic.lean:44) and `finiteInAffine_of_isHQuasiProjective` from [QuasiProjectiveFiniteInAffine.lean:484](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean:484) does not suffice. It merely changes the missing goal to:

```lean
∃ n, Finite n ∧
  ∃ i : P.glueData.glued ⟶ ℙ(n; Spec (.of P.N.1)),
    IsImmersion i ∧ QuasiCompact i ∧
      i ≫ (ℙ(n; Spec (.of P.N.1)) ↘ Spec (.of P.N.1)) = P.gluedMap
```

The original project explicitly records that no Picard H-quasi-projectivity producer exists. Its `pointedPicSharpQuasiProjectivePieces_demand` is still `by sorry` in [DemandLedger.lean:158](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Projective/DemandLedger.lean:158).

Current base-change work also stops short: `baseChangeGluingIso`, `gluingChartIso`, and `overlapBaseChangeIso` in [Pic0FiniteStageGluingBaseChange.lean:37](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:37) compare the pulled-back gluing locally, but do not provide a global isomorphism to the exact Pic0 representer or descend an immersion. The project’s own boundary statement records this at [Pic0CriticalPath.lean:284](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:284).

Thus the shortest real new work is to spread out one global Pic0 immersion, including compatible projective coordinates across every chart. Porting the H-quasi-projective vocabulary is optional packaging after that construction, not a solution to it.
