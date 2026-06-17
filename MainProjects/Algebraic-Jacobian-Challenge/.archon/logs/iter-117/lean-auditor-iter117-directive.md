# Lean Auditor Directive (iter-117)

## Slug

iter117

## Scope (files)

all

## Focus areas (optional)

Particularly:

- Any declaration whose statement (signature) is mathematically WRONG
  — e.g. an iff that is actually a one-sided implication, a missing
  hypothesis that makes the claim false, a stand-in placeholder
  definition that doesn't match the named concept.
- Excuse comments ("temporary wrong", "will fix later", "deferred", etc.).
- Inline `sorry` sites whose surrounding docstring claims the body is
  mathematically impossible without further Mathlib infrastructure,
  but the claim is actually closeable from what Mathlib b80f227 has.
- Any `axiom` declarations.

## Known issues (do not re-report)

- The 16 inline `sorry` sites (file:line listed below). These are
  known; what you should report is whether any of them is on a
  **statement that is false** or **a stand-in placeholder definition**.
  A true-but-currently-unproved statement is NOT must-fix.
  - `Cohomology/BasicOpenCech.lean`: L1120, L1212, L1536, L1564, L1754, L1846.
  - `Differentials.lean`: L191, L737, L931, L947, L1091.
  - `Modules/Monoidal.lean`: L173.
  - `Picard/LineBundle.lean`: L82, L96.
  - `Picard/Functor.lean`: L181.
  - `Jacobian.lean`: L179.

- 2 deprecation warnings on `Differentials.lean` L933/L950
  (`IsSmoothOfRelativeDimension`) — known, awaiting Mathlib bump
  recipe. Do not re-flag unless severity is now major.
- 1 line-length linter on `Differentials.lean` L846 — known, cosmetic.

## Absolute paths to read

The project root is `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge`.

`.lean` files to audit:

- AlgebraicJacobian.lean (the umbrella module)
- AlgebraicJacobian/AbelJacobi.lean
- AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- AlgebraicJacobian/Cohomology/SheafCompose.lean
- AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- AlgebraicJacobian/Differentials.lean
- AlgebraicJacobian/Genus.lean
- AlgebraicJacobian/Jacobian.lean
- AlgebraicJacobian/Modules/Monoidal.lean
- AlgebraicJacobian/Picard/Functor.lean
- AlgebraicJacobian/Picard/FunctorAb.lean
- AlgebraicJacobian/Picard/LineBundle.lean
- AlgebraicJacobian/Rigidity.lean

Do NOT read:

- `references/challenge.lean` (it has 9 placeholder sorries by design;
  it is the original challenge file, not project code).

## Output target

`.archon/task_results/lean-auditor-iter117.md` per the descriptor's
standard format. Apply standard severity classifications; do not soft-
classify wrong-decision findings.
