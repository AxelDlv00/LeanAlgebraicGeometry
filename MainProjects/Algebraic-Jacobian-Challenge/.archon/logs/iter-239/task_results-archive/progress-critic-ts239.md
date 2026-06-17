# Progress Critic Report

## Slug
ts239

## Iteration
239

## Routes audited

### Route A — `Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 2 → 2 → 2 → 2 across iter-235 to iter-238. Completely flat for K=4 iters.
- **Helper accumulation**: 6 helpers added (3 Γ-fragment decls in iter-236; 3 route-iii decls in iter-237); 0 sorry reduction. Iter-235 and iter-238 were corrective iters with no prover dispatch. Net: 6 helpers, 0 sorry closed.
- **Prover dispatch pattern**: iter-235 = no prover (corrective); iter-236 = prover dispatched (1 file); iter-237 = prover dispatched (1 file); iter-238 = no prover (corrective). Pattern: corrective → prover → prover → corrective.
- **Recurring blockers**: "smul carrier wall" / "structure-sheaf smul carrier wall" appears across all 4 iters in the window. It is now at its **3rd section location** (`D(a)`), having migrated from the `⊤` level (iter-235 soundness probe) → Γ-level → `D(a)`. The wall does not disappear when addressed at one section location — it re-surfaces at the next.
- **Avoidance patterns**: None in the classical sense. Corrective iters (235, 238) were correctly structured as correctives, not avoidance. No deferral language persisting uncorrected.
- **Prover status pattern**: NO_PROVER, PARTIAL, PARTIAL, NO_PROVER. Two PARTIAL results, zero COMPLETE, zero INCOMPLETE.
- **Throughput**: ON_SCHEDULE — engine phase began ~iter-233; elapsed ~6 iters against STRATEGY.md estimate of ~30–60. Phase-level budget is not exhausted. However, the **specific sub-target** (`pushforward_spec_tilde_iso`) has been the focus since iter-234 (~5 iters) with zero sorry reduction — this sub-target is locally stalled even if the engine phase is on schedule globally.
- **Verdict**: **STUCK**

  All three STUCK rules are triggered simultaneously:
  1. Sorry count unchanged across K=4 iters (2→2→2→2).
  2. Recurring blocker phrase ("smul carrier wall") appears in every iter in the K-window (≥3).
  3. Helpers added (6) without any sorry-elimination across K iters.

**On the post-corrective re-engagement question:**

The iter-238 blueprint expansion was the correct corrective (the prover had no element-free recipe for the `D(a)` carrier wall; now it has one). This is NOT a verbatim re-dispatch — the target acquired material new information (the `e_{D(a)}` linear-equiv + ring equation + `IsLocalizedModule.of_linearEquiv`/`powers_restrictScalars` transport chain). **One post-corrective attempt is justified this iter.**

However, a structural risk flag is warranted: the smul carrier wall has recurred at **three distinct section locations** (`⊤` → Γ → `D(a)`). This pattern is consistent with an architectural issue in how the project accesses ring/module carriers across the structure sheaf, not a one-off proof gap. The blueprint expansion addresses the `D(a)` instance specifically, but nothing guarantees the wall won't re-surface at the next section boundary (e.g. a stalk or a different basic-open). If sorry count remains at 2 after this post-corrective dispatch, **do NOT issue a fourth blueprint expansion** — the corrective type must escalate.

- **Primary corrective (if sorry stays flat after iter-239)**: **Route pivot** — specifically, decompose `affineBaseChange_pushforward_iso` differently. The current route drives through `pushforward_spec_tilde_iso` → `hloc` → quasi-coherence, which requires taming the carrier wall at every section location. An alternative decomposition may be: establish quasi-coherence of the affine pushforward directly via `IsLocallyFreeOfRank` or a scheme-level `IsQuasicoherent` criterion, bypassing the localization-instance transport path entirely. The strategy-critic should review whether a non-`IsLocalizedModule` route for `hloc` is feasible before dispatching the next prover.
- **Secondary corrective (if pivot is needed)**: Mathlib-analogy consult specifically on `IsLocalizedModule.of_linearEquiv` over a varying structure ring — confirm whether this is the canonical Mathlib path or whether there is a more direct instance derivation that sidesteps the carrier wall.

---

### Route B — `Picard/TensorObjSubstrate.lean`: `IsInvertible.pullback` (FRESH)

- **Sorry trajectory**: N/A (fresh; 0 prior prover attempts).
- **Helper accumulation**: N/A.
- **Prover dispatch pattern**: 0 prior iters.
- **Recurring blockers**: None (no prior attempts).
- **Avoidance patterns**: None.
- **Prover status pattern**: N/A.
- **Throughput**: ESTIMATE_FREE (fresh sub-target; no per-sub-target estimate in STRATEGY.md).
- **Verdict**: **UNCLEAR** (fresh route; fewer than K iters of data)

**Churn-risk framing check:**

The backbone is confirmed present (`(extendScalars f).Monoidal` + `SheafOfModules.sheafificationCompPullback`). The mathematical argument is short: monoidal functors preserve invertible objects, and pullback on `SheafOfModules` is built from extension of scalars which is strong-monoidal. The framing does not exhibit the structural red flags that trigger churn cascades (no missing Mathlib infrastructure, no false-as-typed signature risk flagged, no gated predecessor still open).

**Minor churn risk to watch**: `SheafOfModules.sheafificationCompPullback` involves carrier transport through sheafification. If the project's `SheafOfModules` pullback instance has the same ring/module carrier mismatch as Route A's smul carrier wall (the smul instance is a presheaf-level construct that may not lift cleanly through the sheafification iso), this substrate could accumulate helper wrappers. This is speculative — the route is too fresh to confirm. **Watch for: if the first prover attempt adds ≥3 helpers without closing `IsInvertible.pullback`, escalate to Mathlib-analogy consult on sheafification-compPullback carrier semantics before the second dispatch.**

---

## PROGRESS.md dispatch sanity

Verdict: **OK** — 2 files dispatched (FlatBaseChange + TensorObjSubstrate), well within cap of 10. No ready-but-not-dispatched files omitted: `RelPicFunctor.lean` is correctly gated on the `IsInvertible.pullback` substrate landing before the carrier re-basing can begin; `HigherDirectImage.lean` is gap-blocked; `FGAPicRepresentability.lean` is gated post-RPF. The 2-file dispatch is not under-dispatch given the gating structure.

---

## Must-fix-this-iter

- **Route A (FlatBaseChange): STUCK — post-corrective re-engagement is ONE justified attempt.** The prover now has the element-free `D(a)` recipe it lacked. Allow exactly one post-corrective dispatch. If sorry count is still 2 at iter-239's review, the corrective type must escalate to **route pivot** (new decomposition of `affineBaseChange_pushforward_iso` that does not traverse `hloc` via `IsLocalizedModule.of_linearEquiv`); do NOT dispatch a fourth blueprint expansion. The structural recurrence of the smul carrier wall at 3 section locations is the signal that the current architectural path has a systemic friction point.

---

## Informational

- **Route B (TensorObjSubstrate `IsInvertible.pullback`): UNCLEAR** — fresh, backbone confirmed, framing is clean. One minor churn-risk marker: watch for ≥3 helper accumulation on the first attempt without closing the target. If that happens, consult Mathlib-analogy on `sheafificationCompPullback` carrier semantics before second dispatch.

---

## Overall verdict

One route is STUCK (FlatBaseChange, sorry flat for K=4, smul carrier wall recurring at 3 section locations), one route is UNCLEAR (IsInvertible.pullback, fresh). The STUCK route's post-corrective re-engagement for iter-239 is **sound for exactly one attempt** — the prover now has a materially new element-free recipe. The planner should treat this as the last blueprint-expansion-class corrective: if sorry count remains 2 after iter-239's review, the next action is a route-pivot consultation (strategy-critic + Mathlib-analogy on a non-`IsLocalizedModule` path for `hloc`), not a fifth blueprint expansion. Dispatch sanity is OK; no avoidance patterns detected.
