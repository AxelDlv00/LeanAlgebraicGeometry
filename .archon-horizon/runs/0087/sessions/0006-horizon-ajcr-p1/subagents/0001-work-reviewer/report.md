You are auditing work by lane `ajcr-p1` in the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon, project MainProjects/Algebraic-Jacobian-Challenge-Rebuild.

TARGET: the new file `AlgebraicJacobian/Picard/Pic0ChartVMonotone.lean` (commits c2e6be0573 area, then HEAD d33634cd92 — but note the shared-ledger misattribution problem, so audit the file ON DISK, and check it matches HEAD by content hash).

Its claims, which you should try hard to REFUTE:
1. `isChartUniv_antitone` — antecedent 1 of `pic0RepresentableByOfCharts` is antitone in V.
2. `isLocallySurjective_sigmaDesc_mono` — antecedent 2 is monotone in V, AT THE LEVEL OF THE INSTANCE the seam consumes (not the `hcov` spelling).
3. `isLocallySurjective_unrestricted` — antecedent 2 at ANY family of opens implies it for the UNRESTRICTED family `Sigma.desc f`. The file calls this its "substantive content" and says it means a coverage lane "cannot buy relief by restricting".
4. `pic0RepresentableBy_of_nested` — the seam fires from two nested opens Vc ≤ Vf.
5. `nested_iff_shared` / `shared_top_of_nested` — the nesting generalisation is EQUIVALENT to the shared-V form, so it buys nothing.

WHAT I MOST WANT CHECKED, in priority order:

(a) IS CLAIM 3 REALLY NON-TRIVIAL, OR IS IT SECRETLY VACUOUS/CIRCULAR? Specifically: `restrictChart_top` is proved by `rfl` using `Scheme.topIso.hom`, which is *defined* as `(⊤ : X.Opens).ι`. Does that make claim 3 a tautology in disguise, or does it genuinely say something about arbitrary V? Also: is the direction right? I claim monotone lifts V *upward* to ⊤. Verify the ⊤ step actually strips the factor rather than assuming what it proves.

(b) DOES `nested_iff_shared` ACTUALLY QUANTIFY OVER WHAT IT CLAIMS? It is stated with existentials over open families for a FIXED chart family f. Is the forward direction doing real work, or is it `P → P`? Is there any weakening — e.g. does it state antecedent 1 as `IsOpenImmersion.presheaf (restrictChart ...)` where the seam actually needs `RestrictedChartFibre`, and if so does that make the biconditional about a different pair than the one the board cares about?

(c) IS `pic0RepresentableBy_of_nested` A GENUINE GENERALISATION or does its own proof reveal it is just the special case? Its proof reduces to `mixedParamRepresentableBy` at Vc. Check whether the Σ-typed conclusion hides anything (compare `pic0RepresentableBy_of_restrictedChartFibre_of_coverage` in Pic0ChartRestrictedFibre.lean, which has the same Σ shape). Also check it does NOT discharge any antecedent — I claim rep/huniv/hcov all remain hypotheses.

(d) HEADER HONESTY. Read every sentence of the module docstring against the actual statements. This project has a recorded failure mode where docstrings cite declarations that do not exist in the file's import closure — check every declaration name the header cites with `#check`, not grep (see inbox I-0994, I-1073). Particularly: does `Pic0ChartRestrictedFibreSat.lean:93-98` say what I claim it says? Does `Pic0ChartCoverageAffineTest.lean` contain the reduction I attribute to it? Is `not_coverageContainment_bot` correctly described?

(e) Verify sorry-freeness and axiom-cleanliness YOURSELF, and check imports are current BEFORE believing any probe (this project has a recorded stale-import trap where `lean_multi_attempt` reports every snippet as succeeding). Use a control declaration that SHOULD fire sorryAx (e.g. `AlgebraicGeometry.Jacobian`).

Do not fix anything. Report: which claims survive, which are refuted or overstated, with the exact statement text and the measurement that shows it. Be specific about the difference between "the implication is proved" and "the conclusion holds". If you find nothing wrong, say so plainly rather than inventing a finding — but check (a) and (b) hardest, since those are where I would expect my own error.
