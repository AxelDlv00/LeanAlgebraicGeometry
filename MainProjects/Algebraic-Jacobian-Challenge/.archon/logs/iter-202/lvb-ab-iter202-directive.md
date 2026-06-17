# lean-vs-blueprint-checker — AuslanderBuchsbaum (iter-202)

Bidirectionally verify ONE Lean file against its blueprint chapter.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

## Focus this iter

The prover closed `auslander_buchsbaum_formula_succ_pd` fully (was `sorry`,
now complete and axiom-clean) and the main `RingTheory.auslander_buchsbaum_formula`
is now axiom-clean. 4 new helper lemmas were added:
`enat_ab_inductive_combine`, `projectiveDimension_ker_eq_of_surjection`,
`Module.depth_ses_ineqs_of_surjection_finite_localRing`,
`Module.exists_ne_zero_ext_of_depth_eq`. Three decls had `private` removed:
`auslander_buchsbaum_formula_succ_pd`, and (in the `RingTheory.CohenMacaulay`
namespace) `isDomain_of_regularLocal` and
`regularLocal_quotient_isRegularLocal_of_notMemSq`.

Report bidirectionally:
1. Lean → blueprint: are the closed proof and the new helpers faithful to the
   blueprint's stated lemmas? Any fake/placeholder/over-weak statement? Any
   `\lean{...}` pin pointing at a now-renamed/wrong declaration? Note the
   `RingTheory.CohenMacaulay` namespace on the two promoted helpers (the plan
   prose referred to them without the `.CohenMacaulay` segment).
2. Blueprint → Lean: is the chapter now stale (still describing `_succ_pd` as
   open / future-tense, gap tables claiming Stacks 00MF still needed when it
   was obviated, the NOTE asking to remove `private`)? Does the chapter need a
   `\lean{...}`-pinned block for any of the 4 new helpers?

Flag must-fix items with severity. Write your report to task_results.
