# lean-vs-blueprint-checker — CodimOneExtension (iter-202)

Bidirectionally verify ONE Lean file against its blueprint chapter.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## Focus this iter

The prover added 4 axiom-clean "scheme-to-algebra bridge" declarations in a
new `§3.B` section (Stage 6 Step B substrate):
`exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension`,
`isLocalization_atPrime_stalk_of_affineOpen`,
`open_eq_top_of_subsingleton`, `gammaSpecField_ringEquiv`. The three
pre-existing sorries (`isRegularLocalRing_stalk_of_smooth` L1262,
`extend_of_codimOneFree_of_smooth` L1459,
`indeterminacy_pure_codim_one_into_grpScheme` L1534) are UNCHANGED.

Report bidirectionally:
1. Lean → blueprint: are the 4 new bridges faithful substrate? Any over-weak
   or trivial statement masquerading as the named bridge?
2. Blueprint → Lean: does the chapter document these Step B bridges, or is it
   stale (e.g. the iter-203 Step A1 recipe block — verify it references the
   `RingTheory.CohenMacaulay`-namespaced promoted AB helpers correctly; the
   prover task report warns the plan prose used un-namespaced names
   `RingTheory.isDomain_of_regularLocal` etc. which are WRONG)? Should any of
   the 4 new bridges get a `\lean{...}` pin?

Flag must-fix items with severity. Write your report to task_results.
