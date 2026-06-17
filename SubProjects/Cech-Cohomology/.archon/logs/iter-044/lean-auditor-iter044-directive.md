# lean-auditor — iter-044

Audit the Lean code in this project for outdated comments, suspect definitions, dead-end
proofs, bad Lean practices, and over-claiming comments. Report as Lean, with no bias toward
what any strategy claims should be true.

## Files (absolute paths)

Primary (received prover work this iter):
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

Context files (read-only, for cross-reference of the new decls' dependencies):
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`

## Focus areas

This iter added 5 new declarations near lines 760–895 of QcohTildeSections.lean:
`appTop_appIso_inv_eq_res`, `key_morph`, `tile_appIso_comp`, `tile_section_ring_identity`,
`tile_scalar_compat`. Pay extra attention to:

- Whether each new declaration's PROOF actually closes its STATED goal (no spurious-rfl /
  kernel-soundness trap — the project has a documented trap where `ext`/`congr 1`/`Subsingleton.elim`
  auto-close subsingleton-morphism goals with a term the LSP accepts but `lake env lean` rejects;
  re-verify with a fresh build / `#print axioms`, do not trust LSP-only).
- Whether the in-file block comments (especially the long "DONE (iter-044)" / "PROVEN tactic prefix"
  comments around lines 895–940) over-claim or contain stale/contradictory statements.
- Deprecated API usage (e.g. `Sheaf.val` / `.val.obj` deprecation warnings).
- Whether `tile_scalar_compat` is genuinely the scalar-compatibility statement it claims, and whether
  the dead-end comments about `tile_section_localization` accurately describe the remaining obstruction.

Report per-file checklist + a flagged-issues block with severity. Do NOT read STRATEGY.md / PROGRESS.md.
