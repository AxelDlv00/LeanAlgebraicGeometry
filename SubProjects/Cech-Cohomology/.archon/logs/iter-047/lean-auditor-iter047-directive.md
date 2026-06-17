# Audit directive — iter-047

## Files to read (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Focus
Six declarations were added near the end of this file this iteration:
`isLocalizedModule_of_exact`, `overlap_target_eq` (private), `presheaf_map_comp₂_apply` (private),
`overlap_section_localization` (private), `qcoh_section_isLocalizedModule`,
`qcoh_section_kernel_comparison`. Pay extra attention to:

1. Proof closures that use `convert`, `congr 1`, `congrArg ... (Subsingleton.elim _ _)`, or bare
   `ext` over thin/subsingleton-morphism goals — confirm each is a GENUINE equality and NOT a
   spurious rfl-term that the LSP accepts but the kernel would reject. (Verify your reads against a
   real build; do not trust LSP-only acceptance.)
2. The `change`-based defeq reductions of `LinearMap.pi` applications — confirm the `change` targets
   are genuinely defeq to the goal, not papering a mismatch.
3. The `set_option maxHeartbeats 1000000` on `qcoh_section_isLocalizedModule` — is the heartbeat
   inflation justified, or hiding a runaway elaboration?
4. Any `@`-explicit instance threading (`@IsLocalizedModule.iso ... (qcoh_section_isLocalizedModule F f)`)
   — confirm it is sound, not bypassing a real instance gap.

Report per-file checklist + flagged issues with severity. Do NOT assume what the declarations are
"supposed" to prove — audit the Lean as Lean.
