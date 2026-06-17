# Progress Critic Report

## Slug
iter143

## Iteration
143

## Routes audited

### Route: piece (i.b) Step 2 BUNDLED 3-sub-sorry closure on `AlgebraicJacobian/Cotangent/GrpObj.lean`

- **Sorry trajectory**: 3 → 3 → 3 → 3 → 2 across iter-138 to iter-142.
  Net change: −1 over K=5 (≈ −0.2/iter), well below the 0.5/iter
  threshold (i.e. "down by <1 per 2 iters" of the CHURNING rule).
  iter-142's d_map closure is the FIRST strict-count closure on this
  route since the iter-138 decomposition refinement; iter-138's "3"
  was a hollow-1 → narrow-3 decomposition, not a strict reduction.

- **Helper accumulation**: +3 helpers across K=5 (+2 iter-138
  decomposition of d_add + d_mul + d_app + d_map + IsIso into typed
  sub-sorries, +1 iter-140 `isIso_of_app_iso_module`). Helpers added
  in 2 of the 5 iters (iter-138, iter-140) — meets the ≥2-of-K
  threshold; sorry-elimination payoff is 1 closure (iter-142 d_map)
  against +3 helpers. Helper-to-closure ratio: 3:1.

- **Recurring blockers**:
  - "categorical chase / factoring witness `h`" — iter-138, iter-140;
    resolved for d_map at iter-142 (via `NatTrans.naturality_apply`
    packaging); **STILL LIVE for d_app**.
  - "per-open IsIso identification" — iter-140 (narrowing), iter-141
    (plan), iter-142 (prover priority-deferred) → **3 iters, STILL
    LIVE**.
  - "`whnf` opacity / `pushforward₀`" — iter-140 only (resolved via
    iter-141 + iter-142 fully-explicit `change` skeleton + named-lemma
    swap; codified into iter-142 Knowledge Base entry). Closed.
  - NEW iter-142: "Step 3 adjunction-transpose chase ~20–40 LOC
    bespoke NEEDS_MATHLIB_GAP_FILL" — d_app residual after iter-142
    `change`-skeleton refinements; not yet seen across multiple iters
    so doesn't trigger the recurring-blocker arm, but is a fresh
    Mathlib-gap signal.

- **Prover status pattern**: PARTIAL, plan-only (iter-139), PARTIAL,
  plan-only (iter-141), PARTIAL. That is **3 PARTIAL in K=5** (the 2
  plan-only iters are HARD-GATE-driven deferrals, not active prover
  outcomes). PARTIAL ≥3 of K triggers the OR clause of CHURNING.

- **Verdict**: **CHURNING** (CHURNING-CONFIRMED, agrees with the
  iter-142 pre-commit on the PARTIAL acceptance arm).

  Two independent CHURNING rules fire:
  1. PARTIAL prover status ≥3 of last K iters (3 of 3 active iters).
  2. Helpers added in ≥2 of last K iters (iter-138 +2, iter-140 +1) AND
     sorry count net change of −1 over K=5 is below the 0.5/iter
     threshold AND the approach is the same "structural decomposition
     into sub-sorries on the bundle" across the window.

  Note: iter-142's d_map closure via the `NatTrans.naturality_apply`
  packaging IS a positive structural technique-advance — it's the
  first new closure technique to land on this route in K=5. By
  itself this is not enough to flip the verdict (PARTIAL ≥3 fires
  unconditionally), but it modulates the corrective: this route is
  CHURNING-with-positive-signal, not CHURNING-and-stalling.

- **Primary corrective**: **Refactor — extract IsIso into a named
  sorry-bodied theorem, narrowing iter-143's prover lane to d_app
  only** (closest match to the planner's option (c), which itself is
  also the lean-auditor-review142 MAJOR remediation).

  Why: the size mismatch within the bundle is structural. d_app is
  ~40–80 LOC and the iter-142 d_map closure technique
  (`NatTrans.naturality_apply` rw-show packaging) likely generalizes.
  IsIso is ~195–365 LOC and lives in Route (b'2) territory that the
  iter-142 prover priority-deferred. Keeping them coupled in one
  bundle is what's producing the PARTIAL chain — every iter the
  prover closes part and the bundle stays sorry-bodied.

  Extracting IsIso into a named sorry-bodied theorem:
  (a) makes the residual auditable (fixes lean-auditor-review142
      MAJOR);
  (b) narrows iter-143's bundle to d_app + the Step 3
      adjunction-transpose Mathlib-gap question, where iter-142's
      technique-advance is most likely to convert to a strict-count
      closure;
  (c) lets IsIso be addressed in iter-144+ as a clean, separately-
      scoped prover round (or as a separate Route (b'2)-aligned
      consult round) without dragging d_app's iter through it again.

- **Secondary correctives**:
  - **Mathlib analogy consult on the d_app Step 3 adjunction-
    transpose**, *conditional* on the d_app prover round actually
    encountering the NEEDS_MATHLIB_GAP_FILL signal. Not pre-emptive.
    This is a follow-on if the iter-143 d_app round itself stalls on
    Step 3.
  - The pre-committed (e) "mid-iter strategy-critic with DIAGNOSTIC
    question" is reasonable strategy hygiene but does not by itself
    move the residual. From the signal level, prefer (c) AS the
    corrective and let the strategy-critic DIAGNOSTIC fire iff (c)
    surfaces a definition-level or strategy-level failure (i.e. if
    extracting IsIso reveals the named theorem is unstatable in its
    current shape).

## Must-fix-this-iter

- Route A (piece (i.b) Step 2 bundle on `Cotangent/GrpObj.lean`):
  **CHURNING** — primary corrective: refactor to extract IsIso into
  a named sorry-bodied theorem (planner option (c)). Why: 3-of-3
  active iters PARTIAL on the same bundle; size mismatch d_app
  ~40–80 LOC vs IsIso ~195–365 LOC is producing artificial coupling
  and the iter-142 d_map technique-advance can convert to a strict
  closure ONLY if d_app is the iter-143 scope.

## Informational

- The iter-142 strict-count closure (d_map) is the first structural
  closure-technique advance in K=5 on this route. It is a genuinely
  positive signal — it just isn't enough on its own to flip the
  PARTIAL-ratio out of CHURNING with K=5 of data. If iter-143
  closes d_app via the same technique generalization, K=5 at
  iter-144 will read 3 → 3 → 3 → 2 → 1 with 2 closures in the
  window and PARTIAL only in 1–2 of K — that will resolve toward
  CONVERGING.

- **Question 3 (5-consult overhead axis)**: from the signal level,
  the consult-overhead axis does NOT shift my verdict. Only iter-137
  widened the envelope; the envelope-widening ≥3 arm has not fired;
  the consult-count ≥5 arm was demoted to a calibration watchpoint
  by `strategy-critic-iter140` Edit-2 with revisit at iter-150. So
  a 6th mathlib-analogist consult on Route (b'2) IsIso-specific
  details is not gated. Whether to spawn one is a strategy-critic
  decision, not a progress-critic one; from the convergence-signal
  point of view, if iter-143 follows the primary corrective (extract
  IsIso, narrow to d_app), then a 6th consult on IsIso would be
  premature — IsIso is not the iter-143 target. If the planner
  rebuts the corrective and keeps IsIso in the iter-143 bundle, then
  the 6th consult becomes more defensible, but that path also keeps
  the PARTIAL chain alive.

- **Pre-commit alignment**: my verdict CHURNING-CONFIRMED matches
  the iter-142 PROGRESS.md PARTIAL-arm pre-commit. My primary
  corrective (refactor / option (c)) differs from the pre-commit's
  (e) DIAGNOSTIC. Per descriptor rules, the planner must follow my
  corrective or rebut explicitly in iter-143's plan.md naming why
  my read is wrong. The DIAGNOSTIC route is not blocked by my
  corrective — it can run in parallel (the strategy-critic
  DIAGNOSTIC is a low-cost informational consult, while the refactor
  is the structural action that actually unblocks the bundle).

## Overall verdict

One route audited; one CHURNING (with positive iter-142 signal). The
iter-143 plan should: (1) refactor IsIso out of the
`basechange_along_proj_two_inv_derivation` bundle into a named
sorry-bodied theorem (planner option (c)), (2) dispatch the prover
lane on d_app only, applying generalization of iter-142's
`NatTrans.naturality_apply` packaging technique, (3) optionally
fire the iter-142-pre-committed mid-iter strategy-critic DIAGNOSTIC
in parallel — it does not gate the prover lane and is cheap insurance
against a definition-level failure surfacing during the IsIso
extraction. Spawning a 6th mathlib-analogist on IsIso is NOT
recommended for iter-143; defer to iter-144+ when IsIso is the
prover target.
