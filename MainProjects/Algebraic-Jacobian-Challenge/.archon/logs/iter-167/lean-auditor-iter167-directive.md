# Lean Auditor Directive

## Slug

iter167

## Files

Audit every `.lean` file under the project tree at
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`.

This iter's prover edits touched two files (pay extra attention to these — but
audit the whole project as usual, do not skip the others):

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — Lane B
  (refactored the 5 inline `sorry`s out of the private helper
  `morphism_P1_to_grpScheme_const_aux` and added one named top-level bridge
  `iotaGm_isDominant` (still `sorry`)).
- `AlgebraicJacobian/Genus0BaseObjects.lean` — Lane A
  (added 4 new top-level instances + 3 new scaffold-`sorry` instances:
  `gmRing_isDomain`, `gm_irreducibleSpace`, `projGm_locallyOfFiniteType`,
  `projGm_geomIrred` (all axiom-clean), plus the scaffolds
  `projectiveLineBar_isReduced`, `gm_geomIrred`, `projGm_isReduced`).

## Focus areas

1. **Excuse comments / TODO markers**: the iter-166 audit flagged 5
   `-- TODO:` excuse comments inside the AVR helper that "the iter-167 prover
   would drop." Verify they are gone from `AbelianVarietyRigidity.lean` and
   that no new ones were introduced by Lane A.
2. **Sorry-bearing instances**: 3 new scaffold-sorry instances landed in
   `Genus0BaseObjects.lean` (`projectiveLineBar_isReduced`, `gm_geomIrred`,
   `projGm_isReduced`). Check their docstrings for honest accounting of
   the Mathlib gap vs. a smuggled-in excuse.
3. **Outdated comments**: docstrings on
   `morphism_P1_to_grpScheme_const_aux` and the new dominance bridge
   `iotaGm_isDominant` were rewritten this iter — check they accurately
   describe current state.
4. **Stale narrative blocks** in the fallback-route files
   (`Cotangent/GrpObj.lean` ×2, `Cotangent/ChartAlgebra.lean`,
   `RigidityKbar.lean`, `Jacobian.lean`) — these have been deferred for
   several iters and the iter-166 lean-auditor still flagged 6 majors.
   Re-flag if still applicable; explicitly note when prior majors are
   unchanged.

## Output

Per-file checklist + flagged-issues block in the standard format.
