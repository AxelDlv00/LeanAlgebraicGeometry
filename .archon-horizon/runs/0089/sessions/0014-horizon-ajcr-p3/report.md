Confirmed: nothing durable of mine is uncommitted. The file-mutating calls after my last ledger commit were the two memory files under `/home/axel/.claude-api/.../memory/` (the new fact plus its `MEMORY.md` pointer) — that directory sits outside `$HORIZON_LEDGER_WORK_TREE` by design and is not committable to the ledger, which is exactly why the checkpoint fired with nothing stageable. The other mutation was `scratch_p3r6/`, my probe directory, which I deleted; `ls` confirms no `p3` scratch remains in the project.

All five paths I authored or repaired hash-match HEAD.

## Progress

- **`Picard/DivisorFamilyAffFieldMono.lean`** (new, rooted, 9 declarations, 0 sorries): the field-level window-recovery mono is carrier-free. `eqnsWindowGermSet` states the ε-window germ set on a bare `LocalEquations`; two `rfl`s show **both** carriers' germ sets *are* it. Then `span_eqnsWindowGermSet_le`, `divEq_of_eps_eq_of_field_of_windowGen` (widened field mono given `hgen`), and `hgen_of_chart_divEq` / `hgen_toAff` — **`hgen` transports along a `DivEq`, hence is free with no hypothesis on the `CertifiedDivisorFamily.toAff` image.**
- **`AlgebraicJacobian.lean`**: rooted, so the `rfl`s are kernel-checked in-graph.
- **`Picard/DivisorFamilyAffFrameCover.lean`**: restored 73 lines of p1's work that my own commit reverted.
- **Board**: `fieldmono-aff` claimed → done → released, pinned `64d309c665`.
- Verification: 9/9 axiom-clean `[propext, Classical.choice, Quot.sound]` on rebuilt oleans vs a control firing `sorryAx`; root build EXIT=0 at 9323 jobs; per-file check EXIT=0, zero warnings.

**Which item and why third.** I-1248 named separation as the widened tower's load-bearing missing rung. I read the proof, not the name: `stalkIdeal_le_span_windowGerm_of_field` touches its carrier only through `G.eqns`. p1 held the sibling rung `framecover-aff`, so no contest.

**State: closed as scoped; no antecedent of the seam moves.** `rep` still has zero producers; `IsChartUniv` and Zariski-local surjectivity untouched. Non-vacuity checked by deletion: dropping `hgen` leaves the goal open, dropping `heps` reduces it to a span equality on which `rfl` **fails**.

## Issues

**My central pricing was wrong, retracted in-tree.** "~250 mechanical lines" for `hgen` was refuted by a fresh-context audit; I reproduced it before accepting — the real cost is ~12 lines. The residue changed shape: not "transcribe the window generation widened" but "produce a chart-typed `DivEq` representative for an arbitrary widened family", which off the `toAff` image is the straddling case `forall_not_isCertified_of_straddling` refutes. That is the R2 asymmetry one level down, not missing plumbing.

Three more of my claims refuted and fixed: a deliverables list naming **five nonexistent declarations**; "geometry-free", false since `divisorWindow` names `fiberTwoCover π`; and one exhibit billed as carrier-dependent whose binder is dead.

**I reverted 73 lines of p1's file** (`64d309c665`), repaired at `d37f7c0c62`, p1 confirmed intact. The propagatable finding (I-1309): the prescribed pre-commit check *cannot* catch this — `diff --cached` compares the index to the same HEAD the reversion is relative to. Only the post-hoc `show HEAD --stat` caught it; fourth independent reproduction.

## Why I stopped

Objective complete for this round. `hgen` is **not** proved for an arbitrary widened family and I do not claim it is.

## Next

`(divFunctorAff C n).RepresentableBy` remains the bottleneck; per I-1216 antecedent 1 is downstream of it. Before pricing any further widened rung, ask what its two sides are invariant under — I-1366 records why.
