# Progress Critic Report

## Slug
iter015

## Iteration
015

## Routes audited

---

### Route: FBC — `Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 5 (iter-011) → 5 (iter-012) → [no data: iter-013 DAG-only] → 4 (iter-014).
  Net: −1 over 3 active-prover iters. Verified: current file has 4 actual sorry terms (lines 1170,
  1215, 1388, 1410; remaining grep hits are in comments).
- **Helper accumulation**: iter-012 added 3 typed seam decls (intentional structural decomposition)
  + proven `inner_value`. iter-014 closed Seam 1 (`base_change_mate_unit_value`) axiom-clean via
  conjugate-unit abstract calculus — the mathlib-analogist corrective prescribed by the iter-014
  critic was applied and paid off. No helper accumulation without payoff.
- **Prover dispatch pattern**: iter-011 dispatched, iter-012 dispatched, iter-013 no prover (DAG),
  iter-014 dispatched. 3 of 3 eligible iters dispatched. No under-dispatch.
- **Recurring blockers**: "`conjugateIsoEquiv` element chase" — was active in iter-011 and iter-012,
  resolved in iter-014 by replacing element-level ext chase with abstract conjugate-unit calculus.
  **RESOLVED.** No blocker persists into iter-015.
- **Avoidance patterns**: none.
- **Prover status pattern**: PARTIAL (iter-011), PARTIAL (iter-012), N/A (iter-013), **COMPLETE**
  (iter-014). The PARTIAL×3 streak that triggered CHURNING in iter-014 is broken.
- **Throughput**: SLIPPING — phase FBC-A entered iter-008, elapsed 7 iters; current `Iters left`
  1–2. The "long-running" tag in the directive confirms elapsed exceeds the likely original estimate.
  Total phase length will be ~9 iters. Without the original estimate the OVER_BUDGET threshold
  cannot be confirmed; flagged as SLIPPING. No must-fix implication at this stage given active
  convergence.
- **Verdict**: **CONVERGING**

The iter-014 CHURNING verdict + mathlib-analogist corrective produced a clean break: Seam 1 axiom-
clean, blocker phrase gone, prover status lifted from PARTIAL to COMPLETE. Next target (Seam 2
`fstar_reindex` → Seam 3 cascade) is typed-sorry with roadmap in place. Nothing masks churn here.

---

### Route: GF — `Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 5 (iter-011) → 5 (iter-012) → [no data: iter-013 DAG-only] → 4 (iter-014).
  Net: −1 over 3 active-prover iters. Verified: current file has 4 actual sorry terms (lines 516,
  1337, 1404, 1471; remaining grep hits are in comments).
- **Helper accumulation**: iter-011: +3 Nagata dévissage sub-lemmas (axiom-clean, mathematical
  payoff). iter-014: +5 transport helpers enabling `gf_torsion_reindex` closure. Each helper round
  yielded a closing in the same or next prover iter. No accumulation without payoff.
- **Prover dispatch pattern**: iter-011 dispatched, iter-012 dispatched, iter-013 no prover (DAG),
  iter-014 dispatched. 3 of 3 eligible iters dispatched.
- **Recurring blockers**: "inline (a)–(e) stacking blows isDefEq heartbeats" — active in iter-012,
  characterized precisely in the iter-014 must-fix, resolved in iter-014 by top-level helper
  factoring. **RESOLVED.** No blocker persists.
- **Avoidance patterns**: none.
- **Prover status pattern**: PARTIAL (iter-011), PARTIAL (iter-012), N/A (iter-013), **COMPLETE**
  (iter-014). Same break-out-of-PARTIAL pattern as FBC.
- **Throughput**: SLIPPING — phase GF-alg entered ~iter-007, elapsed ~8 iters; current `Iters left`
  1–3. The iter-014 critic noted "if GF does not close in iter-014, the route is OVER_BUDGET" —
  it did close, landing at the strategy estimate ceiling (original 2–4 iters). Treating as SLIPPING
  given the boundary condition; not OVER_BUDGET because the sorry just dropped and only 1–3 remain.
- **Verdict**: **CONVERGING**

Parallel structure to FBC: iter-014 CHURNING verdict + correct corrective dispatched produced a
COMPLETE with sorry reduction. Next target (L5 `exists_free_localizationAway_polynomial` with
5-step roadmap → L4 → `genericFlatnessAlgebraic`) is typed-sorry with blueprint sketch. Nothing
masks churn.

---

### Route: QUOT — `Picard/QuotScheme.lean`

- **Sorry trajectory**: 4 (iter-012) → 4 (iter-013, no prover) → 4 (iter-014, no prover). Net: 0
  across all 3 SNAP-S2 iters. Verified: current file has 4 actual sorry terms (lines 126, 165, 201,
  228; all typed-sorry stubs with comments identifying them as downstream-blocked).
- **Helper accumulation**: iter-012: +8 axiom-clean decls (power-series engine). iter-014: graded-
  API blueprint chapter (`subsec:gradedModuleApi`, G1–G5/D5 over existing Mathlib scaffold) authored
  — a substantial setup artifact. Helpers added in 2 of 3 SNAP-S2 iters. Sorry-elimination: 0 in
  all 3 iters.
- **Prover dispatch pattern**: iter-012: QUOT dispatched (COMPLETE on power-series sub-build, but
  the 4 downstream-blocked sorry stubs were not the target). iter-013: no prover (DAG). iter-014:
  **no QUOT prover dispatch** — graded-API setup instead. 2 consecutive iters (013, 014) with zero
  prover dispatch targeting the 4 sorry stubs or their upstream prerequisites.
- **Recurring blockers**: none explicitly named for QUOT. The directive notes "typed-sorry count flat
  at 4 reflects downstream-blocked stubs" rather than a proof-search failure.
- **Avoidance patterns**: The iter-014 progress critic explicitly flagged 3 consecutive non-prover
  iters for QUOT (012 engine, 013 DAG, 014 setup) and required an "unconditional iter-015 prover
  commitment." That commitment was made. iter-015 is the first prover lane that will target
  QUOT's upstream building blocks (G1→G5). Two consecutive iters (013, 014) without QUOT prover
  dispatch puts this route one iter from the ≥3 consecutive plan-phase-only threshold.
- **Prover status pattern**: COMPLETE (iter-012, on power-series sub-build only), N/A (iter-013),
  N/A (iter-014). The COMPLETE result in iter-012 was on new decls, not the 4 sorry stubs.
- **Throughput**: ON_SCHEDULE — SNAP-S2 entered iter-012, elapsed 3 iters, `Iters left` 2–4.
  Total phase estimate 5–7 iters; 3 elapsed is well within range.

**Verdict rule applied verbatim**: "helpers added without any sorry-elimination across K iters" (K=3,
iters 012–014). Helpers added in 2 of 3 iters; sorry-elimination = 0. **STUCK** rule fires.

The architectural context is noted: the 4 sorry stubs are typed-sorry placeholders that cannot be
closed until G1–G5 graded-API building blocks exist. The helpers are building those prerequisites,
not failing to close the stubs. This is a genuine sequencing constraint, not proof-search failure.
The rule fires on the observable pattern regardless. The STUCK verdict is correct and the corrective
is timely: the G1→G5 prover lane is the remedy, and it is already in the iter-015 plan.

- **Verdict**: **STUCK**
- **Primary corrective**: **Fill all ready lanes** — the G1→G5 graded-API prover lane committed
  unconditionally for iter-015 must execute without displacement. This is the first prover round
  that targets QUOT's upstream building blocks. If G1→G5 land as axiom-clean decls this iter,
  the 4 stubs become closeable in iter-016 and the STUCK signal will not recur. If the iter-015
  prover lane is displaced or produces another setup/helper round without sorry-trajectory
  movement, the route escalates to unambiguous STUCK with no remaining automated corrective — the
  next step would be user escalation (route pivot or deferral decision).

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (cap: 10)
- **Files proposed**: FlatBaseChange.lean [prove], FlatteningStratification.lean [prove],
  QuotScheme.lean [prover-mode: mathlib-build]
- **Over the cap**: no.
- **Under-dispatch finding**: no — all 3 active routes with open sorries are in the proposal.
  GrassmannianCells.lean (new, 0 sorry) is not an actionable prover target. No other file with
  a complete blueprint chapter and open sorries has been identified as missing.
- **Iter-over-iter trend**: [iter-014: 2 prover lanes, QUOT excluded as pre-setup] →
  [iter-015: 3 prover lanes, all routes included]. Not under-dispatching.
- **Verdict**: OK — file count 3 within cap 10, no ready-and-actionable file left undispatched.

---

## Must-fix-this-iter

- **Route QUOT: STUCK** — primary corrective: fill all ready lanes. The G1→G5 graded-API prover
  lane must execute in iter-015 without displacement. The sorry count has been flat at 4 for 3
  consecutive SNAP-S2 iters; the 4 stubs cannot be closed until G1–G5 exist. The iter-015 plan
  already carries the unconditional commitment; the must-fix here is that this commitment not be
  deferred again. A fourth consecutive iter without QUOT sorry-trajectory movement is STUCK with
  no remaining in-loop corrective.

---

## Informational

**FBC and GF throughput (SLIPPING)**: Both routes have elapsed 7–8 iters in phases originally
estimated at 2–4 iters. Neither is OVER_BUDGET enough to confirm via available signals (original
estimates not recoverable from the directive), but both have run approximately 2× the estimate
ceiling. This is acceptable given that in both cases the prior CHURNING correctives worked and
the routes just delivered COMPLETE results in iter-014. The 1–2 (FBC) / 1–3 (GF) remaining
estimates are plausible given the seam-by-seam structure. No must-fix, but STRATEGY.md should
reflect the revised phase durations once the routes close.

**QUOT STUCK is architectural, not adversarial**: the STUCK finding is formally correct but the
route is not in pathological stall. The 4 sorry stubs are by-design placeholders; the helpers
built prerequisites. The STUCK verdict's purpose here is to force the prover lane to execute this
iter — which the plan already intends. The risk to watch is: if G1→G5 land but the 4 stubs still
can't close (e.g. because the typed-sorry signatures don't match the graded-API output types), a
blueprint-expansion corrective will be needed in iter-016. The prover should verify stub-signature
alignment against G1–G5 output types as a first step before attempting the stubs.

**Iter-014 corrective fidelity**: both prior CHURNING verdicts (FBC and GF) were resolved by the
prescribed correctives — mathlib-analogist consult for FBC, top-level helper factoring for GF —
demonstrating that the must-fix-this-iter protocol is functioning correctly. The same discipline
applies to QUOT this iter.

---

## Overall verdict

Two of three active routes are CONVERGING: FBC and GF each delivered a COMPLETE prover result in
iter-014, breaking their respective PARTIAL streaks and resolving their named blockers. Both are on
trajectory to close in the next 1–2 prover iters. One route (QUOT) is STUCK by the helper-without-
sorry-elimination rule: the 4 typed-sorry stubs have been flat since SNAP-S2 entry (iter-012) and
two consecutive prover-free iters preceded the iter-015 commitment. The STUCK corrective is already
encoded in the iter-015 plan (G1→G5 graded-API prover lane); the planner must not displace it.
Three lanes is the right load: FBC and GF need prover continuation, and QUOT's G1→G5 prover lane
is overdue. No dispatch-cap violations, no under-dispatch of actionable files, no avoidance
patterns at the planning level beyond the two-iter QUOT gap now addressed. The single must-fix
this iter is QUOT: execute the committed prover lane.
