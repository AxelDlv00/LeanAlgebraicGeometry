# lean-auditor directive — iter-215

## Files to audit (absolute paths)

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Focus areas

- This file received prover work this iter: a new ~75-LOC `noncomputable def
  restrictScalarsRingIsoTensorEquiv` was added near the top of the file. Audit it
  as Lean: is it a genuine, complete construction (no hidden `sorry`, no
  `admit`, no vacuous statement), is the `LinearEquiv.ofLinear` round-trip
  actually discharged, and are the `change`/`show`-heavy tactic blocks honest
  (not masking an `exact?`/`sorry`)?
- Confirm the four pre-existing typed `sorry` bodies are still genuine typed
  sorries (not laundered): `isLocallyInjective_whiskerLeft_of_W` (~L546),
  `tensorObj_restrict_iso` (~L1082), `exists_tensorObj_inverse` (~L1125),
  `addCommGroup_via_tensorObj` (~L1164).
- Flag any outdated comments / docstrings that no longer match the code (the
  prover updated several docstrings this iter referencing the new helper).
- The file has a known false-positive `opaque` scan warning at ~L1040 (the word
  "OPAQUE"/"opaque" appears in a docstring) — do NOT flag that as a real
  `opaque` declaration.

That is the full scope. Report a per-file checklist plus a flagged-issues block
with severities.
