# Progress Critic Report

## Slug
pc252

## Iteration
252

## Routes audited

### Route 1 — Lane TS-cmp — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 2 → 2 → 2 → 1 → 3 across iter-247 to iter-251. Net: +1 over the K=5 window. Not strictly decreasing. The dip to 1 at iter-250 is real (D2′ closed); the rise to 3 at iter-251 is from scaffolding two honest D1′ sorries, not regression. Regardless, the raw count is not converging on zero.
- **Helper accumulation**: Helpers added in all 5 iters. Single sorry elimination event across the window (iter-250: 2→1). One close in five iters while adding helpers every iter matches the churn pattern. Mitigating context: iter-250's close was the FIRST canonical close on this route; iter-251's helper additions are typed D1′ obligations (not dead scaffolding). Still churn by the numbers.
- **Prover dispatch pattern**: Not provided in signals (under-dispatch check N/A for this route). Both available files dispatched each iter they existed.
- **Recurring blockers**: `.val` / `forget₂`-carrier defeq-not-syntactic friction appears in iter-247 ("presheaf↔sheaf defeq-laden labor"), iter-248 (`.val`-composite friction), iter-249 (`Category.assoc`/`rw` silent misfire on Presheaf-over-Sheaf.val composites), and iter-251 (whisker lemmas don't fire against file-local `MonoidalCategoryStruct`). Absent only from iter-250, where the D2′ close itself discharged the D2′ instance of this blocker. **4 of 5 iters carry the same blocker class.** This is the dominant signal.
- **Avoidance patterns**: None. Route has been active and dispatched every iter.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, COMPLETE, PARTIAL — 4 of 5 PARTIAL.
- **Throughput**: SLIPPING. Strategy labels D1′ "easy" (implying ~1 iter); 2 iters have elapsed post-D2′-close (iter-250 and iter-251) without D1′ closed. D3′+D4′ estimated ~5–10 additional iters and not yet started. Phase entered at iter-250.
- **Verdict**: **CHURNING**

  Two independent criteria trigger:
  1. PARTIAL prover status in 4 of K=5 iters.
  2. Helpers added in ≥2 of K iters AND sorry count net is +1 (2→3), far below "down by 1 per 2 iters."

  The structural change at iter-250 (propositional `:= rfl` strip + `erw`) is genuine and IS a new technique — but it was intra-iter and its immediate payoff (D2′ close) happened in the same iter. It does not break the K-5 PARTIAL-dominance signal. The iter-251 blocker is the same carrier-class in a new sub-problem (D1′ whisker goals), meaning the fix pattern generalizes but does NOT transfer automatically. One carrier-normalisation brick was sufficient for D2′; another is now required for D1′; a third will likely be required for D3′. This is the hallmark of a recurring structural friction, not a fully defeated blocker.

- **Primary corrective**: **Mathlib analogy consult** — targeted search for Mathlib whisker lemmas (`whiskerLeft_comp`, `comp_whiskerRight`, `whisker_exchange`) on a `MonoidalCategory` instance vs a `MonoidalCategoryStruct`, and the precise form a `whiskerLeft`/`whiskerRight` carrier-normalisation brick must take so that those lemmas fire syntactically. The prover has the conceptual fix but not the specific Lean term that makes it compile; one pre-armed consult before the next prover round removes the risk of another multi-iter thrash on D1′ like D2′ had. The planner should dispatch the analogist BEFORE the iter-252 prover for this lane.
- **Secondary correctives**: None required. Route pivot is not warranted; the math is sound and D2′ demonstrated the fix pattern works.

---

### Route 2 — Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean`

- **Sorry trajectory**: 3 → 2 (one iter). Count dropped by 1.
- **Helper accumulation**: Four axiom-clean decls closed at iter-251 (`unitDualSectionEquiv`, `dualUnitIsoGen`, `presheafDualUnitIso`, `dual_unit_iso`). One meaningful sorry closed.
- **Prover status pattern**: PARTIAL (1 iter).
- **Recurring blockers**: Step-4 pushforward-commutes-with-dual presheaf residual flagged; prover deliberately deferred it for analogist consult.
- **Avoidance patterns**: None — route is one iter old.
- **Throughput**: ESTIMATE_FREE — no standalone `Iters left` row in STRATEGY.md for this sub-lane.
- **Verdict**: **UNCLEAR**

  One iter of data. Sorry count dropped. Prover made real progress (4 new closed decls). Blocker is concrete and named. Cannot assess convergence from a single data point. Proceed with the proposed objectives but track carefully: if iter-252 does not close `homOfLocalCompat` AND `dual_restrict_iso` Step-4 (the two stated targets), the next critic window will have enough signal to give a verdict.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: 10)
- **Ready but not dispatched**: None identified. The directive explicitly states no other route is structurally available (RPF gated on D4′ + dual chain; A.2.c HELD; Route C PAUSED by user).
- **Over the cap**: No.
- **Under-dispatch finding**: No — all structurally available files are in the proposal.
- **Iter-over-iter trend**: Insufficient cross-iter dispatch data in the directive to show a multi-iter under-dispatch trend.
- **Verdict**: OK — file count 2 within cap 10, no under-dispatch against available lanes.

**Coordination hazard note** (informational, not a dispatch-sanity failure): Route 1 editing TensorObjSubstrate.lean transiently broke DualInverse.lean's LSP verification mid-session at iter-251. Final build was green. If the Mathlib analogy consult for Route 1 is dispatched BEFORE the prover round, or if Route 1's prover is given a hard "leave TensorObjSubstrate.lean compilable at every intermediate commit" constraint, the hazard is eliminated. This is a scheduling note, not a blocker.

---

## Must-fix-this-iter

- **Route 1 (TS-cmp)**: CHURNING — primary corrective: **Mathlib analogy consult** on whisker-carrier-normalisation for the file-local `MonoidalCategoryStruct` vs canonical instance. Why: the same `.val`/`forget₂`-carrier defeq blocker class appeared in 4 of 5 iters; the conceptual fix for D1′ is known but the specific Lean form (which Mathlib lemma, which `erw`-key) is not — without it the prover will thrash D1′ the same way D2′ was thrashed for 11 iters before the propositional-strip pattern was discovered. Dispatching the analogist before the prover removes this risk.

---

## Informational

- **Route 2 (TS-inv)**: UNCLEAR — 1 iter of data; trajectory positive (sorry 3→2; 4 new axiom-clean decls). The proposed iter-252 objective (close `homOfLocalCompat` + `dual_restrict_iso` Step-4 via pre-armed analogist consult) is appropriate given the single-iter profile. The planner's instinct to arm the Step-4 blocker with an analogist consult first is correct — do not waive it.
- **Route 1 throughput**: D1′ is SLIPPING relative to the "easy" label. One full iter (iter-251) elapsed without closing D1′. The proposed iter-252 plan (one carrier-normalisation brick → D1′ close → D3′ attempt) requires the brick to work on the first try; the Mathlib analogy consult is the hedge that makes this realistic.

---

## Overall verdict

One of two routes is CHURNING (TS-cmp, K=5 PARTIAL-dominant with a recurring blocker class in 4/5 iters), one is UNCLEAR (TS-inv, one iter of data). The CHURNING finding does NOT imply the route is broken — D2′ was closed at iter-250 and D1′ is correctly scoped — but it does mean the iter-252 prover for TensorObjSubstrate.lean must not enter cold. The planner must dispatch the Mathlib analogy consult on the whisker-carrier-normalisation brick BEFORE the prover round for Route 1; without it, the risk is another multi-iter thrash on the same blocker class that cost ~11 iters on D2′. Dispatch sanity is OK (M=2, both lanes are the full set of structurally available files). The coordination hazard (Route 1 breaking Route 2's LSP mid-session) should be managed by sequencing or by a compile-at-every-step constraint on Route 1's prover.
