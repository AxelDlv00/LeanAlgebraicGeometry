# lean-auditor — iter-163

## Files to audit (absolute paths)

Primary (received prover work this iter):
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`

Secondary (cross-check for stale comments / consistency only):
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean`

## Focus areas

1. The two newly-added declarations in `AbelianVarietyRigidity.lean`:
   `hom_additive_decomp_of_rigidity` (≈L809) and `av_regularMap_isHom_of_zero` (≈L879). Are the
   proofs sound and complete (no hidden `sorry`, no false hypothesis laundering)? Is every
   hypothesis load-bearing, or is any instance/argument vacuous or unused?
2. The 3 remaining `sorry` declarations (`morphism_P1_to_grpScheme_const` ≈L919,
   `genusZero_curve_iso_P1` ≈L943, `rigidity_genus0_curve_to_grpScheme` ≈L968): are their
   docstrings/status comments accurate, or stale? Pay extra attention to any docstring claiming a
   dependency that the surrounding code no longer reflects.
3. Any stale status comments elsewhere in the file referring to closed work as "the lone residual
   sorry" or similar.

Report the standard per-file checklist + flagged-issues block with severities. Do NOT assume any
strategic framing — audit the Lean as Lean.
