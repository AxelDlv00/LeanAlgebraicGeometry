# Progress Critic Report

## Slug
route178

## Iteration
178

## Routes audited

### Route 1 — Genus-0 chart-bridge (`Genus0BaseObjects/GmScaling.lean`)

- **Sorry trajectory**: 8 → 8 → 5 → 5 → 2 across iter-173 to iter-177. Total -6 over 5 iters. But the iter-177 drop from 5 → 2 was achieved by landing **2 named TEMPORARY project axioms** (`gmScalingP1_chart_data_temp`, `gmScalingP1_collapse_at_zero_temp`), not by proving. Stripping axiom-laundering, the real trajectory is 8 → 8 → 5 → 5 → 5 → effectively stalled since iter-175.
- **Helper accumulation**: +1, +2, +0, +0, +0 (with 0 axioms until iter-177's 2-axiom landing). 3 helpers added across iter-173/174 without converging; iter-175/176 added none and produced INCOMPLETE results; iter-177 escaped via HARD STOP into axioms.
- **Prover dispatch pattern**: Single chart-bridge lane each iter (iter-173/174/175/176/177). The dispatch was focused; the failure was on the lane.
- **Recurring blockers**:
  - "Fin syntactic mismatch" — iter-173, iter-174 (2 consecutive)
  - "cover-vs-`Proj.awayι` syntactic mismatch" — iter-176, and implicitly the underlying reason the temp axioms were needed in iter-177 (2 consecutive)
  - Analogist-verified option (a) NOT applied on file in iter-175 (planner laziness signal — see [[chart-bridge-prover-bypass-iter175]] feedback rule)
- **Avoidance patterns**: Route reclassified as **OFF-CRITICAL-PATH** at iter-177 alongside the temp-axiom landing. The replacement plan IS named (mathlib-analogist consult on cover-vs-Proj.awayι API + separated-locus universal extension feasibility) and a body lane on `iotaGm_isDominant` is firing this iter — so this is NOT pure indefinite deferral, but the off-critical-path label paired with temp-axiom retirement of 3 sorries is the canonical "papered-over churn" pattern.
- **Prover status pattern**: PARTIAL-low, PARTIAL-low, INCOMPLETE, INCOMPLETE, RESOLVED-axiom-laundered. 4 of 5 iters non-COMPLETE; the "RESOLVED" of iter-177 is bookkeeping, not proof.
- **Throughput**: Strategy `Iters left = 1` (off-critical-path); phase entered iter-168. Elapsed ≥10 iters on a route that has shed its budget into an axiom-laundering exit ramp. Classify as OVER_BUDGET on the original 1-iter estimate — but per the planner's reclassification, the route is now waiting on the analogist consult, so the over-budget reading applies to the *original* approach, not the now-pivoted one.
- **Verdict**: **CHURNING** — helper accumulation iter-173/174 + recurring blocker phrases across 4 iters + iter-177 axiom-laundering all match the CHURNING pattern. The iter-178 corrective the planner is proposing (mathlib-analogist consult, NOT another helper-retry) is exactly the right type — see below.
- **Primary corrective**: **Mathlib analogy consult** on the cover-vs-`Proj.awayι` API mismatch + on the separated-locus universal-extension feasibility. This matches the planner's iter-178 dispatch proposal verbatim. **Concur with planner.** The temp axioms are the must-fix output of the consult — track them as a hard gate on closing the route, not as progress.
- **Secondary correctives**:
  - **Encode the iter-175 feedback rule in the next analogist directive**: when an analogist recipe is empirically verified, the next prover directive must FORBID alternative approaches before the recipe is attempted on file. The iter-175 bypass pattern (Lane A1 ignored verified option (a)) is a confirmed planner failure mode per [[chart-bridge-prover-bypass-iter175]].
  - **Time-box the temp axioms**: name an explicit iter (e.g. iter-181) by which the temp axioms MUST be retired or the route formally re-escalated to user. Without a deadline, "OFF-CRITICAL-PATH + 2 temp axioms" becomes the new equilibrium.

### Route 2 — Picard scheme infrastructure (`Picard/*.lean`)

- **Sorry trajectory**: Not given numerically. Iter-176 closed RelativeSpec with placeholder `:= X` body (laundering); iter-177 closed `flatBaseChangeCohomology` via `CategoryTheory.mateEquiv` but factored deep math into named-helper sorry `canonicalBaseChangeMap_isIso`. Net: 1 placeholder + 1 sorry-rename — modest real progress.
- **Helper accumulation**: +0 across all 5 iters. Discipline is good — no helper-pile churn.
- **Prover dispatch pattern**: Lane redirected iter-177 from RelativeSpec body to QuotScheme (honoring iter-177 progress-critic's CHURNING corrective). Good responsiveness.
- **Recurring blockers**: "type-encoding gap" (iter-173, surfaced); "RelativeSpec body untouched" iter-177 (responsive deferral, not blockage).
- **Avoidance patterns**: RelativeSpec body deferred 2 consecutive iters (iter-176 placeholder + iter-177 untouched), but BOTH cases have explicit re-engagement plans:
  - iter-176: placeholder was a hard-stop pattern, with CHURNING corrective to consult.
  - iter-177: deferral was the corrective in action — iter-178 dispatches the consult.
  - This is NOT avoidance; this is the deferral-while-consult-fires pattern working as designed.
- **Prover status pattern**: PARTIAL, PARTIAL, DAMAGED, RESOLVED-laundered, RESOLVED-partial. The iter-176/177 RESOLVED tags are partially honest (real lane closures alongside the laundering).
- **Throughput**: A.1.a RelativeSpec estimate 6-10; phase started ~iter-173. Elapsed 5 iters. **ON SCHEDULE** for A.1.a (with the laundered placeholder still on the books).
- **Verdict**: **CONVERGING** (with caveat). The consult deferral is the correct corrective; Lane 4 made real factored progress; no helper-pile churn. The placeholder body must be retired by the consult output, but the planner is on the right track.
- **Primary corrective**: None required this iter — proceed with the mathlib-analogist consult on RelativeSpec type encoding as planned.
- **Secondary correctives**: Time-box the `:= X` placeholder retirement (e.g. iter-180) so it does not become permanent.

### Route 3 — RiemannRoch divisors (`RiemannRoch/{WeilDivisor, OCofP, RRFormula, RationalCurveIso}.lean`)

- **Sorry trajectory**: Multiple sorries closed axiom-clean (`ofClosedPoint`, `order`, `principal`, `principal_hom`) across iter-173 → iter-177. Net negative on sorries — real progress.
- **Helper accumulation**: +1 typeclass at iter-177 (`IsRegularInCodimensionOne`). Reasonable.
- **Prover dispatch pattern**: 2-4 lanes per iter across the RR file family. Healthy parallelism.
- **Recurring blockers**: None at the proof level. But **the same dispatch-level failure recurs**:
  - iter-176: signature-race broke Lane K OCofP build
  - iter-177: Lane FIX-BUILD threaded `[IsLocallyNoetherian]` but Lane WD's NEW class addition (`IsRegularInCodimensionOne`) was not anticipated — STILL-BROKEN-BUILD
- **Avoidance patterns**: None at the route level.
- **Prover status pattern**: RESOLVED, RESOLVED-partial, DAMAGED, RESOLVED+BROKE-BUILD, RESOLVED+STILL-BROKEN-BUILD. Lane-level prover work is genuinely closing sorries; the meta-pattern is the parallel-race build failure.
- **Throughput**: RR.1 WeilDivisor 4-8 estimated; phase started iter-172. Elapsed 5 iters. **ON SCHEDULE**.
- **Verdict**: **CONVERGING** at the lane level. The parallel-signature-race is a **dispatch-level** finding, not a route-level CHURNING (handled in PROGRESS.md dispatch sanity below).
- **Primary corrective**: None for the route itself. The build-race is a dispatch process bug — see below.

### Route 4 — File-skeleton fan-out

- **Sorry trajectory**: 37 → 60 → 71 across iter-176 → iter-177 (+34 over 2 iters). Growth, but intentional structural landing.
- **Helper accumulation**: +25 stubs iter-176, +14 stubs iter-177. By design.
- **Prover dispatch pattern**: 5 file-skeletons iter-176, 3 file-skeletons iter-177. Proposing 1 more iter-178 (Albanese/SymmetricPower).
- **Recurring blockers**: None.
- **Avoidance patterns**: None — this is the planner aggressively decomposing work, the opposite of avoidance.
- **Prover status pattern**: RESOLVED, RESOLVED.
- **Throughput**: Estimate-free (no `Iters left` for skeleton fan-out). Elapsed 2 iters — not flag-worthy.
- **Verdict**: **CONVERGING** — intentional fan-out matching the skeleton-first strategy. The sorry-count growth is the right signal for this phase, not a regression.
- **Primary corrective**: None.

### Route 5 — Genus-0 arm closure (over k̄)

- **Sorry trajectory**: Only 1 iter of data (iter-177 UNCHANGED at AVR L86, L290). Not enough for a trajectory read.
- **Helper accumulation**: N/A.
- **Prover dispatch pattern**: iter-178 proposes 1 lane (AVR-IOTAGM via `gmScalingP1`, axiom-clean over temp axioms).
- **Recurring blockers**: None.
- **Avoidance patterns**: None — fresh route.
- **Prover status pattern**: UNCHANGED.
- **Throughput**: AVR `iotaGm_isDominant` 1-2 estimated; entering iter-178 as fresh. **ON SCHEDULE**.
- **Verdict**: **UNCLEAR** (fresh route, 1 iter of signals). Proceed and watch.
- **Primary corrective**: None — lane is small and well-scoped. Watch for whether `iotaGm_isDominant` actually closes axiom-clean over the temp axioms as estimated.

## PROGRESS.md dispatch sanity

- **File count**: 8 (cap: 10)
- **Ready but not dispatched**: Not enumerated in the directive — cannot independently verify. The 8-lane proposal is internally coherent: FIX-BUILD priority + 1 axiom-clean small lane + 5 body attempts + 1 new file-skeleton (gated). The directive's framing ("8 lanes within ~10 cap") matches my read.
- **Over the cap**: no
- **Under-dispatch finding**: no — 8 of cap 10 is a healthy load.
- **Iter-over-iter trend**: not tracked in the directive; the iter-176 (+5 skeletons) and iter-177 (+3 skeletons) loads were also healthy.
- **Verdict**: **OK** on count and load. **BUT** an independent dispatch-level finding lands below.

### Dispatch-level finding: parallel-signature-race build breakage

**iter-176 broke build** (Lane K OCofP) via a parallel signature change. **iter-177 broke build again** (`IsRegularInCodimensionOne` synthesis failure at OCofP L335) via a new parallel signature change while a fix-build for the prior iter's race was also in flight. **2 consecutive iters of build-broken-by-parallel-race is a planner failure mode**, not a prover failure — the planner is dispatching lanes that mutate shared typeclass/signature surfaces in parallel without sequencing.

This is a dispatch process bug. Recommended mitigations, in priority order:

1. **Mandate that any lane that introduces / modifies a typeclass parameter, instance argument, or namespace-level variable block be tagged at planning time as a "signature-mutating lane" and serialize against all lanes that read from the same file family.** This is the minimal-friction fix — most lanes are body-only and run in parallel as today; only the signature-mutating minority serializes.
2. **Add an integration-build gate**: after parallel lanes return, run `lake build` against the merged state before declaring the iter complete; if it fails, the planner immediately dispatches a FIX-BUILD lane that has full visibility into all the iter's signature changes (rather than chasing one race at a time across iters).
3. **Encode a planning checklist item**: before approving a multi-lane dispatch, the planner explicitly lists files each lane will modify and flags any pair of lanes touching files where one is a downstream dependent of the other.

The current iter-178 plan **includes** a Lane FIX-BUILD #2 to fix the iter-177 race — that addresses the visible damage but does not prevent recurrence. Option (1) or (2) above should land in `iter/iter-178/plan.md` as a process change, not just another fix-lane.

## Must-fix-this-iter

- **Route 1 (Genus-0 chart-bridge)**: CHURNING — primary corrective: **Mathlib analogy consult** on cover-vs-`Proj.awayι` API + separated-locus universal-extension feasibility. Planner is already dispatching this; concur. **Add**: encode the iter-175 verified-recipe-bypass rule in the analogist's directive, and time-box temp-axiom retirement to a specific iter (suggest iter-181).
- **Route 1 (Genus-0 chart-bridge)**: OVER_BUDGET on original 1-iter estimate (elapsed ≥10 iters). The reclassification to OFF-CRITICAL-PATH is the planner's response, but STRATEGY.md should explicitly record the consult-replacement-path estimate, not just `1 iter (axiom-laundered, off-critical-path)` — otherwise the budget reading is meaningless going forward.
- **Dispatch**: parallel-signature-race build breakage 2 consecutive iters. **Land mitigation (1) or (2) above as a process change in `iter/iter-178/plan.md`**, in addition to dispatching Lane FIX-BUILD #2.

## Informational

- **Route 2**: CONVERGING with caveat. The iter-177 deferred-consult pattern was the correct response to iter-177's CHURNING verdict; iter-178 dispatching the consult continues that. Track the `:= X` placeholder for retirement.
- **Route 3**: CONVERGING at the route level — multiple axiom-clean closures (`order`, `principal`, `principal_hom`, `ofClosedPoint`) — but the dispatch finding above is load-bearing for this route in particular.
- **Route 4**: CONVERGING by design (intentional skeleton fan-out). The sorry-count growth (37 → 60 → 71) is signal of the strategy working, not a regression.
- **Route 5**: UNCLEAR (fresh). The 1-2 iter estimate for `iotaGm_isDominant` should be tested this iter.
- **Lane WD-DEGREE 2nd attempt**: Acceptable. STRETCH-then-deferred-then-retry is not a churn pattern when the file has independent momentum (iter-177 closed principal + principal_hom). If iter-178 STRETCH also fails, demote from STRETCH at iter-179 and either fully scope a multi-iter dedicated effort or pivot to Hartshorne's specific divisor-class identity lemma.

## Overall verdict

Of 5 active routes: 1 CHURNING with correct corrective in flight (Route 1, genus-0 chart-bridge — temp-axiom-laundered iter-177, mathlib-analogist consult dispatched iter-178), 3 CONVERGING (Routes 2, 3, 4 — consult deferral working, RR-lane closures real, skeleton fan-out by design), 1 UNCLEAR (Route 5 — fresh). The 8-lane PROGRESS.md proposal is within cap and internally coherent. **The most consequential single finding this iter is not route-level: it is the 2-consecutive-iter parallel-signature-race build breakage**, which the planner is patching reactively (Lane FIX-BUILD #2) but has not addressed structurally. Land one of the three mitigations named above as a process change in iter-178's plan.md. Without it, the build will break a third time before iter-180.
