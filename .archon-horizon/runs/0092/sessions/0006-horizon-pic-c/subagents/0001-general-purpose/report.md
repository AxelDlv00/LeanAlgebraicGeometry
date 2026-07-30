You are surveying the Lean project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (AJCR). Read files, do not edit anything. Answer precisely with declaration names, file:line, and exact statements (binders included).

Context: the seam is `pic0RepresentableByOfCharts` (AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161) with two antecedents: (1) `IsOpenImmersion.presheaf (f i)` for each chart, (2) `Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)`. The Abel chart is `abelSigmaChart` (Pic0AtlasFromDivRep.lean:205) built from a representation `rep : (divFunctor C π n).RepresentableBy D` at a chart index (m, Z) with `deg Z = m * d1 - n`.

QUESTIONS (answer each separately, with evidence):

1. `PointwiseCoverage` — where is it defined, what is its exact statement? What landed theorems produce it or reduce it? List every declaration in the project that CONCLUDES `PointwiseCoverage` or `Presheaf.IsLocallySurjective` for a chart family, with its hypotheses.

2. Pic0ChartCoverageThreshold.lean (pic-h's recent work): what exactly does `admissibleCoverageParameter` mean and what does `exists_uniform_admissibleCoverageChart_eq_univ` state? Full binder list.

3. Is there any landed declaration producing an element of `DivFamZar C R π n` (or `DivFam`) from an effective divisor / from a class — i.e. the "backward realization" direction? Search broadly (names containing ofDivisor, realize, classify, divRepClassify, section, seed). Give exact statements and their hypotheses.

4. What is landed about `h^0 = n + 1 - g` on the chart locus (Pic0ChartLocusH0Rank.lean, Pic0ChartLocusH0One.lean) and about `h^0 >= 2` at high parameter (Pic0ChartCoverageThreshold / Pic0ChartHonestAff)? Exact statements.

5. Does anything in the project state or prove coverage at parameter n = genus C? Is there a declaration saying every degree-zero class over a field is (locally) a chart value at n = g?

Be exhaustive on names but concise in prose. Do not speculate: if you cannot find something, say "no declaration found matching X, searched: <patterns>".
