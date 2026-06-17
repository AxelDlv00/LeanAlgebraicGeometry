# Progress Critic Report

## Slug
ts222

## Iteration
222

## Routes audited

### Route: Lane TS.dual (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)

- **Sorry trajectory**: Project-wide 81 → 80 → 80 → 80 → 80 (iter-217 through iter-221). Flat at 80 for 4 iters. Flat sorry count is BY DESIGN for this mathlib-build block — `exists_tensorObj_inverse` closes only at sub-step 5. The correct convergence metric (as specified in the directive) is **sub-step retirement**.
- **Sub-step retirement trajectory (tracking metric)**:
  - iter-218: INCOMPLETE (gate — Mathlib-absent dual correctly identified)
  - iter-219: **sub-step 1 COMPLETE** — 11 decls axiom-clean (per-object VALUE module `homModule`/`internalHomObjModule`)
  - iter-220: **sub-step 2 COMPLETE** — 12 decls axiom-clean (restriction maps + assembled presheaf `internalHom` via `ofPresheaf`)
  - iter-221: **sub-step 3 PARTIAL** — 6 decls axiom-clean (`dual` DONE, `internalHomEvalApp` built, 4 helpers); `internalHomEval` full morphism NOT assembled
  - **Retired: 2 of 5 sub-steps; sub-step 3 at ~50% (primary target 1 done, primary target 2 blocked at naturality assembly)**
- **Helper accumulation**: 29 decls across iters 219–221. Iters 219 and 220 delivered the respective sub-step assembly targets as their primary decls (not wrappers). Iter-221 delivered `dual` (primary target 1 — genuinely retired) and `internalHomEvalApp` (the per-object mathematical content of primary target 2), plus 4 supporting helpers. The assembly target `internalHomEval` did not land. This is the FIRST iter where the primary assembly target was not delivered; the per-object decls are the real content, not scaffolding.
- **Recurring blockers**: `Over.map` pseudofunctor coherence (map_id/map_comp not definitionally equal) appeared in iter-220 (CRACKED for `restrictionMap` via `hom_app_heq`/`subst`) and iter-221 (NOT yet cracked for `internalHomEval` naturality). **Two consecutive iters** — below the ≥3-iter STUCK threshold by one iter. The iter-221 prover left a precise, worked-out reduction naming the exact template to port.
- **Avoidance patterns**: None. Route dispatched every iter since block opened (219, 220, 221). No "off-critical-path" reclassification, no deferral language, no consecutive plan-only iters.
- **Prover status pattern (last 5 iters)**: INCOMPLETE (gate), COMPLETE, COMPLETE, COMPLETE, PARTIAL. The first and only PARTIAL is iter-221; PARTIAL ≥3-of-K is NOT triggered (1 of 5).
- **Throughput**: ON SCHEDULE — elapsed 3 iters since phase entry (iter-219), estimate ~6–12 iters. Actual pace has been ~1 sub-step per productive iter for iters 219–220; the slip in iter-221 costs ~0.5 extra iters at worst. Elapsed is within the lower bound of the estimate.
- **Verdict**: **CONVERGING**

**Assessment of the three directive questions:**

1. **Is this route CONVERGING, CHURNING, STUCK, or UNCLEAR?**
   CONVERGING. The formal sorry-count trajectory is flat (by design), but under the correct tracking metric (sub-step retirement), the route has retired 2 of 5 sub-steps in 2 productive iters and made genuine within-sub-step progress in iter-221 (primary target 1 fully retired; primary target 2's per-object content assembled). The single PARTIAL is the first such slip in 3 productive iters. No recurring blocker at ≥3 iters, no avoidance, no under-dispatch. The `Over.map` coherence obstacle is understood, has a recorded fix template, and does not constitute a churn signal at 2-iter recurrence.

2. **Is re-dispatching the same lane with the ported `hom_app_heq` trick the right move or a churn signal?**
   Right move. Churn is "add helpers and hope for a breakthrough." This is "apply a known technique (`hom_app_heq`/`subst`, proven in iter-220) to a named, precisely-reduced obstacle (the naturality field of `internalHomEval`)." The prover recorded the exact reduction path — `tensor_ext` → `internalHomEvalApp_tmul` simp lemma → `Over.map` coherence steps — and the iter-220 template to port. This is structural follow-through, not avoidance.

3. **Is "iter-222 returns PARTIAL with only more eval helpers and no assembled `internalHomEval` morphism" the correct stop-signal? Is there an earlier one?**
   Yes — that is the correct stop-signal. **An earlier trigger**: if iter-222's prover report says it successfully ported `hom_app_heq` AND it still failed to close the naturality field for a non-obvious reason not matching the iter-220 pattern (e.g., the reduction via `tensor_ext` does not reach `naturality_apply` as expected, or a new universe/instance obstacle appears that is NOT the `Over.map` coherence). That would indicate the obstruction is structurally deeper than the recorded reduction path suggests, and warrants immediate Mathlib-analogy consult before iter-223, rather than another dispatch iteration.

---

## PROGRESS.md dispatch sanity

- **File count**: 1 (cap: default 10)
- **Ready but not dispatched**: none identified — all other lanes are explicitly HELD per PROGRESS.md (RPF, FGA, Quot engine, Albanese cone, Route 2, WD, RCI, A.3.*)
- **Over the cap**: no
- **Under-dispatch finding**: no — single-file dispatch is appropriate for a single funded block with no other ready lanes
- **Iter-over-iter trend**: 1 → 1 → 1 (iters 219, 220, 221); consistent with the mathlib-build contract and the HELD lane structure
- **Verdict**: OK — file count 1 within cap 10, no under-dispatch; single-file pattern appropriate.

---

## Informational

**Watch item — `Over.map` coherence recurrence**: This blocker has now appeared in 2 consecutive iters (220 cracked it for `restrictionMap`; 221 did not crack it for `internalHomEval` naturality). If iter-222 reports it again despite the recorded `hom_app_heq` port, the counter hits 3 and the STUCK threshold is met. The plan agent should check for this explicitly when reading the iter-222 prover report. At that point the primary corrective would be **Mathlib analogy consult** — specifically, searching Mathlib for how `PresheafOfModules.Hom` naturality proofs are constructed when the restriction functor is defined through `Over.map` (there may be a cleaner abstraction boundary than what the prover is currently threading through).

**Blueprint enrichment (iter-222 parallel work)**: The blueprint-writer ts222 is dispatched to enrich `lem:internal_hom_eval`'s proof prose. This is the correct companion action — the assembly gap is recorded in the blueprint so the next sub-step's dispatch has complete written context. Not a sign of avoidance; it's the normal blueprint-maintenance cycle for a mathlib-build block.

---

## Overall verdict

One active route (Lane TS.dual), one verdict: **CONVERGING**. Sub-steps are retiring at roughly 1/productive iter; the first PARTIAL slip (iter-221) has a known, precedented, precisely-recorded fix. No recurring blocker at ≥3 iters, no avoidance, no under-dispatch. The plan agent should proceed with the iter-222 prover dispatch as proposed (complete sub-step 3, `internalHomEval` via ported `hom_app_heq`). The explicit stop-signal for the NEXT progress-critic round is: iter-222 returning PARTIAL with only more eval helpers and no `internalHomEval` morphism assembled, OR the `hom_app_heq` template failing in a structurally unexpected way — either triggers a mandatory Mathlib-analogy consult before iter-223 prover dispatch.
