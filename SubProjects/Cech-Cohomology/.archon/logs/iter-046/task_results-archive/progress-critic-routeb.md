# Progress Critic Report

## Slug
routeb

## Iteration
046

## Routes audited

### Route: 01I8 keystone — `tile_section_localization` chain (`QcohTildeSections.lean`)

- **Sorry trajectory**: N/A — mathlib-build mode; sorry count is always 0. Residual ingredient count (the equivalent metric): ≥3 → 2 → 1 → 0 (all math) across iters 041–044; at iter-045 math ingredients remain at 0 but assembly is BLOCKED (engineering walls W1/W2/W3). The residual on the *named target* `tile_section_localization` itself is unchanged across 2 consecutive targeted iters (044 stated "assembly next"; 045 blocked on assembly).
- **Helper accumulation**: 16+ helpers across 5 iters (+3, +1, +2, +5, +5). Through iter-044 each helper batch closed a qualitatively distinct ingredient (no repetition). At iter-045, 5 more helpers added (`tile_scalar_compat'` + general-V companions + 2 private), but the target declaration `tile_section_localization` still does not exist. Total helper accumulation (16) vs sorry-equivalents closed (0 — target never introduced): by the letter of the STUCK "helpers added without sorry-elimination" rule, this fires, but in mathlib-build mode there are no sorries to eliminate — the genuine residual is the unwritten target declaration.
- **Prover dispatch pattern**: 1 of 1 available file each iter (no other lane exists per directive — the only off-keystone frontier node is gated on this route).
- **Recurring blockers**: No single phrase recurs across 3+ iters. The blocker morphed each iter: "keystone glue / section-comparison" (041) → "section comparison NOT rfl / non-definitional" (042) → "reduced to one ring identity" (043) → "ring identity CLOSED; assembly next" (044) → "W1/W2/W3 Lean-engineering wall" (045). However, the ASSEMBLY TARGET (`tile_section_localization`) has been the stated next objective for 2 consecutive iters and has not advanced.
- **Avoidance patterns**: None detected. No off-critical-path reclassification; no consecutive plan-only iters (iter-046 dispatched both a mathlib-analogist and a prover); no persistent deferral language.
- **Prover status pattern**: PARTIAL × 5 (iters 041–045). CHURNING rule (PARTIAL ≥ 3 of last K iters) fires unconditionally.
- **Throughput**: OVER_BUDGET — original estimate ~2 iters for the leaf; 5 iters elapsed (041–045). Elapsed (5) > 2 × original estimate (4). STRATEGY.md has already revised to "Iters left = ~3" (acknowledging slippage), but total projected run is now ~8 vs original ~2 — the estimate revision does not retire the OVER_BUDGET signal.
- **Verdict**: **CHURNING**

**On the PARTIAL × 5 verdict.** The iter-045 progress-critic explicitly warned: "If the iter-045 prover returns PARTIAL again, re-examine: that would be iter-045 PARTIAL on the *assembly* step itself (not a new ingredient), which would be a genuine CHURNING signal (same target, same wall, no new ingredients to add)." That prediction has been confirmed. iter-045 was PARTIAL on the assembly step. The target `tile_section_localization` is now the stated objective for a second consecutive iter without advancing. CHURNING is the correct verdict.

**On the structural change in approach at iter-045.** The iter-045 blocker (W1/W2/W3) is qualitatively different from prior iters' blockers — it is pure Lean engineering, not mathematics. This is not the same wall recurring across 3+ iters; it is a *new* wall hit at the assembly step. This nuance is informational, not verdict-changing: CHURNING fires on PARTIAL × 5 regardless, and the corrective must address this specific wall before the route can advance.

**Is the planner's corrective the right type?** YES. The mathlib-analogist consult is the canonical corrective for "the prover hit an API/elaboration wall but the math is zero-remaining." The analogist (already run in iter-046) returned a concrete recipe: wrap the tile section in `ModuleCat.restrictScalars (algebraMap R R_g)` to make `Module R`, `Module R_g`, and `IsScalarTower R R_g` all structural (no `letI`/`have` needed), dissolving W1/W2; then address W3 via `show`/staging. This is actionable and Mathlib-idiomatic. Route pivot, structural refactor, and user escalation are not warranted — the fix is surgical and well-specified.

**Must the corrective land THIS iter?** YES. The analogist has already returned. The prover must be dispatched with the `ModuleCat.restrictScalars` carrier recipe in iter-046 (the meta.json confirms the prover stage is active). Deferring to iter-047 without dispatching a prover in iter-046 would add a plan-only iter to this route and deepen the OVER_BUDGET slippage.

## PROGRESS.md dispatch sanity

Verdict: OK — file count 1 within cap 10, no under-dispatch (no other lane available; the only off-keystone frontier node is gated on this route per directive).

## Must-fix-this-iter

- Route `tile_section_localization`: **CHURNING** — primary corrective: **Mathlib analogy consult**, ALREADY EXECUTED in iter-046 (report at `logs/iter-046/mathlib-analogist-tile-descent-report.md`). The analogist identified the carrier-misalignment anti-pattern (manual `letI`/`have` instance installation on a `Spec`-noncomputable carrier → W1/W2) and prescribed the `ModuleCat.restrictScalars` wrapper idiom as the fix. The prover lane **must** be dispatched with this recipe in iter-046. Do not close this iter without a prover attempt on `QcohTildeSections.lean` using the structural-instance approach.
- Route throughput: **OVER_BUDGET** — STRATEGY.md estimates "Iters left = ~3"; 5 iters elapsed vs ~2 original estimate. Revise the `01I8` row estimate in STRATEGY.md to reflect the actual trajectory (original ~2 → revised remaining ~3 → total ~8) after `tile_section_localization` lands or fails this iter.

## Informational

**On the PARTIAL × 3 mechanical trigger and the "converging" override in iter-044–045.** The iter-044 and iter-045 progress-critic reports gave CONVERGING verdicts by overriding the PARTIAL × 3 rule on the grounds that the residual ingredient count was shrinking monotonically. That override was correct *at the time*: the assembly target only became the sole next objective at iter-044 (after iter-043 closed the ring identity). CHURNING on the assembly step was the flagged contingency in the iter-045 report, and it has now materialized. The CONVERGING override was valid for ingredient-accumulation iters; once the assembly target itself fails to land, the override expires.

**On the analogist's F-side-carrier answer (Q2).** The analogist rejected the F-side carrier as a standalone fix (it loses structural `Module R_g`, creating a symmetric wall). The prover should NOT attempt a pure F-side reshape. The `ModuleCat.restrictScalars` wrapper is the only carrier where all three instances are structural.

## Overall verdict

One route audited; one CHURNING verdict; one OVER_BUDGET throughput finding; dispatch is OK. The route is not mathematically stalled — all ingredients are axiom-clean — but the assembly target has been blocked for two consecutive targeted iters by a Lean-engineering wall (carrier misalignment in the instance plumbing). The correct corrective (Mathlib analogy consult) has already been executed in iter-046 and returned a concrete, actionable fix. The planner must dispatch the prover with the `ModuleCat.restrictScalars` carrier recipe before iter-046 closes. If the prover closes `tile_section_localization` this iter, the CHURNING finding self-corrects and STRATEGY.md should be updated to retire the slippage note.
