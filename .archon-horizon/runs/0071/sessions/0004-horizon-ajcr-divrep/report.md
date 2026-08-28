I-0566 is archived. The two remaining open threads (I-0494, I-0495) are human-started coordination threads whose closure belongs to the human, not me — I've posted my closing content to both. Final state confirmed.

## Summary

I closed the divisor-representability tail down to a single statement. The result worth stating first: the tail's **two** remaining obligations turned out to be **one**. My own roadmap row — re-scoped three times by predecessor sessions — listed `isDivRepClassify_pull` and `DivRepChartFamily.IsCompatible` side by side as separately ε-gated. They reduce to the same per-chart clause, and there is now a sorry-free producer of `(divFunctor C π g).RepresentableBy DivOver` from that clause alone.

## Progress
- `Picard/DivRepAffPullNat.lean`: new, 0 sorries — `pull_naturality`. ε-free and performs **no gluing**: `IsDivRepPullValue` pins the value up to nothing, so pushing the factorization forward plus `divRepPullValue_eq_of` is the whole proof. My predecessor report priced it as "the same glue machinery as `pull`"; that was wrong.
- `Picard/DivRepAffPullClause.lean`: new, 0 sorries — the reduction. `isDivRepClassify_of_forall_away` is the reusable tool and names no chart family: **`IsDivRepClassify` is local on the base**, because the predicate quantifies over tower tests, so its hypothesis data *and* its conclusion restrict. Then `isDivRepClassify_divRepPullValue` is four lines, and `divFunctor_representableBy_of_chartClause` is the endpoint. Acting on a reviewer finding, `IsChartClause.of_id` further shows the ω-quantifier collapses to `ω = id`, so the debt is U2 exactly as the worksheet writes it.
- `Picard/JacobianDataAbelImage.lean`: new, 0 sorries — DAT-J. w4-datj §2.2's four-step qc argument had three steps landed and nothing joining them; `JacobianData.ofChartsOfAbelImage` supplies `ofChartsOfCompactSpace`'s `CompactSpace` hypothesis from a surjection, which matters because the chart index is infinite.
- `informal/w4-rep-critical-path.md`: new §7.8 correcting §7.7's own obligation count.

Six commits, all via private-index CAS. Final root build green at **9164 jobs, exit 0**, independently re-confirmed by a sibling lane.

## Issues
- **I turned the root build red for ~20 minutes; two sibling lanes caught it before I did.** A duplicated `set_option ... in` around a docstring is a parse error. The cause matters more than the fix: my edits were silently reverted to HEAD mid-session by a concurrent write, and my re-application landed alongside a surviving fragment. My LSP reported clean on a file state `lake` never saw. Protocol §1b covers the shared *index* going stale; the *worktree* going stale under an open editing session is not in it. Recorded on the thread and in the fix commit.
- The reduction claim was strong enough to warrant an audit rather than self-checking. A fresh reviewer confirmed by `rfl` in both directions that `IsChartClause` is the *same* Prop the old lemma consumed (a naming, not a strengthening), and that `IsDivRepClassify` is not vacuous. It also forced a qualification I kept everywhere: the endpoint still carries `hO`/`hχ` and the curve instances, so "one hypothesis" describes the new debt, not representability for an arbitrary curve.
- A first dispatched reviewer died without reporting; the re-run was scoped tighter and told to finish with a verdict.

## Why I stopped
**Partly advanced, not complete.** Deliverables (1), (2), (5) moved; (3) the datum tail and (4) DAT-G/glue I did not start. I checked DAT-G0 first and found its pinned probe already answered (verdict YES, one L-sized analytic residual in `PicRepColimitCompat.lean`), so there was no cheap win there, and I judged closing the link above it worth more than opening two gated rows.

**No gate cleared.** Nothing produces an `IsChartClause`; U2 is unproved and still gated on the G-4 certificate discharge. §7.6's finding also stands untouched: L8 — local surjectivity of the Abel map out of a too-small divisor functor — remains the campaign's real gate and is arguably false as stated. The tail becoming cheap is not progress toward it.

## Next
U2, now stateable in one line: for each pair chart, the supplied chart class is classified by that chart's own morphism to `DivScheme` — and `divUniversalFamily`'s left side *is* `divUniversalFst` definitionally. Its blocker is `ThetaGeneratorSeed.certifiedFamily` demanding a global `IsCertified` over the chart ring. Worth checking before assuming that is a wall: cert-r2 landed several new widened-certificate producers today, and I only verified that `DivFamZar.toAff` points the wrong way.
