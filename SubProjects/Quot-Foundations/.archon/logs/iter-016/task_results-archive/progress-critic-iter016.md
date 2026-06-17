# Progress Critic Report

## Slug
iter016

## Iteration
016

## Routes audited

### Route: FBC — AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **Sorry trajectory**: 5 → 5 → 4 → 4 across iter-012 to iter-015 (iter-013 no-prover; prover-iter sub-window: 5 → 4 → 4)
- **Helper accumulation**: helpers added only in iter-012 (+3 seams + inner_value); iter-014 and iter-015 both added zero. No helper churn post-decomposition.
- **Prover dispatch pattern**: 1 file per prover iter (012, 014, 015). No multi-file opportunity was missed because FBC is a single-file route.
- **Recurring blockers**: none across ≥3 iters. The iter-015 "conjugate-calculus coherence gap at Seam 2" is a first-appearance blocker, not recurrent.
- **Avoidance patterns**: none. iter-013 was an intentional DAG-only iter (project-wide); iter-014 closed Seam 1 (COMPLETE).
- **Prover status pattern**: PARTIAL (012), COMPLETE (014), PARTIAL (015) — seam-by-seam progress; the COMPLETE represents a real structural advance.
- **Throughput**: SLIPPING → borderline OVER_BUDGET. STRATEGY.md states 1–2 iters; elapsed = 4 calendar iters (3 prover iters). Elapsed calendar iters = 2× the upper estimate of 2. The route has not yet closed; at minimum one more iter is needed (Seam 2 + Seam 3).
- **Verdict**: CONVERGING

**Rationale.** The CONVERGING rule requires strictly decreasing sorry count in the K-iter window. Technically the count is 5, 5, 4, 4 — flat at the endpoints. However: (a) no CHURNING rule fires (helpers only in 1 of 4 iters, sorry IS net-down by 1, structural changes were made); (b) no STUCK rule fires (sorry not unchanged; no INCOMPLETE statuses; no ≥3-iter recurring blocker); (c) the flat segment 014→015 is a single-iter scaffolding phase preceding Seam 2 closure — not stall. The route is advancing. The verdict stands CONVERGING with the caveat below.

**Throughput caveat** (informational, but note for STRATEGY.md). Estimate was 1–2 iters; 4 calendar iters elapsed (3 prover). The estimate needs upward revision: Seam 2 + Seam 3 together are unlikely to close in one iter given that Seam 1 alone needed a full prover iter after a scaffolding iter. Realistic remainder: 1–3 more prover iters. If Seam 2 and Seam 3 do not both close in iter-016, update STRATEGY.md rather than counting the estimate as still in-range.

**Proposed iter-016 action read.** Blueprint expansion for Seam 2/3 + re-review + "prove Seam 2 → Seam 3 in one prover pass" is the right corrective type but optimistic in scope. Seam 3 closing cascades to section_identity/generator_trace/cancelBaseChange, which would drop the count to ~1 or 0 — that would be the phase-closure event. If the prover stalls at Seam 2 alone, that is still progress; the planner should not treat Seam 3 slippage as a failure signal requiring a new pivot.

---

### Route: GF — AlgebraicJacobian/Picard/FlatteningStratification.lean

- **Sorry trajectory**: ~5 (iter-012) → 5 (iter-013, no-prover) → 4 (iter-014) → 5 (iter-015). Net: approximately flat or -1 → +1; the iter-015 increase is a decomposition artifact (new stub `free_localizationAway_of_away_tower` introduced with 1 open sorry, which is itself the next closure target).
- **Helper accumulation**: helpers added in iter-012 (reindex helpers) and iter-015 (+1 helper stub) — 2 of 4 iters. But: iter-014's 5 helpers paid off (COMPLETE on gf_torsion_reindex), and iter-015's single helper is the direct closure target for iter-016, not a dead-end accumulation.
- **Prover dispatch pattern**: 1 file per prover iter (012, 014, 015). Single-file route.
- **Recurring blockers**: the iter-015 OreLocalization instance-diamond is a first-appearance blocker. Prior iters had distinct blockers (reindex hard-finiteness in 012, factoring approach in 014). No ≥3-iter recurrence.
- **Avoidance patterns**: none. iter-013 was project-wide DAG-only.
- **Prover status pattern**: PARTIAL (012), COMPLETE (014), PARTIAL (015) — same shape as FBC. A real COMPLETE in iter-014.
- **Throughput**: SLIPPING. STRATEGY.md states 1–3 iters; elapsed = 4 calendar iters (3 prover iters). Upper estimate (3 prover iters) is exactly met, but the route is not closed — L5 + L4 + assembly remain. On calendar iters (4 vs upper estimate 3), clearly SLIPPING.
- **Verdict**: CONVERGING

**Rationale.** The sorry count rising from 4 to 5 in iter-015 is the key signal to assess. It is a deliberate decomposition: a new stub helper was introduced as the abstraction vehicle for the IH application blocked by an OreLocalization diamond. This is a structural approach change, not churn — the iter-015 helper (`free_localizationAway_of_away_tower`) is explicitly the iter-016 closure target with no further decomposition planned. The CHURNING rule requires "no structural change in approach"; two structural changes occurred (iter-014 factoring breakthrough, iter-015 abstract-T descent helper). The STUCK rule requires sorry unchanged across K iters — it went from ~5 to 4 to 5 (net -1 at best, never truly unchanged). CONVERGING is the correct call.

**Throughput caveat** (informational). The proposed iter-016 action for GF is very ambitious: close `free_localizationAway_of_away_tower` + splice L5 + close L4 (`gf_noether_clear_denominators`) + assembly (`genericFlatnessAlgebraic`) — effectively the entire remainder of GF-alg in one prover pass. Given that closing gf_torsion_reindex alone required 5 helpers and one dedicated iter, this scope is likely to partially stall. The planner should pre-define an acceptable partial outcome (e.g., close `free_localizationAway_of_away_tower` + L5 splice alone = success) to avoid misreading a correct partial advance as failure. The STRATEGY.md estimate should be updated: with L5 splice + L4 + assembly still open, the realistic remainder is 1–3 more prover iters, not 0–1.

---

### Route: QUOT — AlgebraicJacobian/Picard/QuotScheme.lean

- **Sorry trajectory**: 4 → 4 → 4 → 4 across all 4 iters in the window. The headline graded-API stubs (the 4 remaining sorries) have been unchanged for the entire K=4 iter window. Note: iter-012 COMPLETE was on a *different* sorry set (power-series engine), not the graded-API stubs — the 4 stubs have been at exactly 4 from the start of the window.
- **Helper accumulation**: iter-012 (+8 power-series-engine decls — different sorry set, COMPLETE), iter-015 (+3 axiom-clean decls G1a, G1b, D5). 2 of 4 iters added helpers. The 3 iter-015 additions are new axiom-clean proofs, not sorry-bearing stubs — so they don't inflate the count. But they also did not close any of the 4 headline stubs. Sorry count for the graded-API stubs: 4 → 4 after adding G1a/G1b/D5.
- **Prover dispatch pattern**: iter-012 (COMPLETE, different lane), iter-013 (no prover), iter-014 (no prover — setup/blueprint only), iter-015 (PARTIAL, headline stubs untouched). Graded-API lane specifically: 1 prover iter (015), immediately blocked. iter-016 proposed as another no-prover iter (analogy consult + pivot). The graded-API phase will have had only 1 prover iter (015) by the end of iter-016.
- **Recurring blockers**: the G2-G4 isDefEq/whnf runaway appeared in iter-015 (first and only appearance so far — NOT yet ≥3 iters). However, the non-termination at 2M heartbeats is a qualitatively different class of blocker: it is not a proof gap that more work can close, it is a kernel-level elaboration failure that requires restructuring the definitions.
- **Avoidance patterns**: iter-013 and iter-014 were both no-prover for QUOT (2 consecutive no-prover iters, not ≥3). However: iter-014 was explicitly "setup/blueprint only" — the graded-API work was not yet decomposed enough to dispatch. This is borderline. The key signal is that the graded-API sorry count of 4 is completely static across 4 iters, with only 1 real prover attempt (iter-015), which immediately hit a hard wall.
- **Prover status pattern**: COMPLETE (012, different lane), (no-prover), (no-prover), PARTIAL (015, headline stubs untouched).
- **Throughput**: ON_SCHEDULE (SNAP-S2 graded-API phase entered iter-015, estimate 2–4 iters; elapsed 1 iter). — but see structural note below.
- **Verdict**: CHURNING

**Rationale.** The CHURNING rule fires on the "helpers added in ≥2 of last K iters AND sorry count net unchanged" criterion: iter-012 (+8 decls) and iter-015 (+3 decls) both added helpers while the 4 graded-API headline stubs remained at exactly 4. The iter-012 helpers closed a *different* sorry (power-series, not the graded-API stubs), so they do not count as sorry-elimination for the stubs. Over the graded-API sub-window, sorry count is 4 → 4 → 4 with helpers added and then a hard wall encountered. More critically, the G2-G4 isDefEq non-termination at 2M heartbeats is not a missing-lemma blocker — it is a definitional structure blocker requiring route-level restructuring. Sending a second prover at the same definition structure would reproduce the same non-termination.

- **Primary corrective**: **Structural refactor** (route pivot to ambient-M / Hilbert-function-level architecture). The G2-G4 quotient/subtype `GradedDecomposition` path is a confirmed dead end at the kernel level. The mathlib-analogist consult (running this iter) + pivot to ambient-M restatement + blueprint surgery is the exactly correct response. This is the right corrective; the planner's proposed action already implements it.

- **Secondary corrective** (advisory): Before the iter-017 prover dispatch on the restated form, confirm that the analogist's verdict rules out all ambient-M/Hilbert-function isDefEq traps — the memory entry `graded-quotient-module-isdefeq-pathology.md` records that `IsInternal/map_iSup over ↥p or M⧸p` loops the elaborator; the new restatement must avoid all quotient-type graded decompositions, not just the specific G2-G4 form that blocked. The prover directive for iter-017 should include an explicit prohibition on building `GradedDecomposition` or `DirectSum.Decomposition` instances on quotient types without a prior elaboration-termination check.

**Proposed iter-016 action read.** Correct. The mathlib-analogist consult + strategy pivot + blueprint surgery without a prover dispatch is the appropriate response to a kernel-level non-termination wall. Deferring the prover to iter-017 is not avoidance — it is the prerequisite sequencing. The risk is that if the analogist verdict is inconclusive or if blueprint surgery is incomplete, iter-017 will hit a second wall; the planner should define concrete entry criteria for the iter-017 prover (i.e., the analogist report must name at least one concrete ambient-M formulation that is elaboration-terminating before the prover is dispatched).

---

## PROGRESS.md dispatch sanity

- **File count**: 2 prover files (FBC + GF); QUOT gets structural action only (0 prover files dispatched).
- **Cap**: default 10.
- **Over the cap**: no.
- **Under-dispatch finding**: no. QUOT's prover is deliberately withheld pending the analogy consult and pivot — this is the correct sequencing given a confirmed kernel-level blocker, not avoidance throttling.
- **Iter-over-iter trend**: 1 → 1 → 1 → 2 (effective prover files); holding steady, not under-loading against ready files.
- **Verdict**: OK — 2 prover files + 1 structural action within cap; QUOT deferral is justified by the isDefEq blocker; no ready-but-skipped lanes identified.

---

## Must-fix-this-iter

- **Route QUOT: CHURNING** — primary corrective: structural refactor (route pivot to ambient-M / Hilbert-function-level restatement). Why: G2-G4 isDefEq non-termination at 2M heartbeats is a kernel-level dead end, not a proof gap; the same definition structure will reproduce the same non-termination in any subsequent prover dispatch. The proposed iter-016 analogy-consult + pivot IS the correct action; this entry is a must-fix confirmation that the planner cannot silently skip the pivot and dispatch again on the blocked form.

- **Route FBC: SLIPPING (borderline OVER_BUDGET)** — STRATEGY.md estimates 1–2 iters; 4 calendar iters have elapsed, 3 prover iters. Update the `Iters left` estimate in STRATEGY.md this iter regardless of iter-016 prover outcome. If both Seam 2 and Seam 3 close in iter-016, the route closes and no revision is needed; otherwise, record the revised estimate (likely 1–2 more prover iters) before the estimate becomes misleading to downstream planning.

---

## Informational

**GF ambitious scope.** The proposed iter-016 GF action chains 4 sequential milestones (close `free_localizationAway_of_away_tower` + L5 splice + L4 + `genericFlatnessAlgebraic` assembly) in a single prover pass. Given prior pacing (gf_torsion_reindex alone needed 5 helpers + one dedicated iter), the planner should define a success threshold before dispatching: closing `free_localizationAway_of_away_tower` plus wiring L5 steps 3–4 constitutes progress even if L4/assembly slip to iter-017. Without a pre-declared partial-success bar, the review agent may misread a correct partial advance as INCOMPLETE.

**FBC Seam 2/3 ambition.** Proposing to prove both Seam 2 and Seam 3 in one iter is reasonable if the recipe (`conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv` + Seam 1) is as mechanically repeatable as the blueprint-writer's Seam 2 expansion suggests. If the recipe executes cleanly, closing both seams in one iter is plausible. If Seam 2 alone closes, the sorry count drops from 4 to ~2–3 (section_identity/generator_trace/cancelBaseChange remain gated on Seam 3). Either partial or full outcome should be treated as progress; the plan should not escalate if only Seam 2 closes.

**QUOT throughput.** The SNAP-S2 phase is ON_SCHEDULE (1 iter elapsed vs 2–4 estimate), but this is misleading: the phase spent 2 of its 4 window-iters as no-prover (013, 014), and the 1 real prover iter (015) hit an immediate hard wall. The throughput clock is ticking but no progress on the stubs has been made. After the iter-016 pivot, the "iters left" clock for SNAP-S2 should reset against the restated architecture, not continue against the original estimate.

---

## Overall verdict

Two routes (FBC, GF) are CONVERGING: both have made genuine structural progress (Seam 1 closed, gf_torsion_reindex closed), no helper churn, no recurring blockers — the proposed prover dispatches for iter-016 are appropriate. One route (QUOT) is CHURNING: the 4 headline graded-API stubs have been static for the entire 4-iter window, the G2-G4 isDefEq non-termination is a kernel-level blocker that cannot be probed away, and the correct response (analogy consult + route pivot) is already the proposed action. The planner must execute the QUOT pivot this iter and define concrete elaboration-termination entry criteria before the iter-017 prover dispatch. FBC also needs a STRATEGY.md estimate revision regardless of iter-016 outcome (4 calendar iters elapsed against a 1–2 iter estimate). Dispatch is clean (2 prover files, 1 structural action, QUOT deferral justified); no over-cap or under-dispatch finding.
