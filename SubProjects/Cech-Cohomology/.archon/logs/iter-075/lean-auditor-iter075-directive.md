# Lean audit — iter-075

## Files (read in full)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean

## Focus
- This file received a large proof merge this iter (~500 new lines, lines ~1007–1521): the helper
  chain `unit_pushforward_rFIP_inv`, `restrict_unit_comp`, `inner_beta_chain`,
  `pullbackComp_rFIP_compat`, `pushPull_toRestrict_comm`, `thin_resid5`, `map_op_eqToHom_swap`,
  `pls_eq`, and the target `pushPull_interLegHom_sections`.
- Check for: dead-end / orphaned scaffolding, duplicate helpers (same statement as something in
  Base or CechHigherDirectImage), per-lemma `set_option maxHeartbeats` smells, `eqToHom`/thin-category
  proofs that may be hiding an unsound `rfl` term (kernel-soundness trap), stale docstrings post-split.
- Report whether any helper is unused (declared but never referenced downstream).

## Output
Per-file checklist + flagged issues with severity (must-fix / major / minor). No strategy context needed.
