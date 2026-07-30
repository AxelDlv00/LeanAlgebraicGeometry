All work verified at HEAD: file, roadmap row (status `done`), comment, and the root import. Nothing uncommitted remains from my lane.

## Progress

- **AlgebraicJacobian/Picard/Pic0ChartMultiIndexInterval.lean** (new, 26 declarations, 0 sorries): answered the multi-index `V`-interval question that `Pic0ChartCoverForcesNonInj` explicitly leaves open. Rooted at `AlgebraicJacobian.lean:581`; `lake build` EXIT=0 (8895 jobs); all declarations axiom-clean `[propext, Classical.choice, Quot.sound]` against `AlgebraicGeometry.Jacobian` firing `sorryAx`.
- **AlgebraicJacobian.lean**: one import line.
- **Board**: new row `AJCR.w4-rep.datum.dat-c.c9-chartlocus.abel-noninj.multi-index` → `done`; comment on `chart-restrict` qualifying its carry-off.

The finding. Every landed "this `V` is dead" fact in the tree is stated at `ι := PUnit`, while the assembly (`pic0RepresentableBy_of_restrictedChartFibre`) consumes `mixedParamChart` at arbitrary `ι`. The no-go does **not** transmit through an index-separation premise: `jointlyInjective_iff` splits joint injectivity into index separation *and* per-chart injectivity, and the one-chart theorem concludes only the second. It **does** transmit when the coverage witness index is point-independent (`UniformCoverage`) — which I label in-file as the landed one-chart theorem with `Subsingleton ι` replaced by a named index, not new mathematics. Both halves are composed at `mixedParamChart` itself; that needed no bridge, since it is definitionally `restrictChart` of `abelSigmaChart` pointwise.

## Issues

- **I shipped a vacuity and repaired it.** My first `IndexSeparated` quantified over all tests, which makes it `Subsingleton ι` for *every* family — the empty test decides it via `pic0Sigma_obj_subsingleton_of_isEmpty` plus each source's `⊥` open. A `work-reviewer` audit caught it (I-1495); I reproduced it, then restricted the live predicates to nonempty tests, kept the collapsed form as `IndexSeparatedAll` with `indexSeparatedAll_iff_subsingleton` as its epitaph, and checked the repair is not a slower vacuity (`indexSeparated_satFam` at `ULift Bool`). Two prose defects from the same audit are fixed: the `hV`/full-locus carrier confusion and the "useful half" overclaim. Filed to memory as `probe-new-predicate-at-empty-test`.
- **Stale `index.lock` on the shared ledger** (0 bytes, ~80 min, no live holder). It blocks I-1222's remediation step — my file is staged D in the shared index and I could not clear it after 45 retries. Filed as I-1504 with the enumeration of all 11 staged-D `.lean` paths across both projects, and the order to repair in. I did **not** delete it: while held, the 152 staged deletions are inert, and removing the lock re-arms them. My file is present at HEAD and on disk. Fresh-index committing is unaffected (7 commits, all with clean post-commit `HEAD~1..HEAD` stats).

## Why I stopped

Partly advanced, not complete. The objective — close Pic representability — is not met and no antecedent is discharged. `PointwiseCoverage` at a proper `V` still has no producer, and refuting a refutation is not an inhabitation. What changed is that antecedent 1's route is no longer blocked by refutations aimed at an atlas the assembly does not use, and the condition that would re-block it is now named. Satisfiability of `IndexSeparated` at the *Abel* atlas stays open — my witness uses an empty chart source, which no producer would build, and the file says so.

## Next

pic-h's `neighborhood-point` row (I-1498) is the bridge that would let `not_injective_of_uniformCoverage_of_ne_top` compose with their full-locus chart and close the `⊤` end for the real atlas — I relayed that as I-1506. The `index.lock` needs a human or a lane willing to follow I-1504's four-step order; clearing it without re-adding all 11 paths is strictly worse than leaving it.
