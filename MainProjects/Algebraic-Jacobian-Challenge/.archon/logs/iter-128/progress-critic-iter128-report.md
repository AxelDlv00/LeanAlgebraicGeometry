# Progress Critic Report

## Slug
iter128

## Iteration
128

## Routes audited

### Route: M2.a `rigidity_over_kbar`

- **Sorry trajectory**: 1 (NEW iter-126) → 1 (iter-127). Stable since scaffold introduction; 2 iters of data.
- **Helper accumulation**: 1 scaffold (iter-126) + 0 Lean / +101 blueprint LOC (iter-127). No accumulation in the .lean file post-scaffold.
- **Recurring blockers**: none — no prover attempt has been made on this declaration.
- **Prover status pattern**: N/A (gated route; no dispatch).
- **Verdict**: UNCLEAR
- **Reasoning**: Fresh route with only 2 iters of data and no prover signal. The planner is NOT proposing prover work on this route this iter (deferred to iter-143+ per the shared pile dependency). Cannot detect churn or stall without prover engagement; pre-prover scaffold + blueprint expansion is appropriate setup work. Re-evaluate once piece (i)/(ii)/(iii) are closed and the body closure becomes reachable.

### Route: M2.b `genusZeroWitness`

- **Sorry trajectory**: 1 (NEW iter-127). 1 iter of data.
- **Helper accumulation**: 1 scaffold (iter-127) + 31 blueprint LOC. No iter-128 plan-time additions.
- **Recurring blockers**: none — no prover attempt.
- **Prover status pattern**: N/A.
- **Verdict**: UNCLEAR
- **Reasoning**: Single-iter fresh route, no prover dispatch yet, and planner is not proposing prover work here this iter. Closure gated on M2.a body (iter-145+). No signal to judge convergence.

### Route: META-PATTERN (consecutive plan-phase-only iters)

- **Sorry trajectory**: −1 (iter-125, Rigidity refactor) → 0 net (iter-126, M1 excise −1, M2.a scaffold +1) → +1 (iter-127, M2.b scaffold). Net across 3 iters: 0. Trend is *worsening* (each iter closes less and adds more).
- **Helper accumulation**: 3 iters, ≥1 new declaration in 3 of 3 iters; blueprint LOC growing in 2 of 3 iters.
- **Recurring blockers**: meta-blocker — "no prover dispatch fires" in 3 consecutive iters. iter-127 progress-critic explicitly named iter-128 as the TRIPWIRE.
- **Prover status pattern**: N/A × 3 (no dispatch any of the 3 iters).
- **Verdict**: **CHURNING**
- **Reasoning**: Verdict rule "helpers added in ≥2 of last K iters AND sorry count net unchanged or down by <1 per 2 iters" matches. The structural-change-exemption does NOT apply: the planner's meta-strategy across all 3 iters has been the *same* ("more refactor + scaffold + blueprint, defer prover"). The structural changes inside that meta-strategy (refactor vs excise vs scaffold) are tactical variations on a single pattern of prover-deferral.

- **Primary corrective**: PROVER DISPATCH this iter (as the planner already proposes), with a binding iter-129 guard. The planner's iter-128 proposal IS a real corrective — same-iter prover dispatch is not plan-phase-only by any honest reading, regardless of whether the dispatch closes its target. Crediting the corrective is correct *for this iter*. But the corrective is fragile: the refactor adds +1–2 new sorries that the same-iter prover may not close. If iter-128 ends with the prover returning PARTIAL/INCOMPLETE on `lieAlgebra`, the net signal will be: another iter of helpers added with no prover closure, and the CHURNING verdict hardens.

- **Secondary corrective**: explicit binding rule for iter-129 — see "Must-fix-this-iter" below. The planner asked for this in directive question 3; I am answering YES, codify it.

### Route: NEW iter-128 piece (i.a) `AlgebraicGeometry.GrpObj.lieAlgebra`

- **Sorry trajectory**: 0 → 1 or 2 (new this iter from refactor scaffold).
- **Helper accumulation**: 1–2 new declarations this iter (`lieAlgebra`, optionally `lieAlgebra_finrank_eq_dim`).
- **Recurring blockers**: none — fresh route.
- **Prover status pattern**: pending this iter.
- **Verdict**: UNCLEAR
- **Reasoning**: Fresh route; no signal until the iter-128 prover returns. Watch this slot — its outcome decides whether the META-PATTERN verdict stays CHURNING or escalates to STUCK at iter-129.

## Must-fix-this-iter

- **Route META-PATTERN: CHURNING — primary corrective: PROVER DISPATCH this iter (already in plan).**
  Why: 3 consecutive plan-phase-only iters with net 0 sorry closure and a worsening per-iter trend. The planner's same-iter prover dispatch on `lieAlgebra` is the binding corrective. It is **non-optional** — if for any operational reason the prover lane does not actually fire on a real Lean file this iter, the verdict immediately flips to STUCK and the planner must pause for user escalation rather than re-plan.

- **Route META-PATTERN: SECONDARY corrective — codify the iter-129 fallback rule NOW, in iter-128's `plan.md`.**
  Why: the planner asked (directive Q3). Concrete rule to write into iter-128 plan.md:

  > If iter-128 prover returns INCOMPLETE or PARTIAL-with-`lieAlgebra`-still-`sorry`, then iter-129 MUST NOT:
  >   (a) scaffold any new declaration on M2.a / M2.b / M3 routes,
  >   (b) expand any blueprint chapter,
  >   (c) refactor any file.
  > Iter-129 MUST do exactly one of:
  >   (1) dispatch `mathlib-analogist` on `AlgebraicGeometry.GrpObj.lieAlgebra` with directive "find the exact mathlib pattern for `eta_G^* Omega_{G/k}` as finite-free k-module; flag if the project's `relativeDifferentialsPresheaf` infra is insufficient"; THEN re-dispatch prover on the same target with the analogist's findings, OR
  >   (2) escalate to user with explicit ask: "should we (a) substitute a smaller intermediate target, (b) accept a stronger Mathlib smoothness import, or (c) treat `lieAlgebra` as an axiomatized hypothesis for now and let M2.a body closure proceed Modulo that hypothesis?"
  >
  > Iter-129 MAY NOT propose "another scaffold + prover round" on a *different* M2/M3 sub-piece as the corrective — that pattern, repeated once more, would constitute the helper-churn failure mode this guard exists to prevent.

## Informational

- **Route M2.a `rigidity_over_kbar`: UNCLEAR.** Gated route. The planner correctly is not assigning prover work here this iter. Re-evaluate when the shared pile pieces (i)/(ii)/(iii) close.
- **Route M2.b `genusZeroWitness`: UNCLEAR.** Single-iter fresh scaffold, no prover work proposed. No corrective needed.
- **Route NEW lieAlgebra: UNCLEAR.** Fresh route. Its iter-128 prover outcome is the load-bearing signal for the META-PATTERN verdict next iter.

## Answers to the planner's specific questions

**Q1 — Is the iter-128 META-PATTERN TRIPWIRE prover dispatch a real corrective, or still plan-phase-only?**

REAL corrective for *this iter only*. Same-iter prover dispatch is by definition not plan-phase-only; the planner's framing is honest. BUT the corrective is fragile: the refactor adds +1–2 sorries that the same-iter prover may not close. If iter-128 closes nothing, the iter looks (in signal terms) like "+2 helpers, 0 sorry-elimination" — exactly the helper-churn pattern that defines STUCK. The corrective is therefore conditional: it lands as a real corrective if the prover closes at least one of the new declarations; it lands as another iter of churn if the prover returns INCOMPLETE on both.

**Q2 — Is `lieAlgebra` appropriately sized for a 1-iter close-or-PARTIAL outcome?**

Borderline-too-ambitious. The target's mathematical content (pullback of a presheaf of modules along the identity section, free-k-module structure via smoothness, finite-rank lemma via dimension theory) involves three distinct Mathlib infrastructure layers (`PresheafOfModules` pullback, smoothness/regularity, Krull dimension). One-iter close is optimistic absent a pre-existing mathlib pattern that matches all three. PARTIAL is the realistic outcome (probably: `lieAlgebra` defined, `lieAlgebra_finrank_eq_dim` left as `sorry`). The planner's framing already admits this as the "PARTIAL with narrower residual" branch — that framing is correct. The risk is that "PARTIAL" turns out to mean both decls still `sorry`, i.e. INCOMPLETE in critic-signal terms.

Recommendation: the iter-128 plan should pre-commit to a stricter PARTIAL definition — "at minimum, `lieAlgebra` body closes (no `sorry`) by end of iter-128, even if `lieAlgebra_finrank_eq_dim` remains open" — so the iter-129 fallback rule has a sharp trigger condition.

**Q3 — Iter-129 fallback rule?**

YES, codify one. See the "Must-fix-this-iter" secondary corrective above for the concrete rule text.

## Overall verdict

Four routes audited: two UNCLEAR (fresh / gated, no signal), one UNCLEAR (the new iter-128 lieAlgebra target), and one CHURNING (the META-PATTERN of three consecutive plan-phase-only iters). The planner's iter-128 same-iter prover dispatch is a real, if fragile, corrective and should proceed — but the planner MUST codify the iter-129 fallback rule in `plan.md` so the corrective has a sharp termination condition. The iter's success or failure is now load-bearing on the `lieAlgebra` prover outcome: a single-`sorry`-closure is enough to flip META-PATTERN toward CONVERGING; two unresolved sorries flips it to STUCK and forces user escalation.
