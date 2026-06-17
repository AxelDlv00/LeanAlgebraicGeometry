# Lean ↔ Blueprint Checker Directive

## Slug
chartalgebra-iter152

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean

## Blueprint chapter
blueprint/src/chapters/RigidityKbar.tex

## Known issues
- This iter performed an architectural pivot: `[IsAlgClosed k]` + `[IsDomain B]` were added to `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`; `[IsAlgClosed k]` was added to `constants_integral_over_base_field` (and its body re-routed to a single `sorry`); `[IsAlgClosed k]`+`[IsDomain B]` propagated to `df_zero_factors_through_constant_on_chart`. The blueprint chapter RigidityKbar.tex was rewritten this iter to reflect these new hypotheses. Your primary job: verify the rewritten chapter's `\lean{...}` blocks and signatures MATCH the new Lean signatures (the alg-closed hypotheses must be present on both sides), and that the KDM proof sketch is consistent with the now-TRUE statement (the prior bare-`B` statement was mathematically false; counterexamples `B = k×k` and `ℚ(√2)/ℚ`).
- The 9-sorry headline is known; the KDM lemma and constants lemma carry open `sorry`s by design this iter. Report them as open obligations, not as fake/placeholder unsoundness — UNLESS the chapter prose claims a closed proof while the Lean has a sorry (prose-vs-Lean status divergence), in which case flag it.
