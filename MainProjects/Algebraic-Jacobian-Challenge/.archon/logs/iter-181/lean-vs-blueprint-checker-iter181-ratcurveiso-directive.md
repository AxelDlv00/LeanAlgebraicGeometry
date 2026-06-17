# Lean vs blueprint check — RationalCurveIso iter-181

## File

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

## Chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`

## What happened this iter

Lane I prover mutated the signature of `iso_of_degree_one` (Pin 3) at
line 386 of the file:

- **Before** (iter-177 file-skeleton): hypothesis was
  `Nonempty (C'.left.functionField ≃+* C.left.functionField)` —
  documented as a weak placeholder.
- **After** (iter-181, per analogist recipe Decision 2
  `DIVERGE_INTENTIONALLY`): hypothesis is
  `[Algebra C'.left.functionField C.left.functionField]` +
  `_hφ_deg : Module.finrank C'.left.functionField C.left.functionField = 1`.

The prover task_result notes that "chapter prose re-tightening happens
iter-182 plan-phase" — provers don't edit the blueprint. So the chapter
prose may still describe the OLD (existence-iso) hypothesis shape.

## Audit questions

1. Does the new Lean signature of `iso_of_degree_one` match the
   chapter's lemma block (label `lem:degree_one_morphism_iso`)?
2. The new typeclass binder `[Algebra C'.left.functionField
   C.left.functionField]` — is the canonical call-site instance
   (the `φ`-induced function-field map) documented in the chapter?
3. Pin 2 `morphism_degree_via_pole_divisor` (L310) — does its
   signature still match the blueprint's lemma block?
4. The iter-181 docstring updates (analogist recipe at
   `analogies/ratcurveiso-pin3.md`) — does the chapter need a
   `% NOTE:` pointer to the analogist recipe for future readers?

## Output

Standard lean-vs-blueprint-checker report. Flag whether
`complete:` / `correct:` are satisfied for the chapter after the
iter-181 signature mutation; if the chapter prose was written for the
pre-iter-181 shape, flag it as a blueprint-writer follow-up needed.

## Read scope

- The Lean file in full.
- The blueprint chapter in full.
- The persistent analogist file `analogies/ratcurveiso-pin3.md`
  (so you can compare the Decision 2 recipe against the landed shape).
- No other context.
