# lean-auditor directive — iter-221

## Files to audit

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

This file received prover work this iteration. Audit the WHOLE file as Lean code,
with no bias toward what any strategy claims should be true.

## Focus areas (do not let these limit a full audit)

- The newly-added declarations near the `PresheafOfModules.dual` / `InternalHom`
  sections (approx lines 1300–1400): `dual`, `termRingMap_terminal`, `evalLin`,
  `evalLin_add`, `evalLin_smul`, `internalHomEvalApp`. Confirm each is genuinely
  proved (no `sorry`, no `admit`, no axiom escape hatch) and the statements are not
  vacuous / weakened / placeholder.
- Verify axiom-cleanliness of `dual` and `internalHomEvalApp` first-hand (e.g.
  `#print axioms` / `lean_verify`): expected `{propext, Classical.choice, Quot.sound}`.
- The `@[implicit_reducible]` attribute on `internalHomObjModule` — confirm it is
  present at the def site and correctly placed.
- Pre-existing `sorry` sites (expected 3, around the whiskering/stalk apparatus).
  Report their exact current line numbers; do NOT count them as new regressions.
- Stale docstrings / status-comment blocks that misreport the sorry status of
  now-complete declarations.

Read the file at its absolute path under the project root. Report a per-file
checklist plus a flagged-issues block with severities.
