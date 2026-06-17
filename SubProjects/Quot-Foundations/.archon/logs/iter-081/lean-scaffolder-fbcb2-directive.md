# Scaffolder directive — FBC-B stub (verified header drop-in)

Target: `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean` (currently 0-sorry).

A `mathlib-analogist` pass produced a **verified-to-elaborate** signature (full def +
sorry body, only the `sorry` warning). Source of truth:
`.archon/task_results/mathlib-analogist-fbcb-sig.md` ("Recommended header" block) and
`analogies/fbcb-pullback-equiv-sig.md`. Use that header VERBATIM — do not redesign it.

Action: insert, before `end AlgebraicGeometry` (L251), the two decls from the verified
header:
1. `pullbackGroundRingAlg` (helper `B →+* groundRing X'`).
2. `baseChangeGammaPullbackEquiv` (blueprint `thm:fbcb_global_direct`) — sorry body.
Final `\lean` name MUST be `AlgebraicGeometry.Modules.baseChangeGammaPullbackEquiv`
(place inside a `namespace Modules` within the file's `namespace AlgebraicGeometry`, or
use the report's `namespace AlgebraicGeometry.Modules` block — whichever lands the exact
qualified name). Add `open scoped TensorProduct` if not already in scope.

Then ALSO attempt to add `flatBaseChange_isIso_iff_gammaTensorComparison` (blueprint
`lem:flat_base_change_reduce_global_sections`, L4000): an `Iff` that the sheaf-level
`pushforwardBaseChangeMap` (FlatBaseChange.lean L79) `IsIso` ⟺ the module comparison
`baseChangeGammaPullbackEquiv`'s underlying map `IsIso`. If its signature does not
elaborate cleanly this pass, SKIP it (leave a one-line `/- TODO -/`) — landing
`baseChangeGammaPullbackEquiv` as a real sorry stub is the success criterion.

Constraints:
- These decls are NOT protected — signature freedom is fine, but the analogist header is
  already verified, so prefer it as-is.
- `sorry` bodies only; no proofs.
- Final file must `lake build AlgebraicJacobian.Cohomology.FlatBaseChangeGlobal` with only
  `sorry` warnings, no errors. Verify with `lean_diagnostic_messages` before finishing.
