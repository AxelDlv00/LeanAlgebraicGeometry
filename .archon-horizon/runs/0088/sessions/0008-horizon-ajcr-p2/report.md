All three of my authored ledger paths match HEAD byte-for-byte. The file mutations after my last commit were the eight `/tmp` scratch probes (now deleted) and my own agent-memory files under `~/.claude-api/.../memory/`, which are outside this workspace repo. Nothing durable of mine is uncommitted; the last two ledger commits touching my work are `04b46547f6` (the vacuity fix) and `4610f92107` (the row release), and the newer HEAD is another lane's board commit.

## Progress

I claimed **`AJCR.w4-rep.datum.dat-c.c9-chartlocus.locus-h0one`** (new row under `c9-chartlocus`, announced at I-1195). It was the second-most important item because antecedent 1 (`IsChartUniv`) is the one `review-ajcr`'s re-ranked costing calls decidable in a single round, its residue is `exists_factor`, and seven files price that residue as "the relative form of GAP-2" whose field-level keystone `eq_of_picClass_eq_of_h0_one` is landed but unfed — owing three binders. My previous round had reduced the fork to `h⁰ = 1` as the single survivor.

- **`Picard/Pic0ChartLocusH0One.lean` (new, rooted at `AlgebraicJacobian.lean:578`, 5 declarations, 0 code sorries; `lake build` EXIT=0, 8897 jobs, module 22s, zero own diagnostics; all five axiom-clean on `[propext, Classical.choice, Quot.sound]` against a control that fires `sorryAx`; HEAD blob == disk):** all three keystone binders are **free on the chart locus**. `chartLocus` is *defined* through `IsSplitWitness`, whose clause already supplies a divisor in the presenting class with vanishing H¹ — the rank anchor's exact hypothesis. The missing ingredient was never effectivity but **degree**, and the chart-index constraint pins it to `n`, so `h⁰ = deg + χ = 1`; `exists_effective_of_h0_pos` then supplies effectivity. Every link was already landed; nothing related them.
- The sound face to feed downstream is `eq_of_picClass_eq_of_deg_of_subsingleton` — the keystone with `h⁰ = 1` traded for `(deg = n, Subsingleton H¹)`. This is **not** `hb_forces_h0_eq_one`, which needs a threshold its own file proves false at `n = g`; mine needs vanishing at one divisor only.

## Issues

**A commissioned fresh-context audit refuted my two headline theorems as VACUOUS, and it was right** (I-1233, independently reproduced at I-1258). Both quantified existentially over the splitting field *and* the divisor with neither `M` nor `chartTwist` in the conclusion, so `L = κ(t)`, `W = 0` discharged them on any curve with all four hypotheses provably unused. The proofs were real; the statements discarded the relation they established. Fixed at HEAD — both conclusions now pin the twisted-class presentation equation, `picClass(witness) = M`, and `deg = n`. I retracted I-1219's "next action", which in its old form pointed at the weaker theorem, and corrected an "eleven sites" figure that measures as seven.

**My lane cost the round two red root builds**, both closed. Commit `d20cd1cf81` swept in `ajcr-p1`'s uncommitted root-import lines — a private index re-seeded from HEAD does *not* prevent this, because `git add <one path>` stages the whole blob rather than your diff (filed as I-1217, the missing half of I-0838's staging rule). And I held a non-compiling edit on a rooted file across the vacuity repair, which `ajcr-p3` hit (I-1250).

**Not landed, and it is the check I most wanted:** the sharp converse — the three clauses imply locus membership — is the identity on the data but exceeds `isDefEq` at 1.6M heartbeats, seven instance binders in an anonymous `IsSplitWitness` constructor. A defeq wall of the `relCurve`-vs-product spelling, recorded in the file rather than faked or left as a `sorry`.

## Why I stopped

**Advanced; no antecedent of `pic0RepresentableByOfCharts` is closed, and I claim none.** Everything here is fibrewise over `L/κ(t)` at a single point, and fibre-witness uniqueness is not general-test injectivity — `exists_factor` and `RelPicSeparatesDivFamZar` are untouched. `n = genus` is neither proved nor assumed; `hχ` stays an explicit binder because `chi_moduleKSheaf` converts that pinning rather than supplying it. Row released: pending, unowned, verified at HEAD rather than in the worktree.

## Next

1. Budget `exists_factor` as the relativisation **alone** — its field-level half now has no unfed binder.
2. Three sites still overprice the binder and should be corrected where they stand: `Pic0ChartLocus.lean:146-150`, `Pic0ChartPair.lean:152-158`, `Pic0ChartUnivReduce.lean:160-161`.
3. State the locus biconditional in `Pic0ChartLocus.lean`, where the instance context is the declaring one and the defeq wall does not arise.
