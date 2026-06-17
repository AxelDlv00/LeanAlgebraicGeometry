# Lean Auditor Directive

## Slug
iter104

## Scope (files)
all (every `.lean` file under `AlgebraicJacobian/`). Absolute paths:

- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/SheafCompose.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Modules/Monoidal.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Functor.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FunctorAb.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/LineBundle.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean

## Focus areas (optional)
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — actively edited this iteration; pay extra attention to a newly-added `theorem cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` whose body uses `rcases n with _ | n'; · omega; · have hPrev : ... := by simp [...]; sorry`. Look for excuse-comments, stale comments that refer to historical iter numbers, and any inline `sorry` that looks accidental.
- `AlgebraicJacobian/Modules/Monoidal.lean` — only **1** sorry, in `instIsMonoidal_W`, with a stand-in comment claiming Mathlib gap. Audit whether the comment is honest or excuse-comment territory.

## Known issues
- All `sorry` occurrences in `BasicOpenCech.lean` are tracked (~7) and known to the review agent — do not flag them just for being sorry. DO flag if a body around a sorry has a stale or excuse comment.
- `Modules/Monoidal.lean` L173 sorry is a long-standing Mathlib upstream gap; do not flag it as new.
- `Jacobian.lean` L179 `nonempty_jacobianWitness` and `Picard/Functor.lean` L190 `PicardFunctor.representable` are long-standing Phase C scaffolding sorries.
- Differentials.lean carries 5 deferred sorries (L122, L636, L957, L974, L1116); the review agent already tracks them.
