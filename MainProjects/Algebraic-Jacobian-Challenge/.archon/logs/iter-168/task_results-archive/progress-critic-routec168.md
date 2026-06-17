# Progress Critic Report

## Slug
routec168

## Iteration
168

## Routes audited

### Route: Route C genus-0 base case (Genus0BaseObjects.lean Lane A + AbelianVarietyRigidity.lean Lane B)

- **Sorry trajectory** (combined Lane A + Lane B, since this is one route):
  - iter-164 entry: 0 + 3 = 3 (G0BO did not exist)
  - iter-165 exit: 9 + 3 = 12 (+9 from scaffold landing)
  - iter-166 exit: 6 + 6 = 12 (Lane A −3, Lane B +3 from signature refactor inlining)
  - iter-167 exit: 9 + 2 = 11 (Lane A +3 NEW scaffold exports, Lane B −4 via Lane A exports)
  - Net (post-scaffold, iter-165 → iter-167): −1 over 2 iters = 0.5/iter
- **Sorry trajectory per file**:
  - Lane A (G0BO): 9 → 6 → 9 — **net 0 over 2 iters; file-level CHURNING signal**
  - Lane B (AVR): 3 → 6 → 2 — net −1 with a −4 cliff iter-167 (genuine CONVERGING for Lane B's scope)
- **Helper accumulation**: ~10 (iter-165) + 3 (iter-166) + 7 (iter-167) = ~20 named decls added across last 3 iters. Route-level sorries closed in same window: ~5 (3 ℙ¹-points iter-166 + 5 AVR aux iter-167 − 3 NEW scaffold sorries iter-167). Helpers-to-closure ratio ≈ 4:1 — helper-heavy.
- **Prover dispatch pattern**: 1 → 2 → 2 files dispatched across iter-165/166/167. Proposed iter-168: 1 file (G0BO only). Not yet a ≥2-iter under-dispatch pattern, but is a regression from the 2-file cadence.
- **Recurring blockers** (verbatim from directive):
  - **"deferred — substantial chartwise glue, ~3-4 sub-lemmas worth"** (`gmScalingP1` body) — appears in iter-165, 166, 167 reports = **3 consecutive iters**
  - **"estimated 80-150 LOC, multi-step"** (`gm_grpObj`) — appears in iter-165, 166, 167 = **3 consecutive iters**
  - Three NEW Mathlib-gap blockers added iter-167 (`HomogeneousLocalization.Away` is-domain, `Smooth → GeometricallyReduced` scheme-level, tensor-localization-of-domains). These are fresh, not yet recurring, but they replaced sorries the planner thought would close cleanly.
- **Avoidance patterns**:
  - `gmScalingP1` body and `gm_grpObj` have been deferred 3 consecutive iters with the same phrasing each time. Trips the **STUCK condition "same deferral phrase persisting across ≥2 consecutive iters"** literally.
  - `genusZero_curve_iso_P1` (the RR-bridge "long pole" in AVR) — directive describes it as a long pole, has not been opened as a prover lane across iter-165/166/167 (3 iters), and iter-168 proposal does not open it. **Possible rotation/avoidance churn** — flagged as CHALLENGE for the strategy-critic to confirm: is the RR bridge genuinely gated on un-built blueprint infrastructure, or is the planner avoiding a difficult lane it could open?
- **Prover status pattern**:
  - Lane A: COMPLETE (iter-165, scaffold) → PARTIAL → PARTIAL — 2 PARTIALs in a row (not yet hitting the ≥3 PARTIAL bar, but trending)
  - Lane B: (none) → PARTIAL → COMPLETE — converging within scope
- **Throughput**: **ON_SCHEDULE** — STRATEGY.md `Iters left = 5–12`, elapsed in current phase = 3 iters (phase started iter-165). Well within band.
- **Verdict**: **CHURNING**

#### Why not CONVERGING

The strict verdict rules fire:
- The deferral-phrase rule (STUCK condition #3) fires literally: identical deferral phrasing on `gmScalingP1` body and `gm_grpObj` for 3 consecutive iters.
- Lane A's own sorry count is net 0 over 2 iters of work despite ~10 helpers added in that window.
- Combined route residual moved 12 → 12 → 11 = 0.5/iter, which is sub-threshold for "down by <1 per 2 iters" CHURNING but only by a hair, and the apparent −1 was a Lane B collapse that depended on freshly-added Lane A scaffold sorries — bookkeeping migration, not net residual collapse.

#### Why not STUCK

I am soft-clamping the verdict at CHURNING rather than STUCK because:
- Lane B genuinely converged in iter-167 (−4 in one iter, COMPLETE for its scope).
- The iter-168 PRIMARY (`homogeneousLocalizationAwayIso` ~30 LOC) is **prover-identified**, not planner-speculated — the iter-167 prover named this as the lever unlocking 3 named downstream closures. Prover-driven decomposition is principled, not the "more wrapper helpers to set up next iter" failure mode.
- The deferred items have stated, concrete prerequisites (not "we'll get to it" deferral).

If iter-168 lands the iso and `projectiveLineBar_isReduced` axiom-clean and the iter-169 plan still defers `gmScalingP1` body with the same phrasing, that crosses into STUCK and the corrective must escalate.

#### Primary corrective: **Mathlib-idiom consult** on `gmScalingP1` body's chartwise glue

The two 3-iter-deferred items (`gmScalingP1` body, `gm_grpObj`) share a root cause: the planner does not yet know the Mathlib idiom for the chartwise-glue step. Each iter the planner closes more upstream/sideband helpers, but the body remains shape-uncertain. Before iter-169 dispatches another prover at this body, run a Mathlib-idiom consult that produces (i) the concrete `Scheme.Cover.glueMorphisms` recipe for `σ_× : ℙ¹ × 𝔾_m → ℙ¹` with the explicit chart data, and (ii) for `gm_grpObj`, the `GrpObj.ofRepresentableBy` + units-functor pattern. With those two recipes in hand, the body becomes a transcription, not a research task.

#### Secondary correctives

- **Bounded decomposition commitment**: planner must articulate in iter-168's `plan.md` a concrete target iter for `gmScalingP1` body landing (e.g. "iter-170 lands the body, contingent on iter-169 closing the chartwise-glue helpers identified by the Mathlib-idiom consult"). If `gmScalingP1` body is deferred without such commitment a fourth time, escalate to user.
- **Investigate Lane B's `genusZero_curve_iso_P1`**: planner should explicitly state in iter-168 whether the RR-bridge has a blueprint-ready scaffold or whether it requires upstream chapter expansion. If a scaffold exists and the prover could be dispatched, the single-lane G0BO drill is under-dispatch.

#### Answers to planner's specific questions

1. **Verdict on Route C across the two files**: CHURNING. The route-level residual is moving slowly and unevenly. The cross-file bookkeeping (Lane B sorries migrating to Lane A scaffold) is real progress *for Lane B's scope* but is not residual collapse at the route level.
2. **Is `gmScalingP1` body + `gm_grpObj` 3-iter-deferral escalation-watch territory?** YES. By the verdict-rule letter, this trips the persistent-deferral-language STUCK condition. I am clamping to CHURNING because the iter-168 plan does start chartwise-glue work and the upstream helper is prover-identified, but iter-169 must land or attempt the body itself; a fourth consecutive deferral of the same item is STUCK.
3. **Is `homogeneousLocalizationAwayIso` "another helper round" or principled decomposition?** Principled decomposition. The helper is concretely scoped (~30 LOC ring iso), addresses a named Mathlib gap (`HomogeneousLocalization.Away` is-domain), and the iter-167 prover identified it as the single lever unlocking 3 named closures. This is different from "vague helper to set up next iter." Land it.
4. **Single-lane vs multi-lane**: Borderline. Lane B's claimed unavailability hinges on whether `genusZero_curve_iso_P1` truly has no openable scaffold. Three iters of "long pole" treatment without engagement is the avoidance pattern this critic exists to catch — but I lack the blueprint to confirm. **Surface as a CHALLENGE** in iter-168's plan: planner must state explicitly whether the RR bridge is dispatchable.
5. **Dispatch sanity (1 file)**: Within cap, but is a regression from the 2-file iter-166/167 cadence. Acceptable for one iter; if iter-169 is also 1 file with the RR bridge still untouched, it becomes UNDER_DISPATCH.

## PROGRESS.md dispatch sanity

- **File count**: 1 (cap not specified in directive; typical cap 10)
- **Ready but not dispatched**: Possibly `AbelianVarietyRigidity.lean` for the RR bridge `genusZero_curve_iso_P1` — directive cannot confirm. Flagged as CHALLENGE.
- **Over the cap**: no
- **Under-dispatch finding**: not yet — single iter at file count 1 is below the ≥2-consecutive bar. Watch next iter.
- **Iter-over-iter trend**: 1 → 2 → 2 → 1 proposed. Regression from cadence but not yet a pattern.
- **Verdict**: **OK** (with watch on next iter's file count and on RR-bridge dispatchability)

## Must-fix-this-iter

- **Route C: CHURNING** — primary corrective: **Mathlib-idiom consult** on the `σ_× : ℙ¹ × 𝔾_m → ℙ¹` chartwise glue (for `gmScalingP1` body) and the `GrpObj.ofRepresentableBy` + units-functor pattern (for `gm_grpObj`). Why: both items have been deferred 3 consecutive iters with identical phrasing; the root cause is Mathlib-idiom uncertainty, not lack of prover throughput.
- **Route C: bounded decomposition commitment** — planner must state a concrete target iter for `gmScalingP1` body landing in iter-168's `plan.md`. A fourth consecutive deferral without such commitment triggers STUCK and user escalation.
- **Dispatch CHALLENGE**: planner must state explicitly in iter-168's `plan.md` whether `AbelianVarietyRigidity.lean`'s `genusZero_curve_iso_P1` (RR bridge) has a blueprint-ready scaffold that could be opened as a second prover lane. If yes, open it. If no, name the upstream chapter expansion required and schedule it.

## Informational

- Lane B (AVR) is genuinely converging within its current scope. The iter-167 collapse from 6 → 2 sorries was real and was directly enabled by Lane A's exported instances. The cross-file design (Lane A bundles primitives, Lane B consumes) is working.
- The route is **ON_SCHEDULE** against the STRATEGY.md `5–12 Iters left` estimate (3 elapsed). The CHURNING verdict is about *quality of progress per iter*, not about overshooting the schedule.

## Overall verdict

One route audited, verdict CHURNING. The route is mid-decomposition with one lane (Lane B / AVR) genuinely converging and one lane (Lane A / G0BO) accumulating scaffold helpers faster than it is closing its own residual. Two named items (`gmScalingP1` body, `gm_grpObj`) have been deferred 3 consecutive iters with identical phrasing — strictly STUCK-by-deferral-language under the verdict rules, soft-clamped to CHURNING because the iter-168 plan attacks a prover-identified upstream helper rather than freshly speculating. iter-168 must run a Mathlib-idiom consult on the chartwise glue pattern AND commit in `plan.md` to a concrete landing iter for `gmScalingP1` body; a fourth consecutive deferral of the same item with the same phrasing crosses into STUCK and warrants user escalation. The planner must also state explicitly whether the RR bridge `genusZero_curve_iso_P1` could be opened as a parallel Lane B dispatch — if it could and isn't, the single-lane drill becomes under-dispatch on the very next iter.
