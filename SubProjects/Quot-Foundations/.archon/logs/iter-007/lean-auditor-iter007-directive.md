# Directive — lean-auditor (iter-007)

Read-only Lean audit of the two files edited this iteration. No strategy context is
supplied by design; audit the Lean as Lean.

## Files to audit (absolute paths)

- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean`
- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`

## Focus areas

- The newly filled `affineChart` def body (GrassmannianCells.lean).
- The two new declarations in QuotScheme.lean: the predicate
  `SheafOfModules.IsLocallyFreeOfRank` and the theorem
  `Module.annihilator_isLocalizedModule_eq_map`.
- Check for: dead-end / vacuous definitions, type-weakening to dodge proofs,
  excuse-comments ("temporary", "will fix later", "wrong def"), outdated comments
  that no longer match the code, unauthorized `axiom`/`sorry`-laundering, and bad
  Lean practice (e.g. a predicate that is trivially true/false, a theorem whose
  hypotheses make it vacuous).
- The 4 pre-existing typed `sorry` stubs (hilbertPolynomial, QuotFunctor,
  Grassmannian, representable) were intentionally left untouched this iter — confirm
  they remain honest typed scaffolding (substantive types, not weakened to Unit).

Produce your per-file checklist plus a flagged-issues block with severities.
