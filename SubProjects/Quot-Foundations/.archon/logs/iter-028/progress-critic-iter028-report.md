# Progress Critic Report

## Slug
iter028

## Iteration
028

## Routes audited

### Route: FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: ~6 → ~6 → 5 → 5 across iter-020 to iter-026 (1 sorry closed in 4 iters; flat for 2 consecutive iters)
- **Helper accumulation**: helpers added in ≥3 of the last 4 iters (iter-020, 022, 024); iter-026 added 0 new sorries but also closed 0. Net: 1 sorry closed across 4 iters while helpers accumulated.
- **Prover dispatch pattern**: signals don't enumerate "N of M ready" across the window, so no under-dispatch finding here.
- **Recurring blockers**: "literal-form lock" appears in iter-020, iter-022, iter-024 (3 consecutive iters). The blocker was resolved in iter-026 via `erw` (defeq match). The blocker is no longer active, but it consumed 3 iters without a sorry close.
- **Avoidance patterns**: none — the route has been continuously dispatched.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL (all 4 iters)
- **Throughput**: OVER_BUDGET — phase FBC-A entered at iter-018; `Iters left` in STRATEGY.md at phase entry was 2–4; 10 iters have elapsed (iter-018 through iter-028); 10 > 2× 4 = 8.

**Verdict: CHURNING**

Triggered by: (a) PARTIAL prover status in all 4 of the K=4 iter window — this fires the CHURNING rule mechanically regardless of the structural advance in iter-026; (b) sorry count net down by only 1 in 4 iters (< 1 per 2 iters); (c) OVER_BUDGET on phase duration.

**Primary corrective: Blueprint expansion**

The iter-026 advance (breaking the literal-form lock via `erw`) changed the live route from the pre-subst `inner_value_eq` path to the post-subst `_legs` path, and confirmed the pre-subst path is walled. The blueprint chapter's proof sketch must be updated to reflect this routing decision explicitly before the next prover round: (1) close off the pre-subst route as a dead end; (2) document that `erw` (defeq matching) rather than `rw` (syntactic matching) is required at the unit-expansion step; (3) decompose the remaining `_legs` cancellation assembly into explicitly numbered sub-goals in the chapter (`_gammaDistribute` application, codomain-read unfold, `_eCancel` telescoping, Seam 1 transport) so the prover can close them individually rather than tackling ~100 LOC as a single obligation. The in-code comments document this plan but the blueprint chapter may still show the pre-subst route; the mismatch is why 4 prover passes haven't closed this sorry.

**Note on iter-026's advance**: The `erw` tactic solving the unit-expansion step IS a genuine structural advance — this is not discarded-helper churn — but the sorry count remained flat because no prover pass attempted the full assembly after the unlock. The CHURNING verdict reflects the PARTIAL×4 rule firing, not a judgment that iter-026 was wasted.

---

### Route: QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

- **Sorry trajectory**: 4 → 4 across iter-024 to iter-026 (flat by design; protected stubs only)
- **Helper accumulation**: +2 axiom-clean decls in iter-024; +5 axiom-clean decls in iter-026. Infrastructure build accelerating.
- **Prover dispatch pattern**: only 2 iters of signals (iter-024, iter-026) within the K=4 window.
- **Recurring blockers**: blocker changed between the two iters — iter-024 had "gap1 hand-wavy", iter-026 has the more precise "G1-core needs multi-session Stacks-01HA descent." The blocker phrase is evolving, not stuck.
- **Avoidance patterns**: none identified.
- **Prover status pattern**: PARTIAL, PARTIAL (2 data points)
- **Throughput**: ESTIMATE_FREE — STRATEGY.md gives "Iters left: 4–7" as a range but the directive does not supply the iter at which QUOT-defs started, so elapsed vs. estimate cannot be computed from the K=4 window alone.

**Verdict: UNCLEAR**

Only 2 iters of QUOT-defs signal are available in the K=4 window. Progress by the relevant metric (axiom-clean infrastructure added per iter) is positive and accelerating. The keystone obligation has been narrowed to exactly G1-core. The planner's proposed dispatch (Mathlib-analogist consult on whether a shorter affine descent replaces the full Stacks-01HA route) is the correct first move before a prover round on G1-core. No corrective needed yet; watch for signs of G1-core becoming a recurring blocker if the Mathlib-analogist consult does not reduce its scope.

---

### Route: GR — `AlgebraicJacobian/Picard/GrassmannianCells.lean`

- **Sorry trajectory**: 0 throughout (mathlib-build lane; progress = new axiom-clean decls)
- **Helper accumulation**: iter-012: +28 decls (GR-cells sub-phase, COMPLETE); iter-026: +11 decls (GR-glue sub-phase, PARTIAL). Only 2 dispatch data points within the K=4 window, separated by a 14-iter gap in which the sub-phase changed.
- **Prover dispatch pattern**: 1 dispatch (iter-026) in the K=4 window (iters 024–026); iter-024 has no GR signal.
- **Recurring blockers**: iter-026 names "construction volume + product-order subtlety" as the blocker, but qualifies both as now solved (product-order resolved by `awayMulCommEquiv` at iter-026). File currently ends at line 819 with all building blocks present (charts, transitions, cocycle, `awayPullbackIso`, `awayMulCommEquiv`) but the GlueData body (`t'`, `t_fac`, cocycle field, `.glued`) not yet written.
- **Avoidance patterns**: none — the 14-iter gap is accounted for by the GR-cells→GR-glue sub-phase transition. Not an avoidance pattern.
- **Prover status pattern**: COMPLETE (iter-012, GR-cells), PARTIAL (iter-026, GR-glue) — two different sub-phases, not a same-wall repeat.
- **Throughput**: ESTIMATE_FREE for GR-glue — QUOT-repr gives "6–12 iters left" for the whole sub-phase; GR-glue entered iter-026, so 1 iter elapsed. Well within estimate.

**Verdict: UNCLEAR**

Only 1 GR-glue iter of signal (iter-026) exists. The sub-phase is fresh. The proposed iter-028 dispatch (GlueData → `Grassmannian.scheme`) is the natural progression. The GlueData construction is large-but-specified: all fields have proved supporting lemmas in the file; the remaining work is assembly. No corrective needed; re-assess at iter-030 if the GlueData body remains unwritten.

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (cap: 10)
- **Ready but not dispatched**: none identified — all 3 active lanes are in the proposal
- **Over the cap**: no
- **Under-dispatch finding**: no — 3 files proposed, 3 active lanes
- **Iter-over-iter trend**: insufficient window (only current proposal available from directive)

**Verdict: OK** — file count 3 within cap 10, no under-dispatch.

---

## Must-fix-this-iter

- **Route FBC: CHURNING** — primary corrective: **Blueprint expansion**. Before the next prover round, update the FBC chapter to (a) explicitly close the pre-subst `inner_value_eq` route as walled, (b) document `erw` as the required tactic at the unit-expansion step, and (c) decompose the `_legs` cancellation into numbered sub-lemmas so the prover has individually closeable targets. Reason: 4 PARTIAL prover statuses with only 1 sorry closed; the blocker was broken in iter-026 but the chapter may not yet reflect the new routing, causing the prover to rediscover (or fail to follow) the post-subst assembly plan.

- **Route FBC: OVER_BUDGET** — STRATEGY.md phase FBC-A entered iter-018 with estimate 2–4 iters; 10 iters have elapsed. Revise the STRATEGY.md estimate for FBC-A to reflect reality (or confirm close is 1–2 iters away after the blueprint-expansion corrective).

---

## Informational

**QUOT (UNCLEAR)**: The Mathlib-analogist consult proposed by the planner for G1-core is the right prior step. G1-core involves a `cover-refine → local-tilde → flat-equalizer` descent whose step 1 requires `Scheme.Modules` site/over API. If the analogy consult finds a shorter affine descent that avoids the Stacks-01HA machinery, it would significantly de-risk the QUOT route.

**GR (UNCLEAR)**: The GlueData assembly is a volume task, not a missing-fact task — all required lemmas exist in the file. If the prover's iter-028 pass does not produce at least the `t_fac` and `t_id` fields axiom-clean, flag at iter-030 as a construction-volume blocker requiring decomposition into ≥2 separate prover passes (one per GlueData field group).

---

## Overall verdict

One route is CHURNING (FBC) and two are UNCLEAR (QUOT, GR). FBC has been in a PARTIAL cycle for 4 iters with only 1 sorry closed; it is also OVER_BUDGET (10 iters elapsed vs. a 2–4 iter phase estimate). The planner must address FBC before the next prover dispatch: expand the blueprint chapter to document the post-iter-026 routing change and decompose the `_legs` assembly into sub-lemma targets. QUOT and GR have insufficient K=4 window data for a firm verdict — both are fresh in their current sub-phases — but the proposed dispatch for each is directionally correct. Dispatch sanity is OK.
