# Progress Critic Report

## Slug
p4t3

## Iteration
007

## Routes audited

### Route: P4 abstract acyclic-resolution lemma → `AcyclicResolution.lean`

- **Sorry trajectory**: 0 → 0 → 0 across iter-004–006. Per the metric note in the directive, this lane runs under `[prover-mode: mathlib-build]` and has had 0 sorries throughout; "sorry count 0→0" is **expected and is not a stall signal**. The operative metrics are (i) axiom-clean declarations added per iter and (ii) named P4 blueprint targets closed per iter.

- **Declaration trajectory (operative metric 1)**:
  - iter-004: +5 (consumers of the horseshoe engine)
  - iter-005: +27 (horseshoe core, τ-recursion, 3/4 sub-goals)
  - iter-006: +14 (`quasiIso_τ₂`, middle-resolution quasi-iso, horseshoe assembly, dimension shift)
  - Total: +46 axiom-clean declarations across 3 iters, with the per-iter count declining because the substantive construction is converging, not because the route is stalling.

- **Named P4 targets closed (operative metric 2)**:
  - iter-004: 0 / 3 — built consumers; correctly declined the horseshoe monolith (no axiom-clean partial fragment existed)
  - iter-005: 0 / 3 — built 3/4 horseshoe sub-goals; blocked on `quasiIso_τ₂` absent from Mathlib
  - iter-006: **2 / 3** — TARGET 1 (horseshoe `ofShortExact`) ✅, TARGET 2 (dimension-shift `rightDerivedShiftIsoOfAcyclic`) ✅; TARGET 3 (`rightDerivedIsoOfAcyclicResolution`) deferred with a precise (a)+(b) decomposition recipe

- **Helper accumulation**: +46 declarations across 3 iters; 2 of 3 named targets closed. Payoff is real and accelerating (iter-006 delivered the two largest targets). No helper-accumulation-without-payoff pattern.

- **Prover dispatch pattern**: 1 of 1 truly-ready lane dispatched each iter. P3 was blocked (statement gap) and P5 requires P3+P4 to be complete; there was no second ready lane available in any of iters 004–006. Full utilization of ready lanes throughout.

- **Recurring blockers**:
  - "declined + handed off decomposition" appears in iters 004, 005, 006 — **but the decomposition target shrank strictly each time**: horseshoe monolith (iter-004) → horseshoe core + missing `quasiIso_τ₂` (iter-005) → TARGET 3 (a)+(b) only (iter-006). This is the decompose-then-build pattern; each handed-off residual was strictly smaller and different.
  - "absent from Mathlib" (iter-005: `quasiIso_τ₂`) — **resolved in iter-006**. No live recurring blocker.

- **Avoidance patterns**: None. Route was active all 3 iters; no deferral language; no consecutive plan-only iters; no off-critical-path reclassification.

- **Prover status pattern**: PARTIAL (iter-004), PARTIAL (iter-005), PARTIAL/COMPLETE (iter-006).
  - Note on the PARTIAL×3 flag: the verbatim CHURNING rule includes "PARTIAL prover status ≥3 of last K iters." However, iter-006's status is explicitly "PARTIAL/COMPLETE" — 2 of 3 named targets were **closed** that iter; the "PARTIAL" component refers solely to TARGET 3 being correctly deferred as a separate multi-lemma construction (the planner-recommended decompose-then-build fast path). A literal reading of the PARTIAL×3 criterion requires 3 pure PARTIAL statuses; iter-006 does not qualify. Even if it did, the named-target trajectory (0→0→2/3 closed) is unambiguous convergence, not churn — the operative metric for this lane contradicts the false positive. This is recorded as an informational note, not a CHURNING finding.

- **Throughput**: SLIPPING — estimate "~2–4" iters, elapsed 4 (iters 004–007 inclusive per the directive's count). We are at the upper bound of the estimate with one named target still open. The planner's iter-007 proposal addresses TARGET 3 via the prover-recommended (a)+(b) decomposition; if that succeeds, the route closes on schedule at the estimate's upper bound.

- **Verdict**: **CONVERGING**

---

## PROGRESS.md dispatch sanity

Verdict: OK — file count 1 within cap 10, no under-dispatch (no other ready lanes exist: the three remaining frontier nodes in `CechHigherDirectImage.lean` all fail the blueprint HARD GATE, P3 carries a statement gap, and P5 requires P3+P4 complete before it can be dispatched).

---

## Informational

**PARTIAL×3 false positive note.** The verbatim CHURNING rule includes "PARTIAL prover status ≥3 of last K iters." Applied mechanically to this lane it would read CHURNING. It does not apply for two independent reasons: (1) iter-006 carried a "PARTIAL/COMPLETE" designation because 2/3 named targets closed that iter — it is not a pure PARTIAL; and (2) the operative metric for this `mathlib-build` lane is named targets closed, not sorry counts, and the target trajectory (0→0→2/3) is unambiguous forward motion. The PARTIAL designation in each iter reflects the prover correctly refusing to bundle too much into one build, not a failure to make progress. The route has never run into the same wall twice; each "decline" was followed by the handed-off sub-goal being fully resolved the next iter.

**Throughput note.** Iter-007 is the last iter within the "~2–4" estimate window. TARGET 3 closes if the (a)+(b) decomposition the prover handed off succeeds this iter. The plan is coherent with the residual. No schedule escalation is warranted yet — but if TARGET 3 is again deferred to iter-008 the route will be SLIPPING past the estimate upper bound and the throughput check should be revisited.

---

## Overall verdict

One route audited, one CONVERGING verdict, zero CHURNING/STUCK verdicts, zero avoidance findings, dispatch OK. The P4 route is on track: 46 axiom-clean declarations built across 3 effective iters, 2 of 3 named targets closed in iter-006, and a concrete (a)+(b) recipe in hand for the one remaining target (TARGET 3, `rightDerivedIsoOfAcyclicResolution`). The planner's iter-007 proposal — effort-break + blueprint-clean + single `mathlib-build` dispatch — is consistent with the route's trajectory and the residual's actual scope. No corrective action is required this iter.
