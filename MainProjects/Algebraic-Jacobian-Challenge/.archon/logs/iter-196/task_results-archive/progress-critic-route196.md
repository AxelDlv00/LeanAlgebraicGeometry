# Progress Critic Report

## Slug
route196

## Iteration
196

## Routes audited

---

### Route: Lane H — `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`

- **Sorry trajectory**: 4 → 4 → 4 → 3 across iter-192–195. One closure in four iters; flat for three iters then one drop. Not strictly decreasing.
- **Helper accumulation**: 5 helpers across 4 iters; 1 sorry closed. Helpers per-closure ratio: 5:1.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, done — three of four iters are PARTIAL.
- **Recurring blockers**: "SAb.Exact resists" in iter-192–194; cleared in iter-195 via `sheafCompose_preservesFiniteLimits`. Blocker resolved.
- **Avoidance patterns**: Planner proposes OFF-CRITICAL-PATH reclassification at iter-196 — first occurrence, not yet a pattern (requires ≥2 consecutive to trigger avoidance rule). Worth watching.
- **Throughput**: OVER_BUDGET — phase entered iter-184, 12 iters elapsed; STRATEGY says `Iters left: ~6-10`. Total estimated duration was ~6–10 iters; 12 already spent with 6–10 still projected. Elapsed (12) > upper bound of estimate (10).
- **Verdict**: **CHURNING** — PARTIAL prover status in 3 of last 4 iters triggers the CHURNING rule verbatim. The iter-195 closure is genuine progress, but three consecutive PARTIALs plus throughput over-budget make the cumulative signal CHURNING.
- **Primary corrective**: **Scope reduction** — The Tier-3 residual includes `IsFlasque.injective_flasque` (L572) which requires ~100–150 LOC of `j_!` extension-by-zero infrastructure absent from Mathlib. This is a documented Mathlib boundary, not a proof-gap. The planner should formally close this as a known-gap deferred item and pin the 2 remaining reachable sorries (`IsFlasque.constant_of_irreducible` L138, `skyscraperSheaf_eq_pushforward_const` L760) as the actual iter-196 targets. Dispatching into an open Mathlib boundary without scoping it out is what causes the 3-iter flat pattern.

---

### Route: Lane BareScheme — `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`

- **Sorry trajectory**: 2 → 2 (single iter, API error; no mathematical failure).
- **Helper accumulation**: 0.
- **Prover status pattern**: ERROR (API 529) — not a prover PARTIAL; the session never reached a mathematical decision point.
- **Recurring blockers**: none (error was infrastructure, not mathematical).
- **Avoidance patterns**: none.
- **Throughput**: ESTIMATE_FREE — only 1 iter of data; no phase estimate available for comparison.
- **Verdict**: **UNCLEAR** — one iter, infrastructure failure. There is no trajectory to evaluate. The analogist-confirmed recipe and hard-gate-cleared status mean the next dispatch is straightforward re-attempt, not a strategic decision.

---

### Route: Lane E — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

- **Sorry trajectory**: 3 → 3 → 3 → 3 → 3 across iter-191–195. Flat for all five iters; zero closures.
- **Helper accumulation**: 9 helpers across iters 191–194 (iter-195 added 0 due to API failure); 0 sorries closed across 5 iters. This is the STUCK signature.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, ERROR — four genuine provers, all PARTIAL.
- **Recurring blockers**: The iter-193 pivot to `IsOpenImmersion.lift_uniq` did not close any sorries; still PARTIAL in iter-194. The analogist recipe `analogies/lane-e-proj-appiso-pivot.md` was confirmed at iter-195 but not yet tested in a completed prover run.
- **Avoidance patterns**: none — the route has been actively dispatched each iter.
- **Throughput**: ESTIMATE_FREE on the new ANALOGUE_FOUND sub-phase (`Iters left: ~2-4` per iter-195 update); pre-analogue period was 4 iters with zero sorries closed, suggesting the approach used iters 191–194 was wrong.
- **Verdict**: **STUCK** — "helpers added without any sorry-elimination across K iters" applies: 9 helpers, 0 closures over 4 completed prover iters. The STUCK verdict is correct per rules even accounting for the API-529 failure in iter-195.
- **Primary corrective**: **Mathlib analogy consult** — The analogist recipe exists (`analogies/lane-e-proj-appiso-pivot.md`, 3-helper ~30–50 LOC port) but has never produced a closure. Before re-dispatching, the plan agent should expand the blueprint chapter with the analogist recipe's exact Lean API calls (`Proj.awayι_app_basicOpen` / `IsAffineOpen.fromSpec_app_self` mirror) as explicit proof sketch steps. Nine helpers accumulated without closures indicates the prover is reading a recipe that is correct in spirit but insufficiently specific in API form. A consult that produces explicit `have` goals and lemma names will convert the analogy into a prover-executable plan.

  *Contextual note*: The ANALOGUE_FOUND transition at iter-195 represents a genuine strategic advance; the STUCK label reflects the pre-analogue trajectory. The corrective is lightweight (API-specificity expansion, not route pivot), and re-dispatch is appropriate once the expanded recipe is confirmed.

---

### Route: Lane I — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

- **Sorry trajectory**: Start-of-iter values: 3 → 3 → [5 via sanctioned refactor expand] → 4 → 4. Net from post-refactor baseline (5→4→4): one closure in two iters, then flat. Net over full window after expansion: one sorry closed in four iters (5→4, then flat).
- **Helper accumulation**: 11 helpers across 4 iters; 1 sorry closed since refactor expanded scope. Helpers-to-closures: 11:1.
- **Prover status pattern**: PARTIAL, PARTIAL, done (closure), PARTIAL — three of four iters are PARTIAL.
- **Recurring blockers**: `instIsRegularInCodimOneProjectiveLineBar` body opened but not closed in iter-195. L746 `sorryAx` propagation (lean-auditor must-fix) persists.
- **Avoidance patterns**: none — dispatched each iter, sanctioned refactor executed.
- **Throughput**: SLIPPING — "STRATEGY says `Iters left: ~3-7`, realized ~10/it." The "realized ~10/it" figure means actual throughput is ~10 iters per sorry, vs the 3–7 iter estimate implying much faster resolution. This is a SLIPPING-to-OVER_BUDGET boundary.
- **Verdict**: **CHURNING** — PARTIAL status in 3 of last 4 iters; helpers added in 3 of 4 iters with one sorry closed across the window. The L746 sorryAx propagation must-fix has been carried since iter-195 without resolution — this constitutes deferral persisting across 1 iter (not yet ≥2 per strict STUCK rule, but the plan agent must act this iter).
- **Primary corrective**: **Structural refactor** — The instance-demotion must-fix (L746 sorryAx propagation) is the load-bearing blocker: a sorry-carrying instance silently poisons downstream typechecks, masking real progress. Demote L746 to a private theorem first, then dispatch the affine-chart k̄[t] PID transfer (~50–80 LOC). The CHURNING pattern here is partly diagnostic noise from the sorryAx contamination; addressing it removes the confounding and allows honest sorry-trajectory assessment.

---

### Route: Lane A — `AlgebraicJacobian/RiemannRoch/OCofP.lean`

- **Sorry trajectory**: 3 → 3 → 3 across iter-193–195. Flat for all three iters; zero closures. (Iter-193 was gated on Lane H — effectively 2 active prover iters.)
- **Helper accumulation**: 2 helpers across 3 iters; 0 sorries closed.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL.
- **Recurring blockers**: None explicitly stated. Iter-195 advanced 6 axiom-clean substeps internally but residual remains 3 named sub-claims.
- **Avoidance patterns**: Iter-193 gate was legitimate (dependency on Lane H); not an avoidance pattern. But the sorry count has not moved in 3 iters of active or gated work.
- **Throughput**: ON_SCHEDULE — "Iters left: ~5–12", 3 iters elapsed in current phase. Elapsed (3) < lower bound estimate (5).
- **Verdict**: **CHURNING** — PARTIAL in all 3 iters of window. The rules apply verbatim even accounting for the gate context. The route has made internal structural progress (substeps named, recipes identified) but no sorry has closed.
- **Primary corrective**: **Blueprint expansion** — The 3 residual sorries each have "concrete recipes" per iter-195's prover report, but they haven't translated into closures. This gap between recipe-exists and proof-closes is the blueprint-expansion signal: the chapter likely describes the high-level argument but not the Lean term-mode proof steps (specific `exact`/`apply`/`refine` sequences). Expand the blueprint chapter to convert each named sub-claim into an explicit proof sketch with Lean-level intermediate goals. The iter-196 prover for Lane A should be handed a chapter with ≥3 named recipe sub-steps, not just named goals.

---

### Route: Lane F — `AlgebraicJacobian/Picard/QuotScheme.lean`

- **Sorry trajectory**: 12 → 12 → 12 → 12 across iter-193–195 (all four iters flat). Zero closures.
- **Helper accumulation**: 1 helper (refactor, iter-195 plan phase); 0 in prover phases. Zero sorry-eliminations across 4 iters.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL (and implied PARTIAL in iter-193).
- **Recurring blockers**: LOC estimate systematically wrong: "~10–30 LOC" actual vs ~100–150 LOC actual in iter-195. Beck-Chevalley complexity appeared mid-iter after (N1)–(N4) substrate gaps were named. No single quoted blocker phrase repeated, but the systematic LOC underestimation is a structural signal.
- **Avoidance patterns**: none — route dispatched each iter; refactor was executed. But the strategy phase is explicitly labelled "stalled" in the planner's own signals.
- **Throughput**: ESTIMATE_FREE for formal `Iters left` — phase A.2.b has no quoted estimate in the directive. The "stalled" label and zero-closure 4-iter flat trajectory constitute a functional STUCK signal.
- **Verdict**: **STUCK** — "helpers added without any sorry-elimination across K iters" (1 helper, 0 closures across 4 iters). Also: PARTIAL ≥3 of last K iters. The LOC systematically wrong by 5–10× across multiple iters means the blueprint chapter is fundamentally underspecified — provers cannot close sorries they cannot see well enough to target. The strategy phase labelling itself "stalled" corroborates.
- **Primary corrective**: **Blueprint expansion** — A LOC estimate wrong by 5–10× is the canonical blueprint-underspecification signal. The 12 sorries across the Beck-Chevalley steps need the blueprint chapter to be expanded with a concrete sketch that accounts for the actual ~100–150 LOC scope (Stage 1 through 6, with the (N1)–(N4) substrate gaps explicitly bridged). Dispatching more prover rounds on a chapter whose proof sketch is too thin to support closure is the cause of the flat trajectory. **The iter-196 prover dispatch for Lane F should be blocked pending blueprint expansion.** If the plan agent cannot commit to blueprint expansion this iter, Lane F should be deprioritized from iter-196 objectives.

---

### Route: Lane RCI — `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

- **Sorry trajectory**: 1 → 3 → 3 → 3 (iter-193–195). The jump to 3 in iter-193 was sanctioned (helper carve); since then flat at 3 for 3 iters.
- **Helper accumulation**: 5 helpers across 3 iters; 0 net closures since the carve expanded scope.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL.
- **Recurring blockers**: "HARD BAR NOT technically met — tactic-experiments dead per `Classical.arbitrary`/`tauto`/`exact?`" in iter-195. This is a first explicit occurrence; earlier iters showed PARTIAL without this specific phrase.
- **Avoidance patterns**: none — dispatched each iter.
- **Throughput**: OVER_BUDGET — STRATEGY.md itself flags this: "OVER_BUDGET (16 elapsed); `Iters left: ~20-26`." Total projected: 16 + 20–26 = 36–42 iters for this route. This is the most severe throughput signal across all routes.
- **Verdict**: **CHURNING** — PARTIAL × 3; helpers in every iter; OVER_BUDGET flagged in STRATEGY.md itself. The tactic-dead blocker in iter-195 pushes toward STUCK, but the CHURNING rule is triggered first. The OVER_BUDGET finding (Iters left > 0, elapsed >> estimate) is a mandatory must-fix escalation.
- **Primary corrective**: **Scope reduction** — A projected 36–42-iter total for this route is untenable. The route is gated on BareScheme cascade; if BareScheme closes in iter-196, helper (a) per-fibre LQF becomes unblocked. But re-dispatching RCI in iter-196 before BareScheme cascade is confirmed lands the prover in the same "per-fibre LQF blocked" state that produced the PARTIAL × 3 pattern. Recommended action: dispatch RCI iter-196 only as a conditional follow-up (same iter, sequential dependency). If BareScheme prover does not close the gating sorry, RCI should be held and the budget re-examined via a strategy revision. The OVER_BUDGET signal also warrants a STRATEGY.md revision for this route's total estimate.

---

### Route: Lane G — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`

- **Sorry trajectory**: 1 → 2 → 1 → 1 (iter-193–195). The bump to 2 was a sanctioned case-split; closure of n=0 returned to 1; flat at 1 since then.
- **Helper accumulation**: 6 helpers across 3 iters; 1 sorry closed (n=0 branch). The 4-piece iter-196+ slice ordering is a concrete plan, not helper accumulation for its own sake.
- **Prover status pattern**: PARTIAL, done, PARTIAL — 2 of 3 are PARTIAL; the "done" in iter-194 was a genuine n=0 branch closure. This does NOT meet the PARTIAL ≥3 of last K criterion.
- **Recurring blockers**: none.
- **Avoidance patterns**: none — off-critical-path designation is pre-existing and appropriate for A.4.b; route is dispatched rather than deferred.
- **Throughput**: ON_SCHEDULE — "Iters left: ~6-12", ~3 iters elapsed in current analysis window; no budget concern.
- **Verdict**: **CONVERGING** — genuine n=0 closure in iter-194; n=k+1 inductive step carved into a helper with a 4-piece slice plan; no recurring blocker; PARTIAL × 2 of 3 does not trigger the CHURNING rule. Methodical progress on off-critical-path file.

---

## PROGRESS.md dispatch sanity

- **File count**: 8 (cap: 10)
- **Ready but not dispatched**: Lane G (AuslanderBuchsbaum) is appropriately off-critical-path; the directive does not list other known-ready files. No under-dispatch finding on available information.
- **Over the cap**: no — 8 ≤ 10.
- **Bloat concern**: FGAPicRepresentability.lean (proposal item 8) is a NEW file with zero prior signals in the directive. Adding a fresh file while four routes are CHURNING or STUCK constitutes minor scope creep, but the file count is within cap and the planner frames it as a "first slice." Flag but not a hard BLOAT finding.
- **Lane F dispatch concern**: Lane F is STUCK (4 iters, 0 closures, blueprint systematically underspecified). Dispatching a prover to a STUCK route without first executing the corrective (blueprint expansion) is the single most likely source of another PARTIAL at iter-196. The dispatch sanity verdict is conditional on whether the plan agent commits to blueprint expansion for Lane F THIS iter (not next).
- **Lane RCI dependency risk**: proposal item 7 (RationalCurveIso) is gated on BareScheme cascade. If BareScheme closes its gating sorry, RCI helper (a) is unblocked; if not, RCI prover dispatches into a blocked state again. The planner should structure this as a conditional same-iter follow-up, not an independent prover slot.
- **Under-dispatch finding**: no — 8 of cap-10 dispatched, no gap ≥3 identified.
- **Iter-over-iter trend**: last iter also had 8 prover lanes. Stable count.
- **Verdict**: **OK** with two advisory flags — (a) Lane F prover should be blocked until blueprint expansion is committed this iter; (b) RCI dispatch should be structured as conditional on BareScheme gate.

---

## Must-fix-this-iter

- **Route Lane F**: STUCK — primary corrective: **blueprint expansion**. Why: 4 iters, 0 closures, LOC estimate wrong by 5–10× signals a blueprint chapter too thin to support prover closure. Dispatch prover to Lane F only after the plan agent expands the Beck-Chevalley chapter this iter; otherwise Lane F will produce a fifth PARTIAL.
- **Route Lane E**: STUCK — primary corrective: **Mathlib analogy consult**. Why: 9 helpers, 0 closures across 4 completed prover iters; the analogist recipe exists but has never produced a closure; next prover needs explicit Lean API calls (not just the recipe's conceptual frame) before dispatch.
- **Route Lane A**: CHURNING — primary corrective: **blueprint expansion**. Why: 3 named sub-claims with "concrete recipes" remain unclosed; blueprint must be expanded with Lean-level intermediate goals for the iter-196 prover to act on them rather than re-deriving structure.
- **Route Lane I**: CHURNING — primary corrective: **structural refactor** (must-fix L746 demotion). Why: sorryAx propagation from L746 contaminates the sorry-trajectory signal and may be masking downstream progress; demote before next prover round.
- **Route Lane H**: CHURNING, OVER_BUDGET — primary corrective: **scope reduction**. Why: `j_!` extension-by-zero (~100–150 LOC Mathlib gap) should be formally documented as a boundary gap and excluded from iter-196 targets; dispatch only to `IsFlasque.constant_of_irreducible` (L138) and `skyscraperSheaf_eq_pushforward_const` (L760).
- **Route Lane RCI**: CHURNING, OVER_BUDGET — primary corrective: **scope reduction** with STRATEGY.md revision. Why: 16 elapsed, 20–26 more projected (total 36–42 iters); dispatch only if BareScheme gate confirmed this same iter; otherwise hold and revise strategy estimate.
- **Throughput Lane H**: OVER_BUDGET — STRATEGY.md estimates ~6–10 iters total for phase; 12 elapsed, 6–10 still projected. Revise the phase estimate to reflect 18–22 iter reality, or formally close the j_! gap as a scope exclusion and update the remaining-iters projection.
- **Throughput Lane RCI**: OVER_BUDGET (flagged in STRATEGY.md itself) — projected 36–42 total iters. Revise STRATEGY.md estimate for this route this iter.

---

## Informational

- **Lane BareScheme** (UNCLEAR): single API-failure iter; re-dispatch is correct. The UNCLEAR verdict should not delay the mandatory re-attempt — the analogist recipe and hard-gate-cleared status make this a straightforward re-run, not a strategic question.
- **Lane G** (CONVERGING): the 4-piece iter-196+ slice ordering for `auslander_buchsbaum_formula_succ_pd` is a healthy decomposition. The route is processing methodically. No action needed.
- **Lane I / FGAPicRepresentability**: the new file (FGAPicRepresentability.lean, proposal item 8) lacks any prior signals in the directive. The plan agent should confirm that a complete blueprint chapter exists for it before dispatch; without that, it risks becoming a new CHURNING lane by iter-198.

---

## Overall verdict

Five of eight routes are CHURNING or STUCK (Lane H CHURNING, Lane E STUCK, Lane I CHURNING, Lane A CHURNING, Lane F STUCK, Lane RCI CHURNING). Lane G is CONVERGING; Lane BareScheme is UNCLEAR (infrastructure failure, not mathematical). The net sorry delta of −2 over last iter (88→86) reflects a low throughput rate relative to eight lanes dispatched; the dominant causes are a STUCK Lane F (0 closures in 4 iters) and STUCK Lane E (0 closures in 5 iters). The iter-196 plan must execute blueprint expansion for Lane F and a Mathlib analogy consult for Lane E before dispatching provers to those routes, or the same PARTIAL verdicts will repeat for a fifth and sixth time respectively. Lane I's sorryAx demotion must-fix is a low-cost structural action that should be executed as a plan-phase task before the iter-196 prover round, not deferred again. Lane RCI's OVER_BUDGET trajectory (16 elapsed, 20–26 projected) requires a STRATEGY.md revision this iter regardless of dispatch decision.

---

`route196: MIXED — 8 routes audited, 4 CHURNING + 2 STUCK verdicts, 0 avoidance findings (1 off-critical-path watch for Lane H), dispatch=OK (advisory: Lane F prover should be blocked pending blueprint expansion; Lane RCI dispatch conditional on BareScheme gate)`
