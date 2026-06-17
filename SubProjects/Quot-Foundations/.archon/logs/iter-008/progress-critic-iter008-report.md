# Progress Critic Report

## Slug
iter008

## Iteration
008

## Routes audited

### Route: FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 4 → 4 → 4 → 4 across iters 004–007. Prover ran in iters 004 and 006 only; iter-005 was dag-only; iter-007 was plan-phase corrective (blueprint expansion). Net unchanged across all four iters, but the last prover-eligible iters confirm no decrease.
- **Helper accumulation**: Iter-004: ~5 new declarations (prover). Iter-005: 0 (dag-only). Iter-006: 0 net prover declarations (RegroupHelper.lean module split was a plan-phase refactor). Iter-007: 0 prover declarations; blueprint writers added 3 blueprint-only sub-lemma stubs (`base_change_mate_unit_value`, `…_fstar_reindex`, `…_gstar_transpose`). Total prover-side: ~5 declarations across 2 prover iters, 0 sorry-eliminations.
- **Prover dispatch pattern**: 1 prover file (iter-004); 0 (iter-005 dag-only); 1 (iter-006); 0 (iter-007 corrective). Two prover iters in K=4 window.
- **Recurring blockers**: "map_smul' opaque-instance wall" appeared in iters 004 and 006 (2 prover iters). Does not independently meet the ≥3-iter STUCK threshold. Root cause (unsound proof prescription + different tensor carrier types) was addressed by the iter-007 blueprint rewrite; the barrier was not ignored.
- **Avoidance patterns**: None. Iter-007 was a prescribed corrective (blueprint expansion + proof prescription rewrite + 3 sub-lemma decomposition). Blueprint-reviewer confirmed HARD GATE PASS. The prior iter-007 progress-critic mandated "iter-008 must dispatch FBC-A and GF-alg provers immediately — a third consecutive plan-phase-only iter on these routes would cross into the avoidance-pattern clause." Dispatching now is the mandatory response.
- **Prover status pattern**: PARTIAL (004), [dag-only] (005), PARTIAL (006), [corrective-deferred] (007). 2 PARTIAL statuses in K=4 window — does NOT independently meet the CHURNING threshold of ≥3.
- **Throughput**: OVER_BUDGET. STRATEGY.md estimates 3–4 iters left; phase entered ~iter-002; ~6 iters elapsed. Flagged in iter-007 report with mandated estimate revision. Estimate revision to "2–4 iters post-decomposition" was recommended then and should already be in STRATEGY.md.
- **Verdict**: UNCLEAR — The prior CHURNING corrective was fully executed: blueprint prescription rewritten (iter-006 unsound "one-liner" replaced by TensorProduct.ext route-a + eT bridge), generator_trace_eq decomposed into 3 typed sub-lemmas, blueprint-reviewer HARD GATE PASS earned. The K=4 window does not independently trigger CHURNING (PARTIAL ×2 not ×3; helpers in 1 of 4 iters not 2+). Iter-008 is the first prover attempt on the new sub-lemma targets, which did not exist in any prior prover round. Convergence cannot yet be assessed on targets that have never been dispatched.

  **Escalation tripwire**: If the iter-008 prover fails to close ANY of the three new sub-lemmas (`base_change_mate_unit_value`, `…_fstar_reindex`, `…_gstar_transpose`), FBC-A must escalate to CHURNING in iter-009. The "route-a" (TensorProduct.ext at full carrier) prescription could still encounter instance-opaqueness; the blueprint-writer has pre-specified fallback route-b (standalone ModuleCat base-change iso exposing transparent R'-action). If route-a fails, the plan agent must dispatch the blueprint-writer to implement route-b before the next prover round — not dispatch the prover again on the same route-a prescription.

---

### Route: GF-alg — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 4 → 4 → 4 → 4 across iters 004–007. Prover ran in iters 004 and 006 only. Net unchanged across K=4 window. Last sorry-elimination was iter-004 (L3 chain, 4 axiom-clean lemmas).
- **Helper accumulation**: Iter-004: 4 declarations (L3a/b/c + assembly, all axiom-clean). Iter-005: 0. Iter-006: 0 net (L5 strong-induction restructure was a proof-body rewrite, not a new declaration). Iter-007: 0 prover declarations; blueprint writers added 3 sub-lemma stubs (`gf_clear_one_denominator`, `gf_generic_rank_ses`, `gf_torsion_reindex`) + L4/L5 assembly rewrites.
- **Prover dispatch pattern**: 1 prover file (iter-004); 0 (iter-005 dag-only); 1 (iter-006); 0 (iter-007 corrective). Two prover iters in K=4 window.
- **Recurring blockers**: "generic-rank SES dévissage Mathlib-absent" appeared in prover iters 003, 004, 006 — 3 prover iters. This technically meets the STUCK threshold ("recurring blocker phrase across ≥3 iters"). However, the iter-007 corrective directly addressed the root cause identified by the mathlib-analogist: the blocker was not merely "Mathlib-absent" in the abstract but arose from (a) seeking the wrong API (generic rank should use `Module.finrank (FractionRing P_d) (LocalizedModule (nonZeroDivisors P_d) N)`) and (b) an induction that failed to generalize the base domain A. Both root causes are now fixed in the blueprint, verified by the mathlib-analogist, and confirmed by the blueprint-reviewer. Applying the pre-corrective STUCK classification to the post-corrective state would be mechanically accurate but substantively incorrect — the corrective was designed precisely to break this blocker.
- **Avoidance patterns**: None. Iter-007 corrective mirrors FBC-A exactly: first failed prover round reveals root cause; corrective dispatched; gate pass earned; prover dispatched next iter.
- **Prover status pattern**: PARTIAL (004), [dag-only] (005), PARTIAL (006), [corrective-deferred] (007). 2 PARTIAL in K=4 window.
- **Throughput**: OVER_BUDGET. Strategy estimates 3–4 iters left; phase entered ~iter-002/003; ~6 iters elapsed. SLIPPING boundary in iter-007 report; now firmly OVER_BUDGET. The blueprint expansion was necessary before prover work, so elapsed ≠ wasted (structural progress was made); the estimate must nonetheless be revised.
- **Verdict**: UNCLEAR — The CHURNING/near-STUCK corrective was fully executed: L5 decomposed into `gf_generic_rank_ses` + `gf_torsion_reindex` + thin assembly, L4 into `gf_clear_one_denominator` + Finset-fold + AlgHom assembly; mathlib-analogist verified the generic-rank API and confirmed the base-domain-generalization fix; blueprint-reviewer HARD GATE PASS. K=4 window does not independently trigger CHURNING (PARTIAL ×2 not ×3). The recurring blocker met the STUCK threshold, but the iter-007 corrective was specifically targeted at its root causes and was confirmed sound. Iter-008 is the first prover attempt on the decomposed structure.

  **Escalation tripwire (hard)**: If iter-008 closes ZERO sorries among `gf_clear_one_denominator`, `gf_generic_rank_ses`, `gf_torsion_reindex`, GF-alg MUST be classified STUCK in iter-009 — the recurring blocker threshold was already met in the prior window, the corrective has been deployed, and a zero-close iter post-corrective would exhaust the mitigating signal. No further blueprint rounds on GF-alg would be appropriate without user escalation if iter-008 also produces 0 closures.

---

### Route: GrassmannianCells — `AlgebraicJacobian/Picard/GrassmannianCells.lean`

- **Sorry trajectory**: 1 → 0 (iter-007 closed the `affineChart` real sorry, axiom-clean). Current grep confirms no remaining production sorries (1 stale docstring mention, not a proof obligation). Only 1 iter of signal.
- **Helper accumulation**: Iter-007: 0 new helper declarations — filled an existing stub cleanly with no churn.
- **Recurring blockers**: None.
- **Prover status pattern**: COMPLETE for the dispatched target (iter-007).
- **Throughput**: ESTIMATE_FREE for sub-route trajectory (1 iter of data); overall QUOT-defs estimate 4–7 iters left, entered iter-007.
- **Verdict**: UNCLEAR — single iter of data, insufficient for trajectory assessment. Prior iter was clean (0 churn, axiom-clean closure). New target (`def:gr_transition`, `lem:gr_cocycle`) is blueprint-complete per blueprint-reviewer with Nitsure §1 source quotes. Pattern is healthy; watch for instance-synthesis issues on the gluing infrastructure (not yet attempted).

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (FlatBaseChange.lean, FlatteningStratification.lean, GrassmannianCells.lean); cap: 10
- **Ready but not dispatched**: QuotScheme.lean — but a blueprint-writer round (adding engine-lemma block + decomposing QCoh-bridge sub-build) is actively running this iter. This is the first iter of deferral for QUOT-A (iter-007 was its first real dispatch; iter-008 is a prescribed blueprint round paralleling the FBC-A/GF-alg iter-007 pattern). One iter of deferral with an active corrective is not an under-dispatch finding.
- **Over the cap**: no
- **Under-dispatch finding**: no — QUOT-A is gated on blueprint work (exactly as FBC-A and GF-alg were gated in iter-007, which the prior critic deemed correct dispatch). The iter-007 dispatch that opened QUOT-A revealed 2 genuine Mathlib infra gaps (QCoh→IsLocalizedModule bridge; absent monoidal structure on SheafOfModules); a blueprint-writer round before the next prover dispatch is the correct response, not under-dispatch.
- **Iter-over-iter trend**: 2 files (iter-007) → 3 files (iter-008). Expanding, not shrinking.
- **Specific dispatch-sanity question from directive**: "Is deferring QUOT-A + dispatching the two previously-CHURNING routes (FBC/GF) the iter after their decomposition look like avoidance or churn-continuation?"

  **Answer: No. This is an honest dispatch.** Three tests:

  1. **Disguised-repeat test**: The FBC-A targets (`base_change_mate_unit_value`, `…_fstar_reindex`, `…_gstar_transpose`) did not exist in any prior prover round. Every prior FBC-A prover round worked on the monolithic sorry stub in `base_change_mate_regroupEquiv` and the unsound one-liner prescription. The new targets are structurally different. GF-alg similarly dispatches 3 new sub-lemma targets plus a restructured L5 induction (base-domain generalization) — structurally different from the iter-006 dispatch which worked on the existing proof bodies. This is not a repeat.

  2. **Mandate test**: The iter-007 progress-critic explicitly stated: "If iter-007's blueprint writers deliver correctly-typed sub-lemma stubs, iter-008 must dispatch FBC-A and GF-alg provers immediately — a third consecutive plan-phase-only iter on these routes would cross into the avoidance-pattern clause regardless of QUOT-defs progress." The blueprint writers delivered. Dispatching now is the mandatory response, not an avoidance. Failing to dispatch would itself be CHURNING by avoidance.

  3. **QUOT-A deferral test**: QUOT-A's blueprint-writer deferral mirrors the FBC-A/GF-alg iter-007 deferral pattern precisely — iter N reveals Mathlib infra gaps, iter N+1 dispatches blueprint-writer, iter N+2 dispatches prover. This is the correct three-iter pattern. One iter of deferral with an active corrective is not an avoidance pattern. An avoidance pattern would require ≥2 consecutive iters of deferral without a re-engagement plan.

- **Verdict**: OK — file count 3 within cap 10, QUOT-A correctly deferred (blueprint-writer active, first deferral, re-engagement plan explicit), no under-dispatch.

---

## Must-fix-this-iter

No CHURNING or STUCK verdicts this iter. No OVER_CAP or UNDER_DISPATCH dispatch findings.

**Throughput advisory (informational but time-sensitive):**
- FBC-A: OVER_BUDGET. Strategy must reflect revised estimate ("2–4 iters post-decomposition") if not already updated.
- GF-alg: OVER_BUDGET. Estimate revision similarly needed.

**Escalation tripwires (not must-fix this iter, but must-fix NEXT iter if triggered):**
- FBC-A: If iter-008 closes 0 of the 3 new sub-lemmas, escalate to CHURNING in iter-009. Primary corrective: blueprint-writer for route-b (standalone ModuleCat base-change iso with transparent R'-action); do NOT redispatch prover on route-a prescription.
- GF-alg: If iter-008 closes 0 of `gf_clear_one_denominator`, `gf_generic_rank_ses`, `gf_torsion_reindex`, escalate to STUCK in iter-009. The recurring blocker threshold was already met; a second post-corrective zero-close iter exhausts the available mitigating signals. Primary corrective: user escalation (Mathlib infra build if API truly absent; or route pivot to an existence-sorry bypass).

---

## Informational

### FBC-A: Blueprint-reviewer orphan-leaf advisory

`lem:base_change_mate_fstar_reindex` and `lem:base_change_mate_gstar_transpose` have 0 reverse-dependencies in the DAG (they appear only in the PROOF `\uses{}` of `lem:base_change_mate_generator_trace_eq`, not the STATEMENT `\uses{}`). The blueprint-reviewer flagged this as advisory (non-blocking for prover dispatch). The plan agent should fix the STATEMENT `\uses{}` of `lem:base_change_mate_generator_trace_eq` to include all three sub-lemmas so the DAG correctly reflects the dependency chain.

### QUOT-A: Expected pattern, no concern

QUOT-A's one-iter deferral is structurally identical to what FBC-A and GF-alg underwent in iter-007. The iter-007 progress-critic endorsed that pattern ("the QUOT lanes fill otherwise-idle prover capacity on blueprint-ready, independently-gated work"). Applying the same reasoning symmetrically, QUOT-A's iter-008 blueprint round is correct. Watch for avoidance if QUOT-A is deferred again in iter-009 without a re-engagement plan.

### GF-alg: STUCK boundary is now a hard constraint

The recurring SES blocker met the STUCK threshold in the K=4 window for iters 003–006. The iter-007 corrective is the sole mitigating signal keeping it at UNCLEAR rather than STUCK in this assessment. That mitigating signal has a one-iter lifespan: if iter-008 produces no closure on the new sub-lemma targets, the corrective has demonstrably failed and the STUCK classification applies regardless of the blueprint quality. The plan agent must record this tripwire explicitly.

---

## Overall verdict

Two routes (FBC-A, GF-alg) were previously CHURNING; both received and executed their prescribed correctives (blueprint expansion, proof prescription rewrite, sub-lemma decomposition, gate pass) in iter-007. The K=4 window for iter-008 does not independently trigger CHURNING or STUCK for either route — the PARTIAL count is 2 (not ≥3), helper accumulation is 1 iter (not 2+), and the iter-007 no-prover round was a prescribed corrective rather than avoidance. Both routes carry UNCLEAR verdicts: first prover attempt on structurally new targets, with convergence unassessable until iter-008 prover reports return.

GrassmannianCells carries UNCLEAR from insufficient data (1 iter), with a clean trajectory. QUOT-A is out-of-scope for this iter assessment, correctly deferred on its first blueprint round.

The proposed dispatch (3 files) is an honest, mandatory response to the iter-007 corrective completion — dispatching any fewer files would itself constitute CHURNING by avoidance per the iter-007 critic's explicit mandate. The QUOT-A one-iter deferral is structurally identical to the FBC-A/GF-alg iter-007 deferral that the prior critic endorsed.

**The planner's job for the remainder of iter-008:** (1) Monitor iter-008 prover results for any sorry-closures on the new sub-lemma targets. (2) Apply escalation tripwires if zero closures: route-b blueprint for FBC-A; user escalation for GF-alg. (3) Add the three FBC-A sub-lemmas to the STATEMENT `\uses{}` of `lem:base_change_mate_generator_trace_eq` (DAG wire-up advisory). (4) Confirm STRATEGY.md reflects revised OVER_BUDGET estimates for both FBC-A and GF-alg.
