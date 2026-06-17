# lean-auditor directive — iter-026

Audit the Lean source for code quality, outdated comments, suspect definitions,
dead-end proofs, and bad Lean practices. Report per-file checklist + flagged issues.

## Primary focus — new this iter
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`
  (created this iter, 10 declarations). Pay attention to:
  - The `noncomputable local instance hasExtModules : HasExt.{u + 1, u, u + 1} X.Modules`
    universe pin — is the explicit universe triple correct/necessary, and does the
    `local instance` form risk anything downstream?
  - `sheafificationHomAddEquiv` proof ends with `erw [Functor.map_add, Preadditive.comp_add]; rfl`
    — confirm the `erw` is genuine (defeq-carrier mismatch) and not masking a fragile rewrite.
  - The three `absoluteCohomology_covariant_exact₁/₂/₃` wrappers and
    `absoluteCohomology_eq_zero_of_injective` — are they faithful thin wrappers or do they
    silently weaken/restate the Mathlib lemma?
  - Any excuse-comments or overstated docstrings.

## Secondary — carried stale-comment debt (verify still-present, do not deep-audit)
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean`
  — prior audits flagged stale module/strategy comments (strategy block ~L77–119 factually
  wrong about the shipped combinator; "gated on Lane-1" wording now false). Confirm which
  remain.

## Out of scope
Do not assess strategy or whether the math is the "right" approach — audit the Lean as Lean.

Absolute paths to read are above. Report to your task_results file.
