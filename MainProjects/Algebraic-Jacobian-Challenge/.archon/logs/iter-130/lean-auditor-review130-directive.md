# Lean Auditor Directive

## Slug
review130

## Files to audit (whole project)

Read every `.lean` file under `AlgebraicJacobian/`. Pay extra attention to
files touched in the last 3 iterations (most likely to carry drift):

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean`
  — body of `cotangentSpaceAtIdentity` was edited this iter. Check for
  excuse-comments, suspect uses of `Classical.choice`, and docstring
  drift relative to the actual body.
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
  — carries two known `sorry` bodies; check whether the docstring
  enumeration / "single remaining sorry" prose is consistent with the
  current state.
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean`
  — carries one known `sorry` body.
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean`
  — imported by the iter-130 prover work; consumed `smooth_locally_free_omega`.

Also audit the rest of the project for general hygiene:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/SheafCompose.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean`

## Focus areas

1. **Excuse comments** in the active prover-touch file (`Cotangent/GrpObj.lean`).
   Specifically the docstring's "Caveat on canonicity" paragraph and the
   in-body comment about `Classical.choice` — flag if the comment is
   admitting the construction is incorrect rather than honestly
   describing a design tradeoff.

2. **Body-vs-docstring consistency** on `cotangentSpaceAtIdentity`. The
   declaration docstring claims the body uses Replacement (B)
   chart-base-change; check that the actual body matches that description.

3. **Stale per-decl prose** in `Jacobian.lean` — there are two known
   `sorry`-bodied declarations but the file may still carry docstring
   phrases like "the single remaining mathematical sorry" that pre-date
   the second sorry's creation.

4. **General**: dead-end proofs, suspect axioms-as-defs, definitions
   whose body contradicts their name, any other Lean-hygiene issue
   regardless of strategy.

## Output

Per-file checklist + flagged issues block, severity-tagged
(critical / major / minor). Write to your standard task_results path.
