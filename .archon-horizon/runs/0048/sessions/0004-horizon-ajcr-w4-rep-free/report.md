All work is committed and the shared index is clean. Final state verified.

## Summary

The `chart-avoid` question that had blocked this lane for ~8 sessions — and that the previous session escalated to you as a design decision — is **answered: NO**, on three independent grounds. The certificate lane is no longer waiting on a human. One genuinely human question remains, but it is a different and much sharper one.

## Progress

- `Picard/DivSchemeCertZarConfine.lean` (new, `40963e500` + `cbcc9710e`): 8 theorems, 0 sorries, kernel-checked, axioms exactly `[propext, Classical.choice, Quot.sound]`, wired into the default build.
  - `DivEq.unitLocus_eq` / `DivEq.supportLocus_eq` — the support locus is a **divisor invariant**, so the no-go bites the `DivFamZar` *quotient*, not a chosen representative. Re-spelling the equations is not an escape.
  - `isClosed_supportLocus_inter_chart_of_isCertified` — a certificate forces **both** chart traces closed, with **no connectivity hypothesis** at all. This is the strongest and honest form of the failure; the previous session's verdict needed `IsPreconnected`.
  - `isOpen_setOf_fibre_subset_chartInter` + `exists_opens_supportLocus_subset_chartInter` — chart confinement is an **open condition on the base**. This is what licenses an atlas to *record* avoidance rather than *assume* it, which the spec's Discipline (2) rightly forbids.
- `informal/spec-dd-r.md` (`0dbb0c871`, `cbcc9710e`, `e3a67cad2`): ADDENDUM 3 + CORRIGENDUM — the verdict, a counterexample (`V(tX² + XY + tY²)` over `k[t]`: irreducible, degree 2, fibre `{0,∞}` at `t=0`, stable under every base shrink), the diagnosis, and the repair with its real price.
- Roadmap (`58c4bb834`): `chart-avoid` → done, `confine-open` → done, new leaves `p1-aut`, `fibre-avoid`, `cert-relocalize`, `field-size`. Corrected four **factually wrong** claims a 6-front recon with per-front adversarial refuters caught — `c9-chartlocus` is not DD-R-independent, `Pic0PreservesFilteredBaseColimit` is not the cheapest advance, three roadmap citations point into unreachable modules, and `dat-g` has a concrete port lead in the sibling project.

## Issues

- **I ran an adversarial pass on my own conclusions and it overturned my positive half.** Three defects: the repair *relocates* the forbidden geometric input rather than removing it; `ofChartPair` is the wrong constructor in genus ≥ 1; and "assume `k` infinite" is inadmissible — the counterexample is field-independent, so it works over 𝔽₂. All recorded in the corrigendum, not quietly dropped.
- **The one remaining human question** (I-0346, leaf `field-size`): over a small finite field, where `|P¹(k)| < n+2`, no admissible pair of pinned points exists — so what is `DivFamZar` supposed to be? Three costed options. Settle it *before* anyone builds `PGL₂`.
- `Picard/Pic0ThetaCocycle.lean` **does not parse** (bare `by` at :193-194); invisible only because it is unreachable from the root. Filed as I-0348, not fixed.
- Pre-existing unscoped `maxHeartbeats` at `DivSchemeSeedUnivMulSpanClose.lean:23-24` — recorded on I-0309, not mine to fix.
- I did **not** run the full-root `lake build`. My module and its entire cone (8847 jobs) built clean; the three build-reach import fixes are specified but not landed, because they need a full aggregator build I could not safely run alongside live run 0046.

## Why I stopped

The objective is **partly advanced, not complete** — representability of Pic⁰ is six independent mountains and I worked one. But the specific thing the task asked for is done: the blocking point is understood, settled, and broken into subitems. I left the task status unset so it returns to the queue.

## Next

1. Try relaxing `FinCoverData`'s chart-wise partitions to a joint `⨆ pieces = ⊤` — drops "avoid two points" to "avoid one", for a local edit. Untried, and cheaper than `p1-aut`.
2. Settle `field-size` (needs you).
3. `eq_of_isDivRepClassify` — certificate-free, U-free, landable today; makes `pull_classify` a 3-line corollary.
4. The three one-line root imports, with a full aggregator build.
