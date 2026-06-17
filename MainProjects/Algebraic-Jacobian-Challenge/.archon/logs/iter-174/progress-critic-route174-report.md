# Progress Critic Report

## Slug
route174

## Iteration
174

## Routes audited

### Route 1 — `AlgebraicJacobian/Genus0BaseObjects.lean` (`gmScalingP1` chain)

- **Sorry trajectory**: 11 → 11 → 13 → 12 → 8 across iter-170 to iter-173 (net −3 in 4 audited iters; iter-170 was INFRA-FAIL so effective rate ≈ 1.0 / active-iter; the iter-171 +2 spike was intentional top-level scaffolding factoring out load-bearing residuals).
- **Helper accumulation**: 6 helpers added across last 4 iters (0 in 170, 3 scaffold in 171, 1 in 172, 2 in 173). Each helper described in the directive as "axiom-clean" and "load-bearing" (`mvPolyToHomogeneousLocalizationAway_surjective`, `awayι_comp_PLB_hom`, `gmScalingP1_cover_X_iso`) — these are not wrappers, they retire genuine sub-pieces. Helper payoff ratio: 6 helpers → −3 sorries = ~0.5 closures per helper, acceptable but not aggressive.
- **Prover dispatch pattern**: single-lane on this file each iter — within scope (one route, one file).
- **Recurring blockers**: "chart-bridge specialisation" surfaced in iter-172 + iter-173 directives as the bottleneck (2 of last 4 iters — under the 3-iter STUCK threshold, but a yellow flag).
- **Avoidance patterns**: none — every iter has a real prover dispatch attempting concrete closure (the INFRA-FAIL at iter-170 was an API error, not avoidance).
- **Prover status pattern**: INFRA-FAIL, PARTIAL-acceptable, PARTIAL-low, PARTIAL-low — **3 PARTIAL statuses in last 4 iters**. Per-iter scope-vs-delivery is over-promising: iter-172 attacked 4 primaries and closed 1, iter-173 attacked 3 and closed 1.
- **Throughput**: ON_SCHEDULE — STRATEGY.md `Iters left: ~3–6`, phase entered iter-170, elapsed = 4, projected total ≈ 7–10, within band.
- **Verdict**: **CHURNING** (by the `PARTIAL prover status ≥3 of last K iters` criterion). Sorry trajectory IS negative-net and the helpers are load-bearing, so this is the soft end of CHURNING — closer to "deliberately decomposing forward but persistently over-scoping the prover lane." But the verdict-rule letter says CHURNING and the over-scope signature is real: 4-attack-1-close → 3-attack-1-close is a pattern the planner has to break this iter, not next iter.
- **Primary corrective**: **Mathlib analogy consult** on the chart-bridge specialization (`gmScalingP1_chart_PLB_eq` shared helper and the load-bearing chart-bridge step it factors). Dispatch the analogist consult **in parallel with** Lane A this iter, not before — but treat the analogist's recipe as required reading if Lane A returns PARTIAL again at iter-175. Why: the iter-173 review explicitly recommended the shared-helper plan, and the planner has adopted it, but the same "chart-bridge specialisation" phrase has now surfaced 2 iters in a row as the genuine bottleneck. An analogist consult is the cheapest insurance against a 4th consecutive PARTIAL. If iter-174 returns COMPLETE on PRIMARY 2 + 3, the consult is wasted-cheap; if it returns PARTIAL-low, escalate Route 1 to STUCK at iter-175 and require a structural refactor.
- **Secondary correctives**: hard scope-discipline on Lane A — the iter-174 directive should require the prover to close EXACTLY PRIMARY 2 + 3 via the shared helper and explicitly forbid attacking PRIMARY 4 or unrelated sorries; over-scoping is the root cause of the PARTIAL-low pattern.

### Route 2 — `AlgebraicJacobian/Picard/RelativeSpec.lean`

- **Sorry trajectory**: no file → 0 → 6 across iter-172 (INFRA-FAIL) to iter-173 (file-skeleton landed). Only 1 iter of post-file-landing trajectory data.
- **Helper accumulation**: 1 helper (`structureMorphism`) + 4 weakened-type scaffolds acknowledged as such.
- **Prover status pattern**: COMPLETE at iter-173 (the file FIRST landing closed scope-as-promised).
- **Recurring blockers**: none yet (only 1 iter post-landing).
- **Avoidance patterns**: none. The iter-174 proposal to consult mathlib-analogist on `QcohAlgebra` before opening a body lane is a normal pattern for a fresh route's TYPE-level sorry — NOT yet a deferral pattern. **Watch flag**: if iter-175 also defers ("body lane next iter") without firing one, that becomes ≥2 consecutive deferrals and escalates to STUCK by inaction.
- **Throughput**: ON_SCHEDULE — STRATEGY.md `Iters left: ~3–5`, phase entered iter-173, elapsed = 1.
- **Verdict**: **UNCLEAR** — fresh route (< K iters of data).
- **Notes**: the planner's "dispatch analogist consult OR skip prover lane this iter to free budget" is acceptable for one iter. Strong preference: dispatch the analogist consult this iter so iter-175 has a structural recipe and can open the body lane immediately. Avoid the trap of consulting then deferring the body to iter-176.

### Route 3 — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

- **Sorry trajectory**: 0 → 7 → 5 across iter-172 (file-skeleton with `True` placeholder) to iter-173 (`True` retired + `degree_hom` closed; −2 sorries). 2 iters of body-phase data.
- **Helper accumulation**: `Scheme.PrimeDivisor` (172, with placeholder later retired) + `degree_hom_apply @[simp]` (173). Lean and load-bearing.
- **Prover status pattern**: COMPLETE, COMPLETE.
- **Recurring blockers**: none.
- **Avoidance patterns**: none.
- **Throughput**: ON_SCHEDULE — STRATEGY.md `Iters left: ~3–6`, phase entered iter-172, elapsed = 2.
- **Verdict**: **UNCLEAR** trending CONVERGING (only 2 iters of data, but trajectory is monotone-decreasing with COMPLETE statuses and no blockers).
- **Notes**: iter-173 review's recommendation to take `ofClosedPoint` (lighter than `RationalMap.order` which needs a DVR-extraction sub-build) is sound throughput discipline.

### Route 4 — NEW FILE skeleton lanes (`Picard/LineBundlePullback.lean`, `RiemannRoch/RRFormula.lean`)

- **Sorry trajectory**: N/A (files do not yet exist this iter).
- **Verdict**: **UNCLEAR** — no trajectory data; opening file-skeleton lanes is consistent with the STRATEGY.md rows (`A.1.b` Iters left ~2–4, `RR.2` Iters left ~3–5) entering body phase. Standard file-FIRST-landing semantics apply: file-skeleton lane returns COMPLETE if the chapter-aligned skeleton compiles with named sorries; the auditor must flag any `True := trivial` placeholders as iter-172 caught.

## PROGRESS.md dispatch sanity

- **File count**: 5–6 (Lane A continuation; WeilDivisor Lane D; LineBundlePullback NEW skeleton; RRFormula NEW skeleton; optional RelativeSpec body lane gated on analogist).
- **Cap**: default 10.
- **Ready but not dispatched**: none identified in the directive. No other file with a complete blueprint chapter and open sorries is left out.
- **Iter-over-iter trend**: prior iters dispatched 1–3 lanes per the iter signals; iter-174 proposes 5–6. Growth is justified by 2 NEW file-skeleton lanes coming online (A.1.b + RR.2 blueprint chapters landed iter-173) — not bloat.
- **Verdict**: **OK** — file count 5–6 within cap 10; no under-dispatch finding; growth is structural (new chapters opening, not more provers thrown at churning routes).

## Must-fix-this-iter

- **Route 1 (`gmScalingP1`)**: **CHURNING** — primary corrective: **Mathlib analogy consult on chart-bridge specialization** in parallel with Lane A this iter. Why: `chart-bridge specialisation` phrase has recurred 2 iters running as the bottleneck, and the prover-scope-vs-delivery ratio (4-attack-1-close, 3-attack-1-close) is degrading. The shared-helper plan is sound, but a parallel analogist consult is cheap insurance against a 4th consecutive PARTIAL; if PARTIAL persists at iter-175, escalate to STUCK + structural refactor. Secondary: hard scope-discipline on Lane A (close EXACTLY PRIMARY 2 + 3, no other sorries attacked).

## Informational

- **Route 2 (RelativeSpec)**: dispatch the mathlib-analogist consult on `QcohAlgebra` this iter (don't defer it) so iter-175 can open a body lane immediately. Two-consecutive-deferral is the next-iter watch threshold.
- **Route 3 (WeilDivisor)**: continue with `ofClosedPoint` as proposed; `RationalMap.order` correctly deferred until DVR-extraction infrastructure lands.
- **Route 4 (new files)**: file-FIRST-landing lanes are standard; require auditor checks for `True := trivial` placeholders as the iter-172 episode demonstrated.
- **Route 1 throughput trajectory note**: `Iters left: ~3–6` with elapsed = 4 gives projected total 7–10; if iter-174 returns PARTIAL-low again the elapsed bumps to 5 with no further-reducible "Iters left" honesty — at that point the planner should re-estimate, not just reschedule.

## Overall verdict

Four routes audited: **1 CHURNING (Route 1 `gmScalingP1`), 0 STUCK, 3 UNCLEAR (one fresh-route + one trending-CONVERGING + one no-data-yet for new file-skeleton lanes), 0 avoidance findings, dispatch=OK.** The genus-0 chain is making real progress (−3 sorries net, load-bearing helpers) but the prover lane is over-scoping each iter and the "chart-bridge specialisation" blocker has now recurred 2 iters running — these are the early-CHURNING signatures that the iter-174 plan must address by (1) ratifying the shared-helper plan with hard scope-discipline and (2) dispatching a Mathlib-analogist consult in parallel to de-risk a 4th consecutive PARTIAL. The other three routes are either fresh-skeleton territory or just-began body phases; their UNCLEAR status reflects insufficient data, not problems, and the planner's overall dispatch posture (5–6 lanes, 2 of which are NEW file-skeleton openings) is healthy fan-out — well within the dispatch cap and not bloated against any churning route.
