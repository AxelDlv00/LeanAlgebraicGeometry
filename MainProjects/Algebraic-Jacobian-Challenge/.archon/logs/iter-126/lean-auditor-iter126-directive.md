# Lean Auditor — iter-126 (Archon canonical) directive

Audit every `.lean` file under `AlgebraicJacobian/` (the project's
Lean source tree). The iter-126 plan-phase executed two structural
refactors:

1. **`refactor-m1-excise-iter126`** — removed 7 declarations from
   `AlgebraicJacobian/Differentials.lean` (the M1 bridge theorem
   `relativeDifferentialsPresheaf_equiv_kaehler_appLE`, the
   `appLE_isLocalization` Step 0 helper, and 5 support helpers).
   File dropped 572 → 144 lines (~428 LOC removed).
2. **`refactor-m2a-scaffold-iter126`** — created new file
   `AlgebraicJacobian/RigidityKbar.lean` with the named declaration
   `AlgebraicGeometry.rigidity_over_kbar` (single `sorry` body).
   File: 87 lines total.

Both refactors are claimed to have left the project compiling cleanly
with kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`)
on retained declarations + the one new scaffold `sorry` on
`rigidity_over_kbar`.

## Files to audit (absolute paths)

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean` (REWRITTEN this iter; verify the retained standalone utilities are clean post-excise, no stale comments or orphan imports)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean` (NEW this iter; verify the scaffold declaration is well-shaped, comments aren't excuse-prose, the encoding choice note is mathematically honest)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean` (carried forward)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean` (carried forward)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean` (carried forward)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean` (carried forward; the OFF-LIMITS `nonempty_jacobianWitness` sorry at L179 stays)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (carried forward)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/SheafCompose.lean` (carried forward)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` (carried forward)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` (carried forward)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (carried forward)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean` (umbrella; one new import line added for `RigidityKbar`)

## Focus areas (do not let these bias the audit)

- The iter-124 lean-auditor flagged comment-bloat / iter-loop narrative
  bleed inside `Differentials.lean` L332-L397 — those lines are
  EXCISED this iter, so the flag should auto-resolve. Verify the
  retained 144-line `Differentials.lean` does not carry residual
  excuse-comments or stale headers referencing the deleted material.
- The iter-126 `RigidityKbar.lean` file is brand-new. Verify the
  encoding-choice note (Option B abstract genus-0 curve, not literal
  `Spec.map MvPolynomial.C`) reads as an honest design disclosure
  rather than an excuse for not landing the literal `ℙ¹` API.
- Multiple carry-over files have iter-loop narrative cruft from prior
  iters; flag any that have become stale relative to the post-excise
  Lean state.

## Output

Write your report to `.archon/task_results/lean-auditor-iter126.md`
(the wrapper will place it there). Per-file checklist + flagged-issues
block per your descriptor.
