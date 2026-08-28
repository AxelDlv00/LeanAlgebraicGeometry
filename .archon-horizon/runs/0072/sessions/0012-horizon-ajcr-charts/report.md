All clean after HEAD advanced three more times under me. Workspace is hand-off clean.

## Summary

**C9b's gate was mispriced by every prior session on this lane, my own predecessor's included, and one of its two halves needed nothing.** `IsChartUniv` is `IsOpenImmersion.presheaf` = mathlib's `MorphismProperty.relative` at `yoneda`, which *by definition* conjoins (i) relative representability of the fibre product with (ii) the open-immersion property of each represented pullback. The relative-GAP-2 + classifier story the roadmap told feeds (ii) only; (i) needs just an open of the test, and `chartLocus` is one unconditionally. Separately, **DAT-B B-6 is closed** — an instance three files carried as an unproduced `variable`.

Six commits, three new sorry-free rooted modules, 13 axiom-clean results against two firing controls, and a **green full root build (9271 jobs, EXIT=0)**.

## Progress

- `Picard/Pic0ChartOpenImmersionCriterion.lean` (new, 241 lines): `ChartFibrePresented`, `.isPullback` (pointwise pullbacks + `Types.isPullback_iff`; the joint-**injectivity** half is free because `W.ι` is a mono — that is where openness does its work), and `isOpenImmersion_presheaf_of_chartFibrePresented`, the criterion discharging both clauses. Abstract in `f` and `V`: no divRep, certificate, `Z` or `θ`. Plus `mono_of_isOpenImmersion_presheaf` — "the Abel map is not a monomorphism" is cited as a *reason* in three files and is a **derivation** from `presheaf_mono_of_le`.
- `Picard/Pic0ChartUnivReduce.lean` (new, 176 lines): `chartLocusOpens` supplies the `W` field **by construction**, so the datum drops from four fields to three; `isChartUniv_of_isChartLocusFibre` composes with the landed composition half, no seam. By-product: `V` is *arbitrary* for `hf`, so restricting to the chart locus was never what made it true.
- `Picard/Pic0ChartLocalSurjectivity.lean` (new, 137 lines): `ChartsCoverLocally` + `isLocallySurjective_sigmaDesc` = **B-6**, which is B-5 phrased against mathlib's sieve interface. The proof shows *no* cross-chart compatibility and *no* injectivity are needed, so chart-parameter heterogeneity obstructs coverage no more than it obstructed `hf`.
- Both reductions **bracketed by proof**: the datum is unsatisfiable without injectivity (hence for the unrestricted Abel chart, whose fibres are the linear systems), `IsChartUniv` is unreachable without it, and B-6's hypothesis is satisfiable. Gates moved, not removed.
- `Pic0ChartPair.lean`, `Pic0AtlasFromDivRep.lean`, `informal/w4-datc-worksheet.md`: retraction carried to all three sites asserting one clause; the last also claimed `chartLocus` "does not exist in Lean", false since it landed. Worksheet §5 file plan amended — "six of nine rows launchable before divRep" is really seven.
- Roadmap `c9b`, `dat-b`, `dat-c` rewritten and read back from disk; the stale `dat-b` sentence corrected *in place*, not merely contradicted higher up.

## Issues

- **First root build exited 1** on a lone `ChartClassNaturality.olean does not exist` — a sibling's import landed 20 min into my build, after lake computed its target list. Re-run green; `ajcr-w5-av` confirmed independently. Posted as a discriminator so no lane concedes a red root it doesn't own.
- **The full build caught a 105-char line in my own file** that `lake env lean` cannot see. Fixed in `cf26fb010`; flagged to every lane relying on the per-file fallback, and w5-av's reply sharpened it — that fallback is only as good as the options the *file* declares.
- **The lake mutex cannot be held from a foreground tool call**: the harness capped `Bash` at 10 min regardless of the timeout passed and killed my shell mid-hold. Filed as I-0714; the detached-process recipe is now mandatory.
- **Both subagents ran without reporting** (~230 KB transcripts, the known I-0677 pattern). I ran their checks myself rather than assume them.
- Three roadmap warnings survive, all AJC-side rows I don't own, all with standing answers.

## Why I stopped

**Partly advanced.** `c9b` stays honestly `blocked`: `IsChartLocusFibre`'s `exists_factor` and the classifier-produced `r` are genuinely CERT-Σ/divRep-gated, and writing them against a guessed endpoint is what the four-lane thread exists to prevent. DAT-C C6–C8 untouched for the recorded reason — they consume the divisor-scheme side directly and C7's file doesn't yet exist. DAT-B now owes exactly B-5. Task left `running`.

## Next

1. `IsChartLocusFibre` the moment CERT-Σ lands — supply the three fields and call `isChartUniv_of_isChartLocusFibre`; do not re-derive the plumbing.
2. B-5 (`ChartsCoverLocally`) is now the only thing between the tree and the local-surjectivity instance.
3. Still unanswered: does anything in the divRep chain *use* `n = g`, or is `g` incidental?
