Confirmed: nothing durable is uncommitted. The post-commit mutation was `/tmp/p3r5vac.lean`, a throwaway `#check` probe outside the project that I created and deleted in a single command; it produced no durable change. All four paths I authored hash-match HEAD, and no scratch remains in the project.

## Progress

- **`Picard/Pic0ChartHonestAff.lean`** (new, rooted, 229 lines, 5 declarations, 0 sorries): CHART-U(b) openness now reaches the R2 carrier. `abelDivAff'_isPlusHonest` — the widened Abel value is plus-honest at an **arbitrary** test and **arbitrary** widened section, no chart-typed preimage assumed; then `chartValueAff_isPlusHonest`, `isOpen_chartLocus_chartValueAff`, and (added after audit) `chartLocusAffineLocal_chartValueAff` + `chartLocusOpensChartValueAff`.
- **Board**: new row `chart-u-aff` claimed → done → released, pinned `03df3b87ba`. Retitled the stale `chart-u` row whose title still advertised "3 missing inputs" that landed rounds ago.
- Verification: `lake env lean` EXIT=0 zero diagnostics; module build EXIT=0 (8998 jobs); all five axiom-clean `[propext, Classical.choice, Quot.sound]` against **two** controls that both fire `sorryAx`. Both theorems also pass I-1259's vacuity test — the widened carrier occurs in the *conclusion*, not only a hypothesis.

**Which item and why third.** p1 landed the widened Σ-chart hours before me, giving `abelSigmaChartAff` exactly the type `pic0RepresentableByOfCharts` consumes — and thereby re-opened the carrier-target gap one level up: openness closes on `IsPlusHonest`, whose four producers were all chart-typed. Zero declarations related `IsPlusHonest` to any widened object. So the carrier the human decision mandates reached the seam's *input type* but not its *openness antecedent*.

**State: closed sorry-free, no gate cleared.** `IsChartUniv`, Zariski-local surjectivity and `rep` untouched; `(divFunctorAff C n).RepresentableBy` still has zero producers. Honesty at an *arbitrary* `picEt` class remains open and I did not approach it.

## Issues

A fresh-context audit refuted **four of my prose claims**; all reproduced before accepting, all fixed at `03df3b87ba`:
- My `picEtAffineEquiv_abelDivAffPlus` was a byte-identical duplicate of p1's `picEtAffineEquiv_abelDivAff'`, landed the same round *in the file my docstring cited by line*. Deleted. My "exists only as an anonymous `have`" was a stale read — I corrected memory I-1225, since the lesson I published rested on it.
- A paragraph headed "the two tools genuinely disagree" suppressed `linter.unusedSectionVars` on a false premise about `IsPlusHonest`'s binders. The linter was right.
- `unit_surjective_of_section` is outside this file's import closure — now a flagged citation.
- I was **understating**: the openness discharges the `chartLocusOpens` `haff` bridge three sites still price as owed (I-1238). Added two declarations rather than only noting it.

Filed: I-1224, I-1225 + correction, I-1250 (warned p2 their uncommitted file reddened the root build — an error I'd hit twice myself; they fixed it), I-1255.

## Why I stopped

Objective complete for this round: claimed, closed sorry-free with the new theorems' antecedents witnessed, audited, repaired, committed, verified byte-identical at HEAD. The root build was red mid-session in p2's uncommitted file, never mine.

## Next

A producer of `(divFunctorAff C n).RepresentableBy` is the AJCR bottleneck; per I-1216 antecedent 1 is *downstream* of it. A `rep` producer no longer also owes CHART-U(b) on this carrier. Weigh I-1248 first — it argues the R2 widening has a certificate producer and no classifier tower.
