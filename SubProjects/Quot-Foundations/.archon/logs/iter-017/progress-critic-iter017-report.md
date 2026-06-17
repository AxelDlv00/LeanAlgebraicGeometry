# Progress Critic Report

## Slug
iter017

## Iteration
017

## Routes audited

### Route: FBC — AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **Sorry trajectory**: 5 → 4 → 4 → 4 across iter-014 to iter-016 (last 3 prover iters flat at 4; sorry last moved at iter-014 when Seam 1 closed)
- **Helper accumulation**: iter-015 +1 (Seam-2 leg-id scaffold, sorry-bearing); iter-016 +1 (`pullbackPushforward_unit_comp`, CLOSED axiom-clean). Helpers added in 2 of 4 audited iters; 2 helpers added toward Seam 2 with zero net movement on the Seam-2 sorry itself.
- **Prover dispatch pattern**: 1 file per prover iter (014, 015, 016). Single-file route; no multi-file under-dispatch.
- **Recurring blockers**:
  - iter-015: "conjugate calculus coherence gap at Seam 2 — leg-id misalignment"
  - iter-016: "rw [hfst]/[hsnd] motive is not type correct — legs in dependent positions (codomain_read type, gammaPushforwardIso, IsPullback.of_hasPullback)"
  - These are two formulations of the same Seam-2 dependent-position wall. Present in 2 consecutive prover iters (015, 016). Not yet ≥ 3, but the wall is the same structural obstacle.
- **Avoidance patterns**: none. All 3 recent iters had prover dispatches; iter-013 was a project-wide DAG-only iter (intentional).
- **Prover status pattern**: COMPLETE (014), PARTIAL (015), PARTIAL (016). Two consecutive PARTIAL.
- **Throughput**: OVER_BUDGET — Phase FBC-A entered ~iter-011; elapsed = 6 calendar iters; STRATEGY.md currently says "Iters left: 1–3", implying 7–9 total phase iters. The iter-016 progress-critic already flagged SLIPPING→borderline OVER_BUDGET at elapsed-5; another full iter elapsed without the Seam-2 sorry closing confirms OVER_BUDGET. The revised "1–3 remaining" estimate should be reflected in STRATEGY.md before iter-017's prover dispatch.
- **Verdict**: CHURNING
- **Primary corrective**: **Refactor** — the definition `base_change_mate_codomain_read` (and the surrounding chain) must be abstracted with the two legs (`pullback.fst`, `pullback.snd`) as explicit subst-able variables before any further prover pass on Seam 2. Both iter-015 and iter-016 provers hit the same dependent-position wall because the definition's type pins the concrete legs, blocking `rw [hfst]`/`rw [hsnd]` at all reachable transparency levels. Adding further closed helpers (the iter-015 scaffold, the iter-016 reindex engine) did not dissolve the structural obstacle. The needed action is: (i) introduce an abstract variant of `codomain_read` parametrised over `g' f' : …` satisfying `hfst : pullback.fst = g'` / `hsnd : pullback.snd = f'`; (ii) `subst hfst hsnd` to reduce to the abstract form; (iii) apply Seam 1 + the proved `pullbackPushforward_unit_comp` + `pushforwardComp_*_app_app` coherences to close. The planner's proposed iter-017 FBC objective ("abstract-variable-legs Seam-2 restructure") already names this action correctly; this entry confirms that it IS the must-execute corrective and must not be replaced with another helper round.

---

### Route: GF — AlgebraicJacobian/Picard/FlatteningStratification.lean

- **Sorry trajectory**: ~5 (iter-013) → 4 (iter-014) → 5 (iter-015) → 4 (iter-016). Net: -1 in 4 iters. Oscillation is a deliberate decomposition artefact (iter-015 added a sorry-bearing stub; iter-016 closed it); no spurious sorry inflation.
- **Helper accumulation**: iter-014 +5 (all CLOSED); iter-015 +1 (sorry-bearing stub, CLOSED iter-016); iter-016 +0 new. Helpers paid off: iter-014's 5 helpers enabled `gf_torsion_reindex` (COMPLETE); iter-015's stub was the direct iter-016 closure target (COMPLETE). No dead-end helper accumulation.
- **Prover dispatch pattern**: 1 file per prover iter (014, 015, 016). Single-file route.
- **Recurring blockers**: "OreLocalization instance-presentation diamond" — first appeared iter-015, persisted iter-016 as the SOLE remaining L5 blocker. Present in **2 consecutive prover iters**. Has NOT yet reached the ≥3-iter STUCK threshold, but is one iter away from it.
- **Avoidance patterns**: none.
- **Prover status pattern**: COMPLETE (014), PARTIAL (015), COMPLETE(helper) (016). Two genuine COMPLETE outcomes in 4 iters; the PARTIAL represents a purposeful decomposition step (stub introduction), not stall.
- **Throughput**: SLIPPING — Phase GF-alg entered ~iter-012; elapsed = 5 calendar iters; STRATEGY.md currently says "Iters left: 1–3", implying 6–8 total phase iters vs a likely original estimate that is being stretched. L5 assembly + L4 + `genericFlatnessAlgebraic` all remain open. Not yet 2× the upper estimate of 3; SLIPPING not OVER_BUDGET.
- **Verdict**: CONVERGING

**Rationale.** The CHURNING rule requires "no structural change in approach": two structural advances occurred (iter-014 factoring + 5 helpers → COMPLETE on `gf_torsion_reindex`; iter-016 tower-descent helper COMPLETE). The STUCK rule requires sorry unchanged across K iters or helpers added without any sorry-elimination: both criteria fail (two sorries were closed in the K-window). The sorry count is net-negative and the prover status pattern shows real COMPLETE outcomes. CONVERGING is correct.

**Critical watch signal.** The OreLocalization instance-presentation diamond now appears in 2 consecutive prover iters (015, 016). If iter-017's prover does NOT resolve the instance alignment (by either fixing `gf_torsion_reindex`'s emitted instances or restating `free_localizationAway_of_away_tower`'s `hfree` hypothesis), this blocker will reach the ≥3-iter STUCK threshold and the GF verdict will flip to STUCK at iter-018. The planner's proposed iter-017 GF objective ("fix the OreLocalization diamond to close L5") is correctly targeted at defusing this trigger before it fires.

---

### Route: QUOT — AlgebraicJacobian/Picard/QuotScheme.lean

- **Sorry trajectory**: 4 → 4 → 4 → 4 across iter-013 to iter-016 (4 iters, static). All 4 sorries are downstream stubs; none of the Route-1 prover work touched them.
- **Helper accumulation**: iter-015 +3 axiom-clean decls (D5 + G1 split); iter-016 +0 (no prover lane; structural pivot done). Route-1 helpers paid off on the power-series lane (iter-012) but never moved the 4 headline stubs. Route-2 prover: 0 iters of data.
- **Prover dispatch pattern**: Route-2 entered iter-016 (plan-only, pivot executed: mathlib-analogist consult + blueprint re-skeleton done). Iter-017 is the first Route-2 prover dispatch. Only 1 prior Route-1 prover attempt against the headline stubs (iter-015, immediately blocked by isDefEq non-termination).
- **Recurring blockers**: The Route-1 blocker ("isDefEq/whnf 2M-heartbeat runaway on DirectSum.Decomposition over quotient/subtype carrier") was diagnosed as a kernel-level structural dead end; Route-2 (ambient subquotient induction, no derived-carrier grading) makes it structurally impossible. Pre-pivot blocker does NOT carry over to Route-2 assessment.
- **Avoidance patterns**: iter-016 was a no-prover iter for QUOT (1 consecutive no-prover iter). This was the CHURNING-corrective action from iter-016's progress-critic, not avoidance. The plan-phase-only meta-pattern (≥3 consecutive no-prover iters) has NOT fired.
- **Prover status pattern**: PARTIAL (015, Route-1), no-lane (016, pivot). Route-2 prover data: 0 iters.
- **Throughput**: ON_SCHEDULE — Phase SNAP-S2 Route-2 entered iter-016; elapsed = 1 iter; STRATEGY.md says "Iters left: 2–3". The static sorry-4 trajectory for Route-1 does not count against the Route-2 schedule.
- **Verdict**: UNCLEAR — Route-2 has < K iters of prover data (0 prover iters; iter-017 is the first dispatch). The prior Route-1 CHURNING corrective was correctly executed. No Route-2 verdict can be rendered until the iter-017 prover returns. The sorry count will remain at 4 until Route-2 prover work begins; this is expected and should not trigger a STUCK reading at iter-018 without Route-2 prover data.

**Entry criteria reminder (from iter-016 progress-critic, secondary corrective).** The iter-017 Route-2 prover directive must explicitly prohibit building `GradedDecomposition` or `DirectSum.Decomposition` instances on quotient types without a prior elaboration-termination check. The memory entry `graded-quotient-module-isdefeq-pathology.md` records that `IsInternal/map_iSup over ↥p or M⧸p` loops the elaborator; the new ambient-M restatement must avoid all quotient-type graded decompositions, not just the specific G2-G4 form.

---

## PROGRESS.md dispatch sanity

Verdict: OK — file count 3 (2 unconditional + 1 contingent) within cap 10; no under-dispatch; no bloat.

- **File count**: 3 (QUOT unconditional, GF unconditional, FBC contingent)
- **Cap**: 10
- **Over the cap**: no
- **Under-dispatch finding**: no — all 3 active routes are proposed. No fourth file with complete blueprint chapter and open sorries was identified outside the 3 routes.
- **Iter-over-iter trend**: dispatch has held at 2–3 active files; appropriate for 3 active single-file routes.
- **FBC contingency note**: FBC is gated on the blueprint-writer fixing 2 "lvb must-fix" gaps + a fast-path re-review clearing FBC. The blueprint-writer directive for iter-017 (`blueprint-writer-fbc-seams2-directive.md`) exists in the logs but **no report exists yet** in `task_results/` — the prerequisite has not been fulfilled at the time of this assessment. The FBC prover must NOT be dispatched until that report confirms the blueprint gaps are resolved. This is a sequencing gate, not an under-dispatch finding.

---

## Must-fix-this-iter

- **Route FBC: CHURNING** — primary corrective: **Refactor** (abstract `codomain_read` with the two legs as subst-able parameters). Why: the dependent-position wall blocked Seam 2 in both iter-015 and iter-016 despite two different helpers being added; another helper pass without the structural definition change will reproduce the same wall. The planner's proposed FBC action already names this correctly — the must-fix directive is: execute the abstract-variable-legs Seam-2 restructure exactly as documented (do not substitute another helper round), and treat the FBC dispatch as gated on the blueprint-writer prerequisite.

- **Route FBC: OVER_BUDGET** — STRATEGY.md currently says "Iters left: 1–3" with 6 calendar iters elapsed since Phase FBC-A entered ~iter-011. Update the `Iters left` estimate in STRATEGY.md to reflect the realistic remaining cost before the iter-017 prover dispatch. The estimate has been drifting since the iter-016 progress-critic flagged it as "SLIPPING → borderline OVER_BUDGET"; at iter-017 it is unambiguously OVER_BUDGET and should be restated.

---

## Informational

**GF: OreLocalization diamond at 2-iter threshold.** The OreLocalization instance-presentation diamond is now the SOLE L5 blocker and has appeared in 2 consecutive prover iters (015, 016). If iter-017's GF prover does not resolve the instance alignment (fix `gf_torsion_reindex`'s emitted instances **or** restate `hfree` in `free_localizationAway_of_away_tower`), the ≥3-iter recurring-blocker criterion for STUCK will fire at iter-018. The planner's proposed GF objective directly targets this; failure to close it this iter forces an escalation next iter.

**GF: SLIPPING throughput.** 5 calendar iters elapsed in Phase GF-alg (entered ~iter-012) with L5 assembly + L4 + `genericFlatnessAlgebraic` still open. STRATEGY.md says "Iters left: 1–3"; total phase will be 6–8 iters. If the OreLocalization fix closes L5 this iter, the route can realistically close in 1–2 more iters; if L5 slips again, GF will be at risk of OVER_BUDGET territory.

**QUOT: first Route-2 data this iter.** The iter-017 QUOT prover result will be the first real signal on whether Route-2 (ambient subquotient induction) delivers the elaboration-termination guarantee the mathlib-analogist predicted. A PARTIAL result that lands at least the `GradedModule.*` ambient-subquotient decls without heartbeat issues constitutes Route-2 entry criteria success; any isDefEq/whnf recurrence would require an immediate STUCK escalation and user consultation.

---

## Overall verdict

One route CHURNING (FBC), one CONVERGING (GF), one UNCLEAR (QUOT). FBC has been stuck at sorry-4 for three consecutive prover iters while helpers accumulate around the same dependent-position wall; the correct response is the abstract-variable-legs refactor already proposed by the planner — this must execute this iter and must not slip to another helper round. GF is making genuine progress (two COMPLETEs, helpers had payoff) and is one iter away from closing L5, but the OreLocalization diamond is at the ≥3-iter STUCK threshold: if this iter's GF prover does not resolve the instance alignment, GF flips to STUCK at iter-018. QUOT is a fresh restart on Route-2 with no verdict possible until prover data returns. Dispatch is clean and appropriately structured. The primary planning risk this iter is the FBC-CONTINGENT gate: the blueprint-writer prerequisite report must land before the FBC prover is dispatched; dispatching FBC without it will reproduce the same under-specified approach that drove the CHURNING verdict.
