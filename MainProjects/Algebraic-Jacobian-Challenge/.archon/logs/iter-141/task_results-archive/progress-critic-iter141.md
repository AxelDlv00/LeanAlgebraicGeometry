# Progress Critic Report

## Slug
iter141

## Iteration
141

## Routes audited

### Route: piece (i.b) Step 2 in `Cotangent/GrpObj.lean`

- **Sorry trajectory (the 3 sub-sorry residual since iter-138 decomposition)**:
  - iter-136 end: 1 / 1 (Main only; Step 3 already closed)
  - iter-137 end: 1 / 1 (plan-only — no Lean change)
  - iter-138 end: 3 / 4 (the *decomposition* iter — went from 1 hollow `sorry` to 3 narrow well-typed sub-sorries via the helper-pair refactor; d_add + d_mul closed honestly)
  - iter-139 end: 3 / 4 (plan-only, intentional HARD GATE deferral)
  - iter-140 end: 3 / 4 (unchanged in strict count)
  - Net across the K-window: 3 → 3 → 3 on the residual three sub-sorries across 3 consecutive iters of plan-attention; **0 sub-sorries strictly closed across 2 prover dispatches (iter-138, iter-140) on this residual**.

- **Helper accumulation**:
  - iter-138: +2 helpers (`basechange_along_proj_two_inv_derivation` ~38 LOC + `basechange_along_proj_two_inv` ~15 LOC, plus ~11 LOC docs) — ~64 LOC + docs.
  - iter-139: 0 Lean changes; +468 LOC blueprint expansion on a *different* chapter (`RigidityKbar.tex`).
  - iter-140: +1 private helper `isIso_of_app_iso_module` (~5 LOC body + 7 LOC doc) + d_app `change`-tactic scaffolding (~17 LOC) + d_map closure-recipe docstring (~18 LOC) + a new import — ~47 LOC.
  - **Cumulative**: ~111 LOC of (i.b) Step 2-side helper/scaffold build across iter-138 + iter-140 (plus iter-138/140 docstrings ~298 LOC across the route's history). **Payoff in strict-count terms: zero residual reduction across iter-138 → 140.**

- **Recurring blockers**:
  - "PresheafOfModules.pullback chart-opacity" — iter-137 blocker, *resolved* iter-138 via the helper-pair refactor; did NOT recur in iter-140. (Credit to the planner.)
  - "well-definedness of d_app + cross-open d_map naturality + IsIso check" — the iter-138-introduced decomposition; **same three sub-sorries open at iter-140 end**.
  - NEW iter-140 blocker phrase: "deterministic `whnf` timeout at `maxHeartbeats=200000` on `(pushforward ψ).obj.map` opacity" — surfaced for d_map specifically; the iter-140 prover attempted a `change`-based approach and reverted, committing only the docstring. This is a *different* opacity in the *same family* as iter-137's blocker (both are presheaf-of-modules adjunction-side `.obj`/`.map` opacities); the previous family-member required a structural refactor (the iter-138 helper-pair) to clear.

- **Prover status pattern (this route only)**:
  - iter-138: PARTIAL — substantive body cut (1 hollow → 3 narrow), d_add + d_mul honestly closed.
  - iter-139: n/a (plan-only deferral).
  - iter-140: PARTIAL — 0 of 3 strict-count sub-sorries closed; private helper added; IsIso narrowed from whole-iso to per-open iso; d_app factoring-lemma recipe validated standalone via `lean_run_code` (NOT committed); d_map `change` reverted on whnf timeout.
  - Effective sequence over the K-window restricted to iters with prover dispatch on this route: **PARTIAL → PARTIAL**, with the iter-140 PARTIAL specifically pre-committed by the iter-140 planner as the CHURNING-trigger outcome.

- **Verdict**: **CHURNING**

  Reasoning:
  1. The progress-critic CHURNING rule fires verbatim: helpers added in ≥2 of the last K iters (iter-138 substantively, iter-140 substantively; iter-139 plan-only doesn't count against this prong) AND sorry count net unchanged across the 3 prover-attentive iters of the K-window (3 → 3 → 3 on the residual sub-sorries) AND a PARTIAL prover-status sequence on this route's residual.
  2. The "no structural change in approach" prong of the CHURNING rule is the only one with genuine ambiguity. iter-140 *did* deliver structural change — the per-open IsIso narrowing via `isIso_of_app_iso_module` and the d_app factoring-lemma standalone-validated recipe are real. But progress-critic exists precisely to call out the pattern "we added 4 wrapper helpers this iter to set up next iter's closure — for the third iter in a row." The iter-140 planner anticipated this and *pre-committed* the strict-count criterion: "PARTIAL = CHURNING-trigger." That was the right discipline. Softening it post-hoc on the strength of "structural advances are real" would undo the planner's own pre-registration and is exactly the bias progress-critic is the corrective for.
  3. The 4-consecutive-iter focus on the same M2.body-pile piece (i.b) Step 2 (iter-138 → 139 → 140 → 141 planning) without strict-count progress is the textbook helper-churn pattern. The new opacity blocker phrase in iter-140 is *different* enough from iter-137's that it doesn't push to STUCK, but it's in the same family — adjunction-side `.obj`/`.map` opacity — which strengthens, not weakens, the CHURNING read: the previous instance needed a structural escalation (helper-pair refactor) to clear, and the new instance is now sitting open.
  4. Re. the directive's explicit question on UNCLEAR: no. UNCLEAR is for "not enough signal yet." We have K=5 of signal, two prover dispatches on the same residual, and a planner-pre-registered CHURNING-trigger that fired. That's plenty of signal.

- **Primary corrective**: **Mathlib-analogist consult**, specifically scoped to the iter-140 NEW blocker phrase "`(pushforward ψ).obj.map` whnf-opacity at `maxHeartbeats=200000`."

  Why this and not another: the *previous* instance in this opacity family ("PresheafOfModules.pullback chart-opacity", iter-137) was resolved by a targeted analogist consult that led to the iter-138 helper-pair refactor recipe. The same shape of escalation is now warranted for the d_map sub-sorry. A consult should specifically ask: which `PresheafOfModules` / `Scheme.Modules` adjunction lemma(s) let you compute `(pushforward φ).obj.map f` on a chart without `change` invoking `whnf` on the adjunction-transposed presheaf? Candidates the iter-140 prover did not exhaust: explicit `Adjunction.pushforward_obj_map`-style lemmas in `Mathlib.AlgebraicGeometry.Modules.*`, or `PresheafOfModules.{pushforward,pullback}` unfolding lemmas. The consult is targeted (one named blocker), inexpensive (one analogist dispatch), and has direct precedent (iter-137 → iter-138).

  This corrective is also compatible with the iter-141 plan *also* directing the prover to commit the iter-140-validated d_app `lean_run_code`-standalone factoring-lemma recipe — that's already-discovered work and should land regardless of the corrective. But the *route corrective* is the analogist consult on d_map's new opacity, because that is the unresolved escalation.

- **Secondary correctives** (priority order, only if primary returns insufficient):
  1. **Refactor** — if the analogist's lemma recipe requires structural rearrangement of `basechange_along_proj_two_inv_derivation` (parallel to the iter-138 helper-pair restructuring), dispatch the refactor subagent with the analogist's recipe as the directive. Keep this *behind* the analogist consult — we don't know the right refactor until the consult names the lemma.
  2. **Route pivot** — if both above fail in iter-141, the planner should reopen pivot to one of the off-route M-piece bodies (M2.a / M2.b / M3 / piece (iii)) flagged in the directive as available alternatives. Five consecutive iters of attention on (i.b) Step 2 without strict-count closure would be the breakeven point for re-justifying the route under strategy-critic. **Do NOT recommend this in iter-141** — analogist has not yet been tried on the new blocker.

## Must-fix-this-iter

- **Route piece (i.b) Step 2 in `Cotangent/GrpObj.lean`**: **CHURNING** — primary corrective: **mathlib-analogist consult on `(pushforward ψ).obj.map` whnf-opacity blocker phrase**. Why: the iter-140 planner pre-registered PARTIAL = CHURNING-trigger and it fired (0 / 3 strict-count); the new opacity blocker is in the same family as the iter-137 blocker that previously required a targeted analogist consult to clear, and analogist has not yet been dispatched on this new instance.

## Informational

None this iter — the directive scopes me to one route, and that route is CHURNING.

## Overall verdict

One route audited; one CHURNING verdict. The planner's correct iter-141 move is **NOT** to dispatch another prover lane on the three sub-sorries unchanged — that would be the 3rd prover-iter on the same residual with the same toolset. The correct move is (a) dispatch a mathlib-analogist consult scoped to the iter-140 NEW blocker phrase `(pushforward ψ).obj.map` whnf-opacity, and (b) if a prover lane is dispatched in iter-141 at all, it should be narrowly tasked with *committing* the iter-140-validated d_app `lean_run_code`-standalone factoring-lemma recipe (already-discovered work that didn't land), NOT another exploration round on d_map or IsIso. If the planner wants to override this verdict, the override should appear as an explicit rebuttal in `iter/iter-141/plan.md` naming why the strict-count CHURNING-trigger that iter-140 pre-registered no longer applies — and "structural advances were made in iter-140" is not a sufficient rebuttal, because that's exactly the helper-accumulation pattern the trigger was pre-registered against.
