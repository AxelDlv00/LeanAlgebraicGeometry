# lean-auditor directive (iter-019)

Audit the Lean source of the three files edited this iteration. Read them as Lean, with no
strategy bias. Report per-file checklist + flagged issues (outdated comments, suspect
definitions, dead-end proofs, bad Lean practices, excuse-comments, fake statements,
heartbeat-bump legitimacy, axiom cleanliness).

Files (absolute paths):
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

Focus areas:
- Are the `sorry` sites honest scaffolding (typed holes with accurate roadmap comments) or
  do any comments overstate what is proved?
- `set_option maxHeartbeats`/`synthInstance.maxHeartbeats` bumps in FlatBaseChange.lean and
  FlatteningStratification.lean — are they certifying a real defeq / deep instance search, or
  masking a loop?
- Term-mode `congrArg`/`.trans` proofs in FlatBaseChange.lean (the new `_unitExpand` /
  `_gammaDistribute` lemmas) — sound, or hiding a gap?
- QuotScheme.lean keystone `subquotient_finite_transfer` and the whole
  `gradedModule_hilbertSeries_rational` chain — confirm the only residual hole is the base-case
  `iSupIndep` at `subquotient_base_eventuallyZero`.
- Confirm no `axiom` declarations and no weakened/fake statements.
