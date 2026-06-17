# lean-vs-blueprint-checker — QuotScheme (iter-031)

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

Verify bidirectionally for the iter-031 prover work (gap1 bridge C closed):
- New Lean decls: `Scheme.Modules.overRestrictIso` (pin `lem:over_restrict_iso`),
  `overRestrictEquiv`, `overRestrictFunctorIso`, `overRestrictPullbackIso` (latter three have NO
  blueprint block — coverage debt).
- Confirm `lem:over_restrict_iso` statement matches the Lean `overRestrictIso` signature
  `(overRestrictEquiv U).functor.obj (M.over U) ≅ (restrictFunctor U.ι).obj M`.
- Report: (a) any Lean-side fake/placeholder/mismatch; (b) whether the `lem:over_restrict_iso`
  blueprint prose (steps 1->4) was adequate to guide the formalization; (c) coverage-debt decls.
  Note: review agent already corrected the stale `% NOTE` block (which claimed overRestrictIso
  "does NOT yet exist") to "RESOLVED and axiom-clean". The 4 pre-existing protected-stub sorries
  are out of scope.
