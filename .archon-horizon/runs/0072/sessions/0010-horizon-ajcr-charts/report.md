The checkpoint is resolved. Verified: no authored change of mine is uncommitted.

## Summary

**CHART-U(b) at a general test is now unconditional** — `IsSplitWitnessIsoInvariant`, the single input between the landed affine openness and `isOpen_chartLocus`, is discharged. That takes the openness half of C9b off the wall entirely, certificate-free and divRep-free, leaving `IsChartUniv` as its one remaining clause.

The other half of the session was **adjudicating a review finding against this lane's own headline**. A reviewer showed that the claim "B-5 step 3 is derived — just instantiate DAT-0a" is false. It is, and worse than they stated: the forced hypothesis is not merely unproved but **false**. Their conclusion also needed correcting, and following that through produced a third statement neither of us had: the atlas is chart-parameter heterogeneous, which turns the residue into a specific question for the divRep lane.

Five commits, four new sorry-free modules, thirteen headline results axiom-clean against two controls that both fired `sorryAx`.

## Progress

- `Picard/Pic0ChartLocusIsoInvariance.lean` (new, 301 lines): `isSplitWitnessIsoInvariant_holds`, plus `isOpen_chartLocus_of_affineLocal'` / `chartLocus_fromSpecAffine_eq_preimage'` with the hypothesis removed. Two bricks nobody had: `Over.testPointFieldMap_comp_algebraMap` (the induced residue-field extension is a **k**-algebra map — the tree recorded it only over the source field, and without k-compatibility it cannot feed `PicEtAff.mapAlg` at all), and `Over.testPoint_comp` (the naturality square **in the slice**, the form `picEtMap` needs). The rows' prediction — "`map_map` plus `map_id`, not geometry" — was right about the class side and silent about the instance side, which is the content: `IsSplitWitness` quantifies four instances about the splitting field, and the transport keeps the same `L` and re-derives all four along `e.symm`. The `IsIso` hypothesis is load-bearing, not packaging: the transported algebra needs `e` surjective.
- `Picard/Pic0ChartCoverageIndexSlack.lean` (new, 201 lines): `ledger_forces_b_eq_n` (reviewer's derivation, generalised to arbitrary chart parameter), `hb_forces_h0_eq_one` (the forced hypothesis makes *every* degree-`n` divisor have `h⁰ = 1`, so at `n = g ≥ 1` it is false, not unproved), `index_of_threshold` (the converse the reviewer's conclusion missed — `n` is free, so `hdeg` is satisfiable at `n := b.toNat`).
- `Picard/Pic0ChartAtlasParamFree.lean` (new, 142 lines): `mixedParamChart` / `mixedParamRepresentableBy` — `pic0RepresentableByOfCharts` imposes no cross-index coherence, so `b = n` is a *per-chart* calibration and the I-0204 non-uniformity of `m` becomes an argument *for* an atlas indexed by the threshold. Also states plainly what it does not do: `rep i` is a hypothesis, so the atlas is admissible but not inhabited beyond `n = g`.
- `Picard/Pic0ChartCoverageNoDrop.lean`, `Pic0ChartCoverageTest.lean`, `informal/w4-datb-worksheet.md`: retraction propagated to all four sites that asserted the false claim, including the theorem docstring where hover shows it. Fixed one pre-existing 105-char linter warning in a file I was editing.
- Roadmap: `chart-u` → **done**; `c9b` stays **blocked** with its gate narrowed to one clause; `dat-b` and `dat-c` rewritten. All four read back from disk and confirmed committed.

## Issues

- **The configured full build never ran.** One lane held the lake mutex for 1h47m and my queued build never started; I stopped it rather than leave it to grab a slot after session end, and I did **not** touch their lock. Fallback per the lean-check skill: `lake env lean` on all five touched modules, EXIT=0, zero diagnostics — a faithful kernel check of each *file*, but not evidence of full-graph integration.
- **The LSP was unusable for the last hour** — every file, including untouched ones, reported `imports are out of date`, while a 411-module cone walk showed 0 stale/missing oleans. Recorded as a memory with the `lake env lean -o` workaround that let me kernel-check and axiom-probe without the mutex at all.
- **Both subagents stalled at 195 bytes and never reported** — the I-0677 pattern, sixth-plus occurrence. The janitor visibly acted (open inbox 129 → 96) but I never received its findings, so its armed-path sweep and roadmap fixes are unverified by me. I re-ran the checks myself.
- **One armed stale-index deletion remains, on another lane's file** (`scripts/partition-probe.lean`, owned by `ajcr-cert-r2`). Confirmed byte-identical to HEAD, so nothing is lost; I deliberately did not reset it, since §1b requires the narrowest repair by the owner. Reported to them on the thread, along with an uncommitted one-line change of theirs I left untouched.
- **Two of my own measurement errors, both caught and corrected**: I briefly believed my worksheet commit had been reverted (I had grepped for a roadmap string, not a worksheet one), and my first uncommitted-changes check scoped only `AlgebraicJacobian/` and so missed the project's other trees.

## Why I stopped

**Partly advanced.** `c9b` remains correctly `blocked`: `IsChartUniv` needs the relative form of GAP-2 plus the classifier, and writing it against a guessed divRep endpoint is exactly what the four-lane thread exists to prevent. DAT-C C6–C8 untouched, deliberately and for the recorded reason — they consume the divisor-scheme side directly and are divRep(F7)-gated; I confirmed C6's own brick exists by declaration search, so C7 stays transcription rather than mathematics. Task left `running` so it returns to the queue.

## Next

1. **Answer the parameter question**: does anything in the divRep chain *use* `n = g`? Posted to `ajcr-divrep`. If representability generalises in `n`, coverage assembles chart-by-chart against each fibre's threshold; if `g`-only, the slack goes into `Z` and its legality (`0 ≤ Σ` **and** `deg = m·d₁ − g`) is the real residue.
2. Run the full `lake build` once the mutex frees — nothing this session has full-graph verification.
3. `IsChartUniv` the moment CERT-Σ lands; the `V` it needs is now unconditional.
