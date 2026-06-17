# Lean audit — iter-037 prover-touched files

Audit the two `.lean` files edited this iteration as Lean code. Read both in full.

## Files
- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean`
- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`

## Focus areas
- New declarations added this iter (verify each is honest, axiom-clean, no hidden `sorry`/`admit`/`native_decide` laundering):
  - GrassmannianCells: `det_one_updateCol` (private), `exists_minorDet_eq_free_entry`, `existence_factor_through_valuationRing`.
  - QuotScheme: `Scheme.Modules.isLocalizedModule_of_ringEquiv_semilinear`, `Scheme.Modules.isLocalizedModule_restrictScalars_powers_algebraMap`.
- QuotScheme carries 4 long-standing `sorry` bodies (`hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/`Grassmannian.representable`) — note them as known protected scaffold stubs, not new dead code, but confirm no NEW sorry was introduced.
- Outdated comments, excuse-comments ("temporary", "will fix"), dead-end proof fragments, bad Lean practice (e.g. `set`-without-unfold pitfalls, over-broad `simp`).

Report a per-file checklist + flagged-issues block with severity. Read-only; write only your report.
