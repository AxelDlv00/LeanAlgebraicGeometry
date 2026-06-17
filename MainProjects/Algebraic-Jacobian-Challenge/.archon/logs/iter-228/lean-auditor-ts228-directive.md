# Directive — lean-auditor (slug: ts228)

Read-only audit of one Lean file, as Lean. No strategy context.

## File to audit
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Focus
- Three declarations were added near L1558, L1603, L1698 this iter
  (`dualPrecompEquiv`, `dualIsoOfIso` presheaf-level, `dualIsoOfIso` sheaf-level). Check
  their statements and docstrings for accuracy, dead-end proofs, suspect definitions, and
  bad Lean practices.
- Check the whole file for outdated comments / stale line-references / stale status blocks
  (the file has accumulated multi-iter narrative comments).
- Report any `sorry` and whether its surrounding comment accurately describes its state.

Per-file checklist + flagged-issues block. Mark severity. Do not read STRATEGY.md/PROGRESS.md.
