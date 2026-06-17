# lean-auditor directive — iter-247

Audit the Lean code in the two files that received prover edits this iteration, plus
the one file touched by an import-cycle refactor. Report as Lean, with no bias toward
what any strategy claims should hold.

## Files to read (absolute paths)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RelPicFunctor.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean

## Focus areas
- TensorObjSubstrate.lean: two new declarations near L1495–1530 (`presheafUnit_comp_map_eta`,
  `isIso_sheafifyEta_of_unitSquare`). Check they are genuine (no vacuous/`True`-typed statements,
  no hypothesis that is never dischargeable, no `letI`/`haveI` that silently changes the stated type).
  Also check for stale route comments describing abandoned builds as active.
- RelPicFunctor.lean: this iter DELETED 5 local pure-Mathlib substrate copies and 4 local typed-`sorry`
  bridges, rewiring every use site to upstream `Modules.*` decls. Check: no orphaned/dead decls left
  behind, no comment block still describing the (now-resolved) import cycle as active, the `functorial`
  field is still a `0` stub (expected), and the `addCommGroup` construction's group-axiom proofs are
  real (not `sorry`-routed except through the single upstream `exists_tensorObj_inverse`).
- AlgebraicJacobian.lean: import order after the refactor (RelPicFunctor must now import
  TensorObjSubstrate, not vice-versa) — flag any leftover cyclic-looking import or dead import.
- Whole-file: outdated comments, suspect definitions, dead-end proofs, bad Lean practices,
  deprecated API (`Sheaf.val` deprecation warnings are known — note count but not as must-fix).

Write your per-file checklist + flagged-issues block to your task_results report.
