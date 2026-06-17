# Lean Auditor Directive

## Slug
review121

## Scope (files)
all

## Focus areas (optional)

- `AlgebraicJacobian/Differentials.lean`
- `AlgebraicJacobian/Jacobian.lean`
- `AlgebraicJacobian/Rigidity.lean`

These three files are named by iter-121's strategic roadmap as
upcoming prover targets (M1 bridge on Differentials.lean; M2 rigidity
specialisation routed through Rigidity.lean to Jacobian.lean). The
audit should still cover **every** `.lean` file in the project per
the descriptor; this is bias-only-toward-thoroughness, not
scope-limiting.

## Known issues

Issues already documented in prior iters' audits — do NOT re-report:

- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` — the
  dead `IsAffineHModuleHomFinite` class + 3 consumers chain
  (lean-auditor-review118 must-fix #1, also re-noted in -review120).
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` — two
  scaffolding classes without producers (review118 major #1).
- `AlgebraicJacobian/Rigidity.lean:62-67` — redundant typeclass
  arguments (review118 major #2).
- Line-length warnings on `AlgebraicJacobian/Differentials.lean`
  L101 + L106 (algebraize call and `Nontrivial` haveI). Review120
  classified these as minor.

Re-flag only if the severity has changed (e.g. has become must-fix
in light of iter-121's strategic pivot). Otherwise list under "Known
findings — re-confirmed" without new severity.
