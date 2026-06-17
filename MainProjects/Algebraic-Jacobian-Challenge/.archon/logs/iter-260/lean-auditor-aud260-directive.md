# lean-auditor directive — iter-260

Audit the Lean files modified this iteration for outdated comments, suspect
definitions, dead-end proofs, and bad Lean practices. Report as Lean, with no
bias toward what any strategy claims should be true.

## Files to read (absolute paths)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

## Focus areas
- `pushforwardComp_lax_μ` and its private helpers (`pushforward_μ_eq`,
  `restrictScalars_μ_app`, `forget₂_restrictScalars_μ_hom_tmul`,
  `restrictScalars_μ_app_tmul`, `pushforward_map_restrictScalars_μ_app_tmul`,
  `pushforward_map_app_apply`): were closed this iter. Check the proofs are
  honest (no `sorry`/`admit`/`native_decide` laundering), the `set_option
  backward.isDefEq.respectTransparency false` usages are scoped/justified, and
  that no docstring now contradicts the proof (e.g. an old "~150-LOC
  extendScalarsComp" claim left in a comment).
- `pullbackComp_δ` (the Sq2b consumer): confirm it is genuinely closed.
- `sliceDualTransport` / `dual_restrict_iso` in DualInverse.lean: still carry
  typed `sorry`s. Check the in-body diagnosis comments are accurate, not stale.
- Header/status comments in both files for staleness vs the current sorry set.

Report a per-file checklist + a flagged-issues block (severity-tagged).
