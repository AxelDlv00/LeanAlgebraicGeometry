# Whole-project lean audit — iter-181

## Context

Audit the entire `AlgebraicJacobian/` Lean tree as Lean. No strategy
context is provided. Files touched this iter (per task_results):

- `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean`
- `AlgebraicJacobian/Picard/QuotScheme.lean`
- `AlgebraicJacobian/Picard/RelativeSpec.lean`
- `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean`
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

## Focus areas (this iter)

1. **Inflated "axiom-clean" claims.** Prover task_results adopted the
   3-tier disclosure language new this iter (kernel-clean (this body) /
   kernel-clean modulo upstream X / kernel-clean transitively). Spot-check
   the prover's `#print axioms` claims by running `lean_verify` on the
   named declarations and confirming the disclosure tier matches the
   actual axiom set. Flag any decl where the prover's tier claim is
   too strong (e.g. claimed tier-1 / kernel-clean but `sorryAx` is in
   the axiom set).

2. **Helper inflation pattern.** Routes 5a (Thm32) and 4d (QuotScheme)
   have been adding helper sorries faster than they close them. The
   iter-181 lanes added new helpers in GmScaling (`cross01`),
   AVR (`iotaGm_range_isOpen`), AuslanderBuchsbaum
   (`exists_isRegular_of_regularLocal`), QuotScheme
   (`_of_isAffineOpen_of_isAffineBase`), RRFormula
   (`eulerCharacteristic_sheafOf_zero`,
   `eulerCharacteristic_sheafOf_single_add`), RelativeSpec
   (`pullback_iso_affine_piece`, `pullback_iso_construction`),
   OCofP (`globalSections_iff_mp`, `globalSections_iff_mpr`,
   `toFunctionField`). For each new helper, check whether the helper
   genuinely encapsulates a substantive Mathlib gap (acceptable) or
   reads as a "rename + sorry" laundering (NOT acceptable). Flag any
   helper whose signature is "the original sorry's body with a name"
   without genuine substantive content.

3. **Signature drift on RHS-without-bound-variable.** iter-180 surfaced
   the CRITICAL OCofP `globalSections_iff` signature bug (RHS was
   vacuous-in-`f`). The iter-181 plan-phase refactor fixed it. Scan
   ALL iff/exists statements in the project for the same pattern:
   any `Iff` whose RHS does not syntactically mention every LHS
   hypothesis variable should be flagged.

4. **Dead-end excuse comments / weakened-wrong patterns.** iter-178
   lean-auditor flagged 178A (RatCurveIso excuse-comment). iter-181
   refactored Pin 3's signature; verify the new docstring at L324-381
   does NOT contain residual excuse-comment language.

## Output

Per-file checklist (one section per `.lean` file under `AlgebraicJacobian/`).
For each file:
- Outdated comments referencing iters/dates that should be moved to git
  history.
- Helper-sorry decls whose signature is not substantively different
  from the original (laundering risk).
- 3-tier kernel-cleanness audit on lemmas closed this iter (verified
  against `lean_verify`).
- Any iff/exists signature that doesn't bind hypothesis variables.

Conclude with a `## Critical findings`, `## Major findings`,
`## Minor findings` summary.

Read the listed `.lean` files and audit them as Lean. Do not assume
the prover task_results are correct; verify with `lean_verify` /
`lean_diagnostic_messages` / `lean_hover_info` as needed.

## Absolute paths

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects/Points.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuotScheme.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RelativeSpec.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/OCofP.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/RRFormula.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
