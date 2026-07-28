Workspace is hand-off clean: six commits in HEAD's ancestry, all five paths byte-identical, armed set empty, both threads acknowledged.

## Summary

Executed the R2 consumer chain and found the lane's blocker had been **misnamed for three sessions**. The widened `DivFamZar` carrier (human protection I-0492) was already landed, functorial, a Zariski sheaf value, and proved strictly wider — and by declaration reference **nothing produced it from geometry**. Every producer produced a widened value from *another* widened value. Three new modules close that, plus the classifier's first step.

## Progress

- `Picard/DivisorFamilyAffSeedGate.lean`: **new, 0 sorries, rooted, axiom-clean.** `ThetaGeneratorSeed.divFamZarAff_of_swallowing_affineOpen` — seed + subordinate Stacks `0B8B` (`hW`/`hsub`/`hWle`) + degree datum at the swallowing piece ⟹ `DivFamZarAff`. Obligation I-0492 4(i) does not appear: discharged inside the endpoint. Plus per-prime forms, `picClass` preservation by `rfl`, and a non-vacuity witness.
- `Picard/DivisorFamilyAffSeedSection.lean`: **new, 0 sorries, rooted.** `divFunctorAffSection` — the same carried to a **section of `divFunctorAff`**, with `divFamZarAffAffineEquiv_divFunctorAffSection` identifying its class as the gate's. This composition was *elaborated in a review* (ADDENDUM 8 §8.7) and cited in a binding addendum while no declaration performed it.
- `Picard/DivisorFamilyAffAwayRep.lean`: **new, 0 sorries, rooted.** `DivFamZarAff.exists_certified_away_rep` — step 1 of the **classifier**, widened. This corrects my own lane's `AffFraming.lean`, which priced the whole of `exists_certChartCover` as unportable: that conflates two steps, and step 1 alone has no chart content.
- `informal/spec-dd-r.md`: ADDENDUM 11 (+140L), binding, including a method correction to §10.1.
- Roadmap `…ddr.certificate` and `.cert-assemble` rewritten; both verified by disk read-back.

Checks: **full `lake build` green — 8882 jobs, EXIT=0**, zero warnings/errors in any of my files (the 4 in the log are pre-existing linters in another lane's file). This discharges ADDENDUM 9 §9.1a's standing "DO FIRST" that two predecessors could not get. Axiom probes throughout with controls introduced in the probe file; controls fire `sorryAx`, all headlines report exactly `[propext, Classical.choice, Quot.sound]`.

## Issues

**Two scope defects in my own work, caught by attacking it myself** (`20bb502ae`): the `n = 0` inhabitation caveat was not inherited in writing; and `relPinnedChart` **is** in my dependency closure via `ThetaGeneratorSeed`'s own fields. The certificate side is chart-free (no `FinCoverData`, `ChartTyping`, or `relCover_sup` — the last being the mechanism the refuted fixed-pair repair rested on), but the *input datum* is chart-indexed. Both now in the file with the argument for why it limits the claim rather than breaching clause 3.

**My first closure probe was uncalibrated** — controls outside my import cone reported `closure=1`, which would have licensed a negative conclusion from a probe that could not fire at all.

**I migrated no consumer.** Re-measured with the `divFamZarAffineEquiv` substring collision excluded by hand (including it inflates the count 1→6): still exactly **one** file outside the family consumes the widened carrier.

**Neither review agent reported** despite a direct status request, so the widened gate has had no independent adversarial review. The specific unanswered question is whether `IsLocallyCertifiedAff` at the trivial `g = ![1]` cover is genuinely "local" on this route.

## Why I stopped

**Substantially advanced, deliberately not `done`.** The producer gap is closed, kernel-verified under a real full build, and honestly scoped — but no fresh-context review survived to check it, which the skill requires before a terminal claim, and the consumer migration is untouched. The lane's geometric residue is unchanged: the subordinate Stacks `0B8B` input, assumed per I-0492 clause 2.

## Next

1. **Answer the unreviewed question**: is the trivial-cover route genuinely "locally certified", or weaker than the name suggests?
2. **The ε-framing half** of `exists_certChartCover` — the only genuinely two-chart part of the classifier.
3. **A `ThetaGeneratorSeed` base change** along `R → Localization.Away r`, newly named rather than newly owed.
4. `ajcr-divrep`'s `HasCertifiedAdaptation` is **false, not open**, under the straddling hypotheses (I-0705, confirmed from my side as the no-go's owner) — widen the residue onto the new gate rather than repair the chart-typed existential.
