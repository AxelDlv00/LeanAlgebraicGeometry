The post-commit mutations produced no durable ledger change. All seven authored paths hash byte-identical to HEAD, and HEAD has since advanced past my last commit (`df942854f2`) to another lane's `c0cbd4ede7` with my work intact.

The two files touched after my last ledger commit were outside the workspace repo — my own agent-memory file at `~/.claude-api/.../memory/price-the-residue-on-the-data-carrier.md` and its `MEMORY.md` index line. Plus `ScratchP2/`, deleted (and gitignored while it existed, verified by `check-ignore`).

## Progress

I claimed **`AJCR.w4-rep.datum.dat-c.param-admissible`** (new row, announced I-1374). Second-most important because the reviewer's reply to my own I-1345 located parameter matching in exactly two places — `hdeg i` and `hcov` — and p4's row circles `hcov` while nobody held `hdeg`. It is not a seam antecedent but a **binder of every chart declaration below the seam**: unsatisfiable at a parameter, and `IsChartUniv`, coverage and `rep` there are all about nothing, regardless of who discharges them.

- **`Picard/Pic0ChartIndexAdmissible.lean` (new, rooted, 9 declarations, 0 code sorries):** 21 chart files bind `hdeg` (`deg_k Z = m·d₁ − n`) verbatim and **zero** produced one. `chartIndex_iff_isDegree` proves the binder carries *exactly* "`n` is in the image of `deg_k`", both directions. The producer takes `m = 0`, so the **θ-exponent is idle**. Plus shift-invariance and subgroup closure — the `index·ℤ` fact three files assert in prose and none states.
- **`Picard/Pic0ChartIndexLedgerFeed.lean` (new, rooted, 5 declarations, 0 code sorries):** `isDivisorDegree_iff_left` transports the predicate to `C.left`; `isDegree_ledger_add_iff` then drops the ledger constants with no hypothesis, since `δ` *is* a divisor degree there — the fibre divisor of the ledger's own `π`. Endpoint `mem_chartLocus_of_ledgerIndex_of_isDegree_genus`: coverage's locus membership at the ledger parameter from `IsDivisorDegree C g` alone.
- Root `lake build` EXIT=0 (9329 jobs); all declarations axiom-clean `[propext, Classical.choice, Quot.sound]` in runs where `Jacobian` correctly reports `sorryAx`.

## Issues

**Four of my own claims were refuted mid-session.** Three were successive residue pricings, each cheaper than the last: "two unrelated curves" → "a commensurability question" → no hypothesis at all. Each was a correct observation about the carrier I had chosen; the error was stating the predicate in the consumer's coordinates rather than the data's (I-1449). The fourth I committed three times and did not catch myself: calling the final goal "atomic" while citing the composite-vs-atomic rule in the same sentence, when `IsDivisorDegree` is an `∃`. Caught by ajcr-p4 and a hygiene pass; retracted at both sites, and the residue is now **unmeasured**, not measured-absent.

**A commissioned audit found three more, all fixed:** a duplicate I created *by* reducing (`@f = @g := rfl` typechecked between them), the uniformity claim promoted from prose to a theorem, and the count 23 → **21** with the command in the docstring.

**I clobbered two lanes' files** via the I-1222 race (ajc-p1's `GaloisSelfTensor.lean`, ajc-p2's `PicEtDescentRepresentability.lean`), both restored byte-identically and verified. I added two checks to that protection: commit's own printed stat already disagrees with the verified pre-commit stat, one line cheaper than the post-commit diff; and read the victim path's trailers before the DM — I misattributed the second clobber to p1.

**Live at close:** 22 staged deletions in the shared index including one `.lean` (ajc-p3's), all present at HEAD and on disk. Roadmap/inbox overflow warnings are pre-existing — no active item is mine — left deliberately rather than mass-archive nine live lanes' state.

## Why I stopped

**Advanced, not complete. No antecedent of `pic0RepresentableByOfCharts` is discharged.** `IsChartUniv`, `rep` at every parameter, and the pointwise-to-neighbourhood spreading-out are untouched, and `IsDivisorDegree C g` is not known to hold. What changed: the coverage route's residue at the ledger parameter went from an unexhibited `(m, Z)` to one question with no chart, certificate, θ-class or ledger constant in it. Row released, pending, unowned, pinned. Ten commits, all ancestors of `main`.

## Next

1. **Is the genus a divisor degree on `C.left`?** The entire residue of this route. Decompose it — `deg_k` is residue-degree weighted and the only degree-one point needs `[IsSepClosed k]`, forbidden here. Do not re-run `exact?`.
2. I-1427's two prescriptions are genuinely open: a general shift law without the θ-machinery, and a per-`m` producer (mine works only at `m = 0`).
3. `ScratchChartLocal.lean` sits inside `AlgebraicJacobian/Picard/` — sorry-free but imported by nothing, a `build-reach` item.
