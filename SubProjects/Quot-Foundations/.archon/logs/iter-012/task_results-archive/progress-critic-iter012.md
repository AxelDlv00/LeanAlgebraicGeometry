# Progress Critic Report

## Slug
iter012

## Iteration
012

## Routes audited

---

### Route: FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: ~5 (iter-008) → [no prover iter-009, iter-010] → 3 (iter-011). Net −2 over the K=4 window; strictly decreasing across prover iters.
- **Helper accumulation**: iter-008: route-swap rebuild (regroupEquiv on IsPushout.cancelBaseChange); the 3 mate sub-lemma targets from the prior prescription never existed as typed decls so nothing landed. iter-011: `base_change_mate_regroupEquiv` closed axiom-clean (genuine close); `base_change_mate_section_identity` formalized with RHS computable and LHS typed sorry (3-step decomposition). Helpers in 2 of 4 iters, but the iter-011 helper IS a genuine sorry-elimination (regroupEquiv closed; section_identity advanced from phantom to typed crux).
- **Prover dispatch pattern**: iter-008: 1 file; iter-009: 0 (blueprint-writer corrective); iter-010: 0 (DAG); iter-011: 1 file. No under-dispatch relative to what was ready; iter-009/iter-010 non-prover iters were each single-step correctives with clear re-engagement plans.
- **Recurring blockers**: "adjoint-mate unwinding is Mathlib-absent" — first appears as a named, typed crux in iter-011. "Blueprint sketch under-specified on the formalization path" — also first-named in iter-011. Neither has appeared across ≥3 prover iters; both are new-this-iter characterizations of the remaining crux, not long-running blockers.
- **Avoidance patterns**: none. iter-012 non-prover iter (effort-break section_identity into 3 sub-lemmas) is ONE non-prover iter following iter-011's prover dispatch. Not ≥2 consecutive non-prover; not avoidance.
- **Prover status pattern**: PARTIAL (iter-008) → [corrective] (iter-009, iter-010) → PARTIAL (iter-011). Only 2 PARTIAL statuses in 4-iter window. Does NOT trigger the ≥3 CHURNING rule.
- **Throughput**: SLIPPING — STRATEGY.md estimates 2–3 iters remaining entering the current FBC-A phase (~iter-008); 4 iters elapsed. Elapsed exceeds max of estimate range (4 > 3) but is under 2× (4 < 6). The route-swap corrective executed in iter-009 is a legitimate reset event; the post-swap approach has had 1 prover iter (iter-011) and produced a real closure (regroupEquiv) + a typed crux (section_identity). SLIPPING, not OVER_BUDGET on the post-swap clock.
- **Verdict**: **CONVERGING** — sorry count strictly decreased (5→3, −2) across the K window; regroupEquiv closed axiom-clean; section_identity advanced from phantom target to typed, 3-step-decomposed crux; no recurring blocker (≥3 iters); no avoidance pattern; iter-012 proposal ("finish what's started" via effort-break then prover) is correct.
- **Watch condition** (carry-forward from iter-011 critic): "adjoint-mate unwinding is Mathlib-absent" is now named. If the iter-013 prover cannot close `base_change_mate_section_identity` after the effort-break, this becomes a multi-iter recurring blocker and CHURNING fires with full force. The effort-break must produce `% LEAN SIGNATURE` blocks (the iter-007 lesson: prose-only stubs are insufficient).

---

### Route: GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 5 (iter-008) → [no prover iter-009, iter-010] → 5 (iter-011). Net: **unchanged** across K=4 window. The sorry count is flat at 5 across 2 prover iters (iter-008, iter-011).
- **Helper accumulation**:
  - iter-008: `gf_generic_rank_ses` and `gf_clear_one_denominator` closed axiom-clean (2 genuine closes); `gf_torsion_reindex` introduced with sorry (+1). Net sorry: 4→5. **Real mathematical payoff, not churn**, but the metric shows flat-then-rise.
  - iter-009: no prover (effort-breaker; blueprint-level decomposition of gf_torsion_reindex, no Lean declarations).
  - iter-010: no prover (DAG).
  - iter-011: `gf_torsion_annihilator`, `gf_nagata_monic_lastVar`, `mvPolynomial_quotient_finite_of_monic_lastVar` added (3 axiom-clean sub-lemmas, genuinely Mathlib-absent Nagata machinery transcribed); wired into `gf_torsion_reindex` body (typecheck); sorry count stays 5.
  - **Helpers added in iter-008 and iter-011 → 2 of 4 K-iter window.** ✓
- **Prover dispatch pattern**: iter-008 and iter-011: 1 file each prover iter. No under-dispatch.
- **Recurring blockers**: "localization-module transport plumbing / instance diamonds" — first named in iter-011. No prior iter used this phrase; not yet a recurring multi-iter blocker.
- **Avoidance patterns**: none by the strict criteria. iter-009/iter-010 non-prover iters follow a prover dispatch (iter-008); iter-012 prover dispatch follows iter-011.
- **Prover status pattern**: PARTIAL (iter-008) → [corrective] (iter-009, iter-010) → PARTIAL (iter-011). 2 PARTIAL statuses; below the ≥3 independent threshold.
- **Throughput**: SLIPPING — STRATEGY.md's current "2–3 iters left" estimate (revised post-iter-009) with elapsed ~2–3 iters puts us at the top of the range. If this is measured from the original phase entry (~iter-002), OVER_BUDGET; if from the revised estimate, SLIPPING.

**Raw rule assessment**: The CHURNING rule "helpers added in ≥2 of last K iters AND sorry count net unchanged or down by <1 per 2 iters AND no structural change in approach" fires verbatim:

1. Helpers added in iter-008 and iter-011 (2 of 4 iters). ✓
2. Sorry count net unchanged (5→5; 0 per 2 iters, which is <1 per 2 iters). ✓
3. No structural change in approach: the effort-break strategy was established in iter-009; iter-011 executed it. No new structural pivot since iter-009. ✓

All three sub-conditions are met.

**Mitigation assessment**: The sorry metric is structurally misleading here. In iter-008, 2 real axiom-clean closes happened (the metric hides them because gf_torsion_reindex's new sorry netted the count back to 5). In iter-011, the 3 Nagata sub-lemmas are genuine mathematical content (not orphaned helpers): they are proved axiom-clean, wired into gf_torsion_reindex's body (typechecking), and represent the full mathematical difficulty of the Nagata change-of-variables step. The remaining obligation at gf_torsion_reindex (line 949) is characterized as "localization-module-transport plumbing (~120–180 LOC), decomposed into 5 concrete steps with every Mathlib anchor scouted" — engineering assembly, not math obstruction.

Despite the mitigation, the rule fires. Not applying it when it fires verbatim is exactly the failure mode this subagent exists to prevent. The sorry count did not decrease across 2 prover iters; the helpers added do not qualify as a "structural change in approach" (they execute the iter-009 plan, not a new approach).

- **Verdict**: **CHURNING** — raw rule fires (helpers in 2 of 4 iters; sorry flat at 5; no new approach since iter-009 effort-break). The mitigation is real but the pattern is real.
- **Primary corrective**: **Dispatch prover immediately on `gf_torsion_reindex` assembly** with the 5-step recipe. The iter-012 plan already proposes exactly this. The CHURNING verdict validates the plan and makes it a hard obligation: no additional blueprint work, no additional sub-lemma staging — the assembly IS the next prover objective, and it must close. If gf_torsion_reindex's sorry is not eliminated in the iter-012 prover, the corrective escalates to "Mathlib analogy consult" on the localization-module transport (instance-diamond identification) before any further prover work.
- **Note for planner**: The CHURNING verdict does not contradict the iter-012 plan — it endorses it. The corrective that CHURNING calls for is exactly what iter-012 dispatches. Record the CHURNING verdict in plan.md and log that the prover dispatch is the CHURNING-corrective response; this frames iter-012's GF prover as a must-close, not a best-effort.

---

### Route: QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

- **Sorry trajectory**: 4 (iter-011, first prover iter) → [no prover proposed iter-012]. Only 1 prover data point; trajectory unassessable.
- **Helper accumulation**: iter-011: 5 axiom-clean defs (`annihilator`, `annihilator_ideal_le`, `schematicSupport`, `schematicSupportι`, `HasProperSupport`). The 4 skeleton sorries remain downstream-blocked on `isLocalizedModule_basicOpen`; the helpers advanced the definition layer without touching the proof layer.
- **Prover dispatch**: iter-011 was the first genuine prover dispatch on QUOT. iter-012 defers (writer for bridge sub-build).
- **Avoidance patterns**: none currently. iter-012 is ONE non-prover iter following iter-011's prover dispatch. Not ≥2 consecutive. However, note: iters 008, 009, 010 were all non-prover for QUOT before iter-011's dispatch — this was a prior 3-iter consecutive zero-dispatch window that the iter-011 critic ruled acceptable given blocking-dependency resolution. The prior pattern cannot recur: iter-013 must dispatch a prover on QUOT or the ≥3 consecutive zero-dispatch CHURNING rule fires again.
- **Throughput**: ON_SCHEDULE — STRATEGY.md estimate 4–7 iters remaining; 1 prover iter elapsed.
- **Verdict**: **UNCLEAR** — single prover data point; fresh route in proof terms (iter-011 was genuinely the first proof work beyond scaffolding). The `isLocalizedModule_basicOpen` bridge is a genuine Mathlib infra gap (confirmed by grep: `IsLocalizedModule` in `AlgebraicGeometry/` appears only in `Spec`/`StructureSheaf`/`Tilde`, not generalized). iter-012 writer round (bridge sub-build decomposition) is the correct blocking-dependency resolution.
- **Must-watch for iter-013**: if iter-013 proposes a third consecutive non-prover iter for QUOT, the ≥3 consecutive zero-dispatch CHURNING rule will fire. The iter-013 plan must either dispatch a prover on QUOT or explicitly document why the bridge sub-build is still incomplete and what one-more-iter justification exists.

---

### Route: GrassmannianCells — `AlgebraicJacobian/Picard/GrassmannianCells.lean`

- **Sorry trajectory**: 0 (iter-011, +16 decls, GREEN, 0 sorries). Prior iters: 0 committed edits (iter-008, iter-009 — STUCK, 2 zero-output dispatches). Corrective (effort-break + blueprint expansion) applied in iter-011 cycle; produced full transition chain.
- **Helper accumulation**: iter-011: 16 new decls all axiom-clean (`universalMatrix`, `minorDet`, `universalMinor`, `isUnit_det_universalMinor`, `universalMinorInv`, `universalMinorInv_mul_cancel`, `imageMatrix`, `transitionPreMap`, `isUnit_transitionPreMap_minorDet`, `transitionMap`, `transitionMap_self`, + 3 matrix helpers + 2 small lemmas). Zero sorries; not churn.
- **Prover status pattern**: INCOMPLETE (iter-008) → INCOMPLETE (iter-009) → [effort-break corrective: iter-011] → DONE (iter-011). The STUCK was decisively resolved.
- **Recurring blockers**: none post-corrective. The prior "zero-output anomaly" blocker is resolved.
- **iter-012 plan**: writer pins `lem:gr_cocycle` signature → PROVER on `cocycleCondition` conditional on fast-path gate. Prover report explicitly flags: "cocycleCondition has no `% LEAN SIGNATURE` in the blueprint — a writer must pin it first." The conditional dispatch is correct discipline; the writer must produce a `% LEAN SIGNATURE` block before the prover is sent in.
- **Throughput**: ESTIMATE_FREE for the QUOT-repr GR-cells sub-route (many iters left per STRATEGY).
- **Verdict**: **CONVERGING** — STUCK was resolved in iter-011; 0 sorries; full transition chain closed axiom-clean; cocycleCondition is the correct next frontier with a concrete writer-first gate. Route is healthy.
- **Dispatch note**: The conditional gate ("if scoped re-review clears") is appropriate given the zero-LEAN-SIGNATURE state of `lem:gr_cocycle`. If the writer does not produce a `% LEAN SIGNATURE` block this iter, the prover dispatch must be deferred — not dispatched on an ambiguous target (the iter-007 lesson: prose-only stubs produce zero prover output).

---

## PROGRESS.md dispatch sanity

- **File count**: 2 prover lanes (FlatteningStratification.lean, GrassmannianCells.lean conditional) + 2 writer-only routes (FlatBaseChange.lean, QuotScheme.lean). Prover count: 2 (or 1 if cocycleCondition gate does not clear). Cap: 10.
- **Ready but not dispatched**: FBC has 3 open sorries but the adjoint-mate crux (section_identity LHS) requires effort-break into 3 sub-lemmas before a prover can be sent in — not prover-ready without the effort-break. QUOT has 4 open sorries all downstream-blocked on `isLocalizedModule_basicOpen` bridge — not prover-ready without the bridge sub-build. Both deferrals have concrete blocking reasons and active corrective work.
- **Over the cap**: no.
- **Under-dispatch finding**: no — FBC and QUOT are correctly gated; dispatching their provers without prerequisite structure would repeat the iter-007 prose-stub failure. The 2 prover lanes are the correct assignment given what is actually ready.
- **Iter-over-iter trend**: [iter-011: 3 prover lanes] → [iter-012: 2 lanes]. Slight contraction due to FBC shifting to writer; not a bloat-without-progress pattern.
- **Dispatch-sanity question from directive**: "Is deferring FBC and QUOT to writer rounds the right call, or is there ready prover work I am missing?"

  **Answer: Yes, deferring FBC and QUOT is correct.** Three tests:
  1. FBC: `base_change_mate_section_identity` has a typed sorry with a "3-step decomposition" that the iter-011 prover explicitly identified but did not sub-lemma-ize. A prover sent in now would face the same LHS adjoint-mate wall. The effort-break is the prescribed corrective; one non-prover iter for this is the standard pattern (same as GF iter-009).
  2. QUOT: The 4 skeleton sorries are stubs blocked on `isLocalizedModule_basicOpen`. Without the bridge, a prover has nothing to attempt. Dispatching a prover on blocked stubs is wasted capacity.
  3. No other ready work identified: no additional files exist with complete blueprint chapters and open sorries not already in scope.

- **Verdict**: OK — file count 2–3 within cap 10, no ready files left undispatched, FBC and QUOT correctly deferred.

---

## Must-fix-this-iter

- **Route GF: CHURNING** — primary corrective: dispatch prover immediately on `gf_torsion_reindex` assembly with the 5-step recipe. The iter-012 plan already does this; the CHURNING verdict makes it a hard obligation, not a best-effort dispatch. If the prover cannot close the assembly sorry (line 949) in iter-012, escalate in iter-013: primary corrective shifts to Mathlib analogy consult on the localization-module transport (instance-diamond identification). No additional blueprint-level sub-lemma building is appropriate after this point; the math is done and only the engineering assembly remains.

---

## Informational

- **FBC throughput: SLIPPING** — 4 iters elapsed in the current FBC-A phase vs. a 2–3 iter estimate. The route-swap in iter-009 is a partial reset; the post-swap approach has 1 prover iter of data (iter-011) with a real closure (regroupEquiv) and a typed crux (section_identity). Watch condition: if iter-013 does not close section_identity after the effort-break, throughput becomes OVER_BUDGET and the "adjoint-mate Mathlib-absent" blocker becomes a recurring phrase — escalate to CHURNING immediately.

- **GF sorry metric continues to mislead** — the sorry count (flat at 5 across 2 prover iters) hides 2 genuine axiom-clean closes in iter-008 and 3 genuine axiom-clean proves in iter-011. The residual is well-characterized engineering assembly, not math obstruction. CHURNING is the correct structural label for the trajectory; the corrective (direct prover on assembly) is already in the plan and is the right call.

- **QUOT ≥3 consecutive zero-dispatch watch** — iters 008/009/010 were already a zero-dispatch window for QUOT, which the iter-011 critic ruled acceptable. That tolerance is spent. If iter-013 also has no prover on QUOT, the ≥3 consecutive zero-dispatch CHURNING rule fires for the second time on this route. The planner must commit to a QUOT prover lane in iter-013 regardless of bridge sub-build status (find the furthest-available bridge sub-lemma and dispatch on it rather than deferring the entire route again).

- **GrassmannianCells conditional dispatch is correct** — if the writer cannot pin `% LEAN SIGNATURE` for `cocycleCondition` this iter, the prover must be deferred rather than sent in on an ambiguous target. Two consecutive zero-output dispatches drove the prior STUCK; the remedy is signatures before provers, not provers before signatures.

---

## Overall verdict

Two of four routes are healthy: FBC is CONVERGING (sorry decreased 5→3, regroupEquiv closed, section_identity crux typed and scoped for effort-break); GrassmannianCells is CONVERGING (prior STUCK resolved, 16 decls 0 sorries, cocycleCondition correctly gated on a signature-first write). One route (GF) is CHURNING by the raw rule — helpers in 2 of 4 iters, sorry flat at 5, no structural approach change since the iter-009 effort-break — with the corrective (dispatch prover on gf_torsion_reindex assembly) **already present in the iter-012 plan**. The CHURNING verdict makes this prover lane a must-close, not a best-effort. One route (QUOT) is UNCLEAR with a 1-data-point prover history and a correct blocking-dependency corrective underway. Dispatch is sound: the 2 prover lanes are the correct scope given what is actually ready; FBC and QUOT are correctly gated on writer-phase prerequisites. The planner's deferral decisions for FBC and QUOT are validated by the dispatch-sanity check. No avoidance patterns detected; no under-dispatch finding; no cap violation. The must-fix is singular: GF's CHURNING corrective (already dispatched in iter-012 plan) must produce a closed gf_torsion_reindex sorry this iter — if it does not, iter-013 escalation to Mathlib-analogy consult is mandatory.
