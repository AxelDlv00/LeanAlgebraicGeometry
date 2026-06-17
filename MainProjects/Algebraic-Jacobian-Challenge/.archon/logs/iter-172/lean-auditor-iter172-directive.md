# Lean Auditor Directive

## Slug
iter172

## Files modified this iter
- `AlgebraicJacobian/Genus0BaseObjects.lean` — Lane A closed PRIMARY 1 (`mvPolyToHomogeneousLocalizationAway_surjective` at L379), refreshed docstrings on `gmScalingP1_chart` (L831-839).
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — NEW file-skeleton (Lane C).
- `AlgebraicJacobian/Jacobian.lean` — refactor-agent purged the L237-263 excuse-comment + refreshed the `genusZeroWitness` docstring at L182-208 (Route C realignment).
- `AlgebraicJacobian.lean` — umbrella gained one import line.

## Audit scope
Whole-tree read of every `.lean` file under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/` + the umbrella file `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`.

## Focus areas (extra attention)
- **Excuse-comment hygiene** in the post-refactor `Jacobian.lean` (the iter-171 lean-auditor `CRITICAL` finding triggered this refactor — verify the cleanup is real and no new excuse-comments appeared elsewhere).
- **`RiemannRoch/WeilDivisor.lean` scaffolding quality** — new file, 9 pinned declarations + 1 helper struct `PrimeDivisor` carrying a placeholder field `isCodim1AndIntegral : True := trivial` (called out in the prover's task result as honest scaffolding; verify it isn't load-bearing for anything substantive yet).
- **`Genus0BaseObjects.lean` PRIMARY 1 closure** — verify the `mvPolyToHomogeneousLocalizationAway_surjective` proof at L379 is sound (~140 LOC). Pay attention to `gen_eq_pow` helper (intricate `Localization.mk_eq_mk_iff` chain) and the `MvPolynomial.induction_on` step.
- **Stale-narrative blocks in fallback-route files** — iter-171 auditor flagged 4 stale blocks (ChartAlgebra, GrpObj, RigidityKbar, AVR iter-tag drift) that were deferred. Spot-check whether any new drift accumulated.

## Output expectations
Per-file checklist + a flagged-issues block. Use severity must-fix-this-iter / major / minor. Recommendations seed `recommendations.md`.

## Paths
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/SheafCompose.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityLemma.lean`
