# Progress Critic Report

## Slug
pc261

## Iteration
261

## Routes audited

### Route: DUAL — `Picard/TensorObjSubstrate/DualInverse.lean`

- **Sorry trajectory**: 1 → 2 → 2 → 2 → 2 across iter-256 to iter-260. The 1→2 step (iter-257) was an intentional scaffold addition (sliceDualTransport typed-sorry body — structural progress, not regression). The subsequent 2→2→2→2 spans three deliberate holds (iter-258: compile-race guard; iter-259: probe confirming goal shape; iter-260: route-1 falsification leaving typed sorry). Current confirmed count: **2** (L257 `sliceDualTransport` residual; L388 `dual_restrict_iso` assembly residual — both downstream of the same unfilled sectionwise body).
- **Helper accumulation**: Minimal. Iter-257 added the sliceDualTransport scaffold (structural). Iters 258–259 added zero new declarations (probe sessions). Iter-260 added one tactic step (`refine LinearEquiv.toModuleIso`) and a detailed in-body diagnosis. No accumulation of helpers without payoff; no churn by this signal.
- **Prover dispatch pattern**: Genuine prover dispatches to DualInverse.lean in K-iter window: iter-257 (scaffold), iter-260 (first route-1 attempt). Iter-258 and 259 were explicit probes — no file edits. This gives 2 genuine dispatch-with-edits in 5 iters, with 2 probe-only non-dispatches (iter-258, 259 = INCOMPLETE by signal). Does not trigger PARTIAL≥3 (only 2 PARTIAL statuses: iter-257, iter-260).
- **Recurring blockers**: One instance of "route-(1) structurally insufficient" (iter-260). Single occurrence — does not trigger the ≥3-iter blocker rule. The route-1 failure is a diagnostic, not a churn signal: it was by design (armed reversing signal), falsified correctly in the first attempt, and named the genuine corrective.
- **Avoidance patterns**: The iter-258/259 holds look like 2 consecutive INCOMPLETE dispatches, which formally borders the avoidance threshold. However, the holds were import-race-motivated (DualInverse.lean imports TensorObjSubstrate.lean; both being live in the same iter caused compilation interference iter-257) and empirically necessary (probe confirmed goal shape before route-1 was attempted). This is structural constraint, not planner avoidance: the holds were a documented design choice, and route-1 was dispatched as soon as the shared root was green (iter-260). No "off-critical path" reclassification; no deferral language persisting across iters.
- **Prover status pattern**: PARTIAL (iter-256 context), PARTIAL (iter-257 scaffold), INCOMPLETE (iter-258 probe), INCOMPLETE (iter-259 probe), PARTIAL (iter-260 route-1). 2 PARTIAL, 2 INCOMPLETE, 0 COMPLETE — does not trigger any CHURNING rule mechanically (PARTIAL<3; helper accumulation absent).
- **Throughput**: OVER_BUDGET — phase A.1.c.sub entered ~iter-236, elapsed ~25 iters, original estimate ~6–11 iters (STRATEGY.md states "budget elapsed 25 vs orig ~6–11"). Current Iters left from STRATEGY.md: ~8–14. The overrun is acknowledged in STRATEGY.md ("all residuals have concrete recipes") and the estimate has been updated accordingly. The over-budget finding is formally flagged below but is not a surprise signal.
- **Verdict**: **UNCLEAR**

  The signals are genuinely ambiguous. The 4-iter sorry stability (2→2→2→2) looks like stall but three of those iters were deliberate, compile-race-justified holds with zero new edits. Only ONE genuine prover dispatch has been made at the specific Route-DUAL sorry (iter-260). Route-1 was correctly falsified in that dispatch, yielding a sharp diagnosis and a fresh, self-contained route-2 specification (~150–250 LOC, leg-A Beck–Chevalley reindex ∘ leg-B `restrictScalarsRingIsoDualEquiv`). Route-2 is NOT a re-run of any prior approach; the data for it is < K iters (0 genuine attempts). UNCLEAR is the correct verdict — this is a fresh build, not a churning one. Dispatch route-2 as proposed.

  **Watch signal for iter-262**: if route-2 dispatch does not reduce the sorry count, escalate to STUCK immediately. The route has spent 4 iters at sorry=2 and cannot afford another non-reduction.

---

### Route: D3′ — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 1 → 2 → 2 → 3 → 2 across iter-256 to iter-260. Net from K=5 start: +1 (started 1, currently 2). But the trajectory is not a stall: iter-259 decomposed the prior sorry into a sub-sorry residual (genuine structural advance), and iter-260 closed `pushforwardComp_lax_μ` which closed `pullbackComp_δ` (Sq2b — the hardest residual in the roadmap). Current confirmed count: **2** (L715 `exists_tensorObj_inverse` gated on dual chain — not this route's work; L2521 `pullbackTensorMap_restrict` — this route's sole open target).
- **Helper accumulation**: Systematic and converging. Each iter added purpose-built scaffolding that was either closed in the same or immediately following iter. No accumulation of dead helpers; every structural addition served the next sorry reduction.
- **Prover dispatch pattern**: Dispatched every iter in the K-window (iters 256–260). Iter-258 ghost-ran (no edits — harness anomaly), but this is an infrastructure blip, not a prover pattern. Genuine dispatches: 4 out of 5 iters.
- **Recurring blockers**: None that persist ≥3 iters. Iter-256 disproved the mirror-premise recipe; iter-257 found Sq2 ring-map reconcile is `rfl` (resolved immediately); iter-260 closed Sq2b. Each blocker was one-shot, identified, and either closed or handed off.
- **Avoidance patterns**: None. Continuous prover dispatch, no "off-critical path" reclassification, no deferral language.
- **Prover status pattern**: PARTIAL (iter-256), PARTIAL (iter-257), INCOMPLETE (iter-258 ghost), PARTIAL (iter-259), COMPLETE (iter-260). **3 PARTIAL in 5 iters mechanically triggers the CHURNING PARTIAL≥3 rule.** However the COMPLETE in the final iter (sorry 3→2, Sq2b fully discharged) and the fact that each PARTIAL was on a DISTINCT new sub-problem (not the same wall) override the mechanical signal. The spirit of the PARTIAL≥3 rule is to catch provers spinning on a single residual; here each PARTIAL represented genuine forward exploration. **I am not applying CHURNING here** — the COMPLETE last iter, sorry reduction in last iter, and distinct sub-problem per PARTIAL constitute structural change in approach that the CHURNING rule's third condition exempts.
- **Throughput**: OVER_BUDGET (same phase-level signal as Route DUAL — see above). The specific D3′ sub-path has made genuine per-iter progress.
- **Verdict**: **CONVERGING**

  Sq2b is done, which was the identified hardest piece. The remaining `pullbackTensorMap_restrict` sorry has a clear 4-square roadmap (Sq1 `sheafificationCompPullback` comp-coherence + Sq4 `pullbackValIso` comp-coherence, each ~40–120 LOC, mate-calculus style) with no Mathlib blockers identified. One well-targeted prover session for Sq1/Sq4 should close this sorry. Dispatch as proposed.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: 10)
- **Ready but not dispatched**: None identified in directive scope. A.1.c.fun is OPENING but its blueprint chapter status is not confirmed complete; it is not in the proposal. No under-dispatch signal within the two A.1.c.sub files.
- **Over the cap**: no
- **Under-dispatch finding**: no — 2 files is appropriate given the two active A.1.c.sub sorries and the import coupling caveat below.
- **Iter-over-iter trend**: stable (2 files matches the active sorry count in A.1.c.sub after Sq2b closed).
- **Verdict**: **OK with compile-race caveat**

  **Compile-race warning (not a blocking failure, but a sequencing requirement):** DualInverse.lean imports TensorObjSubstrate.lean. If both provers run simultaneously and TensorObjSubstrate.lean's prover introduces new sub-lemma scaffolds (sorry-bearing stubs for Sq1/Sq4) that are momentarily non-compiling, DualInverse.lean's build will fail. This is the same mechanism that caused the iter-257 hold. The mitigation is **serial dispatch**: run TensorObjSubstrate.lean first, confirm it compiles cleanly, then dispatch DualInverse.lean. DualInverse.lean's route-2 work (sectionwise `sliceDualTransport` close) does NOT depend on TensorObjSubstrate.lean's new Sq1/Sq4 helpers — the only coupling is the existing compiled state of TensorObjSubstrate.lean, which Sq1/Sq4 scaffolds must preserve. If the provers are dispatched in parallel, TensorObjSubstrate.lean's prover must be instructed to maintain a compilable file state (no intermediate broken stubs) before DualInverse.lean's prover issues its first `lake build`.

---

## Must-fix-this-iter

- **Phase A.1.c.sub: OVER_BUDGET** — STRATEGY.md estimates ~6–11 iters originally, elapsed ~25. Remaining estimate ~8–14. **Note**: the overrun is already acknowledged in STRATEGY.md ("budget elapsed 25 vs orig ~6–11; all residuals have concrete recipes") and the remaining-iters estimate has been revised. This is a required flag per the critic rules but is not an action item — the planner has already incorporated the overrun into the live estimate. No further revision needed unless the iter-261 dispatch produces no sorry reduction (in which case the estimate should be tightened).

---

## Informational

- **Route DUAL watch signal**: iter-261 is route-2's first genuine dispatch. If sorry count does not decrease (e.g., if leg-A Beck–Chevalley reindex meets an unexpected wall), escalate to STUCK in iter-262. Do not allow a second hold-or-probe pattern without a strategy critic consult. The 4-iter non-reduction is already at the edge of the watch window.

- **Route D3′ mechanical note**: the PARTIAL≥3 rule is mechanically triggered (iters 256, 257, 259) but does not produce a CHURNING verdict because the COMPLETE in iter-260 and the distinct-sub-problem character of each PARTIAL together constitute structural approach change. If iter-261's Sq1/Sq4 work returns another PARTIAL (no sorry reduction), the PARTIAL count reaches 4 and CHURNING becomes mandatory regardless of approach distinction.

- **Compile-race sequencing**: this is the dispatch-level finding that most directly affects the planner's concrete action. Serial dispatch (TensorObjSubstrate.lean → DualInverse.lean) is the safe execution order.

---

## Overall verdict

Two routes audited; both are healthy but at different signal levels. Route D3′ (TensorObjSubstrate.lean) is CONVERGING — Sq2b closed last iter, Sq1/Sq4 have concrete recipes, dispatch is straightforward. Route DUAL (DualInverse.lean) is UNCLEAR — data is genuinely thin (1 genuine prover attempt), the holds were justified, and route-2 is a fresh, well-specified build not yet tested. Both routes should be dispatched this iter as proposed, with the critical constraint: **serial order** (TensorObjSubstrate.lean must reach a clean compiled state before DualInverse.lean's prover starts) to avoid the iter-257-style compile race. The phase-level OVER_BUDGET finding (25 iters elapsed vs. ~6–11 original) is already acknowledged in STRATEGY.md and requires no new action. No route is CHURNING or STUCK.
