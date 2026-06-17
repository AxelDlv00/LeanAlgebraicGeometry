# lean-auditor directive — iter-238

## Files to audit

Primary (received substantial new prover work this iter — a new §5 added around lines 730–863):
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Focus areas

- Pay extra attention to the new declarations in §5 (roughly lines 730–863):
  `tensorObj_assoc_iso_invertible`, `tensorObj_middleFour`, `IsInvertible.tensorObj`,
  `isInvertible_unit`, `IsInvertible.inverse_unique`, `picSetoid`, `PicGroup`,
  `picMul`, `picInv`, and the `picCommGroup : CommGroup (PicGroup X)` instance.
- Also re-check the modified declaration `tensorObj_assoc_iso` (~line 341): its three
  hypotheses were dropped this iter, making it unconditional. Confirm the body genuinely
  does not depend on the dropped hypotheses (no vacuity / no hidden use) and that the
  decl is a real construction, not a degenerate one.
- For each new `def`/`theorem`/`instance`: is it a genuine, non-vacuous construction?
  Flag any that are trivially true, circular, or that secretly rely on a `sorry`'d
  upstream lemma. Flag any `Classical.choose` usage whose well-definedness is not
  actually established.
- Note any outdated comments, dead-end proof scaffolding, or bad Lean practices.

## What NOT to do

- Do not assume what these declarations "should" prove — audit the Lean as Lean.
- Report per-file checklist + a flagged-issues block.
