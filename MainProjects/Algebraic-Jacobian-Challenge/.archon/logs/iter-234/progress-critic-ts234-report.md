# Progress Critic Report

## Slug
ts234

## Iteration
234

## Routes audited

### Route 1 — TS / d.2 (`Picard/TensorObjSubstrate/StalkTensor.lean`)

- **Sorry trajectory**: Project-level 80 → 80 → 80 → 80 → 80 across iter-230 to iter-233. `StalkTensor.lean` itself carries 0 sorries — the file is pure axiom-clean build-up toward `stalkTensorIso`, which does not yet exist as a declaration. The upstream sorry (`isLocallyInjective_whiskerLeft_of_W`) will close when the iso lands; until then the project count is structurally frozen.
- **Helper accumulation**: iter-230: ~0; iter-231: 0; iter-232: 0 (structural pivot/split); iter-233: 7 axiom-clean decls (forward comparison chain: `stalkTensorBilin`, `stalkTensorBilin_balanced`, `stalkTensorDescU`, `stalkTensorDescU_tmul`, `stalkTensorDesc`, `germ_stalkTensorDesc`, `stalkTensorDesc_germ_tmul`). Helpers added in only 1 of 5 audited iters — CHURNING's "≥2 of last K iters" threshold NOT met.
- **Prover dispatch pattern**: 1 of 1 available lane dispatched (d.2 is the sole open TS sub-target post-pivot). Not an under-dispatch finding.
- **Recurring blockers**: The old blocker "dual commutes with pushforward has no packaged Mathlib API" was retired at iter-232. The new phase has one stated blocker: "stalkTensorDescU_smul, a ~20–40 LOC carrier-duality plumbing issue." This appeared ONCE (iter-233); does not satisfy the ≥3-iter recurrence threshold for STUCK.
- **Avoidance patterns**: None in the new phase. iters 230–231 were stall/probe on the NOW-ABANDONED dual route; the iter-232 pivot dissolved that; the new phase has not been reclassified or deferred.
- **Prover status pattern**: PROBE / NO-EDIT-STALL / ENGINE-LANE / PARTIAL — only 1 substantive prover iter in the new phase (iter-233). Insufficient data to apply the PARTIAL ≥ 3 rule.
- **Throughput**: ESTIMATE-FREE for the exact sub-step; at the phase level: Strategy `Iters left` = ~4–7, elapsed in current phase = 2 (iter-232 pivot + iter-233 build). ON_SCHEDULE.
- **Verdict**: **UNCLEAR** — the route entered its current phase 2 iters ago; iter-233 is the only substantive prover data point. The construction plan is concrete and bounded (forward DONE; next = `stalkTensorDescU_smul` ~20–40 LOC → `stalkTensorLinearMap` mirrors d.1 → reverse map ~150–250 LOC → bundle), and the forward chain is genuinely clean. But 1 PARTIAL in a new phase is below the K=5 threshold for any CONVERGING/CHURNING classification.

**Watchpoint for iter-235**: The cheapest reversing signal is `stalkTensorLinearMap` landing (or not) in iter-234. If it does NOT land — or if the reverse map expands materially past ~250 LOC — the route should be re-evaluated for CHURNING. The old dual route also had a "concrete next step" framing for 14 iters before the pivot dissolved it; the distinction here is that d.2's forward chain is genuinely analogous to the already-closed d.1, but this is not yet confirmed by evidence.

---

### Route 2 — Engine: `Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: iter-232: 0 sorries (file not wired; orphan); iter-233: +2 sorries (file wired into build; `affineBaseChange_pushforward_iso` + `flatBaseChange_pushforward_isIso`). The increase is structural (wiring), not regressive. Both sorries correspond to theorems whose proof strategy is fully written in comments; the open gap is identified as the tilde dictionary (~350–450 LOC).
- **Helper accumulation**: iter-232: 1 decl (`pushforwardBaseChangeMap`); iter-233: 3 locality lemmas (`isIso_iff_isIso_stalkFunctor_map`, `isIso_of_isIso_app_of_isBasis`, `isIso_iff_isIso_app_affineOpens`). Helpers added in 2 of 2 iters in phase — but sorry count has NOT yet been given a chance to drop (the wired sorries were created in iter-233 itself). The 2-iter window is too short to call this helper-churn.
- **Prover dispatch pattern**: 1 of 1 available engine lane dispatched per iter. Not an under-dispatch finding.
- **Recurring blockers**: "Mathlib-absent tilde pushforward/pullback dictionary, ~350–450 LOC" — appears in iter-233. First occurrence; not yet recurrent.
- **Avoidance patterns**: None. Route entered build in iter-232; active both iters.
- **Prover status pattern**: COMPLETE / PARTIAL — 2-iter window, natural pattern for a file that was orphan then wired.
- **Throughput**: Strategy `Iters left` = ~30–60, elapsed = 2. ON_SCHEDULE.
- **Verdict**: **UNCLEAR** — only 2 iters of data, COMPLETE then PARTIAL, the sorry count increase was structural. The proposed iter-234 action (tilde dictionary) directly targets the stated blocker. Insufficient data for CONVERGING; no evidence of churn yet.

**Watchpoint for iter-235**: If the tilde dictionary lands and `affineBaseChange_pushforward_iso` closes, this becomes CONVERGING on its affine sub-goal. If iter-234 adds more locality/setup helpers but the sorry stays open, the route should be re-evaluated for CHURNING after the 3-iter mark.

---

### Route 3 — Engine: `Cohomology/HigherDirectImage.lean` (deferred this iter)

Not dispatched in iter-234. The deferral is iter-234's first; avoidance rules require ≥2 consecutive "off-critical-path/deferred" entries with no re-engagement plan — not yet met.

The actual file confirms the justification: 3 sorries, each accompanied by a detailed comment identifying a Mathlib-absent prerequisite (relative Mayer–Vietoris, explicit `Rⁱf_* = sheafify` description, Čech-to-cohomology spectral sequences). None of these has a decomposable frontier sub-step; re-dispatching without a dedicated blueprint+mathlib-build sub-lane would only re-confirm the gaps.

**Churn risk in leaving it untouched**: Low for iter-234 specifically. The file is scaffolded (non-sorry `higherDirectImage` definition exists), and the sorries are properly labelled. The risk accretes if the route is deferred again in iter-235 and iter-236 without a named re-engagement condition — the avoidance rule will trigger at iter-235 (second consecutive deferral). The planner should record the re-engagement condition (e.g. "re-dispatch when a blueprint chapter for Mayer–Vietoris is opened") to stay clean.

---

## PROGRESS.md dispatch sanity

Verdict: OK — file count 2 (cap 10), no under-dispatch (HigherDirectImage's first-iter deferral is justified), no over-cap, no bloat signal.

---

## Informational

**Route 1 (d.2)**: The critical structural question — "old stall wearing new clothes?" — cannot be resolved at 2 iters. The distinguishing evidence is that (a) the forward chain is genuinely analogous to d.1's already-closed `stalkLinearMap` build, (b) the next step (`stalkTensorDescU_smul`) has a concrete technique (carrier-duality `erw`) not a vague Mathlib gap, and (c) helper volume in the new phase is much lower than the old stall (7 decls in 1 iter vs. the dual route's 14+ iter plateau). The plan agent should treat iter-234's prover output as a binary probe: `stalkTensorLinearMap` landing → upgrade to CONVERGING; not landing or a new fundamental gap → flag for CHURNING assessment.

**Route 3 (HigherDirectImage deferral)**: Deferral is correct this iter. The planner should add a one-line re-engagement condition to the iter-234 plan sidecar — something like "return when a Mayer–Vietoris or Čech blueprint chapter is opened, or when a mathlib-build sub-lane for one of the three infrastructure gaps is dispatched." Without such a condition, a second deferral in iter-235 will register as an avoidance pattern.

---

## Overall verdict

Two routes (d.2 stalk-tensor, FlatBaseChange engine) are **UNCLEAR** — each has fewer than K=5 substantive prover iters in its current phase, and neither has yet eliminated a sorry. No CHURNING or STUCK verdicts. The proposed iter-234 objectives (2 prover lanes, HigherDirectImage deferred with justification) are sound. The planner's primary responsibility this iter is to use iter-234's prover output as the first real convergence probe for both routes: `stalkTensorLinearMap` for d.2 and the tilde dictionary for FlatBaseChange. If either stalls, the iter-235 progress-critic should have enough data to render a CHURNING verdict and name a corrective.
