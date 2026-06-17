# Directive — progress-critic, iter-198

## Mode
Read-only fresh-context per-route convergence audit.

## Scope

USER 2026-05-28 standing directive permanently PAUSES Route C and
shifts prover capacity to Route A bottom-up from Mathlib roots.
**Re-evaluate every active route under the new framing**: a Route C
route that was previously CHURNING is no longer relevant, but a
Route A route that has had no prover dispatch in 5+ iters is the new
relevant signal.

## Active routes for iter-198 (Route A only)

### Priority 1 — ungated roots

#### Lane WD-A4a — `WeilDivisor.lean` A.4.a substrate (L249)
- Target: `rationalMap_order_finite_support` (L249, non-zero branch
  case 2 — Stacks 02RV).
- STRATEGY row: A.4.a — codim-1 + Weil-divisor substrate.
  Iters-left estimate: ~3–6. Phase entered: iter-198 (new lane;
  prior iters used WeilDivisor.lean for Lane I = Route C only).
- Signals (last 5 iters, iter-193 → iter-197):
  - iter-193: sorry count 4 (WeilDivisor file-level); no Route A
    work — all 4 were RR.1 sorries.
  - iter-194: 4 → 4 (Lane I CHURNING on RR.1; no A.4.a touched).
  - iter-195: 4 → 4 (1 generic Finsupp helper added: not A.4.a).
  - iter-196: 4 → 4 (instance demotion refactor; not A.4.a).
  - iter-197: 4 → 3 (`hy_ne_bot` residual closed for
    `isRegularInCodimOneProjectiveLineBar` — adjacent to A.4.a
    but file-specific to ℙ¹-bar; the named typed-sorry residual
    `rationalMap_order_finite_support` non-zero branch is the
    iter-198 A.4.a target).
- No prior prover lane has touched the L249 non-zero branch under
  Route A framing. New lane.

#### Lane AB — `AuslanderBuchsbaum.lean` (L1131)
- Target: `auslander_buchsbaum_formula_succ_pd` n=k+1 inductive
  step (Matsumura §19 / Stacks 090V).
- STRATEGY row: A.4.b — n=0 closed; n=k+1 priority-1 root.
  Iters-left estimate: ~6–12. Phase entered: iter-195 (named
  typed-sorry carved); promoted from off-critical to priority-1 in
  iter-198.
- Signals (last 5 iters, iter-193 → iter-197):
  - iter-193: 2 sorries (off-critical, no dispatch).
  - iter-194: 2 → 1 (n=0 closed via
    `Module.depth_pi_const_eq_depth_of_nonempty`).
  - iter-195: 1 → 1 (Lane G PARTIAL — carving + 4-piece slice doc).
  - iter-196: 1 → 1 (no dispatch).
  - iter-197: 1 → 1 (no dispatch).
- Blocker phrases: "off-critical-path", "n=k+1 multi-iter",
  "depth-drops-by-one → minimal-resolution carving → snake".

### Priority 2 — one layer above

#### Lane RPF — `RelPicFunctor.lean` (6 sorries)
- Targets: L235 `exact sorry` (`representable` body); L287, L328,
  L373, L433, L482 (functor-builder sub-pieces).
- STRATEGY row: A.1.c — RelPic functor; iter-198+ unblocked (A.1.a
  closed). Iters-left estimate: ~6–10.
- Signals (last 5 iters):
  - iter-193: 6 → 6 (gated; no dispatch).
  - iter-194: 6 → 6 (gated; no dispatch).
  - iter-195: 6 → 6 (gated; no dispatch).
  - iter-196: 6 → 6 (gated; no dispatch).
  - iter-197: 6 → 6 (gated; no dispatch).
- Blocker phrases: "gated on A.1.b `LineBundle.OnProduct` typed
  sorry", "iter-177+ Block B".

#### Lane COE — `CodimOneExtension.lean` (3 sorries)
- Targets: L526 `isRegularLocalRing_stalk_of_smooth` Stage 6 (Stacks
  00OE / 02JK); L723, L798 downstream consumers.
- STRATEGY row: A.4.c.0 — codim-≥2 conclusion. Iters-left: ~2–4.
- Signals (last 5 iters):
  - iter-193: Lane M↓ Stage 5a + 5b axiom-clean (3 → 3).
  - iter-194: 3 → 3 (no dispatch on this file).
  - iter-195: 3 → 3 (route excised iter-196; restored under new
    directive iter-198).
  - iter-196: 3 → 3 (no dispatch; route marked EXCISED).
  - iter-197: 3 → 3 (no dispatch; route marked EXCISED).
- Blocker phrases: "Stage 6 Stacks 00OE gap", "Lane M↓ EXCISED".

### Priority 3

#### Lane FGA — `FGAPicRepresentability.lean` (7 sorries)
- Targets: 1 free sorry at L354 (`Functor.IsRepresentable` body) +
  6 `⟨sorry⟩` carrier-soundness instances.
- STRATEGY row: A.2.c. Iters-left: ~12–16. Carrier-soundness probe
  abort verdict due iter-198.
- Signals (last 5 iters):
  - iter-196 plan-phase refactor `carrier-soundness-fgapic` LANDED.
  - iter-197: no prover dispatch (probe smoke check scheduled).
- Blocker phrases: "carrier-soundness probe", "`HasPicScheme C` +
  consumers".

#### Lane T32 — `Thm32RationalMapExtension.lean` (2 sorries)
- Targets: L155 `IsReduced A.left := sorry` (post-refactor named
  helper); L294 branch 2 (gated on CodimOneExtension Stacks 00TT).
- STRATEGY row: A.4.c.1. Iters-left: ~8–14. Gated on COE.
- Signals: standing deferral.

## Planner's iter-198 PROGRESS.md `## Current Objectives` proposal

5 lanes (mathlib-build mode for all):
1. `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (Priority 1)
2. `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Priority 1 —
   A.4.a substrate only; RR.1 sorries L538/L1108 off-limits)
3. `AlgebraicJacobian/Picard/RelPicFunctor.lean` (Priority 2)
4. `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (Priority 2)
5. `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` —
   conditional, only the L155 helper-close which does NOT depend on
   COE Stacks 00TT (Priority 3 stretch).

## Your task

Render CONVERGING / CHURNING / STUCK / UNCLEAR per route. Specifically:

1. Lane WD-A4a is a fresh lane this iter under the new directive —
   verdict should reflect "no prior trajectory data" honestly.
2. Lane AB has had no prover dispatch in 3 iters (iter-194 closed
   n=0; iters 195-197 carved but no prover lane). Was that off-
   critical deprioritization the right call, or is the route STUCK
   on the carving alone?
3. Lane RPF: 5 iters of "gated; no dispatch". With A.1.a now closed,
   the gate is gone — is this lane CONVERGING (just needs first
   prover dispatch) or STUCK (gated on something deeper)?
4. Lane COE: was "EXCISED" in iter-196 STRATEGY; user directive
   re-elevates to Priority 2. Verdict on whether iter-197's
   excision was sound or a sunk-cost giveaway.
5. Lane FGA: 2-3 iter probe ends iter-198. Is the abort criterion
   well-defined?
6. Lane T32: 2 sorries, only L155 actionable. Worth a lane?

For each CHURNING / STUCK lane, name the corrective TYPE (blueprint
expansion, structural refactor, design refactor, route pivot, etc.).

## Output

Write to `task_results/progress-critic-route198.md`.
