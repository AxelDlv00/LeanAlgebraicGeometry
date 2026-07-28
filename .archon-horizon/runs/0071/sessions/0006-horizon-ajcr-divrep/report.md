All four thread posts landed, index clean, everything of mine intact at HEAD `e02994f9d`. Workspace is hand-off clean.

## Summary

I closed the divisor-representability tail to a **single equation between two morphisms that already exist**, and found DAT-J's remaining "one honest brick" was two statements — one of them a missing bridge rather than geometry.

The result worth stating first: `IsChartClause` (= U2, the DDR9-U ε-identity) read as a submodule identity quantified over all tower tests and framings. That quantifier is not there. `divRepClassifyZar` is **total** — defined for every locally certified class over every affine test, no side hypotheses — and `isDivRepClassify_unique` makes it the *unique* clause satisfier. So the clause is not a property of `v`; it says `v` **is** the classifier.

## Progress
- `Picard/DivRepChartRange.lean`: new, 0 sorries — `isDivRepClassify_iff_divRepClassifyZar_left_eq` (names no chart family, so reusable for any such obligation), hence `isChartClause_iff_forall_classify_eq`: U2 **is** the per-chart equality `(divRepClassifyZar (U i j)).left = ChartMap i j`. Stated as an **iff** deliberately — per I-0571 a restatement is a reduction only with the converse. Plus `divFunctor_representableBy_of_chartRange`: the classifier is injective, so representability *is* its surjectivity, and surjectivity at the chart rings alone suffices.
- `Picard/JacobianDataAbelSurj.lean`: new, 0 sorries — `surjective_of_forall_exists_residueField_lift`. w4-datj §2.3 produces a *morphism* out of each residue field; the qc field consumes `Function.Surjective`. Nothing converted one into the other. Pure scheme topology.
- `Picard/JacobianDataFromPicRepDatum.lean`: new, 0 sorries — DJ-IN. The tell it was missing: `PicRepDatum` occurred in **no other Lean file**, its defeq an unconsumed `example`. DAT-J's debt is now two inputs in one signature.
- `Picard/DivRepAffPullClause.lean`: cleared a linter warning of my own.
- `informal/w4-rep-critical-path.md`: §7.9, correcting §7.8's own DAT-J count.

Five commits via private-index CAS, all reachable from HEAD `e02994f9d`. Root build green at **9181 jobs, exit 0**. Axioms `propext / Classical.choice / Quot.sound` on all nine new declarations, measured **with a control that still reports `sorryAx`**.

## Issues
- **I corrected my own suggestion.** Mid-session I posted that the G-4 gate might be stale, then measured it: the relaxed pointwise producers also need `D.IsGenerator`, which at the universal seed needs `hrdn`/germ divisibility. It **relocates** rather than removes. Durable part: U2 needs no certificate over the *whole* chart ring, and the weaker pointwise gate is unattempted. I posted "measure it" before measuring — the order I-0602 warns costs a session.
- **Self-checked only.** Both subagents I dispatched (a measurement pass and a janitor) went idle without reporting, so **no fresh-context review was obtained** — part of why I did not mark the task done.
- My §7.9 was reverted by another lane's stale-tree commit (`e964967e8`, now named in protocol §1a) and restored; re-verified present at current HEAD along with all three Lean files, all root imports, and a clean index. I also **accepted a correction to my own CAS data point**: I had inferred that exposure scales with the read-tree window width, but the sweep comes from the tree base — my commits were lucky, not safe. I contributed the cheap detector (diff each commit against *its own parent*), which §1's existing check does not catch.
- One pre-existing warning left: `DivRepClassifyZar.lean:161`, not my file.

## Why I stopped
**Partly advanced, not complete.** Deliverables (1), (2), (5) moved; **(3) the datum tail and (4) DAT-G/DAT-glue I did not start** — gated on DAT-G0's `Pic0PreservesFilteredBaseColimit` and on divRep. I judged sharpening the link above them worth more than opening two gated rows; that is a choice, not an oversight.

**No gate cleared.** Nothing produces a class over a chart ring; U2 is unproved. §7.6 stands: L8 — local surjectivity of the Abel map out of a too-small divisor functor — remains the real gate and is arguably false as stated.

## Next
U2 in its new form: exhibit, for one pair chart, a locally certified class over `R_Z(i,j)` whose backward classifier is that chart's own map to `DivScheme`. Two unattempted routes: the global certificate, or the strictly weaker pointwise gate, which owes germ divisibility first. A next session should also re-dispatch the fresh-context review this one failed to obtain.
