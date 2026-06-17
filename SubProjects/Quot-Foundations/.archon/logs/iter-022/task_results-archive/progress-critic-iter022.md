# Progress Critic Report

## Slug
iter022

## Iteration
022

## Routes audited

### Route GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 3 → 3 → 3 → 2 across iter-018 to iter-021. Not strictly decreasing through the window; net −1 over 4 iters = 0.25 sorry/iter, below the 0.5/2-iter convergence threshold. Current count in-file: **2** (@2021 cascade, @2109 geometric `genericFlatness`). The @2109 sorry is out of iter-022 scope (geometric assembly, correctly deferred).
- **Helper accumulation**: F1–F6 proof blocks (iter-018); injectivity helper `isLocalization_lift_injective` (iter-019); collapsing lemma pre-scouted (iter-020); `g:=g0·g1` witness + `IsIntegral.exists_multiple_integral_of_isLocalization` (iter-021). Helpers added in all 4 audited iters; 1 sorry closed over the full window.
- **Prover dispatch pattern**: not extracted from directive; no under-dispatch finding to report.
- **Recurring blockers**: "@754 deferred/unchanged" appeared in iter-018, 019, 020 (3 consecutive iters) — **resolved iter-021**. No recurring blocker active at iter-022 boundary. The remaining crux (@2021) has a documented 4-step route with one open gap: the ring↔module localisation bridge `LocalizedModule (powers g) C ≃ Localization.Away (algebraMap A C g)`.
- **Avoidance patterns**: none detected. No off-critical-path reclassification; no consecutive plan-only iters on this route.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, COMPLETE(L4)+PARTIAL(cascade) — all four iters carry PARTIAL status (the cascade @2021 remained open in every iter even as the L4 leaf was progressively worked).
- **Throughput**: **OVER_BUDGET** — phase entered ~iter-014; current iter-022 → 8 elapsed iters. STRATEGY.md currently says "Iters left 1–2," which is also what would have been the original optimistic estimate when the phase was entered. Elapsed 8 iters vs. estimate 1–2 iters = 4–8× over budget.
- **Verdict**: **CHURNING**
  - Criterion 1 fires: helpers added in ≥2 of last K iters AND sorry count net down by <1 per 2 iters AND no structural change in approach (denominator-clearing route held constant throughout).
  - Criterion 2 fires: PARTIAL prover status in all 4 of the last K=4 iters.
  - CONVERGING is ruled out: the trajectory 3→3→3→2 is not strictly decreasing across the window.
  - STUCK is not triggered: 1 sorry was closed (3→2), so "unchanged across K iters" fails; and "helpers added without *any* sorry-elimination" fails for the same reason.
- **Primary corrective**: **Mathlib analogy consult** — before dispatching the prover to close @2021, identify whether the ring↔module localisation bridge (`LocalizedModule (powers g) C ≃ Localization.Away (algebraMap A C g)`, or an `IsLocalizedModule`-uniqueness iso in this form) exists in Mathlib. The 4-step route documented at @2016 is sound but step (4) is the only fiddly step, and if the bridge is a named Mathlib fact the cascade closes in one tactic line; if it is Mathlib-absent the prover must build it inline and budget accordingly. Sending the prover without this lookup risks another PARTIAL iteration on a now-documented route.
- **Secondary correctives**: remove the stale iter-018 comment block at line @531 (refers to "remaining sorry is the denominator-clearing assembly" as if L4 was still open; L4 closed iter-021, making the iter-018 framing misleading). This is cosmetic but will confuse future provers reading the file.

---

### Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 4 → 4 → 4 → 4 across iter-018 to iter-021. **Zero movement** across the full 4-iter window. Current count in-file: **4** (@1421 dead-code, @1551 live crux, @1724 affine restriction deferred, @1746 flat-base-change deferred). The honest live-crux count is **1** (@1551 `gstar_transpose`); the sorry at @1421 is dead code whose removal was "queued iter-021" in STRATEGY.md but never executed.
- **Helper accumulation**: 1 scaffolding line + 1 comment (iter-018); 2 sub-lemmas closed axiom-clean `_unitExpand`, `_gammaDistribute` (iter-019); `base_change_mate_domain_read` built axiom-clean + route refactor (iter-020); 2-rw reframing isolating the two Γ-factors + route pinned to `conjugateEquiv_counit_symm` (iter-021). Helpers added in 3 of 4 iters; **zero sorries eliminated across all 4 iters**.
- **Prover dispatch pattern**: PARTIAL (iter-018), PARTIAL (iter-019), route-swap / no prover (iter-020), PARTIAL (iter-021). Three prover dispatches, all PARTIAL; one non-prover iter (structural refactor).
- **Recurring blockers**: "fstar_reindex literal-form lock" appeared in iter-014 through iter-019 (~6 iters). Resolved by the iter-020 route swap, not by a prover. The new crux (gstar_transpose) has been attempted exactly once (iter-021), so no recurring blocker on the new crux yet.
- **Avoidance patterns**:
  - **Dead-code sorry left in place**: STRATEGY.md says "removal queued iter-021" for the fstar_reindex apparatus (`@1421`). Iter-021 is complete and the sorry remains. This is a single-iter deferral persistence, not a 2+ iter pattern yet — but it inflates the sorry count from 3 (live) to 4, masking progress and should be flagged.
  - No off-critical-path reclassification pattern detected.
- **Prover status pattern**: PARTIAL, PARTIAL, no-prover, PARTIAL — PARTIAL in 3 of the 3 prover iters (100%).
- **Throughput**: The *overall* FBC-A phase has been active since before iter-014 (8+ elapsed iters; STRATEGY.md currently says "Iters left 2–3"), which is OVER_BUDGET at the phase level. However, the *current crux* (gstar_transpose) entered iter-020 with 2 elapsed iters vs. estimate 2–3 → **ON_SCHEDULE for the gstar crux**, OVER_BUDGET for the phase overall.
- **Verdict**: **STUCK**
  - Rule fires: helpers added in 3 of 4 iters AND zero sorry-elimination across those 4 iters → "helpers added without any sorry-elimination across K iters."
  - CHURNING also fires (PARTIAL in ≥3 of last K iters); STUCK > CHURNING, so STUCK is the verdict.
- **Primary corrective**: **Mathlib analogy consult** — verify that `CategoryTheory.conjugateEquiv_counit_symm` (the pinned analogy from Seam-1, listed in the iter-021 recipe) exists in Mathlib with the exact type signature needed for the `gstar_transpose` goal shape before the next prover round. The recipe was documented in iter-021 but never executed, so the analogy has not been tested against the literal goal. A mis-matched type or missing lemma would produce another PARTIAL iter on a technically sound route. Confirm the lemma exists and its arguments unify with the `gstar_transpose` goal; if it does not exist, the corrective becomes route-pivot to an alternative conjugate-calculus route.
- **Secondary correctives**: (1) Execute dead-code cleanup of `@1421` (`base_change_mate_fstar_reindex_legs` sorry) this iter, as queued. This restores honest sorry tracking (live count 3 rather than 4) and removes trajectory noise. (2) Confirm that sorries @1724 and @1746 are correctly classified as long-term deferred (not this iter's crux) so the prover does not attempt them.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (FlatteningStratification.lean, FlatBaseChange.lean)
- **Cap**: default 10
- **Over the cap**: no
- **Ready but not dispatched**: directive does not list other ready files; cannot determine under-dispatch from available signals.
- **Under-dispatch finding**: no (insufficient data to confirm)
- **Verdict**: **OK** — file count 2 within cap 10; no under-dispatch finding from available signals.

---

## Must-fix-this-iter

- **Route GF: CHURNING** — primary corrective: **Mathlib analogy consult** on the ring↔module localisation bridge (`LocalizedModule (powers g) C ≃ Localization.Away (algebraMap A C g)`). Why: the 4-step cascade route @2021 is sound and documented, but step (4) is the only unverified sub-claim; without confirming the bridge exists (or planning to prove it inline), the prover will hit it mid-proof and produce another PARTIAL.

- **Route GF: OVER_BUDGET** — STRATEGY.md "Iters left 1–2"; elapsed iters in GF-alg phase: ~8 (entered iter-014). Revise the strategy row to reflect realistic elapsed cost, or confirm convergence is genuine and close the estimate gap.

- **Route FBC: STUCK** — primary corrective: **Mathlib analogy consult** on `conjugateEquiv_counit_symm` before prover dispatch. Why: zero sorries eliminated across 4 iters despite 3 prover rounds; the pinned route has never been executed; an unverified analogy is the most likely failure mode on the next attempt. Also: execute dead-code cleanup of @1421 (fstar_reindex_legs) this iter — removal was "queued iter-021" and skipped; the stale sorry inflates the count from 3 (live) to 4.

---

## Informational

**Route GF is making genuine progress despite the CHURNING verdict.** The @754 leaf (previously stuck iters 018–020) was closed axiom-clean in iter-021, and the cascade @2021 has a concrete 4-step documented route. The CHURNING verdict reflects 3 PARTIAL iters and a sorry rate below the threshold, not conceptual stall. If the ring↔module bridge is confirmed in Mathlib before prover dispatch, there is a plausible path to closing @2021 this iter and dropping the GF sorry count to 1.

**Route FBC's STUCK verdict is partly an artefact of the dead-code sorry.** The live-crux sorry count is 1 (@1551), not 4. If @1421 is cleaned up and @1551 is closed this iter, the live-crux sorry count becomes 0 (with @1724 and @1746 correctly classified as long-term deferred work). The route swap in iter-020 was a genuine structural advance; the STUCK verdict is driven by the technical 4-flat-iter window and zero sorry-elimination rule, not by conceptual stall on the current crux.

---

## Overall verdict

Two routes audited; both return non-CONVERGING verdicts. Route GF is **CHURNING** (technically: slow sorry rate, all iters PARTIAL, throughput OVER_BUDGET) but is genuinely advancing — the iter-021 L4 closure was real and the remaining @2021 crux has a documented path. Route FBC is **STUCK** (zero sorry-elimination across 4 iters, dead-code sorry inflating the count) but the live crux (@1551 gstar_transpose) has had exactly one prover attempt on a fresh route with a documented 3-step recipe. The must-fix action for both routes is the **same**: perform a Mathlib analogy lookup on the load-bearing lemma (ring↔module bridge for GF; `conjugateEquiv_counit_symm` for FBC) before dispatching provers this iter. For FBC, also clean up the @1421 dead-code sorry this iter (queued since iter-021, not executed). The planner should add a brief Mathlib-consult step at the top of each lane's prover objective, and should revise the GF-alg STRATEGY.md estimate to reflect actual elapsed iters.
