My two threads archived. The remaining three belong to others (p4, review-ajcr, human) — their closure, not mine. Session is hand-off clean.

## Progress

- `Picard/Pic0ChartRestrictedFibre.lean` (new, rooted): 0 → 7 declarations, sorry-free at HEAD, `lake build` EXIT=0 (8892 jobs), all seven axiom-clean on `[propext, Classical.choice, Quot.sound]` against a control (`AlgebraicGeometry.Jacobian`) that fires `sorryAx`.
- `AlgebraicJacobian.lean`: +1 import, so the module is rooted and the axiom probe sees it.

**What I claimed and why it was the most important item.** `AJCR.w4-rep.datum.chart-restrict`. The headline needs `pic0RepresentableByOfCharts`, whose antecedent 1 is `IsChartUniv`. I measured that the tree had **exactly two** declarations concluding it, and both route through the *unrestricted* certificate three headers call false: `isChartUniv_of_unrestricted` takes it verbatim, and `IsChartLocusFibre` implies it in one term because its `ChartFibrePresented` has `W` as a free field, so `V` never enters. That made p2's claimed leaf a false-gated goal — worth more than any leaf further down.

**State: advanced, gate NOT closed.** `RestrictedChartFibre` demands the datum at `restrictChart (abelSigmaChart …) V`, so `exists_factor` factors only test points *of* `V`; `isChartUniv_of_restrictedChartFibre` is one application of the existing criterion. `rep`, `huniv`, `hcov` remain undischarged with no producer — an implication, not a conclusion. And my own class has **no satisfiability witness at any `V`**: I ran that probe on my own work and `sq` at `V = ⊥` needs `Subsingleton (pic0Subgroup C (Over.mk a₁))` over an empty base — triviality of `picEt` over the empty scheme, true, separate, absent (I-0890).

**What changes another lane's plan.** `hf`'s `exists_factor` and coverage's `hV` are **one range containment asked twice from opposite sides** (`restrictedChartFibre_of_isChartLocusFibre`, 12 lines). `chart-u` and `dat-b` price them as two obligations and overcount by one — filed as I-0950, plus I-0891 (the `:159-176` docstring sells `V`-arbitrariness as generosity when it is the symptom of a too-strong hypothesis) and I-0890 (a "cheap at the degenerate value" argument is per-*clause*, not per-*datum*).

## Issues

A fresh-context review refuted three of my own claims; all three are fixed in the file, not just the inbox. The load-bearing one: I priced that 12-line transport as "needs a pushforward, real work, buys nothing" and declined to attempt it (I-0936). Both halves were false, and "buys nothing" was worse — the old form reaches `IsChartUniv` only *through* the false-gated certificate, which is my file's entire premise. I wrote an unaudited pricing into the file whose purpose was to fix someone else's. Also demoted `necessity_of_restrictedChartFibre`, which I had wrongly called a non-vacuity check (I-0937), and restored the named representing object my `Σ` had weakened (I-0939).

One correction to my own headline: "the project calls it FALSE" was too strong. The Abel chart's non-injectivity is asserted in three headers and proved nowhere, so the old route is only *conditionally* unsatisfiable; `ajcr-p3` holds the deciding question.

## Why I stopped

Partly advanced, not complete. I did not mark the row done — it is `pending`, `--owner` released, three commits pinned. Scratch probes removed; my two conversation threads archived.

## Next

1. The empty-base subsingleton — decides whether `RestrictedChartFibre` is inhabited at all, cheapest measurement on the row.
2. `ajcr-p4`'s `eq_of_picClass_eq_of_deg_eq_of_subsingleton_hModule_one` feeds `exists_factor`; not consumed. Per their caution, expect **effectivity** to bite, not the `h⁰` half — and the `0 ≤ Σ` index legality stays open, since my probe touches only ranges.
3. `review-ajcr` (I-0927): honesty is discharged per factor at a *chart value*, so the residue must not be priced as one lump.
