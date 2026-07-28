Thread acknowledged, ledger clean, everything committed. Final state below.

## Summary

The most consequential output of this session is a **defect found in this lane's own prior work**, not a theorem proved. `chartLocus` — which the roadmap carried as `done` — was **vacuous**: `chartTwist` applied the *same* twist as `chartValue` instead of its inverse, so the class under test had fibre degree `−g` while `h¹ = 0` forces `deg ≥ g − 1`. Empty for every genus ≥ 1, and the openness theorem proved about it was the openness of `∅`. A reviewer had kernel-refuted this hours earlier (I-0514); I built two commits on top before acting on it.

Beyond the fix, three "honest gates" on this lane turned out to be artifacts rather than mathematics, and CHART-U(b) went from one unlanded *construction* to one predicate-matching statement.

## Progress

- `Picard/Pic0ChartLocus.lean`: sign corrected to `λ·θᵐ·Σ⁻¹` (degree `+g`); added `chartTwist_chartValue`, a round-trip law *false* of the old definition, so the direction is now pinned by the kernel rather than a docstring.
- `Picard/Pic0ChartLocusIsOpen.lean`: 1 sorry → **0**. The predecessor's `sorry` was not "transcription" but an unsatisfiable hypothesis shape (`alg`/`tow` ∀-quantified over instances that already existed canonically); three consumers shed two dead parameters each.
- `Picard/Pic0ChartSplit.lean` (new): every plus class over a field splits, unconditionally.
- `Picard/Pic0ChartTwistCollapse.lean` (new): the twist is **one** `thetaFamily`; GAP-1's mul/tensor never gated CHART-U(b).
- `Picard/Pic0ChartHonest.lean` (new): honesty over a general affine base is free — a cover splits over its own carrier, so the map cofinality was being asked for is the identity.
- Worksheets, two roadmap nodes, three `hgraph` nodes synced; I-0514/I-0557/I-0558 closed; 16 CAS commits.

Root build **9161 jobs, exit 0**; all five files sorry-free; every headline result's axioms exactly `[propext, Classical.choice, Quot.sound]`.

## Issues

- **The wrong sign survived two sessions behind a self-consistent ledger.** `degAt_chartTwist` computed `−g` faithfully and said so aloud; a degree ledger recomputes a sign error rather than detecting it. Saved to memory, and the reason the fix ships a round-trip law.
- **Two gates were inferred, not measured** — one from an absent lemma name, one from ∀-quantifying canonical instances. Saved to memory.
- I wrote "unprovable" where "false for some instantiations" was defensible; corrected in four places after review.
- The §1b index staleness armed four times, once staging deletion of a sibling's live 177-line file. Repaired each time; final staged-deletion count is 0.
- **Janitor did not complete** — stopped after ~20 min; I did the hygiene work myself. Collection-health warnings (63 open inbox items, 14 open tasks) remain; standing memory I-0556 says six passes today produced near-identical triages, so I did not re-dispatch.
- 109 duplicate Lean declarations from `graph sync` — pre-existing, outside this lane's write set, recorded rather than passed over.

## Why I stopped

**Partly advanced.** `c9b` stays `blocked`, correctly. I attempted the one remaining residue's natural reverse half (trivial splitting `L := K` where the class is already honest) and it **failed to elaborate** — the fifth variant of the `IsSplitWitness` positional-introduction wall, recorded as a negative result (I-0564) with the likely real fix being to restate `IsSplitWitness` with one spelling of the base-changed curve.

Deliverables (3) and (4) were not started: DAT-B B5/B6 and DAT-C C6–C8 remain untouched. That is the honest gap in this session against the task's four-deliverable scope.

## Next

1. **B-5 / COV-1** — now genuinely launchable: `CoverageDrop`, `SepPointsDense`, `Pic0ChartSplit`, and a non-vacuous locus all exist.
2. `IsChartDatumPresentation`, after unifying the two curve spellings in `IsSplitWitness`.
3. CHART-U(c) still needs relative GAP-2 plus the classifier. `ajcr-divrep`'s endpoint is stable but I never needed it — all of the above is divRep-free.
