# Lean Auditor Directive

## Slug
review136

## Scope (files)
All `.lean` files under `AlgebraicJacobian/` and `AlgebraicJacobian.lean` at:
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean`
- plus any other `.lean` files under `AlgebraicJacobian/` you discover.

## Focus areas (optional)
Pay extra attention to `AlgebraicJacobian/Cotangent/GrpObj.lean`. A prover lane this iter added a new private lemma `section_snd_eq_identity_struct` and substantively closed the previously sorry-bodied `relativeDifferentialsPresheaf_restrict_along_identity_section` (~27 LOC total addition). Audit the new body, the new helper, the surrounding docstrings, and confirm no excuse-comments or unused parameters were introduced. The two remaining sorry-bodied scaffolds in the same file (`relativeDifferentialsPresheaf_basechange_along_proj_two` at L480, `mulRight_globalises_cotangent` at L599) are intentional iter-137+/iter-138+ work — their bodies remain `sorry` by design, but please flag any drift between their docstrings and their actual signatures.

## Known issues (do not re-report)
- `Jacobian.lean:197` (`genusZeroWitness`), `Jacobian.lean:223` (`positiveGenusWitness`), `RigidityKbar.lean:87` (`rigidity_over_kbar`) are intentional off-limits scaffolds (M2.b / M3 user-escalation-gated). Do not flag their `sorry` bodies as must-fix; do flag docstring drift if you spot it.
- `Cotangent/GrpObj.lean` lines 50/53/204 contain `opaque` warnings detected by `lean_verify` — those are pre-existing project structure, not iter-136 introductions.
- `Jacobian.lean:275` carries a pre-existing long-line linter warning on a protected signature — do not flag.
- Stale `\leanok` / `\notready` / docstring-line-anchor drift on the blueprint side is the lean-vs-blueprint-checker's job, not yours.
