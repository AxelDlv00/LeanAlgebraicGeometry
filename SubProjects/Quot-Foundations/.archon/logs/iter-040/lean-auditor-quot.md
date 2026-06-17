# lean-auditor directive — iter-040

## Files to audit (absolute paths)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Focus
The prover added 4 new declarations near the END of the file (lines ~1950–2030):
- `compositeBasicOpenImmersion` (def)
- `pullback_composite_immersion_isIso_fromTildeΓ` (theorem)
- `compositeBasicOpenImmersion_isOpenImmersion` (instance)
- `compositeBasicOpenImmersion_opensRange` (theorem)

Pay attention to:
- Whether these 4 new decls are honest (no hidden `sorry`, no `native_decide`, no
  vacuous/placeholder statements, no axiom leakage beyond {propext, Classical.choice, Quot.sound}).
- Whether the `@`-positional instance passing (`@isIso_fromTildeΓ_of_iso _ _ _ e ...`) and the
  explicit `@Scheme.Modules.fromTildeΓ (...)` form mask any defeq abuse or fragile `rfl`.
- Any dead/orphaned helper introduced and abandoned this iter.
- Stale/inaccurate roadmap comments on the 4 protected scaffold stubs (lines 126/165/201/228) or on
  the new section.
- The 4 pre-existing protected `sorry` scaffold stubs (lines 126/165/201/228) are KNOWN
  (iter-176 file-skeleton). Note them but they are not new findings.

Audit the Lean as Lean. Do not assume what the strategy claims should be true.
