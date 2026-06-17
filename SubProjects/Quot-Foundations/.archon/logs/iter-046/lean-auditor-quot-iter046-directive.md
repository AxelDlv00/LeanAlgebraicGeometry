# lean-auditor — QuotScheme iter-046

## Files to audit
- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`

## Focus
Two declarations were added near lines 2718–2769:
- `AlgebraicGeometry.Scheme.Modules.annihilator_map_basicOpen`
- `AlgebraicGeometry.Scheme.Modules.annihilator_ideal`

Audit for: honesty (no vacuous/trivial statements, no `sorry`/`admit`, no `nativeDecide`),
axiom cleanliness, dead/unused hypotheses, the `set_option backward.isDefEq.respectTransparency false`
usage, the `Module.compHom` + `IsScalarTower.of_algebraMap_smul` instance idiom, and any
outdated/misleading docstrings or excuse-comments. Note pre-existing protected `sorry` stubs
(lines ~126/165/201/228) only if relevant — they are tracked, not new.

## Output
Per-file checklist + flagged-issues block with severities.
