# Progress Critic Report

## Slug
iter019

## Iteration
019

## Routes audited

### Route: FBC — AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **Sorry trajectory**: 4 → 4 → 4 → 4 across iter-015 to iter-018. Flat for all 4 audited iters. Net change over K=4 window: 0.
- **Helper accumulation**: iter-015: +1 scaffold (sorry-bearing); iter-016: +1 (`pullbackPushforward_unit_comp`, axiom-clean); iter-017: +4 (Seam-2 sub-lemmas, axiom-clean — the mandated motive-wall corrective); iter-018: +0 (comment rewrite + one scaffolding `rw` line). Helpers added in 3 of 4 audited iters; sorry-elimination across all 4 iters: 0. The STUCK clause "helpers added without any sorry-elimination across K iters" fires without ambiguity.
- **Prover dispatch pattern**: 1 file per iter — single-file route, no under-dispatch finding applicable.
- **Recurring blockers**: "motive is not type correct" / "dependent-leg-transport" has appeared across iters 014–018 — a 5-iter run. The specific sub-obstacle (step-iii goal in `base_change_mate_fstar_reindex_legs`) has been UNMOVED for 5 consecutive iters (014–018). The iter-018 prover documented this as a "literal-form lock": after `subst` of the pullback legs the goal cannot be refolded to the target form because the motive-type-correctness constraint prevents `rw [he, hinclA]` from applying to the goal itself (only to a key hypothesis). STUCK rule: "recurring blocker phrase across ≥3 iters" fires — this blocker is at 5 iters.
- **Avoidance patterns**: none. All 4 audited iters had prover dispatches.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL — 4 of 4 PARTIAL. Both the CHURNING criterion ("PARTIAL ≥3 of last K iters") and the STUCK criterion fire simultaneously.
- **Throughput**: OVER_BUDGET — Phase FBC-A "Iters left: 2–3" per STRATEGY.md; elapsed ~8 iters in phase. 8 >> 2 × 3 = 6. This is the third consecutive iter flagging OVER_BUDGET on FBC-A; the estimate has not been revised.
- **Verdict**: **STUCK** — three independent STUCK criteria fire: (1) sorry count unchanged across K=4 iters with recurring blocker ≥3 iters; (2) helpers added in 3 of 4 iters with zero sorry-elimination across K; (3) specific step-iii goal unmoved for 5 consecutive iters despite helpers, blueprint expansion, and structural refactor all attempted. CHURNING also fires (PARTIAL×4) but STUCK dominates.
- **Primary corrective**: **Refactor** — The whole-goal proof strategy for `base_change_mate_fstar_reindex_legs` has failed through iters 014–018. The literal-form lock means step-iii cannot be proved in the current single-lemma context. The correct response is structural decomposition: extract each of the 5 recipe steps as a standalone `private lemma` or `theorem`, prove each independently in a context where the substituted legs are not opaque, and then assemble `base_change_mate_fstar_reindex_legs` from the pieces by `exact`. The 150-LOC telescoping recipe documented in iter-018 must be used as the decomposition blueprint. Blueprint expansion has already been attempted (iter-018 GATE-PASS) and the post-prover checker confirmed it was still inadequate for step-iii — another blueprint-only pass is NOT the right corrective; the structural decomposition is. If the prover cannot make the step-iii crux movable by decomposition, escalate to user.
- **Secondary correctives**: (1) OVER_BUDGET administrative: revise FBC-A "Iters left" in STRATEGY.md to 2–3 iters post-decomposition (the decomposition itself costs an iter); this is the third consecutive iter this estimate has been flagged as stale.

---

### Route: GF — AlgebraicJacobian/Picard/FlatteningStratification.lean

- **Sorry trajectory**: 5 → 4 → 3 → 3 across iter-015 to iter-018. Net: −2 in K=4 iters. Stalled in the last two iters (017→018 flat at 3). Not strictly decreasing across the full K-window, but the net rate (0.5 closures/iter) is above the CHURNING threshold of <1 per 2 iters.
- **Helper accumulation**: iter-016: 0 (closed the tower-descent stub); iter-017: 0 net (L5 closed via signature simplification); iter-018: foundation steps F1–F6 landed inside L4 (no new top-level sorry-bearing decl, assembly residue isolated). Helper-churn pattern does not fire: additions in at most 1 iter (the F1–F6 foundation, which are part of the L4 proof body, not fresh top-level helpers). Both genuine closures (L5 in iter-017, tower-descent in iter-016) happened with zero new helpers in those iters.
- **Prover dispatch pattern**: 1 file per iter — single-file route.
- **Recurring blockers**: OreLocalization instance diamond (iters 015–016, resolved iter-017). The new L4 blocker "assembly residue: injectivity + finiteness coupled through witness g" first appeared in iter-018 — 1 occurrence, below the ≥3 recurring threshold. No recurring blocker active.
- **Avoidance patterns**: none.
- **Prover status pattern**: PARTIAL (015), COMPLETE — L5 (016... correction: the directive states COMPLETE at iter-016 for tower-descent, COMPLETE at iter-017 for L5, PARTIAL at iter-018 for L4). Pattern: PARTIAL, COMPLETE, COMPLETE, PARTIAL — 2 COMPLETEs in 4 iters; PARTIAL count = 2 (below ≥3 threshold). CHURNING does not fire.
- **Throughput**: OVER_BUDGET — Phase GF-alg "Iters left: 2–3" per STRATEGY.md; elapsed ~8 iters in phase. Administrative finding; the route is genuinely advancing (−2 sorries over K=4 iters, 2 COMPLETEs).
- **Verdict**: **CONVERGING** — sorry net −2 over K=4 iters; no recurring blocker ≥3 iters; helpers-without-closure rule does not fire (genuine closures in iters 016 and 017); PARTIAL count only 2 of 4. The flat iter-018 is a single-iter stall on a well-characterized L4 assembly residue (injectivity + finiteness through witness g), not a recurrent wall. The planner's proposal (close L4 assembly residue after blueprint Step-3 expansion) is "finish what's started." CONVERGING.
- **Watchpoint for iter-019**: The L4 sorry (line 516 of GF file) has been PARTIAL for 1 iter. If the assembly residue (injectivity + finiteness coupling) is not closed in iter-019, the recurring-blocker clock starts at 1. One more PARTIAL would place GF at 2 consecutive PARTIAL iters for L4, two more at the CHURNING threshold — not an immediate concern, but the assembly residue must close this iter or a targeted sub-lemma scaffold must land.
- **Secondary correctives**: OVER_BUDGET administrative — revise GF-alg "Iters left" in STRATEGY.md (same stale estimate flagged by iter-018 progress-critic; realistic remaining: 2 iters for L4 closure + gated `genericFlatnessAlgebraic`).

---

### Route: QUOT — AlgebraicJacobian/Picard/QuotScheme.lean

- **Sorry trajectory**: 4 → 4 → 4 → 4 across iter-015 to iter-018. Flat for all 4 audited iters. The 4 sorries are designated protected stubs — none can be closed until the induction body connects to them. However, the STUCK criterion does not distinguish between protected and unprotected stubs: **the route's goal is stub closure**, and 4 iters without closure is the signal, regardless of stub taxonomy.
- **Helper accumulation**: iter-016: +3 (axiom-clean); iter-017: +13 (axiom-clean, Route-2 foundation); iter-018: +20 (axiom-clean, poly-module + datum + ker/coker calculus + base-case finiteness). Helpers added in 3 of 4 audited iters with acceleration (+3 → +13 → +20). Zero sorry-eliminations across all 4 iters. STUCK clause "helpers added without any sorry-elimination across K iters" fires. The iter-018 review agent itself flagged: "QUOT must now CLOSE a stub / land the induction, not add more helpers, or treat as CHURNING." The iter-018 progress-critic set a watchpoint: "if iter-018's QUOT prover does NOT close at least 1 of the 4 protected sorries, the STUCK criterion will fire unambiguously at iter-019." The watchpoint condition has been met: 0 stub closures in iter-018.
- **Prover dispatch pattern**: 1 file per iter (015–018). iter-016 was a Route-2 pivot planning iter (no QUOT prover dispatched) — not an avoidance pattern, it was the mandated CHURNING corrective.
- **Recurring blockers**: "isDefEq/whnf pathology" avoided by Route-2 encoding (no recurrence). No explicit recurring blocker phrases. The structural issue is the route has not transitioned from infrastructure building to induction-body writing after 2+ Route-2 prover iters.
- **Avoidance patterns**: none detected by the formal rules. However, the accelerating decl count (+3 → +13 → +20) with 0 stub closures is a form of **work-in-place avoidance**: the prover is demonstrably busy but the deliverable (stub closures) has not advanced. This pattern matches the spirit of "adding helpers each iter while the residual stays the same," which is the CHURNING definition.
- **Prover status pattern**: PARTIAL/building (015, Route-1), N/A pivot (016), PARTIAL/building (017, Route-2), PARTIAL/foundation-complete but induction BODY not started (018). All prover iters: PARTIAL. The induction body has not been written across 2 Route-2 prover iters.
- **Throughput**: ON_SCHEDULE — Route-2 prover iters: 2 (iters 017, 018). STRATEGY.md says "QUOT-defs: 4–7 iters." Elapsed 2 ≤ 4, within estimate. This is the only route not OVER_BUDGET on throughput.
- **Verdict**: **STUCK** — the STUCK clause fires: helpers added in 3 of 4 audited iters, zero sorry-elimination across K=4 iters. The iter-018 progress-critic's explicit watchpoint condition was met (no stub closure in iter-018). The route has accumulated ~36 declarations (3+13+20) without advancing the stub count. That the sorries are "protected" is mathematically true but strategically irrelevant: the route's success criterion is stub closure, and the induction body — the only mechanism that can close the stubs — has not been started.
- **Primary corrective**: **Refactor** — the prover's working strategy must change from bottom-up infrastructure assembly to top-down induction-body drafting. In iter-019, the prover must write the induction body skeleton FIRST: the `subquotient_finite_transfer` induction template with `Nat.rec`/`Fin.inductionOn`, the base case stub, the inductive step stub, and the bridge to `gradedModule_hilbertSeries_rational` — introducing intermediate sorries as needed — such that at least one protected stub is directly connected to the proof chain (i.e., appears as a `exact ?_` or `apply` in a closed subgoal). Only after this skeleton is written should additional helper-filling proceed. If the prover cannot write the induction skeleton at all (cannot connect any protected stub to a proof term), escalate to user.
- **Secondary correctives**: None — the Mathlib infrastructure is confirmed present, the blueprint sketches exist, and a route pivot is not warranted given throughput is ON_SCHEDULE. Only the working strategy needs to change.

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (cap: 10)
- **Ready but not dispatched**: none identified — the 3 proposed files are the only active routes with open sorries
- **Over the cap**: no
- **Under-dispatch finding**: no — all active lanes in proposal; 3 of 3 ready files dispatched
- **Iter-over-iter trend**: 3 → 3 → 3 → 3; stable at 3 active files

**Sequencing discipline flag (not an under-dispatch finding, but must-execute)**:
The FBC proposal says "after an effort-break of `base_change_mate_fstar_reindex_legs` into atomic sub-lemmas." The iter-018 blueprint-writer output was confirmed STILL inadequate for step-iii by the post-prover checker. If the iter-019 FBC prover is doing the decomposition AND the proving, it must not re-attempt the whole-goal proof path before the decomposition is complete. The corrective requires that the decomposition is written as standalone lemmas FIRST (even as sorries), then proved one at a time. A blueprint update (adding the atomic lemma stubs to `lem:base_change_mate_fstar_reindex_legs`) before the prover dispatch would strengthen this — but is not blocking if the prover's directive is clear that whole-goal attempts are disallowed.

- **Verdict**: OK — file count 3 within cap 10, no under-dispatch finding. Sequencing discipline required for FBC prover.

---

## Must-fix-this-iter

- **Route FBC: STUCK** — primary corrective: **Refactor**. The `base_change_mate_fstar_reindex_legs` whole-goal proof strategy has failed for 5 consecutive iters; the literal-form lock makes the step-iii goal unprovable in the current single-lemma context. The prover must decompose the lemma into independently provable atomic sub-lemmas (the 5-step recipe) and prove each separately. Whole-goal attempts are prohibited this iter. If the decomposition cannot make step-iii movable, escalate to user.

- **Route FBC: OVER_BUDGET** — STRATEGY.md "Iters left: 2–3" in FBC-A; elapsed ≈8 iters (> 2×3=6). Third consecutive iter flagging this. Revise FBC-A estimate to 2–3 post-decomposition iters (the decomposition itself costs iter-019) before iter-019 plan is finalized.

- **Route QUOT: STUCK** — primary corrective: **Refactor**. The working strategy must change from bottom-up to top-down: write the induction body skeleton with intermediate sorries, connecting at least one protected stub to the proof chain. Zero stub closures after 36 added declarations and 2 Route-2 prover iters is an execution failure, not a math gap. The induction skeleton must be the first thing written in iter-019 before any further helper additions.

- **Route GF: OVER_BUDGET** — STRATEGY.md "Iters left: 2–3" in GF-alg; elapsed ≈8 iters (> 2×3=6). Administrative: GF is CONVERGING; revise the estimate to 2 iters (L4 closure, then gated `genericFlatnessAlgebraic`).

---

## Informational

**GF CONVERGING with care**: the CONVERGING verdict holds on the data (−2 sorries in K=4 iters, 2 COMPLETEs, no recurring blocker). The L4 iter-018 PARTIAL is a single stall on a specific assembly coupling. The blueprint Step-3 expansion proposed for iter-019 is the correct prep move. If this preparation was not completed before iter-019 dispatch, it should happen first.

**QUOT: route is not failing mathematically.** All engine lemmas confirmed present, isDefEq pathology avoided, 36 axiom-clean declarations built. The failure is purely strategic: the prover has not written the induction body. The math is ready; the code is not. A top-down pivot (skeleton first) should unblock this in a single iter.

**FBC: the Step-iii goal has been the sole obstacle since iter-014.** Everything else in FBC (Seam-1, Seam-3 cascade, `base_change_mate_fstar_reindex` itself) is now sorry-free. The entire route status rests on one 5-step proof path that keeps hitting the literal-form lock in the whole-lemma context. Decomposition is the appropriate and targeted fix; it is not a speculative escalation.

---

## Overall verdict

Two routes STUCK (FBC, QUOT), one CONVERGING (GF). FBC has been at sorry-4 for 5 consecutive iters — the longest stall in the project — with helpers added and multiple correctives attempted; the literal-form lock in step-iii is a hard structural obstacle that requires decomposing the lemma, not re-attempting it. QUOT has accumulated 36 axiom-clean declarations in 2 Route-2 prover iters without closing any protected stubs; the induction body has not been written, and more infrastructure additions without a stub-connecting skeleton would confirm route failure. GF is genuinely advancing (−2 sorries, 2 COMPLETEs in 4 iters) and the L4 assembly residue is a well-scoped 1-iter closure target. Both FBC and GF carry stale OVER_BUDGET throughput estimates requiring STRATEGY.md updates. The planner must address FBC and QUOT via the refactor approach this iter — under-spec of the corrective (e.g. dispatching the prover without enforcing the decomposition-first or skeleton-first constraint) will reproduce the STUCK pattern for a sixth and third iter respectively. No avoidance patterns detected. Dispatch is clean (3 files, within cap, all active lanes).
