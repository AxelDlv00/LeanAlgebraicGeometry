# Progress Critic Report

## Slug
pc255

## Iteration
255

## Routes audited

### Route 1 — TS-cmp: `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 1 → 3 → 3 → 3 → 2 across iter-251 to iter-254. The iter-251 jump (1→3) was deliberate (D1′ authored); the D1′ sorry then sat flat at 3 for three consecutive iters before STEP A closed in iter-254 dropping it to 2.
- **Helper accumulation**: 1 helper added iter-252, several iter-251, 1 iter-254 (`sheafifyTensorUnitIso_hom_eq'`) = 3 of 4 iters with helper additions; D1′ sorry closed in 0 of those iters until iter-254's STEP-A predecessor fell.
- **Recurring blockers**: `restrictScalars(𝟙)`/`forget₂` carrier-spelling friction / "two defeq monoidal instances" appears in all 4 iters (251–254). In iter-254 this crystallised into a specific named failure: `δ_natural (F:=Fp)` cannot synthesise `MonoidalCategory` on the `X.ringCatSheaf.obj` spelling (instance only on the canonical `X.presheaf ⋙ forget₂ CommRingCat RingCat` form). Recurring blocker phrase threshold (≥3 iters) is met.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL/BLOCKED, PARTIAL — all four iters PARTIAL.
- **Avoidance patterns**: None — the planner dispatched the correct corrective (mathlib-analogist tscmp254) in iter-254 rather than silently re-dispatching the prover. No off-critical-path reclassification, no plan-only iters within the K window.
- **Throughput**: OVER_BUDGET — STRATEGY estimate `~4–8 iters`; phase entered ~iter-233; elapsed ~22 iters. Upper bound exceeded by factor 2.75.
- **Verdict**: **CHURNING**

  Rules triggered: (a) `PARTIAL prover status ≥3 of last K iters` — all 4; (b) helpers added in 3 of 4 iters with D1′ sorry net unchanged across the K window (it was authored and remained through iter-254); (c) recurring blocker phrase (carrier-spelling) across ≥3 iters.

  **Nuance — iter-254 is a genuine structural advance, not cosmetic:** STEP A (`sheafifyTensorUnitIso_hom_natural`) fell axiom-clean after a five-iter wall. The route is NOT spiralling: it has ONE remaining sorry (L2064 per grep) with a fully-named, newly-scoped blocker. The tscmp254 recipe exists; the open question is LIGHT (proof-side `change`/`letI`-free spelling normalisation) vs STRUCTURAL (def-retype of the comparison maps). This advance should inform the planner's corrective choice — CHURNING stands by the rules, but the residual work is bounded, not open-ended.

- **Primary corrective**: **Refactor** — the carrier-spelling synthesis failure is structural: `pullbackTensorMap` and its helper isos are stated on the `X.ringCatSheaf.obj`/`Sheaf.val` spelling while the `MonoidalCategory` instance and δ/μ naturality lemmas live on the canonical `X.presheaf ⋙ forget₂ CommRingCat RingCat` spelling. The tscmp254 recipe specifies exactly where to restate (pin the canonical spelling, strip `restrictScalars(𝟙)` eagerly). If the analogist consult this iter confirms STRUCTURAL, dispatch a refactor subagent before the next prover pass; if LIGHT, the prover can apply the spelling normalisation inline. **Do NOT dispatch the prover on TS-cmp this iter if the fix is structural — a fifth PARTIAL adds nothing.** The M=1-fallback (TS-inv prover only this iter + refactor for TS-cmp) is SOUND in the structural case; M=2 (both provers) is SOUND only in the light case.

---

### Route 2 — TS-inv: `Picard/TensorObjSubstrate/DualInverse.lean`

- **Sorry trajectory**: 3 → 2 → 2 → 2 → 2 across iter-251 to iter-254. One sorry closed iter-251; then flat at 2 for three consecutive iters. Internal `homOfLocalCompat` sub-step count moved (2→1 this iter per directive), but file-level count did not drop.
- **Helper accumulation**: ~4 helpers iter-251, 1 iter-252, 2 iter-253 (`topSectionToHom`), 1 iter-254 (`image_preimage_of_le`) = 4 of 4 iters with helper additions; file-level sorry count unmoved across the last 3 iters.
- **Recurring blockers**: No single blocker phrase recurring across ≥3 iters. Iter-253's blocker (the `hf : HEq` freeze, believed protected) was fully resolved iter-254 by re-signing. Iter-254's sole residual (open-immersion ring-bridge / carrier-duality at L636) is NEW — not a ≥3-iter recurring phrase. Per iter:
  - iter-252: compiling scaffold, no deep block
  - iter-253: `hf : HEq` believed protected → BLOCKED sub-step (a)
  - iter-254: `hf` re-signed, sub-step (a) CLOSED; SOLE residual = L636 ring-bridge sorry with fully-mapped inline route
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL — all four PARTIAL.
- **Avoidance patterns**: None. The self-imposed `hf` freeze (iter-253) was correctly identified as a self-imposed throttle and corrected iter-254 via bw254. No off-critical-path reclassification.
- **Throughput**: OVER_BUDGET — same phase as Route 1 (A.1.c.sub), same elapsed count.
- **Verdict**: **CHURNING**

  Rules triggered: (a) `PARTIAL prover status ≥3 of last K iters` — all 4; (b) helpers added in all 4 iters with file-level sorry flat for 3 consecutive iters.

  **Important nuance:** the sub-step advances are real and serial — (b) closed iter-253, (a) closed iter-254, (c) ~90% iter-254. The CHURNING here is not "adding helpers without any progress" — it is the structural constraint that `homOfLocalCompat` must close sub-steps sequentially before the file-level count drops. The iter-254 result is the most advanced state the route has reached: ONE sorry (L636) with a precisely scoped handoff (prove `r •_X z = (appIso.hom r) •_{Ui} z` → `map_smul` → scalar reconciliation). No new helpers are needed; execution is the corrective.

- **Primary corrective**: **Current dispatch** — the DEFINITE prover lane for TS-inv this iter IS the correct corrective. The ring-bridge sorry (L636) has a fully-mapped inline route from iter-254's report; no new architectural decisions are required. The corrective is execution, not scaffolding. **Do not add more helpers — close L636 inline.** If L636 resists the inline route, report the exact new goal and STOP; do not add a 5th wrapper helper.

  Note: no named corrective TYPE in the catalog maps cleanly to "the existing plan is correct; execute it." The closest is **Fill all ready lanes** — this lane is ready, and the DEFINITE dispatch this iter is the right shape. The risk to guard against is the prover adding another helper to set up the ring-bridge rather than closing it inline.

---

## PROGRESS.md dispatch sanity

- **File count**: 1 definite + 1 conditional = 1–2 prover dispatches (cap: 10)
- **Ready but not dispatched**: The engine lane (`IsLocallyTrivial ⟹ IsFinitePresentation`) is committed for iter-255 as a blueprint-writer subagent dispatch (not a prover), satisfying the pc254 avoidance-clock obligation. This is correct sequencing — the engine lane is not prover-ready until blueprinted.
- **Over the cap**: No (2 ≪ 10)
- **Under-dispatch finding**: No. The only candidate 3rd file (engine lane) needs blueprinting first; it is appropriately queued as a blueprint-writer, not a prover.
- **Iter-over-iter trend**: M=2 (TensorObjSubstrate + DualInverse) has been consistent for several iters; within-cap, no bloat.
- **Verdict**: **OK** — dispatch count 1–2 within cap 10, no under-dispatch against prover-ready files.

---

## Must-fix-this-iter

- **Route 1 (TS-cmp): CHURNING** — primary corrective: **Refactor** (spelling-pin). The δ_natural synthesis failure requires normalising `pullbackTensorMap` and helpers onto the canonical `X.presheaf ⋙ forget₂ CommRingCat RingCat` spelling before the prover can close D1′. The analogist consult this iter determines LIGHT vs STRUCTURAL. **If STRUCTURAL: dispatch the refactor subagent, defer D1′ prover to iter-256 (M=1-fallback is SOUND). If LIGHT: include TS-cmp in the prover dispatch (M=2). Do not dispatch a prover on TS-cmp without resolving the spelling issue — that will produce a 5th consecutive PARTIAL on the same wall.**

- **Route 1 + Route 2: OVER_BUDGET** — STRATEGY estimates `~4–8 iters` for phase A.1.c.sub; elapsed ~22 iters (entered ~iter-233). Already acknowledged in PROGRESS.md; correctives are in motion. Revise the strategy estimate for A.1.c.sub to reflect actual remaining work (≤2 iters for TS-inv given ONE sorry; ≤3 iters for TS-cmp after the refactor/spelling fix).

- **Route 2 (TS-inv): CHURNING** — primary corrective: **execute current dispatch** (prover closes L636 ring-bridge inline per the iter-254 handoff). Warning: the prover should NOT add another wrapper helper — the inline route is fully mapped; extra scaffolding is the CHURNING pattern to break. Close L636 or stop and report the exact residual.

---

## Informational

**On the M=1-fallback as dispatch shape (the directive's direct question):**

M=1 (TS-inv only) + refactor subagent for TS-cmp is SOUND under the structural-fix condition. The reasoning: TS-cmp has a CHURNING verdict with a named structural blocker (carrier-spelling); dispatching the prover without the spelling fix will reproduce the same wall for the fifth time. The refactor subagent (normalise to canonical spelling per tscmp254) unblocks the iter-256 prover. TS-inv is independently ready and should close this iter regardless of what happens on TS-cmp. Under the light-fix condition, M=2 is appropriate and the prover can apply the normalisation inline; the M=1 fallback need not activate.

**Route 2's CHURNING verdict is rule-driven, not outcome-predictive:** the route IS converging. The PARTIAL×4 + flat-3-iters signals trigger CHURNING by the rules, but the corrective is not a new architectural intervention — it's completing the existing plan. The planner should read this as "finish the prover work; no new helpers" rather than "something is structurally wrong."

---

## Overall verdict

Two routes audited; both CHURNING. Route 1 (TS-cmp) has the more serious churn: a recurring carrier-spelling blocker (4 iters), D1′ unclosed after authoring in iter-251, and an OVER_BUDGET phase count (22 iters vs 4–8 estimate). The iter-254 structural advance (STEP A fell) is real and meaningful — the residual is ONE named sorry — but the corrective must be the spelling-pin refactor before the next prover pass, not another direct attempt. Route 2 (TS-inv) is in a better state: one remaining sorry with a fully-mapped inline route, no recurring structural blocker, and the DEFINITE prover lane this iter is the correct corrective. The planner's M=1-fallback shape is SOUND for the structural-TS-cmp case. The iteration is well-structured: execute TS-inv prover (close L636), and run the analogist-determined corrective (refactor or light probe) for TS-cmp before committing the prover there. PROGRESS.md dispatch sanity is OK; no avoidance patterns, no over-cap.
