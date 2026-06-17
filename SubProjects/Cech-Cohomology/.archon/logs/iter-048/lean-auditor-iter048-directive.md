## Files to audit

- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Focus

Two declarations were added this iteration near the END of the file (lines ~1490–1543):
- `isIso_fromTildeΓ_of_quasicoherent` (a non-private `instance`)
- `isIso_fromTildeΓ_app_basicOpen` (a private helper)

Audit these two as Lean. Pay particular attention to:
- Whether any `change` / `suffices ... from` / `haveI` masks a type mismatch or an
  unsound definitional-equality assumption.
- Whether the `IsLocalizedModule.ext` + `linearEquiv` + `e.bijective` closure of
  `isIso_fromTildeΓ_app_basicOpen` is genuine, or papers over a gap.
- Whether the `NatIso.isIso_of_isIso_app` / `IsCoverDense.iso_of_restrict_iso`
  assembly is a real instance-synthesis path (not a vacuous/auto-closed subsingleton
  coherence goal that the kernel would later reject).
- `maxHeartbeats` / `set_option` usage, dead code, outdated comments.

Report a per-file checklist plus any flagged issues with severity.
