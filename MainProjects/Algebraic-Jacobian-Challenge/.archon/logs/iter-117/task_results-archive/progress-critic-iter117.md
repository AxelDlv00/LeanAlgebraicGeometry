# Progress Critic Report

## Slug

iter117

## Iteration

117

## Routes audited

### Route 1: `Differentials.lean` L191 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`

- **Sorry trajectory**: 3 → 5 → 5 → 5 (no-lane) → 5 across iter-111..iter-115. Net: **+2 sorries, 0 closed** over 5 iters. The only direction the count has moved is up.
- **Helper accumulation**: Helpers #1/#2 family added at L168/L235 in iter-111 (Bar B scaffolding); fresh sub-helper L168 `_isSheafUniqueGluing_type` introduced in iter-113 (planner-acknowledged "reformulation, not progress"). Iter-115 produced only a docstring rewrite + a structural `intro` advance — no helpers added, no helpers closed. So: helpers added in 2 of 5 iters with **zero sorry-eliminations attributable to them**.
- **Recurring blockers**: "no off-the-shelf Mathlib bridge for `Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on X" appears in **4 of 5 iters**. Iter-114 mathlib-analogist consult confirmed it as `NEEDS_MATHLIB_GAP_FILL` (i.e. not a naming issue, an actual gap). Iter-115 prover-lane did not address it — it produced cosmetic advance only.
- **Prover status pattern**: PARTIAL → PARTIAL → PARTIAL → (no lane) → INCOMPLETE. Worsening, not flat.
- **Verdict**: **STUCK**.

  Two of the verdict rules fire independently:
  - sorry count unchanged across K iters AND prover statuses include INCOMPLETE AND recurring blocker phrase across ≥3 iters; and
  - helpers added without any sorry-elimination across K iters.
  Plus the regression flavor (PARTIAL → INCOMPLETE) and iter-113's planner's own honest self-classification ("reformulation rather than genuine mathematical progress") corroborate.

- **Primary corrective**: **Refactor**. The mathlib-analogist already returned `NEEDS_MATHLIB_GAP_FILL` and iter-114's blueprint-writer landed a corrected 3-step recipe; further prover passes on the *current* formulation will just replay iter-112/113/115. Dispatch the `refactor` subagent to restructure the route into explicit per-step helper signatures matching the blueprint's 3-step recipe, surfacing the gap-fill bridge as its own load-bearing lemma with a named signature. Only after that refactor lands should a prover lane attempt closure — and the gap-fill bridge itself should be its own discrete prover assignment, not folded into the goal at L191.

- **Secondary correctives**: If after one refactor pass the bridge lemma still has no tractable proof outline, this becomes a **route-pivot** candidate, and `strategy-critic` should be re-dispatched mid-iter to validate an alternate path. Explicitly *not* recommending another blueprint-expansion pass: the iter-114 recipe is the blueprint, and re-expanding it won't unblock the gap.

### Route 2: `Cohomology/BasicOpenCech.lean` L1846 `h_loc_exact`

- **Sorry trajectory**: Two prover-lane data points (iter-108 PARTIAL, iter-109 PARTIAL) with scaffolding landed but 0 sorries closed. Then **7 consecutive iters with no prover lane** (route parked, budget-deferred per Option (i) at iter-109). For the K=5 window (iter-112..iter-116), there is **no prover-lane data at all**.
- **Helper accumulation**: ~30 LOC inline scaffolding (Step 1a+1b) at iter-108, ~20 LOC inline (Step 1c) at iter-109. Nothing since.
- **Recurring blockers**: None. Strategy-critic at iter-108 explicitly confirmed remaining work is mechanizable from existing Mathlib (`IsLocalizedModule.{Away,pi,prodMap}` + algebra adapter). No blocker phrase has re-appeared.
- **Prover status pattern**: PARTIAL → PARTIAL → (parked × 7). No K-window pattern to read from.
- **Verdict**: **UNCLEAR**.

  This is not a stalled route — it's a *parked* route. Parking was a budget decision (Option (i) escape-valve), not a stuck-protocol response. The user directive lifts the parking, so it returns to active. With only two stale prover data points and a strategy-critic clearance for mechanizability, the right read is "fresh, watch the first new lane." If iter-117 dispatches a prover lane here and it returns INCOMPLETE or PARTIAL-without-closure, iter-118 progress-critic will have actionable signal.

- **Primary corrective**: None — UNCLEAR doesn't need one. (Implicit recommendation: this is a reasonable prover-lane target this iter.)

### Route 3: `Differentials.lean` L931 `smooth_iff_locally_free_omega` (forward)

- **Sorry trajectory**: No prover-lane data points. Signature has been corrected twice via plan-phase refactor directives (iter-113, iter-115). Sorry count for this declaration is whatever the scaffolding put there; **no prover has attempted closure**.
- **Helper accumulation**: None inside the proof body. Strategy-critic at iter-114 decomposed into forward+converse with separate budgets; iter-115 verified one closing lemma name; iter-116 added two more name verifications. That's plan-side scaffolding, not prover-side helper churn.
- **Recurring blockers**: None.
- **Prover status pattern**: No prover statuses (no lane has been dispatched).
- **Verdict**: **UNCLEAR**.

  Genuinely fresh route. Signature is cleaned, closing lemma names are pre-verified, the math has been pre-decomposed. This is exactly the state in which a first prover lane is high-information: it will either CONVERGE (close), CHURN (need more helpers), or expose a definition mismatch.

- **Primary corrective**: None — UNCLEAR doesn't need one. (Implicit recommendation: highest-priority candidate for a *first* prover lane this iter — fresh, well-scaffolded, no historic baggage.)

### Route 4: `Cohomology/BasicOpenCech.lean` L1120 `cechCofaceMap_pi_smul`

- **Sorry trajectory**: 7 consecutive PARTIAL iters (iter-100..iter-107), all on the same root cause (Pi.lift compositional wrapper engineering). 0 sorries closed across those 7 iters. Then 9 iters parked (iter-108..iter-116) per multiple prior progress-critic STUCK verdicts.
- **Helper accumulation**: Heavy across iter-100..107 — repeated wrapper-helper churn. Quoting the directive: "7 consecutive PARTIAL iters … same root cause." The architectural blocker (Q2 Path B vs Path A refactor) has not been addressed in the 9-iter pause; pausing isolated the damage but did not resolve it.
- **Recurring blockers**: "Pi.lift compositional wrapper engineering" / "Q2 Path B or Path A architectural refactor not addressed" — recurring across 7+ iters explicitly per the directive.
- **Prover status pattern**: PARTIAL × 7 → paused × 9. Definitionally STUCK by every verdict rule.
- **Verdict**: **STUCK**.

  This is the canonical STUCK route in this project's history; prior progress-critic invocations have already classified it as such, and **nothing about the structural blocker has changed during the 9-iter pause**. The user's "nothing deferred" directive lifts the parking but does not (and cannot) supply the missing refactor. Spinning a prover lane on this route without first executing the architectural refactor will deterministically replay the 7-PARTIAL pattern.

- **Primary corrective**: **Refactor** — the Q2 Path B (or Path A) architectural refactor that prior strategy/progress critics named. Dispatch the `refactor` subagent on the surrounding `cechCofaceMap` infrastructure before any further prover lane on this declaration. **Do not** dispatch a prover lane on this route this iter under any pretext (including "the user lifted the deferral"); the deferral was the right call until the architecture is fixed.

- **Secondary correctives**: If the refactor subagent cannot find a clean Path B/Path A decomposition either, this becomes a **route-pivot** — re-dispatch `strategy-critic` to consider whether the entire `cechCofaceMap_pi_smul` chain is the right cohomology route or whether a parallel API in Mathlib (Čech vs derived, etc.) should replace it. **User escalation** is the tertiary option if both fail, but the project has not yet attempted the refactor route, so escalation would be premature.

## Must-fix-this-iter

- **Route 1** (`relativeDifferentialsPresheaf_isSheafUniqueGluing_type` L191): **STUCK** — primary corrective: **Refactor** to restructure into explicit per-step helper signatures matching iter-114's 3-step blueprint recipe; surface the gap-fill bridge as its own named lemma. Why: 4-of-5 iters show the same `NEEDS_MATHLIB_GAP_FILL` blocker and prover statuses are regressing (PARTIAL → INCOMPLETE) on a formulation that doesn't expose the bridge.
- **Route 4** (`cechCofaceMap_pi_smul` L1120): **STUCK** — primary corrective: **Refactor** (Q2 Path B / Path A architectural refactor) **before** any prover lane on this route. Why: 7 prior PARTIALs from one unresolved root cause; the 9-iter pause did not resolve it; re-running prover on the same architecture is deterministic churn.

## Informational

- **Route 2** (`h_loc_exact` L1846): **UNCLEAR** — parked, not stuck. Strategy-critic previously cleared mechanizability. A first post-unparking prover lane here is reasonable and high-information. Iter-118 progress-critic will produce actionable signal.
- **Route 3** (`smooth_iff_locally_free_omega` L931): **UNCLEAR** — fresh route, well-scaffolded by three iters of plan-side prep (decomposition + closing-lemma name verification). First prover lane is high-information.

## Overall verdict

Four routes audited. **Two are STUCK** (Routes 1 and 4), **two are UNCLEAR** (Routes 2 and 3) with the UNCLEAR status reflecting parked-not-stalled and fresh-not-tried respectively. Zero routes are currently CONVERGING.

The iter-117 prover-lane assignment should treat Routes 1 and 4 as **no-prover-lane** routes — they get refactor work, not prover work, this iter. The two prover lanes (if the planner runs two) should go to **Route 3 first** (fresh, scaffolded, highest expected information yield) and **Route 2 second** (un-parking a tractable, strategy-critic-cleared route). Crucially, the planner must NOT interpret the user directive "nothing deferred" as license to re-dispatch prover lanes on Routes 1 and 4 — the user lifted the *budgetary* deferral but did not (and could not) supply the structural correctives those routes need. The corrective path for Routes 1 and 4 is refactor first, prover second; flipping that order would replay multi-iter churn that this subagent's verdicts have already named.
