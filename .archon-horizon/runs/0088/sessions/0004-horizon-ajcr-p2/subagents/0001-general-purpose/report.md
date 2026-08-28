You are measuring, read-only, inside the Lean 4 project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (source root `AlgebraicJacobian/`). Do NOT edit any file and do NOT run `lake build` (nine other lanes contend for the build lock). You may read files and grep. You may use `"$HORIZON_BIN" search "<words>" --json` (spans this project, the sibling project at ../Algebraic-Jacobian-Challenge, and mathlib).

TARGET OF MEASUREMENT: antecedent 2 of `pic0RepresentableByOfCharts` (AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161), namely
`[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]` — roadmap rows `AJCR.w4-rep.datum.dat-b` (B-5/B-6).

Already known, do not re-derive: `Picard/Pic0ChartLocalSurjectivity.lean` reduces the instance to `ChartsCoverLocally`, and `Picard/Pic0ChartCoveragePointwise.lean:128` (`chartsCoverLocally_of_pointwise`) reduces THAT to pointwise data: for every test scheme `T`, every `s : (pic0SigmaSheaf C).1.obj (op T)` and every point `t : ↥T`, an open `W ∋ t`, an index `i`, and `x : (W : Scheme) ⟶ X i` with `(f i).app (op W) x = (pic0SigmaSheaf C).1.map (W.ι).op s`. Both are sorry-free.

WHAT I NEED, as precise file:line facts:

1. Enumerate EVERY declaration in `AlgebraicJacobian/Picard/` whose statement concludes something of the shape "a chart value equals a given pic^0 class" or "every degree-zero class is locally a chart value" — i.e. candidate producers of that pointwise datum. Start from `Pic0ChartCoverageAbel.lean`, `Pic0ChartCoverageNoDrop.lean`, `Pic0ChartCoverageIndexSlack.lean`, `Pic0ChartLocus.lean`, `DivisorFamilyFieldSurj.lean`, `JacobianDataAbelSurj.lean`, `JacobianDataAbelImage.lean`, `JacobianDataCharts.lean`, and anything `horizon search` surfaces. For each: the exact statement (transcribe the signature), whether it is sorry-free, and what its open hypotheses are.

2. For the strongest such candidate, state EXACTLY what remains between it and the `chartsCoverLocally_of_pointwise` hypothesis. Be specific about carriers: what type is the index, what type is the neighbourhood (an open of the test, a set, a cover map?), does the chart source `X i` match `(V i : Scheme)` for the real atlas (`mixedParamChart`, Pic0ChartAtlasParamFree.lean:86-94)?

3. Report whether any candidate is stated at ONE test only, or for an arbitrary test scheme `T`. Several files in this tree prove things for affine tests `Spec S` only and the general-test extension is open work (see the pattern at `DivisorFamilyH1Locus.lean`). Say clearly which side each candidate is on.

4. Check the sibling project /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian for anything concluding local surjectivity of an Abel/divisor chart family onto a Picard functor, or the Riemann-Roch surjectivity "every degree-0 class is O(D-Z) with D effective of degree g" in a form usable over a general base test. Give file:line.

5. Finally: name the single smallest Lean statement whose proof would put the pointwise datum in hand, and say honestly whether its own inputs exist in the tree. If the honest answer is "the geometry is not there", say that plainly with the evidence.

Report as a compact list of file:line + transcribed signature + verdict. No prose padding. Do not speculate about what "should" exist — measure.
