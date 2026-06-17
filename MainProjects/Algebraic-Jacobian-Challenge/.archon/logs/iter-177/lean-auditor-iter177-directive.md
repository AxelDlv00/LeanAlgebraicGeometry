# Lean Auditor Directive

## Slug
iter177

## Scope (files)
Whole project. Pay extra attention to the 8 files edited this iter:

- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/OCofP.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuotScheme.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RelPicFunctor.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/AlbaneseUP.lean (new file)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/CodimOneExtension.lean (new file)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean (new file)

Note: `AlgebraicJacobian/RiemannRoch/OCofP.lean` is BUILD-BROKEN — last line fails to synthesize `Scheme.IsRegularInCodimensionOne C.left` at L335.

## Focus areas

- GmScaling.lean: two new named axioms `gmScalingP1_chart_data_temp` and `gmScalingP1_collapse_at_zero_temp` — are their docstrings honest about what they assume?
- WeilDivisor.lean: introduces new typeclass `Scheme.IsRegularInCodimensionOne` — design quality / parallel-API risk vs. Mathlib?
- The 3 new file-skeleton files (AlbaneseUP.lean, CodimOneExtension.lean, RationalCurveIso.lean): are declared types non-tautological?
- QuotScheme.lean: `canonicalBaseChangeMap_isIso` helper-with-sorry pattern — clean encoding or sorry-laundering?

## Known issues

- OCofP.lean L335 build failure is known; do not re-flag the synthesis error itself but DO flag any related comments / structural smells.
