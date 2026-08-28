You are auditing the Lean 4 project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (module root `AlgebraicJacobian`, files under `AlgebraicJacobian/Picard/`).

TASK: measure the CURRENT state of the roadmap leaf "CHART-U(a)/(b): the co-signed chartLocus c lambda and isOpen_chartLocus (3 missing inputs, all divRep-free)". I need to decide whether to spend a session on it, so I need facts, not prose.

Read these files (they are the chart-u cluster):
- Picard/Pic0ChartLocus.lean (the `chartLocus` def ~line 244, `mem_chartLocus_iff` ~249)
- Picard/Pic0ChartLocusIsOpen.lean
- Picard/Pic0ChartLocusGeneralTest.lean (its header claims to be "CHART-U(b) AT A GENERAL TEST")
- Picard/Pic0ChartLocusIsoInvariance.lean
- Picard/Pic0ChartLocusPlusFibre.lean
- Picard/Pic0ChartPlusFibreProducer.lean
- Picard/Pic0ChartCoverageAbel.lean, Pic0ChartCoverageNoDrop.lean, Pic0ChartCoverageTest.lean

ANSWER EXACTLY THESE QUESTIONS, each with file:line evidence:

1. What is the FULL Lean statement (verbatim, with all binders and instance arguments) of the top-level openness result(s) — every declaration whose conclusion is `IsOpen (chartLocus ...)` or similar? List each with its file:line and the COMPLETE list of its hypotheses.

2. For each hypothesis of each such openness theorem: does a PRODUCER exist in this project — i.e. a sorry-free declaration whose CONCLUSION is that hypothesis (not one that assumes it)? Search by conclusion shape, and use case-insensitive grep so producers in suffix position are not missed. Report per hypothesis: PRODUCER FOUND (name + file:line) / NO PRODUCER / PRODUCER EXISTS BUT ITSELF HAS UNDISCHARGED HYPOTHESES (name them). Pay special attention to hypotheses named like `hinv`, `IsSplitWitnessIsoInvariant`, `chartLocusAffineLocal`, `plusFibre`, and any datum-shaped class.

3. Which of the named "3 missing inputs" can you actually identify from the files' own docstrings? Quote the sentences that name them, with file:line. Do the named-missing declarations actually not exist? For each name cited in a docstring, check whether it exists at all (grep the whole project including case-insensitively).

4. Are there ANY `sorry` occurrences in these files? Report exact file:line for each.

5. Is `IsSplitWitnessIsoInvariant` a structure/class whose fields MENTION the curve C and the chartLocus data, or is it a vacuity-shaped predicate (fields not mentioning the objects it claims to be about)? Quote its full definition.

Do NOT edit any file. Do NOT run `lake build`. You may use grep/read freely. Report compactly, evidence first, and be explicit about anything you could not determine.
