Audit my (lane pic-c, run 0092 round 4) work with fresh eyes, in the workspace /home/axel/LeanAlgebraicGeometry-Horizon, project MainProjects/Algebraic-Jacobian-Challenge-Rebuild.

THE FILE: AlgebraicJacobian/Picard/Pic0ChartSeamPairDecided.lean (400 lines, 10 declarations, rooted at AlgebraicJacobian.lean, verified with `lake env lean` giving zero output — no errors, no warnings, no sorries). It is at HEAD, byte-identical to disk.

MY HEADLINE CLAIMS, which are what I want adversarially checked:

1. `seamPair_abelSigmaChartZero_iff` — at the Abel chart at parameter 0 (`abelSigmaChartZero`, whose `rep` binder is discharged by `divFunctorZeroRepresentableBy`), the pair of the two antecedents of `pic0RepresentableByOfCharts` (`IsOpenImmersion.presheaf f` and `Presheaf.IsLocallySurjective zariskiTopology f`) is EQUIVALENT to `∀ S, Subsingleton (pic0Subgroup C S)`. I claim this DECIDES the question four roadmap rows and three file headers call "unmeasured at every V and may be empty everywhere".

2. `injective_abelSigmaChartZero` — antecedent 1's elementwise content is UNCONDITIONAL at this chart, and I claim in the docstring that this is NOT the `V = ⊥` degeneracy of `isChartUniv_bot` (Pic0ChartRestrictedFibreSat.lean) and NOT in tension with `Pic0ChartForkNegativeBranch`'s refutation of chart-map injectivity.

3. `isOpenImmersion_presheaf_of_injective` — I claim that GIVEN coverage, antecedent 1 IS plain elementwise injectivity, so the fibre-product-representability half that Pic0ChartOpenImmersionCriterion prices as a `ChartFibrePresented` datum is not an independent obligation for a lane holding antecedent 2.

WHAT I MOST WANT YOU TO TRY TO BREAK, in this order:

(a) IS THE FILE'S HEADLINE A VACUITY? Specifically: is the equivalence in (1) perhaps trivially true because BOTH sides are false, or both unconditionally true, for reasons that make the statement empty? Check whether `pic0Subgroup C S` could be a subsingleton for trivial reasons in this project's definitions, and whether `abelSigmaChartZero`'s binders (`hdeg` at parameter 0, `IsIntegral (C ⊗ overSpec k k).left`) are actually satisfiable. Note `isDegree_zero` and `chartIndex_iff_isDegree` in Picard/Pic0ChartIndexAdmissible.lean.

(b) DOES CLAIM 2's "NOT THE V = ⊥ DEGENERACY" SURVIVE? Read `isChartUniv_bot` and `restrictedChartFibre_bot` in Picard/Pic0ChartRestrictedFibreSat.lean and Picard/Pic0ChartVMonotone.lean's `isChartUniv_antitone`. My argument is that my chart source is `Spec k` (nonempty) and unrestricted, whereas theirs is the empty scheme. Is that a real distinction, or does antitonicity in V mean my statement is a consequence of theirs / of the same triviality?

(c) IS CLAIM 3 A REDUCTION OR A RESTATEMENT? It consumes antecedent 2, which the board prices as the most expensive antecedent. Is the docstring honest that this is not a cheaper route to the seam? And is the claimed converse (`injective_of_isOpenImmersion_presheaf` in Picard/Pic0ChartOpenImmersionCriterion.lean, which needs no coverage) really the converse I say it is?

(d) EVERY CITED NAME. The header and docstrings cite declarations across files. For each backticked name, check it EXISTS and is in this file's import closure, or is cited by file (which is the house rule here). I already ran a #check pass on 12 of them; please check the ones I did not, especially: `restrictedChartFibre_bot`, `not_restrictedChartFibre_top_of_not_injective`, `instSubsingletonDivFamZarSectionZero`, `chartIndex_iff_isDegree`, `isDegree_zero`, `Pic0ChartForkNegativeBranch`'s theorem names, `Over.sigmaExtension_ext`, `NatIso.isIso_of_isIso_app`, `MorphismProperty.of_isIso`.

(e) ANY PROSE CLAIM IN THE FILE THAT IS A THEOREM NOBODY WROTE. In particular check the header's paragraph "What this does NOT do" and the docstring sentences that make comparative claims about other files' results ("that conclusion is about *that* chart", "the arithmetic data of the chart is idle here"). This project has a standing lesson that self-critical prose and gap lists are the least-audited text in a file and can be wrong in the CHEAP direction.

Report concrete defects with file:line and the exact false sentence, ranked by how much they would mislead a later lane. If a claim survives, say so briefly rather than restating it. Do not edit any source file — report only.
