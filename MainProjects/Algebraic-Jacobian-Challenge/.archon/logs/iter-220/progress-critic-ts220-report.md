# Progress Critic Report

## Slug
ts220

## Iteration
220

## Routes audited

### Route: A.1.c.SubT.dual — Lane TS (`Picard/TensorObjSubstrate.lean`)

- **Sorry trajectory**: 81 → 81 → 80 → 80 → 80 across iter-215 to iter-219 (net −1 over 5 iters; sole close at iter-217)
- **Helper accumulation**: ~25 decls added across 5 iters (3 + 6 + 5 + 0 + 11); 1 sorry closed. Sub-phase A.1.c.SubT.dual itself: 11 decls in iter-219, 0 sorries closed (by design — sorry closure is sub-step 5 of 5).
- **Prover dispatch pattern**: 1 file dispatched each iter; no competing ready files identified in the directive.
- **Recurring blockers**: "Mathlib-absent dual" appears at iter-218 and iter-219 — but this is the *named target* of the mathlib-build sub-phase, not a failure blocker that the prover keeps hitting. It is the reason the sub-phase exists, not evidence the sub-phase is failing.
- **Avoidance patterns**: none detected. The INCOMPLETE at iter-218 was a pre-committed gate (documented), not deferral. The entry into the mathlib-build at iter-219 is a structural phase change, not a pivot-without-plan.
- **Prover status pattern (5-iter)**: PARTIAL → PARTIAL → COMPLETE → INCOMPLETE → PARTIAL.  
  Decomposed: iters 215–216 built substrate, iter-217 closed the linchpin sorry, iter-218 fired the designed gate, iter-219 opened the mathlib-build sub-phase.
- **Throughput**: ON SCHEDULE — sub-phase A.1.c.SubT.dual entered at iter-219 (elapsed = 1 of ~6–12 iters). The 5-iter window predates the sub-phase and cannot be read against its estimate.

---

#### Sub-phase verdict (A.1.c.SubT.dual, the directive's primary question)

**Verdict: UNCLEAR** — the sub-phase has exactly 1 iter of data, which is below the K-iter threshold for a CONVERGING declaration. Signals are unambiguously positive (see findings below), but the rules require K data points before CONVERGING can be asserted.

#### 5-iter route view (secondary, for context)

The PARTIAL×3 rule is mechanically triggered (PARTIAL in 3 of 5 iters), which would ordinarily yield CHURNING. However, the three PARTIAL iters are NOT homogeneous:

- iter-215–216 (PARTIAL×2): genuine substrate-building, not aimless helper accumulation. The helpers in these iters were prerequisites for the iter-217 linchpin close.
- iter-219 (PARTIAL): first iter of a new funded sub-phase with a named decomposition. PARTIAL is expected — sub-step 1 was the entire target.

The COMPLETE at iter-217 closed a real sorry (81→80, `tensorObj_restrict_iso` eliminated). The INCOMPLETE at iter-218 was a designed gate. These are not "PARTIAL → nothing" cycles. The PARTIAL×3 trigger reflects phase-crossing noise, not helper-churn dynamics.

**5-iter route verdict: CHURNING (rule triggered)**, but the corrective is already in place: the mathlib-build sub-phase IS the structural response to the Mathlib gap, and it entered correctly at iter-219 with a clean sub-step 1 completion. No additional corrective beyond tracking the sub-phase against its own K-iter estimate.

---

#### Findings on the directive's three specific questions

**Q1. Is iter-219's output a convergent brick?**

Yes. The 11 decls (`homModule`, `internalHomObjModule`, and 9 helpers) are foundational, not wrappers around a wrong definition. They build the value module `ℋom(M,N)(U) = ModuleCat(R(U))(M|_U, N|_U)`, which is the literal base object that restriction maps operate on in sub-step 2. The handoff is precise (restriction maps for `V ↪ U` open immersion + presheaf assembly), directly actionable, and targets a concrete Lean declaration (`PresheafOfModules.internalHom`). Sub-step 1 is retired: the gotchas documented (CommRingCat/RingCat carrier duality, `map_add` ambiguity, `ModuleCat.of` fragility) reduce the residual risk for sub-step 2. This is the cleanest sub-step retirement signal the sub-phase could have produced at iter-1.

**Q2. Is dispatching sub-step 2 the correct next move?**

Yes. The build decomposition is linear: value module → restriction maps + presheaf assembly → dual + evaluation → sheaf condition → discharge. Sub-step 1 is verified done (11 axiom-clean decls). Sub-step 2's target (`PresheafOfModules.internalHom`) is named, and the value-module definitions are exactly the payload that restriction map construction needs to act on. No sign of build mis-shape: the helpers at iter-219 are data (the `R(U)`-module), not bureaucratic wrappers, and they have a direct use in sub-step 2. Dispatching sub-step 2 is the correct move.

**Q3. Is there a churn or stuck pattern?**

No churn pattern at the sub-phase level. The 5-iter PARTIAL×3 trigger is real but explained by phase-crossing (substrate-build era vs. sub-phase era). Within the sub-phase itself (1 iter), the helper-to-payoff ratio is high: 11 decls retire exactly 1 named sub-step. Crucially, the helpers are not accumulating *around* the target definition — they *are* the target definition (the value module is sub-step 1). If the build were mis-shaped, we would see helpers that don't appear in the decomposition, or a definition whose type turned out wrong. No such signal here.

The one legitimate watch item: the value-module definitions memo "ModuleCat.of of hom-module fragile" as a gotcha. If restriction maps require repeated `ModuleCat.of` manipulations, the fragility could produce a PARTIAL at iter-220 without structural progress. This is not yet churn — it is a risk to monitor at iter-221 if iter-220 produces a PARTIAL with helpers accumulated around the same gotcha.

---

## PROGRESS.md dispatch sanity

Verdict: OK — file count 1 (TensorObjSubstrate.lean), within any reasonable cap; no other files identified as ready-but-not-dispatched. Single-file dispatch is appropriate for a named mathlib-build sub-phase; no under-dispatch finding.

## Must-fix-this-iter

- **Route A.1.c.SubT.dual: CHURNING** (5-iter PARTIAL×3 rule triggered) — primary corrective: **the corrective is already in place** (the mathlib-build sub-phase). The planner must ensure that the sub-phase is tracked against its own K-iter estimate (~6–12 iters from iter-219), and that sorry-count-per-iter is NOT used as the convergence metric until sub-step 5. If the planner's iter-220 plan still evaluates this route by sorry-count trajectory rather than sub-step retirement, re-classify as CHURNING by avoidance.

  No additional corrective type is warranted: blueprint is detailed (sec:tensorobj_dual_infra), Mathlib-idiom analysis was already done (hence the sub-phase structure), refactor is not indicated (sub-step 1 looks correct), and pivot is out of scope (the mathlib-build is the alternative to pivot).

## Informational

The UNCLEAR verdict for the sub-phase will resolve to CONVERGING or CHURNING by iter-221 (2 iters of sub-phase data). The signal to watch: at iter-220, does sub-step 2 produce a named `PresheafOfModules.internalHom` with restriction maps, or does it produce more value-module helpers without assembly? The former is CONVERGING; the latter is the first real churn signal for the sub-phase.

Throughput is on schedule (elapsed 1 of 6–12). The planner has 5–11 more iters before the estimate is in question. No throughput escalation needed this iter.

## Overall verdict

One route audited. The sub-phase A.1.c.SubT.dual (iter-219 entry) is UNCLEAR by rule — 1 iter of data — with strongly positive signals: sub-step 1 retired with 11 axiom-clean decls, precise handoff to sub-step 2, on schedule. The 5-iter route view triggers CHURNING by PARTIAL×3, but the corrective (the mathlib-build sub-phase) is already in place and was entered correctly. The must-fix is procedural: the planner must track the sub-phase against its own K-iter estimate, not the prior sorry-count metric. Dispatch sub-step 2 (restriction maps + presheaf assembly) this iter — no blocking reason to delay.
