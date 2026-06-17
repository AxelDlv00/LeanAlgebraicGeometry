# Progress Critic Directive — iter-143

## Slug
iter143

## Active route this iter

**Route A: piece (i.b) Step 2 BUNDLED 3-sub-sorry closure on
`AlgebraicJacobian/Cotangent/GrpObj.lean`**

Only one route is active in iter-143's prover-lane consideration.
Other files (`Jacobian.lean`, `RigidityKbar.lean`) are off-critical-path
this iter (gated on M2.a body close iter-151+ + M2.b body close iter-153+).

## K=5 signal extract for Route A (iters 138–142)

Sub-sorry count on the d_app + d_map + IsIso bundle:

| Iter | Sub-sorries on bundle (entry) | Bundle (close) | Strict-count net | Prover status |
|---|---|---|---|---|
| 138 | (entry: 1 hollow sorry inside `basechange_along_proj_two_inv_derivation` + 1 in `relativeDifferentialsPresheaf_basechange_along_proj_two`) → close: 3 narrow sub-sorries (d_app + d_map + IsIso) | 3 | hollow-1 → narrow-3 (decomposition refinement; +2 sub-sorries because the hollow scaffold split into 3 well-typed sub-sorries; d_add + d_mul of the pointwise derivation closed honestly at the same time) | PARTIAL (structural Route (b) skeleton landed end-to-end; d_add + d_mul closed; d_app + d_map + IsIso remain) |
| 139 | 3 | 3 | 0 | plan-only deferral (HARD GATE on RigidityKbar.tex + CHURNING-trigger; blueprint-writer Wave 2 +6 directive edits 754 → 1224 LOC; mathlib-analogist Route (b'2) PROCEED) |
| 140 | 3 | 3 | 0 (structural advance: IsIso narrowed via `isIso_of_app_iso_module ... (fun _ => sorry)`; d_app `change`-scaffolding + d_map closure-recipe docstring; d_map `change` reverted on `whnf` timeout) | PARTIAL (0 strict closures; +1 private helper `isIso_of_app_iso_module`) |
| 141 | 3 | 3 | 0 | plan-only deferral (HARD GATE on RigidityKbar.tex 3 must-fix items + CHURNING-trigger pre-commit; iter-141 Wave 2 mathlib-analogist on d_app/d_map shape PROCEED-with-`pushforward_obj_map_apply'`; iter-141 Wave 3 blueprint-writer +125 LOC) |
| 142 | 3 | 2 | **−1 (d_map at L643 CLOSED substantively)** | **PARTIAL — 1 of 3 sub-sorries closed; CHURNING-CONFIRMED per pre-commit acceptance matrix (PASS ≥2/3; PARTIAL 0–1; FAIL 0+blocker)** |

Helpers added per iter:
- iter-138: +2 (decomposition into d_add + d_mul + d_app + d_map + IsIso; counted as +2 net helpers because the d_add + d_mul were closed honestly leaving 3 sub-sorries with explicit Lean shapes)
- iter-139: 0 (plan-only)
- iter-140: +1 (`isIso_of_app_iso_module` private helper, 5 LOC body, marked upstream-PR candidate)
- iter-141: 0 (plan-only)
- iter-142: 0 (explicit "no 4th helper" guardrail per progress-critic-iter142)

**Total over K=5: +3 helpers; +1 strict-count closure (d_map iter-142)**

Recurring blocker phrases:
- "categorical chase / factoring witness `h`" — iter-138, iter-140
  (resolved for d_map iter-142; **still live for d_app**)
- "`whnf` opacity / `pushforward₀`" — iter-140 only (resolved iter-141
  blueprint-writer + iter-142 prover via fully-explicit `change` on
  both sides + named lemma `pushforward_obj_map_apply'` swap; d_map
  closed iter-142 confirms resolution; **codified into iter-142
  Knowledge Base entry as: even `_ = 0`-shape goals need fully-explicit
  `change` when ANY side crosses `pushforward₀`-annotated definitions**)
- "per-open IsIso identification" — iter-140 (narrowing), iter-141
  (plan), iter-142 (prover priority-deferred); **still live**

Iter-142 NEW blocker phrases:
- "Step 3 adjunction-transpose chase ~20–40 LOC bespoke
  NEEDS_MATHLIB_GAP_FILL" — iter-142 prover-side identification of
  the d_app load-bearing remaining step after the iter-141 +
  iter-142 `change`-skeleton refinements; no chasing chain available
  via Mathlib defaults.
- "`rw [show ... from NatTrans.naturality_apply ...]` packaging" —
  iter-142 NEW iter-shape lesson; the bare lemma produces
  `ConcreteCategory.hom`-form equalities that don't unify with the
  goal's `RingCat.Hom.hom` / `CommRingCat.Hom.hom` mix. This is a
  d_map closure technique; whether it also applies to d_app is
  iter-143's question.

## Pre-committed iter-143 acceptance matrix (from iter-142 PROGRESS.md)

The iter-142 PROGRESS.md and iter-142 review.md pre-committed iter-143
to the following:

- **PASS arm** (iter-142 ≥2/3 closures) → CONVERGING-confirmed; iter-143
  fires Main composition + piece (i.c) scaffolding.
- **PARTIAL arm** (iter-142 0–1 closures) → **CHURNING-CONFIRMED**;
  iter-143 mid-iter strategy-critic with **DIAGNOSTIC question**
  (NOT a pre-committed route-pivot question, per iter-141 must-fix #4
  on CHURNING-trigger discipline): "which of d_app / d_map / IsIso
  failed and why — is the failure recipe-level, definition-level, or
  strategy-level?"
- **FAIL arm** (iter-142 0 + new opacity-family blocker) → STUCK +
  mandatory route pivot.

Iter-142 closed 1 of 3 (d_map only) → **PARTIAL arm fires → CHURNING-
CONFIRMED**.

## Question for you

1. Given the K=5 signal:
   - Sub-sorry count: 3 → 3 → 3 → 3 → 2 (first strict-count closure
     on this route since iter-138; iter-138's "3" was a decomposition
     refinement, not a strict closure).
   - Helpers added: +3 across K=5 (+2 iter-138 decomposition + 1
     iter-140 `isIso_of_app_iso_module`).
   - Prover statuses: PARTIAL (iter-138), plan-only (iter-139), PARTIAL
     (iter-140), plan-only (iter-141), PARTIAL (iter-142).

   Does Route A still read CHURNING (the pre-commitment said
   CHURNING-CONFIRMED at iter-142 close), or has the iter-142 strict-
   count closure shifted the read toward UNCLEAR / CONVERGING?

2. The remaining sub-sorries are d_app (smaller, ~40–80 LOC; explicit
   `change`-skeleton landed iter-142; categorical-witness Step 3
   adjunction-transpose is the load-bearing residual) and IsIso (larger,
   ~195–365 LOC bundled; Route (b'2) items 2–4 deferred iter-142 due
   to size mismatch with the bundle).

   If you read this as CHURNING / STUCK, what is the correct
   corrective?
   - **(a)** Continue the prover lane targeting d_app only (drop IsIso
     from the iter-143 bundle; defer IsIso to iter-144+ as a separate
     prover round).
   - **(b)** Continue the prover lane on the full bundle (d_app + IsIso).
   - **(c)** Defer prover; address lean-auditor-review142 MAJOR by
     dispatching a refactor subagent to extract the IsIso obligation
     into a named sorry-bodied theorem (this is structural hygiene; it
     doesn't close any sub-sorry but makes the residual sorry auditable).
   - **(d)** Route pivot to off-route M-piece bodies (this is the
     iter-145+ breakeven trigger per `progress-critic-iter141` secondary
     corrective; one iter early per the iter-142 CHURNING-CONFIRMED
     pre-commit).
   - **(e)** Mid-iter strategy-critic with DIAGNOSTIC question per the
     iter-142 pre-commit (the diagnostic is whether the d_app /
     IsIso remaining failures are recipe-level, definition-level, or
     strategy-level — a route-pivot question is NOT pre-committed,
     only the diagnostic is).

3. **5-consult overhead axis (per STRATEGY.md soundness rules iter-140
   narrowed envelope-widening arm)**: piece (i.b) Step 2 currently
   carries 4 mathlib-analogist consults (iter-133 mulright-globalises,
   iter-135 phi-compatibility, iter-137 kaehler-tensorequiv, iter-139
   IsIso-routes, iter-141 d_app/d_map shape — actually 5 consults if
   we count iter-141, but only iter-137 widened the envelope).
   - The envelope-widening arm (≥3 consults that EACH widen) has NOT
     fired (only iter-137 widened).
   - The consult-count arm (≥5) is **demoted to a calibration
     watchpoint** per `strategy-critic-iter140` Edit-2 and revisits to
     a principled value at iter-150.
   - Does this consult-overhead axis change your verdict? In particular,
     should iter-143 spawn a 6th mathlib-analogist consult on Route
     (b'2) IsIso-specific details (chart-unfolding + universal-map
     identification + `tensorKaehlerEquiv.symm`) before the prover
     dispatches?

## Strict context discipline reminder

You are intentionally NOT given STRATEGY.md, blueprint chapters, or
iter sidecars' full content. The question is convergence at the signal
level. If you find yourself wanting to comment on the math of the
route, that's strategy-critic's territory; if on the chapter
correctness, that's blueprint-reviewer's territory.
