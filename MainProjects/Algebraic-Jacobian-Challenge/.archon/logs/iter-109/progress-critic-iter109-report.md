# Progress Critic Report

## Slug
iter109

## Iteration
109 (Archon canonical) / 111 (project narrative)

## Routes audited

### Route 1: `BasicOpenCech.lean` L1846 (`h_loc_exact`)

- **Sorry trajectory**: BasicOpenCech file count 6 → 6 → 6 across iter-106 / 107 / 108. Net change over 3-iter window: 0.
- **Helper accumulation**: 5 inline `have`s landed across iter-106 (2) and iter-107 (3); iter-108 added 0 (only a 10-LOC `-- DEFERRED (budget)` annotation). Total ~59 LOC of inline scaffolding accumulated. **Zero sorries eliminated** across the 3-iter window.
- **Recurring blockers**:
  - "Steps 2-4 deferred" — verbatim in iter-106 + iter-107 task reports (2 iters).
  - "letI … in <goal-type> does not propagate to body binders for per-x algebra threading" — iter-107 task report (named root cause for iter-108 escape valve).
  - "inert infrastructure for future re-attempt" — iter-108 task report (used to justify *preserving* scaffolding past the annotation, i.e. accumulated helpers are now frozen, not converging).
- **Prover status pattern**: PARTIAL → PARTIAL → PARTIAL (3 of last 3). iter-108 is PARTIAL by the sorry-count metric; the prover/planner framing of "COMPLETE by route-pivot intent" is a narrative re-classification, not a signal-level change.
- **Verdict**: **STUCK**.
  - Sorry count unchanged across K=3 iters (6 → 6 → 6). ✓
  - Recurring blocker phrase across ≥2 iters (the K-window is only 3 iters; "Steps 2-4 deferred" hits 2/3, plus the deeper `letI` blocker resolves to the same root cause). ✓
  - Helpers added without any sorry-elimination across K iters. ✓
  - Multiple STUCK conditions match; the CHURNING rule (≥3 PARTIAL) also fires. Pick the worse → STUCK.
- **Primary corrective**: **Route pivot — ratified.** The planner has already pivoted to OFF-LIMITS via the iter-108 Option (i) escape valve, which is the textbook STUCK response. **No new prover work this iter is correct.** The iter-106 + iter-107 inline scaffolding being preserved "byte-for-byte as inert infrastructure" is the right framing: it documents the partial advance for a future re-attempt without continuing the churn now.
- **Secondary correctives**: When this route is re-opened in a future iter, the entry condition should be either (a) a mathlib-analogist consult on the `letI … in <goal-type>` propagation pattern (this is the named structural blocker, not a tactic blocker — analogist is the right tool), or (b) a blueprint expansion that re-specifies Steps 2-4 with the per-x algebra threading made explicit so the prover doesn't re-discover the propagation issue at the tactic layer. Until one of those entry-conditions fires, the route should stay OFF-LIMITS.

### Route 2: `BasicOpenCech.lean` L1120 (`cechCofaceMap_pi_smul`)

- **Sorry trajectory**: 1 → 1 → 1 → 1 → 1 across iter-104 / 105 / 106 / 107 / 108. Net change over 5-iter window: 0.
- **Helper accumulation**: 2 top-level helpers across iter-104–105 (`cechCofaceMap_summand_family_R_linear`, `cechCofaceMap_summand_family'_R_linear`), 0 in iter-106 / 107 / 108. The L1120 sorry itself has not budged.
- **Recurring blockers** (per directive, hitting 4–6 of the 7-iter project-narrative window):
  - "anonymous-closure Pi.lift codomain" — 6/7 iters.
  - "discrim-tree pattern-unification" — 5/7.
  - "whnf timeout" — 4/7.
  - "eqToHom-vs-Pi.π transport" — 4/7.
  - "Fin index mismatch / Fin.cast" — 4/7.
  - These are not 5 separate blockers; they're 5 symptoms of the same definitional-equality / transport-management wall.
- **Prover status pattern**: PARTIAL → PARTIAL → PAUSED → PAUSED → PAUSED. The pause is intentional and was ratified by iter-106 progress-critic STUCK.
- **Verdict**: **STUCK (carry)**.
  - Sorry count unchanged across K=5 iters. ✓
  - Recurring blocker phrases across ≥3 iters (every one of the 5 listed blockers crosses that threshold). ✓
  - Pre-existing STUCK verdict from iter-106 progress-critic; no signal-level change since.
- **Primary corrective**: **Route pivot / PAUSED preserved — ratified.** OFF-LIMITS this iter is the only defensible signal-level response. **No new prover work is correct.**
- **Secondary correctives**: This route's eventual re-entry will need a structural pivot, not another helper round. Candidate pivots (in priority order): (i) refactor the `cechCofaceMap` definition itself to avoid the `Pi.lift` anonymous-closure codomain, (ii) mathlib-analogist consult on whether `Limits.Pi.lift` is the right primitive at all (the recurring 5 blockers all sit around it — the API may be load-bearing in a way the route can't survive), (iii) user escalation if (i) and (ii) both fail.

### Route 3: `Picard/LineBundle.lean` (C1 promotion — FRESH)

- **Sorry trajectory**: N/A (0 iters of route-specific data).
- **Helper accumulation**: N/A.
- **Recurring blockers**: N/A.
- **Prover status pattern**: N/A.
- **Verdict**: **UNCLEAR** (per rule: fresh route, < K iters of data).
- **Hard-shape pre-launch read** (responding to the planner's explicit question):
  - **Positive signals**:
    - The dispatch is **preceded by a mathlib-analogist consult** (`analogies/c1-route.md`) that returned 4 concrete decisions (A/B/C/D). This is the textbook escalation pattern — exactly what I'd recommend for CHURNING routes — fired *before* any prover round, not after. The planner is using the right tool at the right point.
    - The expected delta is **bounded and named**: project total 14 → ~15-18; named-sorry count 4 → 5 (the new gap, `SheafOfModules.pullback_tensorObj`, is documented as Decision C with an explicit "default option (c) accept" disposition). This is not an open-ended refactor; the analogist has scoped the gap.
    - Decision D ("hand-rolled `Units.mkOfMulEqOne`, no scheme-side `Invertible` typeclass") is a concrete construction pattern, not a wishlist. Decision A's rename target is a verbatim mathlib idiom (`(Shrink (Skeleton X.Modules))ˣ`).
  - **Risk signals (planner should watch, not gate)**:
    - The "expected: maybe 1-3 new sorries that the next prover iter resolves" framing is the **single most common precursor to CHURNING that I see in this report's prior routes**. Both Route 1 (helper-cascade across iter-106/107) and Route 2's early iters (iter-104/105 wrapper helpers) opened the same way: "small bounded delta, next iter closes it." When those "1-3 new sorries" don't close cleanly on iter-110, the planner must NOT respond by adding more helpers — that's the failure mode. The correct iter-110 response if the new sorries don't close is to dispatch the analogist again on the specific downstream call-sites, not to attempt another prover round.
    - The "downstream call-site fixes in `Picard/Functor.lean` + `Picard/FunctorAb.lean`" scope is the soft edge of bounded vs CHURNING. If the refactor confines itself to `Picard/LineBundle.lean` + ≤2 mechanical sorry insertions per downstream file (4 total max), the route is bounded. If the refactor opens >4 downstream sorries, or if the downstream files themselves need their own refactor passes, that's a route-pivot signal — the planner should re-dispatch `strategy-critic` mid-iter rather than absorbing the rippling.
    - Decision B re-classifies `instIsMonoidal_W` from "dormant deferred" to "load-bearing deferred." This is a disclosure cost the iter accepts knowingly, but it expands the surface area that future iters will have to navigate. Not a blocker, but a route-shape signal: the post-C1 Pic arc now has one more thing it can't ignore.
  - **Helper-churn risk profile**: **MEDIUM**. The pre-work pattern (analogist consult before dispatch, named decisions with explicit dispositions) suggests the planner is escalating proactively rather than after-the-fact, which historically reduces churn. The risk is concentrated at the iter-110 follow-through: if the downstream sorries don't close cleanly, the planner must escalate again rather than helper-round.
- **Primary corrective**: None (verdict is UNCLEAR; route gets a clean first iter). For iter-110's progress-critic dispatch, the entry signal to watch will be: did the refactor land within the bounded scope (≤4 downstream sorries, no cascade into `Picard/Functor.lean` / `Picard/FunctorAb.lean` proper), and did iter-110's prover close those downstream sorries? PARTIAL on iter-110's first prover round on Route 3 is acceptable (UNCLEAR continues); PARTIAL on iter-111's second prover round on the same Route-3-downstream sorries flips it to CHURNING.

## Must-fix-this-iter

- **Route 1 (`h_loc_exact` L1846)**: **STUCK** — primary corrective: **route pivot ratified / keep OFF-LIMITS**. Why: 0 sorry-elimination + accumulated scaffolding now frozen as inert infrastructure across K=3 iters. The planner's OFF-LIMITS framing is the correct response and is hereby ratified. **No new prover work this iter.**
- **Route 2 (`cechCofaceMap_pi_smul` L1120)**: **STUCK (carry)** — primary corrective: **PAUSED preserved**. Why: 5/5 iters at sorry count 1, 5 named blockers each crossing the ≥3-iter threshold, prior iter-106 STUCK verdict still authoritative. **No new prover work this iter.**

## Informational

- **Route 3 (`Picard/LineBundle.lean` C1 promotion)**: **UNCLEAR** (fresh). Helper-churn risk MEDIUM. Pre-launch shape is well-formed because the analogist consult preceded dispatch; the iter-110 follow-through on downstream sorries is the next signal that resolves the verdict.

## Overall verdict

Two of the three routes are STUCK and correctly OFF-LIMITS this iter — the planner has already adopted the right corrective for both (Route 1 via the iter-108 budget-deferral escape valve, Route 2 via the iter-106 STUCK pause carry). Route 3 is the only active route this iter, and its pre-launch shape is healthier than either of the stuck routes' early iters because a mathlib-analogist consult preceded dispatch rather than following N iters of churn. The planner's iter-109 should proceed: dispatch the C1 refactor on `Picard/LineBundle.lean` per the analogist's 4 decisions, run the concurrent `blueprint-writer` on `Picard_LineBundle.tex`, and explicitly bound the downstream rippling scope to ≤4 new sorries in `Picard/Functor.lean` + `Picard/FunctorAb.lean` combined. **Signal I'd flag the planner might be missing**: the "1-3 new downstream sorries that the next prover iter resolves" framing matches the iter-104/106 opening of both stuck routes; if iter-110's prover doesn't close the downstream sorries cleanly, the planner must escalate (re-dispatch analogist on the specific downstream sites) rather than helper-round — that's the failure-mode boundary worth pre-committing to now.
