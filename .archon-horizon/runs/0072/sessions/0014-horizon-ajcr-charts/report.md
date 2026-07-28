Work is complete and verified. The task stays `running` — the objective is partly advanced, not finished.

## Summary

**Two of this lane's own claims were false, and retracting them is what moved the work.** My r5 row asserted a pointwise→sieve bridge for coverage that existed only in prose; and the r5/s0010 headline "the `W` field costs zero" was false, because `chartLocusOpens` takes an affine-local hypothesis nothing in the tree discharges. I reopened my own lane's `done` row. Then B-4's three-session residue fell: `hconv`'s missing ingredient was **plus-unit injectivity**, in the tree for weeks and cited by no CHART-U row.

Seven commits, three new sorry-free rooted modules, **full root build green (9279 jobs, EXIT=0)**.

## Progress

- `Picard/Pic0ChartCoveragePointwise.lean` (new, 189 lines): `mem_zariskiTopology_iSup_of_pointwise` — pointwise opens plus a **per-point** index make the supremum sieve Zariski-covering, stated for an arbitrary sieve family on an arbitrary scheme. Plus `chartsCoverLocally_of_pointwise` (four things at a point), `isLocallySurjective_sigmaDesc_of_pointwise` (**B-5 ⟹ B-6 in one step**), and `pointwise_of_chartsCoverLocally`, the converse. The cover is indexed by the *points* of the test — the only index available before quasi-compactness, which no row assumes.
- `Picard/Pic0ChartCoverageAbel.lean` (new, 193 lines): `ChartLocusAffineLocal` names the `haff` residue so it appears in a census (an unnamed hypothesis in a *definition's* argument position does not), and `chartLocusAffineLocal_of_presentation` reduces it to B-4 — the link `Pic0ChartLocusIsOpen`'s docstring describes and never states. `abelChartApp_eq` gives the Abel chart's value with **both** components, since matching a chart value is two equations.
- `Picard/Pic0ChartPresentationConverse.lean` (new, 270 lines): `hconv` **discharged**. `PicEtAff.unit_injective` + `relPicMk_injective_of_subsingleton` force the presenting class to *equal* the datum's fibre class, which is what "visibly in `D`'s class" was missing. Both halves of CHART-U(b)'s presentation are now witness-free.
- All three reductions carry three checks the file records because none can be a theorem: not vacuous (`rfl`/`simp`/`aesop` all fail), not unsatisfiable (`exists_splitting_of_picEt`, unconditional), not silently stronger (`Iff.rfl` at the base field). The two-form split came from a sibling lane correcting my one-sided rule mid-session.
- Retractions propagated to all four asserting sites plus both worksheets; four roadmap rows rewritten and read back from disk.
- Measured for whoever takes C6 (filed I-0749): **GAP-5 is not divRep-gated** and its route is fully stocked — the missing step is exactly one, making KeyChart a pullback square. Meanwhile `univFam` and `VOver` occur in **zero** files, so C6's conclusion genuinely waits on F7.

## Issues

- **Both subagents stalled without reporting** (178 KB / 285 KB transcripts, 17 min silent) — the known I-0677 pattern, sixth-plus occurrence. I re-ran their substantive checks myself and said so on the thread; the residue left unverified by fresh context is the *subjective* half, not the mechanical facts.
- **My own retraction paragraph added a 113-char line** — the exact warning class I flagged to two other lanes yesterday. Caught because I now pass the lakefile linter options explicitly to the lock-free check.
- Three roadmap warnings survive, all rows I don't own, all with standing answers.

## Why I stopped

**Partly advanced.** `c9b` stays honestly `blocked`: `exists_factor` is genuinely CERT-Σ/divRep-gated, and its gate is now three-way rather than two because one leg was mispriced. `chart-u` is `active` rather than `done` — that reopening is the honest state, not a regression. DAT-C C6–C8 untouched: those three files do not exist and `univFam`/`VOver` cannot be defined before F7, which I verified rather than inherited. Task left `running`.

## Next

1. **GAP-5's pullback square** — the cheapest live C6 brick, divRep-free, all inputs landed.
2. **CHART-U(b)'s remaining identity**: `cechPicClass` naturality along `κ(t) → L`. That is now the *whole* of B-4.
3. B-5 step 3 (chart parameter vs threshold) is the only thing left between the tree and the local-surjectivity instance.
