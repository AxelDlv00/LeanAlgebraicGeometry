# Directive: lean-auditor

Audit the Lean as Lean. No strategy context is provided intentionally.

## Files to read
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

## Focus
This is a newly created file (one `noncomputable def` plus two `sorry`-bodied
theorems). Pay extra attention to:
- Whether `pushforwardBaseChangeMap` is a sound, non-degenerate construction
  (adjoint-mate composite), or whether the composite typechecks but does not
  actually denote the intended base-change map.
- Whether the two `sorry` sites are honest (a real reduction precedes the
  `sorry` in the affine lemma; the flat theorem is a bare documented `sorry`).
- Dead-end proof shapes, suspect definitions, outdated/over-claiming comments,
  bad Lean practices.

Report a per-file checklist plus a flagged-issues block with severities.
