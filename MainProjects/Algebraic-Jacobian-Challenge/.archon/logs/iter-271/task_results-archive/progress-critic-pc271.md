# Progress Critic Report

## Slug
pc271

## Iteration
271

## Routes audited

### Route: DUAL — `Picard/TensorObjSubstrate/DualInverse.lean` (`sliceDualTransport`)

- **Sorry trajectory**: decl-sorry flat at 2 for all 4 prover-round iters (262–265); internal holes 7 → 6 → 4 → 4 (down 3 in 4 iters; ZERO in the final iter-265). Rate is decelerating: 0 closure in the most recent iter despite 4 new helpers added.
- **Helper accumulation**: 7 helpers added across 4 iters (+1, +1, +1, +4). Fields closed: `map_add'` (iter-263), `map_smul'` (iter-264), then 0 in iter-265. The helpers/payoff ratio inverted in the final iter: 4 helpers, 0 fields.
- **Prover dispatch pattern**: Not under-dispatched; DUAL is consistently assigned.
- **Recurring blockers**: "monolithic ≃ₗ artifact" / "invFun needs standalone helper extraction" — appears in iter-264 AND iter-265 reports (2 consecutive iters). The same phrase named the blocker in iter-265 is verbatim the proposed remedy for iter-271.
- **Avoidance patterns**: None (route has been dispatched every prover round). Note: 5 consecutive plan-only DAG-cleanup iters (266–270) interrupted the prover sequence, but these are organizationally distinct from route avoidance and are acknowledged in the directive.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL (4 consecutive).
- **Throughput**: OVER_BUDGET — elapsed 26 iters in a phase estimated at ~12–20 iters total. Elapsed (26) exceeds the upper bound (20) of the estimate; by the lower bound (12), elapsed is >2× → over budget on either reading.
- **Verdict**: CHURNING
- **Primary corrective**: **Refactor** — the "monolithic ≃ₗ artifact" / "invFun needs standalone helper extraction" blocker has appeared for ≥2 consecutive iters, and the decl-sorry count has been flat at 2 despite 7 helpers. The correct unblocking move is to extract `sliceDualTransportInv` as a top-level definition BEFORE the ≃ₗ packaging attempt. The proposed iter-271 objective (extract `sliceDualTransportInv`, then close `invFun` + round-trips) is the right structural corrective. Mark it must-fix and ensure the prover treats the extraction as a prerequisite, not an optional optimisation.

---

### Route: D3′ — `Picard/TensorObjSubstrate.lean` (`sheafificationCompPullback_comp_tail`)

- **Sorry trajectory**: file-sorry flat at 3 for ALL 4 consecutive prover-round iters (262–265): 3 → 3 → 3 → 3. Zero reduction over the full window.
- **Helper accumulation**: 4 helpers added across 4 iters (+1 per iter, every iter). Zero file-sorries eliminated. This is the canonical STUCK signature: "helpers added without any sorry-elimination across K iters."
- **Prover dispatch pattern**: Not under-dispatched.
- **Recurring blockers**: "R1/R5 collapse tail" / "genuinely-novel sheafification-laden mate step (×3–4 iters)" appears verbatim in iters 263, 264, and 265 — three consecutive prover rounds. A separate but related dead-end ("transpose whole tail back through homEquiv is CIRCULAR") was found by hand in iter-263 and has never been resolved. The prover has tried different helper infrastructure each iter and hit the same wall each time.
- **Avoidance patterns**: Same 5-iter DAG pause (266–270) as DUAL — not avoidance in character.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL (4 consecutive).
- **Throughput**: OVER_BUDGET — same as DUAL (both are phase A.1.c.sub, entered ~26 iters ago, estimate 12–20 iters).
- **Verdict**: STUCK
  - Trigger 1 (STUCK): "helpers added without any sorry-elimination across K iters" — 4 helpers, 4 iters, 0 file-sorry reduction.
  - Trigger 2 (STUCK): recurring blocker phrase across ≥3 iters ("R1/R5 collapse tail" in 263, 264, 265).
  - CHURNING is also triggered (PARTIAL×4), but STUCK supersedes per verdict rules.
- **Primary corrective**: **Mathlib analogy consult** — the blocker is "no homEquiv head for the composite sheafify∘pushforward unit-mate step." The prover has correctly diagnosed that the step is genuinely novel and that the circular homEquiv transpose does not work, but has not found the non-circular Mathlib API path. The proposed iter structure (cross-domain analogist consult dispatched this iter to inform the prover) is the RIGHT corrective shape. **The analogy consult must COMPLETE and its recipe must feed into the prover's objective before the prover is dispatched on this file.** Do not dispatch the prover into D3' without the analogist's concrete recipe for R1/R5 — sending the prover back without a new approach will reproduce iter-265 exactly.

---

### Route: ENGINE — `Cohomology/CechHigherDirectImage.lean` (`pushPullMap_comp`)

- **Sorry trajectory**: 4 → 4 across iters 264–265 (2 prover-round iters). Note: 3 of the 4 sorries (`CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cech_flatBaseChange`) are deep Mathlib-absent theorems outside the scope of the engine work; the operative sorry is `CechNerve` (L97), which depends on `pushPullMap_comp`. The flat count is partly structural.
- **Helper accumulation**: +1 per iter (`pushPullMap_id`, then `pushPull_unit_mate`), both axiom-clean. These are substantive bricks, not churn helpers.
- **Prover dispatch pattern**: Not under-dispatched.
- **Recurring blockers**: "kernel whnf timeout on eqToHom transports" appears once (iter-265). Not yet recurring (only 1 occurrence).
- **Avoidance patterns**: None.
- **Prover status pattern**: PARTIAL, PARTIAL (2 iters only).
- **Throughput**: ON_SCHEDULE — elapsed ~5 prover-round iters out of an estimated 85–140 remaining. Well within range.
- **Verdict**: UNCLEAR — only 2 prover-round iters of data (K requirement is 3–5). The route entered its current phase recently; the blocker is well-identified (kernel whnf on the `eqToHom` over-triangle transports baked into `pushPullMap`'s definition), and the proposed corrective (build a kernel-cheap eqToHom-cancellation lemma — option b — rather than refactoring `pushPullMap`'s definition) is a reasonable next step. One note: if the cancellation lemma approach also hits kernel blow-up (since the DEFINITION still contains the same transports), the transport-light refactor of `pushPullMap` itself (option a) may be the more durable fix. The iter-265 prover comment already names both options; the planner should instruct the prover to escalate to option (a) if option (b) makes no progress within this iter.

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (cap: 10)
- **Ready but not dispatched**: none identified — the 3 files listed cover all 3 active routes.
- **Over the cap**: no
- **Under-dispatch finding**: no
- **Verdict**: OK — 3 files within cap, all active routes dispatched.

---

## Must-fix-this-iter

- **Route DUAL**: CHURNING — primary corrective: **Refactor** (extract `sliceDualTransportInv` as top-level def before attempting ≃ₗ packaging). Why: 4 consecutive PARTIAL iters, decl-sorry flat at 2, same "invFun needs standalone helper extraction" blocker for 2 consecutive iters; the helper-to-payoff ratio inverted in iter-265 (4 helpers, 0 closures).
- **Route DUAL**: OVER_BUDGET — elapsed 26 iters vs. estimate 12–20 iters. Revise the STRATEGY.md estimate or escalate.
- **Route D3′**: STUCK — primary corrective: **Mathlib analogy consult** (analogist must complete and deliver a concrete R1/R5 recipe before prover dispatch). Why: 4 consecutive PARTIAL iters, file-sorry flat at 3 for all 4 iters (0 closures despite 4 helpers), recurring blocker "R1/R5 collapse tail" in 3 consecutive prover reports.
- **Route D3′**: OVER_BUDGET — same as DUAL (shared phase A.1.c.sub). Revise or escalate.

---

## Informational

- **Route ENGINE (UNCLEAR)**: The kernel whnf blocker on `eqToHom` transports is definitional, not mathematical — `pushPullMap_comp` cannot be proved without first either refactoring `pushPullMap` (option a) or building a kernel-cheap eqToHom cancellation lemma (option b). The proposed objective (option b) is sensible for one iter. If option b fails, option a (transport-light def refactor) should be escalated. With only 2 prover-round data points, no CHURNING/STUCK verdict is warranted yet, but the blocker should be watched closely.
- **5-iter DAG pause (266–270)**: The break in prover dispatches (due to blueprint graph cleanup) is organisationally legitimate but has extended the elapsed-iter count for DUAL and D3' without closing any sorries. Both routes were already SLIPPING before the pause; the DAG work made the OVER_BUDGET signal worse. If DAG-cleanup iters are expected to recur, the STRATEGY.md elapsed-iter accounting should note this to avoid inflating OVER_BUDGET signals from non-prover work.

---

## Overall verdict

Two of the three active routes are in poor health. D3′ (`sheafificationCompPullback_comp_tail`) is STUCK: file-sorry count has been locked at 3 for four consecutive prover rounds and the same blocker ("R1/R5 collapse tail") has appeared in three consecutive reports — the prover must not be dispatched again without a concrete recipe from the analogist consult. DUAL (`sliceDualTransport`) is CHURNING: the "invFun needs standalone helper extraction" blocker is named but not yet acted on, and the helper/payoff ratio inverted in the last iter. Both routes are OVER_BUDGET versus their 12–20 iter estimates (26 elapsed). The ENGINE route is UNCLEAR (2 data points) and on track. The planner must treat DUAL as a refactor-first iter (extract `sliceDualTransportInv` before the ≃ₗ packaging) and must hold the D3′ prover dispatch until the analogist consult delivers a concrete R1/R5 recipe; dispatching the prover without that recipe will reproduce iter-265 exactly.
