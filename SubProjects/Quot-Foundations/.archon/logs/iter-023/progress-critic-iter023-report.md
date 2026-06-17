# Progress Critic Report

## Slug
iter023

## Iteration
023

## Routes audited

### Route: FBC — `base_change_mate_gstar_transpose` (FlatBaseChange.lean)

- **Sorry trajectory**: 1 → 1 → 1 → 1 across iter-019 to iter-022. Zero movement on the live-crux sorry across the full 4-iter window.
- **Helper accumulation**: iter-019: 2 sub-lemma proofs (`_unitExpand`, `_gammaDistribute`); iter-020: 1 new top-level decl (`base_change_mate_domain_read`) + route refactor; iter-021: 0 new decls (2-rw reframing pin only); iter-022: 0 new decls (conjugate-counit `set`/`have` scaffold inside proof body, compiles). Net: new top-level declarations in 2 of last 4 iters, zero sorry eliminated across all 4.
- **Prover dispatch pattern**: iter-019 route established (no prover); iter-020 no prover (plan/route-swap iter); iter-021 PARTIAL; iter-022 PARTIAL.
- **Recurring blockers**: "step 2–3 telescoping, ~150 LOC, inline derivation of `Γ_R(θ_in) = ρ`" — named explicitly in both iter-021 and iter-022 prover reports. Two consecutive prover iters have hit the same wall and stopped. The lean-vs-blueprint-checker confirmed iter-022 that step 2 is **under-specified in the blueprint sketch**: the ~150-LOC inline telescoping is not described, so the prover has no written guidance for it.
- **Avoidance patterns**: none of the catalogue patterns (off-critical-path, consecutive plan-only iters, deferral-phrase rotation). The iter-022 prover did make genuine structural progress: step 1 (counit split + conjugate transport via `conjugateEquiv_counit_symm`) is fully formalized and compiles, with the `huce` master counit-transport identity verified. This is not circular helper churn — it is sequential progress on a 3-step recipe. Steps 2 and 3 remain.
- **Prover status pattern**: no-prover, no-prover, PARTIAL, PARTIAL.
- **Throughput**: **SLIPPING** — gstar-crux sub-phase entered ~iter-020; 3 iters elapsed (020, 021, 022). STRATEGY.md `Iters left` for FBC-A was set at 2–3 (post-swap baseline) when the sub-phase opened. 3 elapsed vs. 2–3 estimated = at the outer edge of the range, technically on-boundary. With step 1 formalized and steps 2–3 still open, iter-023 is the 4th iter in the sub-phase — now SLIPPING. The overall FBC-A phase (entered ~iter-014) is OVER_BUDGET at ~9+ iters elapsed; however, the iter-020 route swap reset the sub-phase clock, so the phase-level OVER_BUDGET is noise here.
- **Verdict**: **STUCK**

  Two STUCK rules fire:

  1. **Helpers added without any sorry-elimination across K iters** (iter-019 + iter-020 added top-level declarations; zero sorry eliminated across iter-019 to iter-022).
  2. **Same deferral phrase persisting across ≥2 consecutive iters**: "step 2–3 telescoping, ~150 LOC, inline derivation of `Γ_R(θ_in) = ρ`" appears verbatim in iter-021 and iter-022 prover reports — the prover reached the same sub-goal boundary twice and did not advance past it.

  CHURNING also fires (PARTIAL prover status in 2 of the 2 prover iters); STUCK > CHURNING, so STUCK is the verdict.

  CONVERGING is ruled out: the live-crux sorry count has not dropped once across the 4-iter window.

- **Primary corrective**: **Blueprint expansion** — the lean-vs-blueprint-checker confirmed a must-fix adequacy gap: the proof sketch of `lem:base_change_mate_gstar_transpose` does not describe how to derive `Γ_R(θ_in) = ρ` inline, which is the exact wall the prover has hit twice. Sending the prover back into the same sorry without expanding the blueprint sketch will produce a third PARTIAL. The corrective is: write explicit sub-lemma blueprints for (a) the inline `Γ_R(θ_in) = ρ` derivation (citing `_unitExpand`, `_gammaDistribute`, the three Γ-collapse atoms, `pullbackPushforward_unit_comp`, `base_change_mate_unit_value`) and (b) the generator close (`extendScalars ψ(ρ) ≫ ε^alg = regroupEquiv.inv` via one-generator `ext`), each with their own blueprint block and `\uses` entries, before the prover is dispatched on these pieces.

  **Assessment of planner's proposed corrective**: the effort-breaker decomposition (named sub-lemmas + own blueprint blocks + `\uses`, then fine-grained prover on the pieces) is **exactly the right action** for this STUCK verdict. It directly addresses the blueprint adequacy gap and breaks the ~150-LOC monolith into independently checkable units. The planner should proceed with this approach. No pivot is warranted — the route is correct and structurally advancing; the gap is documentation and granularity, not mathematical direction.

---

### Route: GF-geo — `genericFlatness` (FlatteningStratification.lean)

- **Sorry trajectory**: GF-alg COMPLETED iter-022 (sorry 2 → 1, axiom-clean). The sole remaining sorry is `genericFlatness` @2208 in the new GF-geo sub-phase. Sub-phase has 0 prover attempts.
- **Helper accumulation**: n/a — fresh sub-phase, no prover dispatched yet.
- **Prover dispatch pattern**: 0 iters (sub-phase opened iter-022 completion; iter-023 would be the first dispatch).
- **Recurring blockers**: none — blueprint proof sketch (4-step finite-affine-cover) already exists.
- **Avoidance patterns**: none. The prior CHURNING verdict (iter-022) was for GF-alg, which has now been resolved. The transition to GF-geo is a clean sub-phase boundary, not an avoidance pattern.
- **Prover status pattern**: no data (0 prover iters in this sub-phase).
- **Throughput**: **ESTIMATE_FREE / fresh** — STRATEGY.md `Iters left` for GF-geo: 1–2; sub-phase opened at iter-022 completion. 0 elapsed iters vs 1–2 estimated → on schedule.
- **Verdict**: **UNCLEAR** — fresh sub-phase, zero prover attempts, < K iters of data. Route is ready to proceed.

  **Note**: The planner's "possibly... GF-geo prover OR de-private/stale-comment refactor (mutually exclusive same-file)" framing is an unnecessary hedge. The blueprint proof sketch exists, the phase has not started, and the STRATEGY estimate is 1–2 iters. A refactor pass on this file before dispatching the GF-geo prover defers a ready lane one full iteration. **Prefer the GF-geo prover dispatch this iter**, not the refactor. The de-private/stale-comment cleanup is cosmetic and can run as a secondary objective or be deferred to the review phase.

---

## PROGRESS.md dispatch sanity

- **File count**: 1 certain (FlatBaseChange.lean) + 1 possible (FlatteningStratification.lean) = 1–2 files
- **Cap**: default 10
- **Over the cap**: no
- **Ready but not dispatched**: GF-geo (`genericFlatness`, blueprint exists, phase ready) is listed as "possibly" rather than confirmed. This is not an under-dispatch finding yet (sub-phase only opened iter-022; this is the first iter it could be dispatched).
- **Under-dispatch finding**: no — only 1 iter of data for GF-geo, below the ≥2-iter threshold.
- **Verdict**: **OK** — file count 1–2 within cap 10. One recommendation: firm up GF-geo as a confirmed dispatch (not "possibly"), since the blueprint is ready and 0 iters have elapsed in the sub-phase. Substituting a refactor for a prover on a ready lane, even once, delays GF closure by one full iteration.

---

## Must-fix-this-iter

- **Route FBC: STUCK** — primary corrective: **Blueprint expansion**. Why: two STUCK rules fire (helpers added with zero sorry-elimination across 4 iters; same "step 2–3 telescoping ~150 LOC" blocker in both prover iters). The planner's proposed effort-breaker decomposition (named sub-lemmas with their own blueprint blocks + `\uses`, then fine-grained prover) is the correct action. Execute the blueprint expansion before dispatching the prover this iter, not after.
- **Route FBC: SLIPPING** — STRATEGY.md `Iters left` for the gstar sub-phase was 2–3; 3 iters have elapsed (020, 021, 022); iter-023 will be the 4th. The effort-breaker + sub-lemma strategy is realistic for closing the sorry in 1–2 more iters if the sub-lemmas are well-scoped. Revise the sub-phase estimate after the effort-breaker output is known.

---

## Informational

**FBC structural progress is real despite the STUCK verdict.** The STUCK designation reflects rule-based signal (zero sorry elimination, recurring blocker) — not conceptual stall. The iter-022 prover delivered step 1 of a 3-step recipe in a fully compiled form. The route is sequentially advancing; the gap is that step 2 is ~150 LOC with no blueprint guidance and has blocked two provers. Once the effort-breaker decomposes it, the prover should close individual sub-lemmas in one or two iters.

**GF route closed cleanly.** The prior CHURNING verdict (iter-022) is no longer load-bearing — GF-alg closed axiom-clean. The GF-geo sub-phase opens with a documented blueprint and a realistic 1–2 iter estimate. No churn pattern carries over from the prior phase.

---

## Overall verdict

Two routes audited; one STUCK (FBC, via blueprint adequacy gap), one UNCLEAR (GF-geo, fresh sub-phase). The FBC STUCK verdict does **not** call for a pivot — the route direction is correct and iter-022 formalized step 1 cleanly. The corrective is surgical: write the blueprint sub-proof blocks for the `Γ_R(θ_in) = ρ` derivation and the generator close, then dispatch the prover on those named pieces. The planner's proposed effort-breaker + blueprint re-review + fine-grained prover is the right plan; the critic's only addition is to make the blueprint expansion mandatory (not optional) before the prover fires. For GF-geo, the planner should confirm the prover dispatch (not hedge it with a refactor alternative) — the lane is ready and every deferred iter costs toward the 1–2 iter STRATEGY estimate. No avoidance patterns detected; no over-cap or bloat issues in the proposed dispatch.
