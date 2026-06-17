# Progress Critic Report

## Slug
route172

## Iteration
172

## Routes audited

### Route 1: Genus0BaseObjects.lean — gmScalingP1 body + Lane A

- **Sorry trajectory**: 9 → 8 → 8 → 10 across iter-168 → iter-171. Net +1 over the K=4 window. The iter-171 +2 is *structural decomposition* (one bare body sorry factored into three named scaffolds at L695 / L705 / L721), not pure regression. Strict "decreasing" CONVERGING test fails.
- **Helper accumulation**: iter-168 +4 Lane A exports (axiom-clean) + 3 honest-scaffold sorries; iter-169 net −1 (DELETED `ga_grpObj` / `ga_smooth`); iter-170 zero edits (API-500); iter-171 +2 scaffolds + `mvPolyToHomogeneousLocalizationAway_surjective` helper. Helpers are no longer wrapper accumulation — they are factored pieces of the load-bearing body.
- **Prover dispatch pattern**: 1 of 1 ready file dispatched each iter (only Genus0BaseObjects has a real lane; Routes 2/3 are blueprint-stubs). No under-dispatch on this route.
- **Recurring blockers**: none anymore. The 5-iter "build supports / defer body" pattern (iters 165–170) is broken by the iter-171 body-skeleton landing at L742 (concrete `Over.homMk ((cover).glueMorphisms ...)`).
- **Avoidance patterns**: none on this route. The body-first corrective demanded by iter-170 reviewer was applied iter-171.
- **Prover status pattern**: PARTIAL, PARTIAL, ERROR (API-500), PARTIAL. Three PARTIAL of last four iters → fires CHURNING-by-status rule.
- **Throughput**: OVER_BUDGET — STRATEGY.md estimates `~3-5` iters from phase start (iter-165); elapsed is **7** iters at iter-171 close (planning iter-172 = 8th). 7 > 2× lower bound (6); 7 > upper bound (5) by 2. Estimate is dishonestly low.
- **Verdict**: **CHURNING** (by strict PARTIAL ≥3-of-4 status rule) — qualified.
- **Primary corrective**: **Continue the iter-172 plan as the CHURNING-reversal test, with a hard gate.** The directive's question — "does the iter-171 body-skeleton landing satisfy CHURNING-reversal? Or are the 3 named internal sorries another helper-churn pattern in disguise?" — answer: the 3 sorries are GENUINE scaffolds (chart morphism / cocycle agreement / Over coherence), each with a concrete named Mathlib idiom in the iter-172 proposal (`Scheme.Cover.hom_ext`, `pullbackSpecIso ≫ Spec.map _ ≫ Proj.awayι`, dependency on `aux_left` closing axiom-clean). This is NOT wrapper accumulation. **BUT**: iter-172 must close ≥2 of the 3 scaffolds. If iter-172 closes 0 or 1, the body-first decomposition has revealed a real Mathlib gap and the route flips to STUCK; escalate to **Mathlib-idiom consult** on `Scheme.Cover.glueMorphisms` + `Proj.awayι` chart composition before any further prover round.
- **Secondary correctives**: (i) revise STRATEGY.md `Iters left` for this row from `~3-5` to `~4-7` (honest re-estimate given the realized rate); (ii) if PRIMARY 1 (`mvPolyToHomogeneousLocalizationAway_surjective`, L372) does not close axiom-clean, PRIMARY 3 (the chart) blocks — confirm the dependency chain holds before parallel dispatch.

### Route 2: Picard/RelativeSpec.lean (Route A.1 file-skeleton)

- **Sorry trajectory**: N/A — file does not exist. `blueprint/src/chapters/Picard_RelativeSpec.tex` also does NOT exist on disk (verified). The blueprint chapter required as a prerequisite was never produced.
- **Helper accumulation**: N/A.
- **Prover dispatch pattern**: 0 dispatches on this route across iter-168 → iter-171 (5+ consecutive iters when counting the pre-iter-168 deferral history cited).
- **Recurring blockers**: "blueprint-writer didn't land" (iter-171: first failed, retry killed mid-write).
- **Avoidance patterns**: **CHURNING-by-avoidance confirmed.** Per iter-171 progress-critic finding cited in the directive, Route A had **zero dispatch for 5 consecutive iters**. Iter-171 broke the deferral language by committing the route — but the writer dispatch failed twice and no recovery has landed. The route remains in deferral-by-tooling-failure.
- **Prover status pattern**: not applicable (no prover lane).
- **Throughput**: ESTIMATE-FREE in practice — strategy says `~6-10` iters but the clock hasn't started (no chapter, no file). Phase formally entered iter-171; 1 iter elapsed.
- **Verdict**: **STUCK** (by inaction: 5+ consecutive iters of deferral status persistent across plan-only rotations, now coupled with two consecutive writer failures iter-171; no working artifact exists).
- **Primary corrective**: **Address deferred infrastructure with a hard third-strike gate.** The iter-172 plan correctly re-dispatches `blueprint-writer route-a1-retry2` with a DROPPED-if-fails clause — this is the right shape. Two non-negotiable additions: (i) BEFORE dispatch, the planner must scope the writer's directive narrower than prior attempts (e.g., target only the file-skeleton-shaped subset of A.1, not the full chapter) — both prior attempts may have failed because the directive was too large; (ii) IF the third writer attempt also fails, the route MUST be formally closed for this iter and the planner MUST escalate route choice in iter-173 plan-phase (consider hand-drafting the chapter via plan-agent prose, or pivoting to a different A.x sub-route). Do NOT permit a fourth deferral.
- **Secondary correctives**: none beyond the third-strike gate.

### Route 3: RiemannRoch/WeilDivisor.lean (RR.1 file-skeleton)

- **Sorry trajectory**: N/A — file does not exist. **Blueprint chapter LANDED iter-171** (`RiemannRoch_WeilDivisor.tex`, 22 KB on disk, verified — directive's 445 LOC / 9 `\lean{...}` pins claim confirmed in spirit).
- **Helper accumulation**: N/A.
- **Prover dispatch pattern**: 0 dispatches across last 4 iters; first prover lane proposed for iter-172.
- **Recurring blockers**: none on this iter — iter-171 produced the prerequisite artifact.
- **Avoidance patterns**: 4 prior iters of "deferred (upstream-Mathlib option)" — but the iter-171 in-tree commitment + same-iter chapter landing IS the re-engagement plan. The avoidance is being actively reversed.
- **Prover status pattern**: not applicable (lane not yet active).
- **Throughput**: ON_SCHEDULE — STRATEGY estimates `~12-20` iters; 1 elapsed.
- **Verdict**: **UNCLEAR** (fresh route, <K iters of post-commitment data). Proceed but watch.
- **Primary corrective**: none required for iter-172. Advisory: the proposal correctly gates the scaffold lane on same-iter blueprint-reviewer HARD GATE clearance scoped to RR.1 — keep that gate firm. If reviewer raises must-fix on the chapter, defer the scaffold to iter-173 rather than scaffolding from an unverified blueprint.

## PROGRESS.md dispatch sanity

- **File count**: 3 (Genus0BaseObjects.lean, RiemannRoch/WeilDivisor.lean, Picard/RelativeSpec.lean).
- **Cap**: 10.
- **Ready but not dispatched**: none identified. Only Genus0BaseObjects has a complete chapter + open sorries (and it IS dispatched). RR.1 chapter exists but file doesn't (scaffold-lane, correctly proposed). Picard A.1 has neither chapter nor file (writer-retry lane, correctly proposed).
- **Over the cap**: no (3 < 10).
- **Under-dispatch finding**: no.
- **Iter-over-iter trend**: 1 → 1 → 1 → 3 effective (iter-171 added two scaffold/writer lanes). Healthy expansion: filling routes 2/3 alongside route 1 rather than under-dispatching.
- **Verdict**: **OK** — file count 3 within cap 10, no under-dispatch, growth correlates with new route commitments not with throwing-bodies-at-stuck-routes.

## Must-fix-this-iter

- **Route 1: CHURNING** — primary corrective: **Continue iter-172 plan as the CHURNING-reversal TEST with hard gate.** Why: PARTIAL prover status fires 3-of-4 (iter-168/169/171); the iter-171 structural landing is real but unproven. If iter-172 closes <2 of the 3 named scaffolds, escalate to Mathlib-idiom consult on `Scheme.Cover.glueMorphisms` + `Proj.awayι` before any further prover round.
- **Route 1 throughput: OVER_BUDGET** — STRATEGY.md `Iters left ~3-5` from iter-165; **elapsed 7** at iter-171 close. Revise the estimate in STRATEGY.md this iter to `~4-7` or escalate.
- **Route 2: STUCK** — primary corrective: **Address deferred infrastructure with a third-strike gate.** Why: 5+ consecutive iters deferral; two writer failures iter-171; no on-disk artifact. Narrow the writer's directive scope this iter; if attempt #3 also fails, formally close the route for iter-172 and pivot in iter-173 plan-phase. No fourth deferral.

## Informational

- **Route 1 favorable signal**: the iter-171 body-skeleton landing (concrete `Over.homMk + cover.glueMorphisms` at L742) is *exactly* the structural advance the iter-170 reviewer demanded. The three named internal sorries are factored body-pieces, not wrappers. Iter-172 is the cleanest possible test of whether the corrective worked — full credit if 2-3 scaffolds close.
- **Route 3 healthy commit**: iter-171 turned 4 iters of "deferred upstream" into a 22 KB on-disk blueprint chapter in a single iter. The same-iter HARD GATE pattern proposed for iter-172 is well-calibrated.
- **Dispatch shape**: 1 real prover lane + 2 scaffold lanes for iter-172 is the right shape given the route-2/3 readiness profile; not under-dispatch even though only one file has open sorries.

## Overall verdict

Three routes audited; one CHURNING (Route 1, Genus0BaseObjects.lean — qualified by genuine iter-171 structural landing, but verdict held strict on the 3-of-4 PARTIAL status pattern); one STUCK (Route 2, Picard/RelativeSpec.lean — 5+ iters deferral + two consecutive writer failures iter-171); one UNCLEAR (Route 3, RR/WeilDivisor.lean — fresh post-commitment, blueprint landed iter-171). Dispatch sanity OK. **Iter-172 is the make-or-break iter for Route 1**: the body-skeleton landing answered the iter-170 reviewer's body-first demand, and the planner's 3 PRIMARYs are the right follow-through — but PARTIAL has now fired three of the last four iters, so this iter's prover result is decisive. If ≥2 of the 3 scaffolds close, Route 1 returns to CONVERGING and STRATEGY.md should bump `Iters left` from `~3-5` to `~4-7`; if <2 close, escalate to Mathlib-idiom consult on `Scheme.Cover.glueMorphisms`. **Route 2's third writer attempt is the make-or-break for that route**: success unblocks scaffolding next iter; another failure means the planner must drop the route or pivot rather than allow a fourth deferral.
