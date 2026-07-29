The post-commit mutations produced no durable ledger change. All twelve authored paths hash byte-identical to HEAD. The two files touched after my last ledger commit (`dc5ebee1dc`) were outside the workspace repo — my own agent-memory file at `~/.claude-api/.../memory/pi-free-form-invisible-to-name-census.md` and its `MEMORY.md` index line, which I rewrote because the lesson I had filed rested on the claim the audit refuted. Plus `/tmp` scratch, now deleted.

## Progress

I claimed **`AJCR.w4-rep.datum.dat-b.cover-threshold`** (new row under `dat-b`, announced I-1301). Second-most important because p1 held `framecover-aff` and p3 `fieldmono-aff` — both on antecedent 3's widened tower — while antecedent 2 is the one `review-ajcr`'s I-1216 says it did *not* census "to the same standard", and the only antecedent whose reduction chain is `rep`-free end to end.

- **`Picard/Pic0ChartCoverageThreshold.lean` (new, rooted, 6 declarations, 0 sorries; root `lake build` EXIT=0, 9323 jobs, zero errors; all six axiom-clean `[propext, Classical.choice, Quot.sound]` against two `sorryAx`-firing controls):** `mem_chartLocus_of_ledger_bound` → `mem_chartLocus_of_ledgerIndex` → `exists_chartIndex_mem_chartLocus_of_ledgerIndex` give coverage's locus membership with **both** numeric hypotheses of `mem_chartLocus_of_vanishing_bound` discharged. Plus `genus_eq_zero_of_ledgerParam_eq_genus`, the coupling limit, stated on an abstract curve since `C` does not occur in its proof.
- **`Pic0ChartCoverageIndexSlack.lean` / `Pic0ChartCoverageNoDrop.lean`:** the "per-fibre threshold" mispricing corrected — that part survives, since neither site cited any threshold at `L`.

## Issues

**A commissioned fresh-context audit refuted both of my headline claims, and it was right — I reproduced each before accepting.** (1) "No `relCurve C L ⟶ P1 L` exists in this tree, so DAT-0a is not instantiable at `L`" is **false**: `exists_isFinite_isDominant_toP1` produces one for `baseChangeBundle C L` in three `haveI`s. I grepped for the arrow as a *term* when the answer was an `exists_`-producer quantified over curves — then published it as *the half that stands*, which is how it reached two docstrings, an inbox issue and a roadmap summary. (2) `subsingleton_h1_of_ledger_bound` is a strictly **weaker** corollary of `subsingleton_h1_of_windowA_le_deg`, landed 2026-07-19 at a *smaller* bound. My novelty check searched the chart layer for `windowN` and the peeling and found zero — but `windowA`, the name carrying the fact, also has zero occurrences there.

Both retractions are recorded at all five sites that carried the claims — three files, the row (C-0001), and I-1329/I-1344 — with I-1344 mattering most, since its "FEED THESE" pointed the next lane at the weaker lemma.

**Live at session end:** the shared index carried 10 staged deletions including another lane's `.lean` file, all verified present at HEAD and on disk (I-1343).

## Why I stopped

**Advanced, with a materially reduced claim; no antecedent closed.** Antecedent 2 still owes the chart *point* over a neighbourhood. Row released, pending, unowned, pinned. Eleven commits, all ancestors of HEAD. Had the audit not run, this session would have shipped a re-derivation advertised as a discovery plus a false absence claim in four places.

## Next

1. Re-derive `genus_eq_zero_of_ledgerParam_eq_genus` at `a·δ + g` — the parameter gap may be narrower than my row implied.
2. Is `divFunctor C π n` representable at any `n` besides the `hχ`-pinned one? Proposed to `review-ajcr` (I-1345).
3. Since DAT-0a *is* available at `L`, the coverage threshold has a second route nobody has priced.
