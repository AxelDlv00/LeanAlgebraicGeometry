Implemented [Pic0FiniteStageRightLegEquality.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRightLegEquality.lean:1).

It provides:

- `transition_comp_restrictionLeft_eq_restrictionRight`
- `transportedMap_transition_comp_restrictionLeft_eq_right`
- `mapM_transition_comp_restrictionLeft_eq_right`
- `transitionBaseChange_comp_restrictionBaseChange_eq_right`

The last theorem states the N-stage composite equals the explicit scalar extension of `P.mapM (Sum.inl (Sum.inr (U, V)))`, avoiding an additional dependent alias.

LSP had no concrete diagnostics but timed out unfolding indexed tensor instances. The bounded kernel check completed cleanly:

```bash
timeout 600 lake env lean AlgebraicJacobian/Picard/Pic0FiniteStageRightLegEquality.lean
```

No commit or Horizon state edits were made.
