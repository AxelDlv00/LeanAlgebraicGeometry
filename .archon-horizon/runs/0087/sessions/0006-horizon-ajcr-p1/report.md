The checkpoint is satisfied. Every ledger path I authored is byte-identical to HEAD; the only file mutations after my last commit (`daebd904ee`) were the two memory files and `MEMORY.md` under `/home/axel/.claude-api/`, which is outside the ledger work tree and tracks zero files in it. My `scratch_p1r2/` was untracked and is deleted.

## Progress

- `Picard/Pic0ChartVMonotone.lean` (new, rooted at `AlgebraicJacobian.lean:575`): 0 → 13 declarations, sorry-free, `lake build` EXIT=0 (8894 jobs), all 13 axiom-clean on `[propext, Classical.choice, Quot.sound]` against a control (`AlgebraicGeometry.Jacobian`) that fires `sorryAx`.
- `Picard/Pic0ChartRestrictedFibreSat.lean`: docstring only — the `⊥` instance-binder loophole it flagged as unmeasured is now shut from two directions.
- Board: `atlas-coupling` retitled, summary rewritten, released, pinned `ba34a409f`.

**What I claimed and why it was the most important item.** `AJCR.w4-rep.datum.atlas-coupling` — the row whose *title* asserted coverage must land in the same `V` the `hf` certificate is at. That claim was mine from r1, and `review-ajcr` had just filed I-1050 saying it was false. If the seam's two antecedents were separable, four lanes had been treating one coupled obligation as unsplittable, and the question my own row named as gating the antecedent-1 side was the wrong question. Nobody else could take it: the defect was in my file and my row.

**The reviewer retracted mid-session** (I-1068). Rather than accept either version on trust I proved the collapse — `nested_iff_shared`, `shared_top_of_nested` — so a later lane cannot reopen it by re-reading prose. I also closed a gap their own probe missed: the seam consumes an `IsLocallySurjective` *instance*, not the `hcov` spelling, and instance-level monotonicity needs the coproduct step.

**The substantive result** is `isLocallySurjective_unrestricted`: coverage at *any* family of opens implies coverage for the unrestricted atlas. The restriction relieves antecedent 1 (`⊥` is free) and antecedent 2 by **nothing** — refuted for every `V` at once, which no endpoint computation reaches. With `isLocallySurjective_of_bot`, the `⊥` route costs the full coverage obligation.

**State: advanced, no gate closed.** `rep` has no producer, so `IsChartUniv` is not statable without it; no chart exists at any `V` but `⊥`; inhabitation of `(huniv V, hcov V)` is unmeasured at every `V`. Filed I-1125, released I-1128, DM'd both coverage lanes (I-1130/I-1131 — both replied, neither row bound).

## Issues

A fresh-context audit confirmed all five theorems and refuted two of my **reasons**, both retracted at their sites and in the commits: I called `isLocallySurjective_unrestricted` the file's "substantive content" and credited iso-ness of `Scheme.topIso`, which the file never uses — it is one `rfl` plus one mathlib lemma (I-1117); and "opposite monotonicities squeeze the pair" is false, since either alone collapses the nesting (I-1119). The audit also found my biconditional sits one level *under* the assembly, `RestrictedChartFibre` monotonicity being proved nowhere — now stated in the header, with `coverage_instance_of_nested` added to reach the real pair.

Shared-ledger hazard, sixth mode: `diff --cached` passed immediately before a commit that carried my message over another lane's file (I-1081). Nothing lost — verified by content hash, not sha. The janitor pass hit the same revert hazard on its own README fix and re-applied it.

## Why I stopped

Partly advanced, not complete. The objective was free-choice and the item I picked is measured out: the escape route is closed and *proved* closed. Row left `pending`, owner cleared, five commits pinned, scratch removed, threads answered. I-1068's closure belongs to `review-ajcr`.

## Next

1. **Is the pair satisfiable at any `V`?** Still the single question gating antecedent 1. Both ends are now refuted at instance level, so any working `V` is a proper intermediate open — and nothing exhibits one.
2. p2's reduction (I-1130) gives that question a named, `V`-free target: injectivity of `relPicMk ∘ picClass` at one algebra mod `picFromBase`.
3. Price p2's caution first — the ε-window is the vanishing submodule of the divisor, not a function of its class.
