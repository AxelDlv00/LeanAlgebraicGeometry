Read-only design complete.

The constructor should use locally named `A`, `B`, `r`, then explicitly install the map-selected `Algebra` and `IsScalarTower` instances before calling `affineRingGlueData`. This block compiled in an isolated Lean check:

```lean
let A : Pic0FiniteStageChartIndex C -> Type u := fun U =>
  Pic0FiniteStageChartBaseChangeRing C L n m relation M N U
let B : Pic0FiniteStageChartIndex C -> Pic0FiniteStageChartIndex C -> Type u :=
  fun U V => Pic0FiniteStageOverlapBaseChangeRing C L n m relation M N U V
let r : ∀ U V, A U ->ₐ[N.1] B U V := fun U V =>
  pic0FiniteStageRestrictionBaseChange C L n m relation M mapM N U V
letI : ∀ U V, Algebra (A U) (B U V) := fun U V =>
  pic0FiniteStageAlgebraOfMap (r U V)
letI : ∀ U V, IsScalarTower N.1 (A U) (B U V) := fun U V =>
  pic0FiniteStageTowerOfMap (r U V)
```

Then:

```lean
refine AlgebraicJacobian.affineRingGlueData (R := N.1) A B tau theta
  ?_ ?_ ?_ ?_ ?_
```

The five obligations are, in order:

- `isIso_pic0FiniteStageRestrictionBaseChange_diagonal`
- `isOpenImmersion_pic0FiniteStageRestrictionBaseChange`
- `pic0FiniteStageTransitionBaseChange_self`
- a new literal affine face theorem
- `pic0FiniteStageAffineTripleTransition_cocycle`

The face goal must be changed to use:

```lean
finiteStageTensorPushoutFaceRight (r V W) (r V U)
finiteStageTensorPushoutFaceLeft (r U V) (r U W)
```

The existing `pic0FiniteStageTripleTransitionModel_fac` only exposes package projections, so it is not directly suitable as the `GlueData` face field.

For the existential result, a dependent `Pic0FiniteStageGluePackage` with fields
`L n m relation e M mapM hmapM hOpen N thetaN hthetaN` and a computed
`glueData` method is the non-vacuous interface. Its existence proof composes the two actual producers using:

```lean
obtain ⟨L, n, m, relation, e, M, mapM, hmapM, hOpen, _⟩ :=
  exists_finSubext_pic0FiniteStageTransition_models (C := C) (F := F)
letI : Algebra.IsAlgebraic L.1 k := by infer_instance
letI : Algebra.IsAlgebraic M.1 k := by infer_instance
obtain ⟨N, hN⟩ :=
  exists_finSubext_pic0FiniteStageTripleTransition_models_of_comparisons
    C L n m relation M mapM
    (pic0FiniteStageTripleModelComparisonFamily
      C L n m relation e M mapM hmapM)
choose thetaN hthetaN using hN
```

`Algebra.IsAlgebraic L.1 k` and `M.1 k` infer only with the original `[Algebra.IsAlgebraic F k]`. The pair-stage inverse witness is not required by `GlueData`; its diagonal coherence comes from `pic0FiniteStageTransitionBaseChange_self`.
