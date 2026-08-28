The checkpoint is satisfied: the only file mutations after my last commit (`86205957e9`) were to my personal memory directory at `/home/axel/.claude-api/...`, which is outside the ledger work tree and tracks zero files in it. Every authored change in the repository is committed — my two Lean files are clean against HEAD, the roadmap row is clean against HEAD, and `scratch_p1` is deleted.

## Progress

- `Picard/Pic0ChartRestrictedFibreSat.lean` (new, rooted at `AlgebraicJacobian.lean:573`): 0 → 10 declarations, sorry-free, `lake build` EXIT=0 (9307 jobs), all ten axiom-clean on `[propext, Classical.choice, Quot.sound]` against a control (`AlgebraicGeometry.Jacobian`) that fires `sorryAx`.
- `Picard/Pic0ChartRestrictedFibre.lean`: docstrings only — corrected my own lane's false pricing and my own overreach at the sites that made them; two stale line refs fixed.

**What I claimed and why it was the most important item.** `AJCR.w4-rep.datum.chart-restrict` (antecedent 1). The other three antecedents were held by p2/p3/p4, but the decisive question on mine wasn't a further reduction: my r0 self had landed a well-gated route to `IsChartUniv` and then recorded that `RestrictedChartFibre` had **no satisfiability witness at any `V`**, pricing the obstruction as "triviality of `picEt` over the empty scheme: a genuinely separate lemma, absent from the tree". A correct machine feeding an unmeasured hypothesis is the vacuity class the audit found in 17 of 101 claims — sitting under my own file.

**That pricing was false.** The carrier is a *sheaf*, and a sheaf's value at a `⊥`-covered scheme is terminal: `Sheaf.isTerminalOfBotCover` ∘ `Scheme.bot_mem_grothendieckTopology`, both mathlib, three lines, no `picEt` and no geometry. The error was the **reduction**, not the census — a `congr 1` peeled the Σ-component and named `pic0Subgroup`, discarding the structure that made the goal free. I-0890 retracted at its site.

**State: advanced, no gate closed.** `rep` has no producer, `hcov` at an intermediate `V` has no producer, no chart is built at any `V` but `⊥`. Settled:

- `RestrictedChartFibre` **is inhabited** at `V = ⊥`, so `IsChartUniv ⊥` is free — and `isOpenImmersion_presheaf_restrictChart_bot` shows that construction never mentions the Abel chart, so reaching antecedent 1 without pinning `V` proves nothing about one's own chart.
- Coverage's containment is **refuted** at `⊥` and **free** at `⊤`, while `hf` at `⊤` returns the *unrestricted certificate* three headers call false. Any working `V` is a proper intermediate open, which promotes CHART-U(b)'s openness from bookkeeping to load-bearing.
- `restrictedChartFibre_top_iff`: `IsChartLocusFibre` **is** the `V = ⊤` instance of my class, not an independent obligation — and it supplies the converse `Pic0ChartUnivReduce.lean:55` claims exists under a name defined nowhere (I-1016).

## Issues

A fresh-context `work-reviewer` pass confirmed items 1–5 and 7 but **refuted my framing**: I called the two endpoints "the non-vacuity check for the coupled assembly". They are not — two *bad* values of `V` are two refutations, and **inhabitation of the pair `(huniv, hcov)` is unmeasured at every `V`**. Corrected in both files, not only the inbox (I-1012). The same pass found the `⊤`-equivalence I had under-claimed, which became the session's most useful result.

Two shared-ledger collisions: another lane's sweep committed my umbrella import before my module existed, and the shared index twice picked up other lanes' staged work — handled by re-seeding against HEAD per commit.

## Why I stopped

Partly advanced, not complete. Row `pending`, `--owner` cleared, six commits pinned; scratch removed; two consumed threads archived. I-1017 stays open for p2.

## Next

1. **Is the pair satisfiable at any `V`?** This gates the whole antecedent-1 side; neither endpoint answers it.
2. `review-ajcr`'s I-0927 part 2 offers a landed transport template if `V` should be the h¹-vanishing locus — live again, and sharper, now that `V` must be intermediate.
3. p3's `abel-noninj` decides whether the `⊤` end is dead or merely ungated.
