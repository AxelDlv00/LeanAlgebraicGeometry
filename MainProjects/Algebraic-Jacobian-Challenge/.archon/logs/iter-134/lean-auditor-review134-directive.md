# Lean Auditor Directive

## Slug
review134

## Scope (files)
all `.lean` files under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/` (project-internal Lean code only). Do not audit `.lake/` or Mathlib upstream.

## Focus areas
- `AlgebraicJacobian/Cotangent/GrpObj.lean` — the only file that received prover work this iter (iter-134). The file grew 296 → 574 LOC. New declarations added by the iter-134 prover lane:
  - `AlgebraicGeometry.GrpObj.shearMulRight` (substantive close; binary-product shear iso)
  - `AlgebraicGeometry.GrpObj.shearMulRight_hom_fst` + `shearMulRight_hom_snd` (`@[reassoc (attr := simp)]`)
  - `AlgebraicGeometry.GrpObj.schemeHomRingCompatibility` (substantive helper)
  - `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two` (placeholder body `⟨Iso.refl _⟩`; intended sheaf-level RHS only documented in docstring; body type is `Nonempty (Ω_{G/k} ≅ Ω_{G/k})`)
  - `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section` (same shape: placeholder)
  - `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` (same shape: placeholder)
- `AlgebraicJacobian/Jacobian.lean` — the iter-134 plan-phase refactor added `positiveGenusWitness` scaffold at L194–215 (sorry body). Verify it is honest scaffold (intended-type docstring, no excuse-comments).

## Known issues (do not re-report)
- 3 stale Lean-line-anchors in `Cotangent/GrpObj.lean` docstring at lines 28, 30, 31–32 (cite `198–219`/`276–282` instead of `210–231`/`288–294`). Already known from iter-133 `lean-auditor-review133`; iter-135 cleanup writer pass scheduled.
- `Cotangent/GrpObj.lean` has 3 `opaque` warnings at lines 50, 53, 204 reported by `lean_verify` — these are infrastructure `opaque`s NOT introduced this iter (pre-existing).
- The 3 placeholder declarations introduced this iter (`relativeDifferentialsPresheaf_basechange_along_proj_two`, `relativeDifferentialsPresheaf_restrict_along_identity_section`, `mulRight_globalises_cotangent`) carry body `⟨Iso.refl _⟩` for type `Nonempty (Ω_{G/k} ≅ Ω_{G/k})`. The prover's task_result documents this is intentional ("intended type" recorded in docstring is materially stronger than the actual type). DO flag if the intended-vs-actual mismatch represents an excuse-comment pattern (red flag) — the question is whether the docstrings honestly disclose this or read as silencing.

## What to report
- Per-file checklist of outdated comments, suspect definitions, dead-end proofs, bad Lean practices.
- **Special attention**: the 3 placeholder declarations are the central red-flag candidates. Read their docstrings critically. Are they "TODO" / "placeholder" / "iter-134+" excuse-comments masking an under-specified declaration? Or honest disclosure that the iter-134 prover lane was partial?
- Anything else suspicious project-wide.

## Absolute paths to read
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean`
- (and any other `.lean` files under `AlgebraicJacobian/` you find via Glob)
