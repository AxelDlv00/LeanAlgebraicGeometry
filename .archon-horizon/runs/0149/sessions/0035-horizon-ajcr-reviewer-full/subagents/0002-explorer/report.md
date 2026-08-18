## Audit Result

At ledger HEAD `f4557d0328`, the best bounded next theorem is the missing right-restriction ring square:

```lean
theorem rightRestrictionFinalBaseChangeEquiv_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (overlapFinalBaseChangeEquiv C P U V).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := P.N.1) (K := k)
          ((pic0FiniteStageTransitionBaseChange
              C P.L P.n P.m P.relation P.M P.mapM P.N U V).comp
            (restrictionBaseChangeAlgHom C P V U))) =
      (pic0FiniteStageRestrictionRight C U V).comp
        (chartFinalBaseChangeEquiv C P V).toAlgHom
```

Place it in a new `Pic0FiniteStageRightRestrictionNaturality.lean`, importing `Pic0FiniteStageRestrictionNaturality`.

Proof ingredients:

- Specialize [`pic0FiniteStageFinalBaseChangeEquiv_naturality`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange.lean:70) at:
  - `Sum.inl (Sum.inl (V, U))`, the reversed left restriction.
  - `Sum.inr (U, V)`, the overlap transition.
- Compose those equations using [`scalarExtensionMapOfAlgHom_comp`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/TensorProductFieldTowerMap.lean:65).
- Prove
  `transition(U,V) ∘ restrictionLeft(V,U) = restrictionRight(U,V)`
  by `DFunLike.ext` and `Scheme.resHom_resHom`.
- Use the exact declarations at [`Pic0FiniteStageTransitionModels.lean:54`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageTransitionModels.lean:54) and [`Pic0FiniteStageOverlapRings.lean:111`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOverlapRings.lean:111).

This is the second, `snd`, naturality leg required by the eventual `WalkingMultispan.functorExt`. The existing theorem only supplies `fst`: [`restrictionBaseChangeMap_naturality`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionNaturality.lean:39).

The critical-path narrative explicitly names the right overlap leg as missing at [`Pic0CriticalPath.lean:276`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:276). The rejected nested-overlap attempt failed from dependent tensor-carrier instance re-synthesis, not a false mathematical premise. Complete this ring square before retrying package-level nested pullbacks.

No source or Horizon state was intentionally modified.
