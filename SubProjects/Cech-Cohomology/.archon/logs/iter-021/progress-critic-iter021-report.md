# Progress Critic Report

## Slug
iter021

## Iteration
021

## Routes audited

### Route 1 — P3 standard-cover Čech vanishing — `CechAcyclic.lean`

- **Sorry trajectory**: project-level sorry count is 2 (both intentional / frozen), not a useful metric for this mathlib-build lane. Proxy metric — named top-targets landed: `dDiff_exact` (step a) in iter-019; `qcohSectionsAwayLocalized` (step b) in iter-020. Sequential structural advance, one step per prover iter.
- **Helper accumulation**: +22 (iter-018), +24 (iter-019), +4 (iter-020) — 50 axiom-clean decls across 3 prover iters; each group is a direct rung of the step chain (AwayComparison algebra → D• exactness → tilde-M localisation). Not recycled scaffolding; each rung is consumed by the next.
- **Prover dispatch pattern**: plan-only (iter-017); then 3 prover iters all assigned to this file. No under-dispatch.
- **Recurring blockers**: step (c) `sectionCech_homology_exact` was first explicitly named as a blocker in iter-020. It is NOT recurring across ≥3 iters — it is a freshly-surfaced bridge problem arising after step (b) closed. The `∏ᶜ ↔ pi AddEquiv` mismatch is a new blocker at the correct point in the step chain.
- **Avoidance patterns**: none — route has been active and dispatched each prover iter since iter-017 re-sign.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL (iter-018, 019, 020). The PARTIAL×3 rule technically fires, but all three are structurally distinct: 018 = step-a infra, 019 = step-a close, 020 = step-b close. Not the same residual repeating.
- **Throughput**: SLIPPING — section-form re-sign at iter-017; 4 iters elapsed (017–020); strategy estimate "~4–6 iters left." We are at the low edge of the estimate window with steps (c) and (d) remaining. Not yet OVER_BUDGET (estimate range upper bound = 6, elapsed = 4).
- **Verdict**: **CONVERGING** — named targets landing on each prover iter in strict step order; step (c) blocker is fresh (not a ≥3-iter recurring wall); proposed effort-break (3 sub-lemma bridge) is the correct corrective and is already in the iter-021 plan. SLIPPING throughput warrants close watch: if step (c) does not close this iter, the estimate's upper bound (6) will be exhausted next iter and the route tips to OVER_BUDGET.

---

### Route 2 — P3b free-presheaf complex quasi-iso — `FreePresheafComplex.lean`

- **Sorry trajectory**: same project-level caveat; proxy metric = named top-target `cechFreeComplex_quasiIso`. Status: NOT landed in iter-018, NOT landed in iter-019, NOT landed in iter-020. Three consecutive prover iters with the top target absent.
- **Helper accumulation**: +3 (iter-018, augmentation chain map), +3 (iter-019, objectwise reduction), +10 (iter-020, engine + empty case + per-summand bridges) — 16 helpers across 3 prover iters, top target still missing. Each helper group is structurally distinct and genuinely advances the proof skeleton; however the combination of PARTIAL×3 + top-target-not-landed-in-3-iters satisfies the CHURNING criterion verbatim.
- **Prover dispatch pattern**: plan-only (iter-017); 3 consecutive prover iters dispatched to this file. No under-dispatch at the dispatch level.
- **Recurring blockers**:
  - iter-018: top target not attempted (augmentation setup).
  - iter-019: objectwise reduction built, but "per-V homotopy" deferred.
  - iter-020: engine built, but "differential match on coproduct injections" named as the step-1 wall. The blocking phrase has shifted each iter (augmentation → per-V homotopy → differential match), which means there is NO fixed recurring phrase, but the pattern "one more setup round before the real attempt" has repeated.
- **Binding condition from iter-020 critic**: "Route 2 must ATTEMPT the per-V contracting homotopy this iter, not another setup round." Assessment: iter-020 built `combHomotopy_spec` (the homotopy-identity content) + empty case + per-summand bridges, which IS substantive homotopy content. However the differential-match wrapper — step 1 of the prover's 5-step handoff — was not built. The binding condition is PARTIALLY met: homotopy content exists, but the one remaining glue step (differential-match) was not closed.
- **Avoidance patterns**: none — no "off-critical path" reclassification, no consecutive plan-only iters on this route.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL (iter-018, 019, 020). CHURNING rule fires verbatim: PARTIAL ≥3 of last K=4 iters.
- **Throughput**: SLIPPING — route active since iter-016 (5 iters elapsed); strategy estimate "~4–7 iters left." At 5 elapsed vs 4–7 estimate, just inside SLIPPING, not OVER_BUDGET. But if differential-match + nonempty case + glue do not all close this iter, we reach 6 elapsed next iter and enter OVER_BUDGET territory.
- **Verdict**: **CHURNING** — PARTIAL×3 fires verbatim; top target `cechFreeComplex_quasiIso` not landed in 3 consecutive prover iters; pattern of "one more setup round" has repeated across 018→019→020. Each round IS structurally distinct (not the same helpers recycled), but the absence of the top target is the canonical CHURNING signal.
- **Primary corrective**: **Blueprint expansion** — add an explicit `lem:cech_free_eval_diff_match` node to the blueprint chapter pinning the coproduct-injection differential identity as a standalone lemma, so the prover has a single, sentence-granular target to close before proceeding to the nonempty case and glue.
  - **Status**: the iter-021 proposal ALREADY implements this corrective (effort-break adds the differential-match sub-lemma node; prover dispatched on differential-match → nonempty → glue). The must-fix is therefore satisfied by the current plan.
- **Secondary correctives**: none required.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: 10). CechBridge correctly excluded — bridge is 0-sorry, its only open target `injective_cech_acyclic` is gated on `cechFreeComplex_quasiIso` (Route 2, not yet landed), so a prover lane would be a noop.
- **Ready but not dispatched**: none identified beyond what is in the proposal.
- **Over the cap**: no.
- **Under-dispatch finding**: no — 2 files dispatched, 2 files with open work; CechBridge exclusion is correctly motivated.
- **Iter-over-iter trend**: iter-020 dispatched 3 files; iter-021 drops to 2 (CechBridge graduated to 0-sorry). Appropriate tightening, not under-dispatch.
- **Verdict**: OK — file count 2 within cap 10, no under-dispatch, CechBridge exclusion documented.

---

## Must-fix-this-iter

- **Route 2 (FreePresheafComplex): CHURNING** — primary corrective: Blueprint expansion (explicit `lem:cech_free_eval_diff_match` node, sentence-granular differential-match obligation). **Already addressed** by iter-021 proposal's effort-break + dispatch directive. The planner must not let iter-021 return as another setup-only round: if the differential-match step and at least the nonempty homotopy packaging do not land this iter, escalate to sentence-granular effort-break on `lem:cech_free_eval_diff_match` and consider a Mathlib-analogy consult on `HomologicalComplex.Homotopy` packaging idioms.
- **Route 1 (CechAcyclic): SLIPPING** — throughput watch only (not must-fix yet). If step (c) does not close this iter, the strategy estimate's upper bound (6 iters) is exhausted at iter-022 and must-fix escalates to OVER_BUDGET.

---

## Informational

- **Route 1 CONVERGING watch**: the PARTIAL×3 pattern fires technically but is structurally benign here (sequential step chain, each PARTIAL is a distinct rung). The real risk is throughput: steps (c) and (d) must both close in one iter to stay within the strategy estimate window. If the 3 sub-lemmas + step (d) do not all fit in iter-021, the next iter should be Route 1 sole focus with a SLIPPING→OVER_BUDGET alert.
- **Route 2 CHURNING — self-resolving this iter**: the CHURNING verdict is correct on the signal record, but the proposed action is appropriate and specific. The critic concurs with the plan's diagnosis (differential-match is the precise blocker) and the effort-break is the right intervention. This is not a planning-avoidance CHURNING — it is a proof-complexity CHURNING that the effort-break addresses directly.

---

## Overall verdict

Two routes audited. Route 1 (CechAcyclic) is **CONVERGING** with a SLIPPING throughput note — named targets landing each prover iter, fresh blocker at step (c) with a concrete plan, but the strategy estimate window is nearly exhausted and both step (c) and step (d) must close this iter to avoid OVER_BUDGET. Route 2 (FreePresheafComplex) is **CHURNING** — PARTIAL×3, top target not landed in 3 consecutive prover iters, pattern of one-more-setup-round repeating. The iter-021 proposal already implements the required corrective (blueprint expansion of the differential-match sub-lemma + dispatch targeting that step specifically), so the must-fix is addressed; the planner's iter should proceed as proposed, but with a firm expectation that the differential-match AND the nonempty homotopy packaging land this iter — a third pure-setup round would warrant escalation to a Mathlib-analogy consult on `HomologicalComplex.Homotopy` idioms.
