Everything is committed, verified, and recorded. Final state: 10 commits, 4 new files, root build green at 9178 jobs.

## Summary

Executed the human decision of 2026-07-28 (protection I-0492) and closed **half the standing residue** of the R2 lane. Obligation 4(i) is discharged rather than relocated again, so the lane's remaining input is **one** geometric statement instead of two. Ten commits, four new Lean files, all sorry-free; root build green at 9178 jobs, exit 0, and all four files kernel-check with zero output.

The finding that made it cheap: obligation 4(i) was never chart-typed — it only *lived* in a chart-typed file. Three prior sessions had priced it as chart machinery. Its leaf input, `germ_self_pullbackEqn_mem_nonZeroDivisors`, names only the local-equation system and the fibre curve in its statement: no cover, no pieces, no chart, no partition.

## Progress
- `Picard/DivisorFamilyAffFibre.lean`: new, 287L, 0 sorries — `ThetaGeneratorSeed.affAdaptation_fibre_regular` discharges `hfib` for **every** widened cover and adaptation. The reverse-orientation comparison needs no projectivity; the existing one costs exactly the (c1)-projectivity `hfib` produces, which would have been circular.
- `Picard/DivisorFamilyAffRank.lean`: new, 153L — unplanned second reduction. `hrank` was about the glued module over the whole cover, but a degree statement is about the divisor, which on a straddling cover sits in the swallowing piece. Collapses to one affine open.
- `Picard/DivisorFamilyAffSeedEndpoint.lean`: new, 148L — the composed endpoint. `hfib` gone, `hproj` gone as a hypothesis and derived inside. Composed rather than asserted, because last session's error was a producer/consumer pair each correct but not composable.
- `Picard/DivisorFamilyAffFraming.lean`: new, 141L — the ε-pair and its pair-chart framing are carrier-indifferent, so no type obstruction separates R2 from the representability consumer.
- `informal/spec-dd-r.md`: ADDENDUM 7; ADDENDUM 5 §5.5 and 6 item 5 marked superseded in place. Roadmap `certificate` and `away-kerspan` rewritten; memories I-0584, I-0598, I-0602 filed.

## Issues
**I published a wrong diagnosis to a downstream lane and had to retract it.** I told divrep their interface was walled, inferring the dependency from the signature rather than tracing what the body consumes. It runs through the window, not the cover. I corrected the cause before they acted on it, then measured the corrected version instead of leaving it open. Filed as I-0602 — three instances of that shape in this workspace today, two of them mine.

**Both dispatched reviewers died at exactly 195 bytes** — the fourth lane and seventh helper today. Filed to human as I-0594. This work is therefore **self-checked**, and every commit says so. I ran the reviewer's brief myself: load-bearing by deletion, a 4795-constant circularity scan (zero hits), sorry-reachability, and joint non-vacuity in Lean.

I then **qualified my own non-vacuity claim**: it inhabits at `n = 0`, the degenerate index value, which rules out mutual contradiction but not satisfiability-only-at-zero. Also fixed a linter warning I introduced, and hit the `set_option ... in` ordering trap the tree already records.

## Why I stopped
**Partly advanced; deliberately not marked done.** The objective is substantively complete, but the remaining input — the subordinate Stacks 0B8B statement — is explicitly out of scope per I-0492 clause 2, so claiming done would overclaim. No independent review was obtainable.

## Next
One statement: an affine open `W ⊇ supp D` inside one member of `d.cover`. Separately, `exists_certChartCover` over the widened carrier is now known to be a proof obligation rather than a redesign — worth taking if divrep needs the widened side.
