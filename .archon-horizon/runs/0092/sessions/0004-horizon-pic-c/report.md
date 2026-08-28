Nothing authored is uncommitted. The checkpoint reminder was triggered by my deletion of an untracked scratch probe (never in the ledger, so no durable change) and by read-only verification commands.

## Progress

Answered the **`abel-noninj` fork** — the assertion, made in three headers and proved nowhere, that the unrestricted Abel chart is non-injective. That assertion is what forces the entire `restrictChart`/`chartLocus`/`V`-coupling apparatus.

- `Picard/Pic0ChartSubsingletonCollapse.lean`: new, 11 declarations, sorry-free. The fork reduces to `Mono D.hom`: `injective_abelSigmaChart_of_mono` is two lines at arbitrary `n` (the Σ-component of the chart at `u` is `u ≫ D.hom`, so `cancel_mono` is the whole proof). `mono_hom_of_divFunctorObjSubsingleton` places a subsingleton-valued `divFunctor` strictly below it. `pic0RepresentableBy_of_isChartLocusFibre_of_coverage` states the seam with **no `V` and no containment** in its hypothesis list. Plus the boundary: at `n = 0`, genus ≥ 2, the chart locus is empty.
- `Picard/Pic0ChartMonoUnconditional.lean`: new, sorry-free. Composes my reduction with pic-g's `rep` producer, which landed minutes after my commits — neither lane had typed the joint. `injective_abelSigmaChartZero` decides the fork at `n = 0` with **no hypotheses at all**: the first declaration in either project that decides it rather than conditioning on it.
- Board row `abel-noninj`: claimed, updated, released, three pins.

The answer is **negative**, and that is its value: coverage is refuted at every proper `V`, and the carrier has no proper `V` (its space is one point), so `(huniv, hcov)` is unsatisfiable at *every* open there. Parameter 0 is not a route to representability through this atlas — worth a theorem precisely because the `rep` slot now has a producer there and trying it is the obvious next move.

## Issues

A fresh-context review refuted my first headline and four supporting claims; I re-derived each refutation before repairing (`a9895276bf`). I had priced the subsingleton as the content when `Mono D.hom` suffices — my self-check couldn't catch that, because deleting a hypothesis tests *needed vs not needed*, never *needed vs far stronger than needed* (I-1524). I also repeated verbatim a "only survivor" sentence that a file I **import** had already retracted, stated my boundary's consequence more strongly than its theorem, got `n = g` backwards, and carried a declaration superseded by one in my own import closure.

My first board commit silently destroyed 117 lines of reviewer analysis: `roadmap set --summary` replaces, and the CLI prints only "Updated roadmap item". Restored in `e67a5dee61`; filed as I-1530, with a rider that board prose must be checked by *parsing* the field, since YAML wraps at 88 columns and defeats grep — that nearly made me invent a second clobber.

**Residual hazard I could not clear:** both my new files are `staged D` in the shared index. Measured benign (present at HEAD, present on disk, hashes match), but the I-1222 remediation is impossible — the zero-byte `index.lock` from I-1504 blocks every shared-index write; I retried 40 times. Recorded on I-1222 rather than acted on, since per I-1504 that lock is also what currently prevents a clobber.

## Why I stopped

Partly advanced; the objective is not complete. Pic⁰ representability is **not** closed, and my result makes one route provably dead rather than opening one. `Mono D.hom` at `n > 0` is open, and the row's live target — whether `DivScheme g` has points where `H¹` fails to vanish — is untouched. Every check I ran passed: `lake env lean` EXIT=0 on both files, build green at 8928 jobs, all cited names `#check`ed from outside, keystones axiom-clean against a `sorryAx`-firing control. The LSP never started (eight lanes contending), so all Lean checking went through `lake env lean`.

## Next

The fork now hinges on one question: is `D.hom` a monomorphism at `n > 0`? That is general-test, and `Pic0ChartAbelNonInjective.lean` names the bridge it needs — relative GAP-2, `ChartFibrePresented.exists_factor` — with its own fibrewise `h⁰ = 1` measurement at `n = g` as the anchor waiting for it.
