# Progress Critic Report

## Slug
pc251

## Iteration
251

## Routes audited

### Route: Lane TS — Picard pullback–tensor comparison iso (`Picard/TensorObjSubstrate.lean`)

- **Sorry trajectory**: 2 → 2 → 2 → 2 → 1 across iters 246–250. Flat for the first four iters; net –1 achieved only in iter-250 (D2′ CLOSED axiom-clean). Rate: –0.2 per iter across the K=5 window, below the 0.5/iter CONVERGING threshold. Not strictly decreasing.

- **Helper accumulation**: +~3 (iter-246), +2 (iter-247), +~4 (iter-248), +0 (iter-249, assembly pass), +3 (iter-250: `restrictScalarsId_map`, `epsilonPresheafToSheafUnit`, `pullbackSheafifyUnitEtaTriangle` + close assembly). ≈12 helpers across 5 iters; 1 canonical sorry eliminated (iter-250).

- **Prover dispatch pattern**: M=1 throughout iters 246–250 (single available lane — structural: D2′/D3′/D4′ are a linear chain in one file; confirmed not under-dispatch in prior critic reports).

- **Recurring blockers**: "`rw [Category.assoc]` silent-match failure on `.val` composites (defeq-not-syntactic)" appeared in iters 246, 247, 248, 249 (= 4 consecutive iters). **RESOLVED iter-250** via `restrictScalarsId_map` propositional strip + `erw` keyed-defeq merge.

- **Avoidance patterns**: none. Route was continuously dispatched with no off-critical-path reclassification, no consecutive plan-only iters, no persistent deferral language.

- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, **COMPLETE**. Four consecutive PARTIAL before the close.

- **Throughput**: **OVER_BUDGET** — STRATEGY.md gives D2′ an estimate of "binary (close now OR pivot iter-251)" i.e. ≤1 iter for D2′ specifically; phase sub-form entered at ~iter-243; D2′ took iters 243–250 = ~8 iters ≈ 8× the ≤1 estimate. (This over-budget flag was already identified and the STRATEGY estimate was revised in iter-250 plan-phase.)

- **Verdict**: **CHURNING**

  The PARTIAL×4 trigger fires unconditionally (four of five iters in the window carry PARTIAL status). The helper-accumulation trigger also fires: helpers added in 4/5 iters, sorry net –0.2/iter < the 0.5/iter threshold. By strict rules this is CHURNING regardless of the iter-250 COMPLETE.

  **Structural note (does not change the verdict, but shapes the corrective):** The CHURNING designation accurately captures iters 246–249; iter-250 represents a genuine structural break — the recurring blocker is fully resolved, `pullbackTensorMap_unit_isIso` is verified axiom-clean, and the route has entered entirely new territory (D1′/D3′/D4′). The CHURNING corrective (Mathlib analogy consult) was already executed in iter-250 plan-phase and *produced the close*. The forward question is whether D3′ — "the sole genuinely-new mate calculus, analog of the CLOSED `pullbackObjUnitToUnit_comp`" — will reproduce the 246–249 pattern on first dispatch.

- **Primary corrective**: **Mathlib analogy consult — proactively arm D3′ before dispatch.**

  D3′ is in the same mate-calculus family (oplax comparison naturality under base-change squares) as the five-iter wall that preceded the close. The iter-250 idiom KB (`restrictScalarsId_map` propositional strip, `erw` keyed-defeq merge on `.val`-spelled composites, `presheafUnit_comp_map_eta`-style presheaf telescope) is directly applicable but D3′ operates at a *different position* in the adjunction square (open-immersion restriction chart vs. unit pair). Sending the D3′ prover in cold risks another PARTIAL×3–4 cycle before the same wall is rediscovered. **The corrective is to run a targeted mathlib-analogist consultation on D3′'s specific goal (the open-immersion restriction chart for the sheafified δ) and write the D3′ idiom directives into the prover objective before dispatch** — not after a failed round. The iter-250 KB should be reproduced verbatim in the D3′ prover directive as mandatory warm context.

---

## PROGRESS.md dispatch sanity

Proposed file count: **2** (`TensorObjSubstrate.lean` [Lane TS-cmp: D1′/D3′/D4′] + new file for Lane TS-inv). Cap: 10.

**Ready but not dispatched**: none — both proposed lanes appear in the proposal.

**Over the cap**: no (2 ≤ 10).

**Under-dispatch finding**: The current proposal dispatches both available lanes (TS-cmp + TS-inv). If Lane TS-inv is dropped from the final proposal, that would represent **N=1 with M=2 available** — under-dispatch per the PARALLELISM directive. The dual-inverse chain (`dual_restrict_iso` → `dual_isLocallyTrivial` → `exists_tensorObj_inverse`) has the `homOfLocalCompat` frontier node as its entry and is structurally independent of the D1′/D3′/D4′ chain (both feed `RelPicFunctor.addCommGroup`; neither depends on the other). There is no structural reason to suppress this lane now that D2′ is closed.

**Iter-over-iter trend**: Prior iters 246–250 all had M=1 (structural). With D2′ closed, M=2 is newly available; this is the first iter where a second independent lane exists. No historical under-dispatch finding applies to the new state.

**Verdict**: **OK** — file count 2 within cap 10; both available lanes are in the proposal; no under-dispatch if the TS-inv lane is preserved.

**Warning**: If the planner drops Lane TS-inv from the final objectives (making it N=1 again with M=2 available), this becomes UNDER_DISPATCH. The dispatch-sanity verdict should be re-evaluated against the final objectives before committing.

---

## Must-fix-this-iter

- **Route Lane TS: CHURNING** — primary corrective: **Mathlib analogy consult on D3′ before dispatch**. Why: D3′ is the same mate-calculus family (oplax tensorator naturality under base-change) as the five-iter wall resolved by iter-250's idiom KB; dispatching cold risks a PARTIAL×3–4 repeat. The corrective is to run the analogist on D3′'s specific presheaf-level goal and embed the D3′ idiom directives in the prover objective **before** Lane TS-cmp is dispatched, not as a mid-cycle corrective. The iter-250 KB (`restrictScalarsId_map`, `erw` keyed-defeq reassoc, `W_whiskerRight_of_W`-family) should appear in the D3′ prover directive verbatim.

- **Route Lane TS: OVER_BUDGET** (historical, for record) — STRATEGY.md estimated D2′ ≤1 iter; elapsed ~8 iters. Estimate revised iter-250; forward estimate for D3′/D4′ is ~6–12 iters (from STRATEGY.md). No further action required on the historical over-budget; the revised estimate stands.

---

## Informational

### Q1: Is the route CONVERGING going into D1′/D3′/D4′?

By strict rules: no — CHURNING fires on the K-iter window. **But the structural read is more nuanced.** The iter-250 COMPLETE is a genuine first canonical sorry-elimination of the route (not a helper build or sorry-split — `pullbackTensorMap_unit_isIso` is verified axiom-clean with only kernel axioms). The recurring blocker is fully resolved. The route has entered entirely new territory. The CHURNING designation is accurate for the 246–249 segment; the forward trajectory is better characterized as **UNCLEAR-to-CONVERGING**, contingent on whether the iter-250 idiom KB transfers cleanly to D3′.

The proactive corrective (arm D3′ before dispatch) is the mechanism to push the forward trajectory toward CONVERGING rather than letting it default back to CHURNING-by-repeat. If D1′ (Mathlib naturality pasting, expected easy) closes in one pass and D3′ is armed with the KB, the route should converge over the ~6–12 iter D3′/D4′ estimate without another churn cycle.

### Q2: Should iter-251 open the parallel dual-inverse lane (M=2)?

**Yes.** With D2′ closed, Lane TS-inv is genuinely independent and has frontier nodes at `homOfLocalCompat`. The standing PARALLELISM directive explicitly requires splitting files and running parallel lanes. The prior "M=1⇒N=1" dispatches were structurally justified when D1′/D2′/D3′/D4′ were a single linear chain in one file with no independent parallel path; that condition no longer holds. Opening M=2 is the correct decision for iter-251.

**Caveat on Lane TS-inv readiness:** The iter-230 C-wiring diagnostic identified that `dual_restrict_iso` requires a presheaf-level R-linear slice comparison that is NOT covered by `overSliceSheafEquiv` (different categories, different value ring). This is a genuine new build, not a trivial extension of the tensorObj substrate. The dual-inverse lane is ready to *start* (frontier nodes exist), but its close may itself require a Mathlib analogy consult on the dual-restrict presheaf goal. Dispatch it, but arm it with the iter-230 diagnostic findings as warm context.

### Q3: D3′ churn risk and corrective

**Moderate-to-high risk.** D3′ is "the sole genuinely-new mate calculus, analog of the CLOSED `pullbackObjUnitToUnit_comp`." The specific shape (naturality of `δ` under the open-immersion restriction chart — i.e., commutativity of pulling back the oplax comparison across the `sheafificationCompPullback` device) is in the same family as the D2′ wall but at a strictly harder position: D2′ worked on the *unit pair* (where the oplax unitality identity `left_unitality_hom` gave a concrete factorisation); D3′ works on *arbitrary `M, N`* restricted to an affine chart (where no unitality shortcut exists, and the full δ-naturality square must commute under the adjunction telescope). The iter-250 idiom KB is necessary but not sufficient to guarantee a first-pass close.

**The specific risk signal**: the D2′ close used `Functor.OplaxMonoidal.left_unitality_hom` to factor δ into η ▷ λ on the unit pair, with the λ factor landing in a clean `IsIso inferInstance`. D3′ has no analogous unitality factorisation — the δ-naturality square is a genuine equation between composites. The `.val`-spelling friction (the 246–249 wall) is the SAME family and the iter-250 idiom KB resolves it. But the equation itself is harder. **Recommended corrective**: run the analogist specifically on D3′'s reduced goal (the commutativity of the δ naturality square after folding `sheafificationCompPullback` and stripping `.val` wrappers via `restrictScalarsId_map`) before dispatch, and include the result in the prover directive.

---

## Overall verdict

One active route (Lane TS), verdict **CHURNING** by strict PARTIAL×4 rule on the K=5 window. The iter-250 COMPLETE is genuine — the route cleared its primary blocker and the CHURNING corrective (Mathlib analogy consult) was already applied and produced the close. The route is in structural transition, not churn-in-place.

**The iter-251 plan must address the CHURNING verdict** by applying the analogist proactively to D3′ before dispatch — not as a mid-cycle corrective after a failed PARTIAL round. This is the single most important planning decision for this iter: the difference between CONVERGING over the estimated ~6–12 iter D3′/D4′ window and another 4-iter PARTIAL×4 cycle.

On dispatch: with D2′ closed, M=2 independent lanes are available (TS-cmp: D1′/D3′/D4′; TS-inv: dual-inverse). Both should be dispatched per the PARALLELISM directive. Dropping Lane TS-inv would be under-dispatch and should be flagged.

OVER_BUDGET on D2′ (8× estimate) is historical and already addressed by estimate revision. The forward D3′/D4′ estimate of ~6–12 iters is realistic given the mate-calculus depth.
