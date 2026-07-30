You are inspecting the Lean project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (AJCR). READ ONLY — do not edit or commit anything.

Target: the second antecedent of `AlgebraicGeometry.pic0RepresentableByOfCharts` (AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161), namely
`[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]` for the Abel chart family.

I need a precise, current map of what that clause has been REDUCED to and what mathematical input is still missing. Please:

1. Read the file headers + main declarations of the AlgebraicJacobian/Picard/Pic0ChartCoverage*.lean files (there are ~10: CoverageAbel, CoverageAffineTest, CoverageDegree, CoverageDegreeStep2, CoverageFibre, CoverageIndexSlack, CoverageNoDrop, CoveragePointwise, CoverageSlice, CoverageTest, CoverageThreshold) plus Pic0ChartLocalSurjectivity.lean and Pic0AtlasFromDivRepAff.lean and JacobianDataCharts.lean.
2. For each, report in ONE line: what statement it actually proves (the reduced form of coverage it reaches), and what hypothesis/antecedent it still needs (name the exact Lean hypothesis binder or class).
3. Then state, as precisely as you can, the CURRENT weakest-known sufficient condition for the coverage clause at the Abel chart family: give the exact Lean declaration name(s) that would fire, and the list of still-undischarged antecedents with their file:line.
4. Report which of those undischarged antecedents have producers anywhere in the project (use `/home/axel/.archon-env/bin/horizon search "<name>" --json` and grep for the class name to find instances/theorems concluding it), and which have ZERO producers.

Be concrete: exact declaration names, file:line. Do not speculate about mathematics not in the files. Your final message is the return value — make it a compact structured report, no preamble.
