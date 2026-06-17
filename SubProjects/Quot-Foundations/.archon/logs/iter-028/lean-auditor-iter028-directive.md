# lean-auditor directive — iter-028

Audit these three `.lean` files as Lean code (no strategy bias). They received prover
work this iteration (new declarations + docstring rewrites).

## Files (absolute paths)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean

## Focus areas
1. **FlatBaseChange.lean** — this iter several docstrings were rewritten to claim certain
   theorems are now "sorry-free" (e.g. `base_change_mate_inner_value_eq`,
   `base_change_mate_section_identity`, `pushforward_base_change_mate_cancelBaseChange`,
   `base_change_mate_generator_trace`, the `pushforward_spec_tilde_iso` STATUS block).
   Verify each such claim against the actual proof body: does the body literally end in
   `sorry`, and — separately — is the theorem **transitively** sorry-backed (its proof
   `exact`s another declaration that still contains `sorry`, e.g. via
   `base_change_mate_fstar_reindex` → `base_change_mate_fstar_reindex_legs` @~1445)?
   Flag any docstring that overstates completion (claims "sorry-free"/"axiom-clean" while
   the chain is transitively sorry-backed). There are 4 live sorries (≈ lines 1445, 1817,
   1995, 2017). A `have hpfc := …` was left in place inside the `_legs` proof before a `sorry`.
2. **QuotScheme.lean** — two new helpers were added (`isLocalizedModule_basicOpen_of_presentation`,
   `map_units_restrict_basicOpen`). Check they are genuine (not placeholder/vacuous) and that
   no stray `Scratch`/`example` scaffolding was left behind. The 4 file sorries are protected
   stubs (`hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/`Grassmannian.representable`).
3. **GrassmannianCells.lean** — four new decls (`chartTransition'`, `chartTransition'_fac`,
   `chartTransition'_ringIdentity`, `awayMulCommEquiv_comp_algebraMap`); 0 sorries. Check the
   `set_option maxHeartbeats 1600000` usages carry an explaining comment, and that the
   end-of-file `HANDOFF` comment block describing the unbuilt `cocycle`/`theGlueData` is
   accurate (no false claim that they exist).

## Output
Per-file checklist (outdated/false comments, suspect defs, dead-end proofs, bad Lean practice)
plus a flagged-issues block with severity. Report path is auto-managed.
