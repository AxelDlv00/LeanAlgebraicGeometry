# Progress Critic Report

## Slug
iter034

## Iteration
034

## Routes audited

### Route: FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 4 → 4 → 4 → 4 across iter-030 to iter-033. Zero closures across the entire K=4 window. Unchanged for 8 consecutive iters if the iter-026–029 window is included.
- **Helper accumulation**: +1 (030), +3 (031), ~0 (032), +0 (033) — total ~4 helpers in window, zero sorry-elimination. Matches the STUCK rule verbatim: "helpers added without any sorry-elimination across K iters."
- **Recurring blockers**: "`X.Modules` instance diamond"; "keyed rw/simp/erw dead"; "cross-layer mate coherence has no term-mode form"; "declaration-ordering (cancellers out of scope)" — all appearing across ≥3 of the 4 audited iters. The ≥3-iter threshold for recurring blockers is met on at least two independent phrases.
- **Avoidance patterns**: One plan-only pivot iter (this iter, iter-034) — **not yet** a consecutive avoidance pattern since iter-033 had a live prover dispatch. No off-critical-path reclassification and no persistent deferral language detected in the 4-iter window.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL — 4 consecutive PARTIALs. Meets CHURNING threshold on its own; STUCK dominates.
- **Throughput**: **OVER_BUDGET** — strategy estimate 1–2 iters; direct-on-sections phase entered ~iter-019; elapsed ≈ 15 iters. >7× estimate. Route has been OVER_BUDGET every iter since iter-030.
- **Verdict**: **STUCK**

  Three independent STUCK rules trigger:
  1. *Sorry count unchanged across K iters AND recurring blocker phrase across ≥3 iters* — 4 sorries, 4 rounds, diamond-blocker and "keyed rewriting dead" across ≥4 rounds.
  2. *Helpers added without any sorry-elimination across K iters* — ~4 helpers, zero closures.
  3. *PARTIAL prover status ≥3 of last K iters* — 4 consecutive PARTIALs (CHURNING threshold; STUCK dominates).

  **Is the iter-034 route pivot responsive to the STUCK signal?** Partially yes, partially flagged:

  **Responsive elements**: The planner abandons the direct-on-sections approach that generated the stall, sequences a mathlib-analogist consult BEFORE any prover dispatch (the correct ordering — the iter-030 critic recommended this pattern and it worked for QUOT), and treats iter-034 as a plan-only restructuring iter rather than assigning another raw prover round. This is categorically different from silent re-dispatch. The route pivot is one of the named corrective types and is applicable here.

  **Flags and concerns**:
  
  (a) **Possible rotation churn** (flag for strategy-critic): The `X.Modules` instance diamond is a computation problem that arises when elaborating morphisms that cross the `ModuleCat`-over-scheme boundary. The `mateEquiv`/`conjugateEquiv` encoding operates at the 2-categorical level (functor-functor-functors), but if the final elaboration of a mate or conjugate still requires reducing to section-level morphisms in `X.Modules`, the same instance diamond may reappear in the new encoding. The critic cannot verify this without reading the blueprint or strategy; this is flagged as "possible rotation churn" for the strategy-critic to confirm before the next prover dispatch. If the mate calculus elaboration does not commute past the diamond, the iter-035 prover will hit the same wall in different notation.

  (b) **User visibility gap**: The iter-032 tripwire named "User escalation" as the mandatory corrective, explicitly noting "no automated corrective remains un-tried." The planner overrode at iter-033 with a plan.md rebuttal (sanctioned by the iter-032 report under three explicit conditions). That round also failed. Now at iter-034 the planner is pivoting to yet another automated corrective (mate calculus) rather than consulting the user. This is the second consecutive override of a mandated user-escalation corrective. Given 15 iters elapsed at >7× budget, the user has not been informed of the strategic choice to pivot rather than escalate. The critic does not override the planner's autonomy here, but records: if iter-035's prover does not close at least one of the 4 sorries, user escalation must fire — no further extension.

  (c) **Consecutive plan-only tripwire**: Iter-034 is the first plan-only iter for FBC-A (iter-033 dispatched a prover). If iter-035 also runs no prover on FBC-A (e.g., the mathlib-analogist + blueprint rewrite extends another iter), the consecutive plan-only avoidance pattern triggers, which would be CHURNING by avoidance.

- **Primary corrective**: **Route pivot** (in progress — planner has chosen this). The mate calculus re-encoding is a genuine structural change, not a reworded re-dispatch. The corrective is correctly sequenced (consult-first, then prover). The must-fix requirement is that the strategy-critic confirm the new encoding avoids the diamond before iter-035's prover is dispatched.
- **Secondary correctives**: (1) User communication — TO_USER.md should note the strategic pivot for user awareness given the 15-iter OVER_BUDGET position. (2) Set an explicit tripwire: if iter-035's prover does not close ≥1 sorry on FBC-A, user escalation fires unconditionally at iter-036.

---

### Route: FBC-B — `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`

- **Sorry trajectory**: 0 sorries (axiom-clean new decls; progress metric is decl count).
- **Helper accumulation**: iter-033 = +3 axiom-clean decls. One iter of data.
- **Prover status pattern**: PARTIAL (iter-033 only).
- **Throughput**: **ON_SCHEDULE** — estimate 2–5 iters; 1 iter elapsed.
- **Verdict**: **UNCLEAR**

  Route is fresh (< K iters of data). One-iter snapshot shows healthy output (+3 axiom-clean decls, no blockers named). The modular eqLocus sub-lane is a viable independent lane not gated on FBC-A's resolution. No trajectory to extrapolate from. UNCLEAR is the honest verdict; proceed as planned.

---

### Route: GR-sep — `AlgebraicJacobian/Picard/GrassmannianCells.lean`

- **Sorry trajectory**: 0 sorries (target `isSeparated` is a new declaration; progress metric is axiom-clean infra and keystone assembly). Prior phase GR-glue CLOSED iter-032 (+8 axiom-clean, `Grassmannian.scheme`).
- **Helper accumulation**: iter-033 = +6 axiom-clean decls (`diagonalRingMap` family including `_surjective`, `pullbackιIso`). Route fully scouted; `isSeparated` keystone scaffolded then removed under no-sorry invariant.
- **Prover status pattern**: PARTIAL (iter-033 only). Prior phase COMPLETE.
- **Recurring blockers**: none identified.
- **Throughput**: **ESTIMATE_FREE** — no explicit `Iters left` figure in directive for GR-sep; prior GR-glue was within estimate; "strong close candidate" suggests ≤2 iters.
- **Verdict**: **UNCLEAR**

  Route is fresh (1 iter of GR-sep data, < K=4). The signal is strongly positive: 6 axiom-clean decls in first round, route scouted end-to-end via Proj template analogy, no blockers. This is the healthiest of the three UNCLEAR routes. UNCLEAR is the mechanically correct verdict; the trajectory is trending CONVERGING. Proceed with the route-b close attempt as the highest-probability win this iter.

---

### Route: QUOT-P1 — `AlgebraicJacobian/Picard/QuotScheme.lean`

- **Sorry trajectory**: 4 protected stubs throughout (frozen; not the phase metric). P1 phase metric is axiom-clean infra decls added toward the keystone `isIso_fromTildeΓ_restrict_basicOpen`.
- **Helper accumulation**: iter-033 = +4 infra decls (`overRestrictUnitIso`, `overRestrictPresentation`, `presentationPullbackιOfQuasicoherentData`, private helper). Keystone deferred on budget.
- **Prover status pattern**: PARTIAL (iter-033 only). Prior bridge-C phase COMPLETE (iter-031).
- **Recurring blockers**: none new. Budget exhaustion on unit-iso elaboration is a session-scope concern, not a recurring structural blocker.
- **Throughput**: **ON_SCHEDULE** — estimate 3–7 iters; 1 iter elapsed in P1 phase.
- **Verdict**: **UNCLEAR**

  Route is fresh (1 iter of P1 data, < K=4). First round delivered 4 real infra decls and produced a concrete 5-step recipe for the keystone — this is healthier than generic "will address next iter" deferral. No recurring blockers; route is genuinely advancing. UNCLEAR by data-volume rules; proceed with the 5-step keystone build. The deferral of the keystone under budget pressure is a session artifact, not a structural blocker — no avoidance pattern.

---

## PROGRESS.md dispatch sanity

Verdict: **OK** — file count 3, within cap (default 10). FBC-A is correctly NOT dispatched this iter (plan-only pivot; confirmed as appropriate given the structural change being designed). The three dispatched files (GrassmannianCells.lean, QuotScheme.lean, FlatBaseChangeGlobal.lean) represent all active, unblocked, unpaused lanes. No OVER_CAP, UNDER_DISPATCH, or BLOAT finding.

Note: FBC-A non-dispatch is a one-iter exception. If FBC-A also does not appear in iter-035's proposal, it becomes a consecutive plan-only avoidance pattern requiring a CHURNING flag.

---

## Must-fix-this-iter

- **Route FBC-A: STUCK** — primary corrective: **Route pivot** (in progress). The strategy-critic must confirm that `mateEquiv`/`conjugateEquiv` re-encoding avoids the `X.Modules` instance diamond before the iter-035 prover is dispatched. If the new encoding still requires crossing the `Modules`-over-scheme boundary in elaboration, the same diamond will surface in new notation (possible rotation churn). This confirmation should happen as part of iter-034's plan phase, not deferred to the prover.

- **Route FBC-A: OVER_BUDGET** — STRATEGY.md estimates 1–2 iters; direct-on-sections phase elapsed ~15 iters. Even if the mate-calculus pivot succeeds in 2–3 iters, the total elapsed is ~18 iters at 9×+ budget. The estimate must be revised in STRATEGY.md to reflect the new encoding approach and its realistic timeline. Do not carry forward the "1–2 iters" figure as if it refers to the new approach.

- **Route FBC-A: user-visibility** — TO_USER.md should note the strategic pivot (direct-on-sections → mate calculus) so the user is aware. This is the second override of a mandated user-escalation corrective. The user has not been briefed. A single bullet in TO_USER.md ("FBC-A pivoting to mate-calculus encoding — 15 iters elapsed, prior approach conclusively blocked") is sufficient.

- **Route FBC-A: iter-035 tripwire** — If iter-035's prover does not close ≥1 of the 4 sorries on `_legs` under the new mate-calculus encoding, user escalation fires at iter-036 unconditionally. Record this in plan.md explicitly; do not re-date or re-derive the tripwire.

---

## Informational

- **GR-sep (UNCLEAR, trending CONVERGING)**: The prior GR-glue lane closed cleanly and the first GR-sep round scouted the route to completion. The route-b strategy (π → IsSeparated π via Proj template → reconcile terminal) is concrete. This is the highest-probability close candidate of the three dispatched lanes.

- **QUOT-P1 (UNCLEAR, solid footing)**: The 5-step recipe is concrete enough that a budget-limited prover should make deterministic progress. The keystone deferral was a session-budget event, not a math blocker. Watch for instance issues on `presentationPullbackιOfQuasicoherentData` composition — the QUOT route's historical blocker was instance timeouts on slice-site predicates.

- **FBC-B (UNCLEAR, no concerns)**: The ModuleCat-over-A eqLocus sub-lane is structurally independent of FBC-A's resolution. Healthy to build in parallel. If it advances 2–3 more decls this iter, the route will have a credible signal (≥2 data points) for next iter's critic to assess.

---

## Overall verdict

Three of four routes are in UNCLEAR territory — all for the right reason (fresh phases with < K=4 data points, all showing positive first-iter signals). One route (FBC-A) is **STUCK for the fourth consecutive iter**, with 15 iters elapsed against a 1–2 iter estimate (>7× OVER_BUDGET). The planner's iter-034 response — abandoning direct-on-sections and pivoting to abstract mate calculus — is a genuine structural corrective and the right class of action; it is NOT a silent re-dispatch. The must-fix items are: (1) confirm via strategy-critic that the mate-calculus re-encoding avoids the `X.Modules` diamond before the iter-035 prover fires (possible rotation churn risk); (2) update STRATEGY.md's FBC-A estimate to reflect the new approach; (3) post a single user-visibility bullet in TO_USER.md on the pivot; (4) set an unconditional iter-036 user-escalation tripwire if iter-035 does not close ≥1 sorry. Dispatch for the three active lanes (GR-sep, QUOT-P1, FBC-B) is sanely scoped and FBC-A's non-dispatch is correctly handled. The planner must not dispatch a second consecutive plan-only iter on FBC-A or the avoidance-pattern trigger fires.
