# Progress Critic Report

## Slug
iter055

## Iteration
055

## Routes audited

### Route 1: `cechAugmented_exact` — `CechAugmentedResolution.lean`

- **Sorry trajectory**: N/A (theorem absent) → N/A → 1 (iter-053, scaffolded same iter) → 1 (iter-054, resharpened but not closed). Net: 0 closures in the 2 iters where a sorry existed; theorem never closed across 4 active prover iters.
- **Helper accumulation**: +6 (iter-051) + 3 (iter-052) + 2 (iter-053) + 1 (iter-054) = **12 helpers** across 4 prover iters; 0 sorries closed on the target theorem.
- **Prover dispatch pattern**: 4 consecutive 1-of-ready dispatches, all to this route.
- **Recurring blockers**:
  - "Sub-brick A / L1 categorical↔combinatorial bridge = `Γ(V, pushPullObj F Y) ≅ ∏_σ Γ(U_σ∩V, F)`" — present in iter-053 prover report AND iter-054 prover report. **Two consecutive iters, same wall.**
  - The iter-054 prover confirmed every alternative exhausted: ExtraDegeneracy refuted by variance; abstract homotopy impossible without product structure of `D.X n` (= Sub-brick A); geometric extra-degeneracy out of scope; Sub-brick B blocked by `private CombinatorialCech.Dependent`. Issued an explicit "D1 reversal signal."
- **Avoidance patterns**: none. Dispatched every active iter with no off-critical-path reclassification.
- **Prover status pattern**: PARTIAL → PARTIAL → PARTIAL → PARTIAL (4 consecutive).
- **Throughput**: OVER BUDGET — STRATEGY.md estimates ~1–2 iters left; 4 iters elapsed in the current phase (entered ~iter-051). Elapsed is at 2–4× the estimate.
- **Verdict**: **CHURNING**

**Why CHURNING (not STUCK)**: The CHURNING rule's "PARTIAL ≥3 of last K iters" clause applies verbatim — 4 consecutive PARTIALs now. The STUCK clause ("sorry count unchanged across K iters AND recurring blocker ≥3 iters") is a near-miss: the sorry count was only introducible from iter-053, so the unchanged-sorry window is 2 iters, not K; and the Sub-brick A blocker recurs across 2 iters, not 3. CHURNING is the correct classification: each iter adds scaffolding and resharpens the residual, but the residual itself has not changed in substance since iter-053.

**Primary corrective: Blueprint expansion (effort-breaker for Sub-brick A) + Structural refactor (de-privatize `CombinatorialCech.Dependent`)**. These are a single compound corrective targeting the two concrete code blockers the iter-054 prover identified. Blueprint expansion must name the Lean path for each sub-step of Sub-brick A (backbone geometry, sections-over-coproduct, pullback-along-open-immersion, differential match, contractibility-via-Dependent-engine) as atomic `\uses`-chained sub-lemmas. The structural refactor must promote the `private` `CombinatorialCech.Dependent` engine to a public shared-lemma home before any prover can close Sub-brick B. These two must land before the prover is dispatched on the bottom-most leaf.

**On the planner's proposed 4-step corrective (effort-breaker → mathlib-analogist → refactor → prover-on-leaf)**: this is the **correct response**, not over-engineering. The key reason: the iter-054 prover confirmed that alternative routes to close the residual are exhausted. "Just fine-grain one leaf" is not actionable because (a) the prover cannot identify *which* leaf without the blueprint sub-lemma decomposition, and (b) the Dependent engine's `private` visibility is a hard blocker on Sub-brick B regardless of blueprint clarity. All four steps address genuinely distinct prerequisites. Dispatching another raw prover round without them would be the fourth avoidance iteration in a row.

**Secondary correctives**: after the blueprint expansion and refactor land, dispatch the mathlib-analogist on the section/coproduct/pullback-along-open-immersion path before the prover starts the leaf — this is a one-shot risk mitigation, not a full iter.

---

### Route 2: `higherDirectImage_openImmersion_acyclic` / `_comp` — `OpenImmersionPushforward.lean`

- **Sorry trajectory**: 2 (iter-053, scaffolded) → 2 (iter-054, structurally advanced). Count unchanged, but `_acyclic` went from opaque sorry → single precisely-typed `IsZero (((pushforwardSectionsFunctor j W).rightDerived q).obj H)` residual (Serre vanishing on affine `j⁻¹W`); `_comp` re-signed from `Nonempty (A ≅ B)` to canonical `A ≅ B`.
- **Helper accumulation**: +1 (iter-053) + 4 (iter-054) = 5 helpers. Each is load-bearing (the iter-054 +4 built the full toSheaf-reflection → sectionwise-local-zero machinery required for `_acyclic`'s reduction).
- **Recurring blockers**: "02kg change-of-base leaf — rightDerived-sections ↔ Ext + change-of-space `j⁻¹W ≅ Spec Γ`" appears in iter-054 only (1 iter). Not yet a recurrence.
- **Avoidance patterns**: none.
- **Prover status pattern**: PARTIAL → PARTIAL (2 iters). Below the ≥3 CHURNING threshold.
- **Throughput**: ON_SCHEDULE — STRATEGY.md estimates ~2–3 iters left; 2 iters elapsed (entered iter-053).
- **Verdict**: **CONVERGING**

**Rationale**: The CHURNING rule's "helpers added in ≥2 iters AND sorry count net unchanged AND no structural change" does not apply because there IS structural change: the residual narrowed from two opaque sorries to one opaque sorry plus one precisely-typed Serre leaf. The PARTIAL×2 threshold is not 3 yet. The route is ON_SCHEDULE.

**On the planner's question — decompose first vs. continue with prover**: **continue with prover directly**. The residual in `_acyclic` is now precisely typed. The Serre-vanishing leaf requires:
1. Identify `(pushforwardSectionsFunctor j W).rightDerived q` with `Hᵠ(j⁻¹W, -)` — likely via `isoRightDerivedObj` + the definitional `Scheme.Modules.pushforward_obj_obj` (confirmed by iter-054 prover: "pushforward half is definitional").
2. Transport to `affine_serre_vanishing`, which exists axiom-clean.

The iter-054 prover called this a "multi-iteration job" (the 02kg change-of-base), but the STRATEGY.md confirms that `InjectiveResolution.extEquivCohomologyClass` is present and the path is documented. A well-directed prover has a concrete target; forcing a decomposition-first iter before testing the prover on the leaf wastes an iter. The prover should attempt the Serre leaf directly — if it surfaces a genuine sub-wall (the Ext-transport step), the next iter is where decomposition makes sense.

**Watch condition for iter-056**: if the iter-055 prover returns PARTIAL with the same "02kg change-of-base" framing and no structural advance in the Serre leaf, then Route 2 will be CHURNING at that point. The planner must not allow a third PARTIAL with the same blocker phrase.

---

## PROGRESS.md dispatch sanity

The planner proposes: Route 1 structural corrective (effort-breaker + mathlib-analogist + refactor, sequenced before Route 1 leaf prover) AND Route 2 direct prover on Serre leaf. File count ≤ the dispatch cap of 10. No ready-but-undispatched files are identified that are being omitted without reason (`CechAcyclic.lean` remains appropriately excluded given its shared-bridge dependency). Verdict: **OK** — within cap, no under-dispatch, dispatch composition matches route verdicts (structural corrective for CHURNING route, prover for CONVERGING route).

---

## Must-fix-this-iter

- **Route 1 (`CechAugmentedResolution.lean`)**: CHURNING — primary corrective: **Blueprint expansion (Sub-brick A atomic decomposition) + Structural refactor (de-privatize `CombinatorialCech.Dependent`)**. These are prerequisites; no prover round on the main theorem until both land. Why: 4 consecutive PARTIALs; 12 helpers added with 0 sorry closures; Sub-brick A blocker identical across iter-053 and iter-054; alternatives exhausted per iter-054 prover's D1 reversal signal.
- **Route 1 throughput**: OVER BUDGET — STRATEGY.md estimates ~1–2 iters remaining, 4 iters elapsed. The estimate in STRATEGY.md must be revised to reflect the structural corrective taking 1 iter + the leaf prover taking ≥1 iter, for a minimum of 2 more iters before `cechAugmented_exact` can close.

---

## Informational

**Route 2 — `_comp` gating**: `higherDirectImage_openImmersion_comp` (line 290 sorry) depends directly on `_acyclic` closing. If the Route 2 prover closes the Serre leaf in `_acyclic` this iter, `_comp`'s proof body becomes immediately unblocked for the next iter. The planner should keep `_comp` in scope for iter-056 if `_acyclic` closes.

**Shared-bridge opportunity**: the iter-054 prover confirmed that the pushforward half of Sub-brick A is definitional (`pushforward_obj_obj`). The blueprint expansion for Route 1 should exploit this: only the pullback-over-backbone geometry sub-lemma and the `CombinatorialCech.Dependent` contractibility sub-lemma require new Lean declarations. Naming these exactly (not as "Sub-brick A as a monolith") may reduce the required prover work from ~2 iters to 1 after the structural corrective lands.

---

## Overall verdict

One route CHURNING (Route 1, 4 consecutive PARTIALs, same wall for 2 iters, OVER BUDGET by ~2–3× the strategy estimate), one route CONVERGING (Route 2, ON_SCHEDULE, precisely-typed residual). The planner's proposed structural corrective for Route 1 is correct and must execute this iter before any prover round on the main theorem. Route 2 prover should proceed directly on the Serre leaf. Both routes can be worked in parallel this iter — the Route 1 structural work (effort-breaker, refactor, mathlib-analogist) and the Route 2 prover are independent. The Route 1 bottom-leaf prover should be sequenced after the structural work completes, either within iter-055 or as the first task of iter-056.
