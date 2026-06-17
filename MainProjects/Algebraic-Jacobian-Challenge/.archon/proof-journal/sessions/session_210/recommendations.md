# Recommendations for iter-211 plan agent

## 1. HARD GATE — re-review the corrected TS chapter BEFORE dispatching (must-fix-this-iter)

The iter-210 corrective writer (ts-engine210b) rewrote `Picard_TensorObjSubstrate.tex`'s
associator route from realization (1) local-trivialization to **realization (2) flat-exactness
whiskerLeft** *after* blueprint-clean/reviewer had already run. The chapter therefore has **no
fresh complete+correct verdict on its current realization**. This is exactly why the iter-210
planner deferred the prover dispatch.

**Action:** re-run blueprint-clean + blueprint-reviewer on `Picard_TensorObjSubstrate.tex`
(scoped fast-path is sanctioned). Only on a `complete: true` + `correct: true` verdict with no
must-fix may `TensorObjSubstrate.lean` enter `## Current Objectives`. The previously-flagged
must-fix (`lem:tensorobj_isoclass_commgroup` over-claim) was ALREADY addressed by ts-engine210b
(statement now scoped to ⊗-invertible objects + clarified as an abelian group) — confirm it
holds in the re-review.

## 2. Dispatch target once the gate clears

Realization (2): the load-bearing lemma is **`W_whiskerLeft_of_flat`** (`J.W g → J.W(F◁g)` for
flat `F`), feeding the sheafified-presheaf associator + the ⊗-invertible ⇒ flat reduction. All
ingredients claimed present in Mathlib (analogist `ts-assoc-gate210`, ALIGN_WITH_MATHLIB).

**Pre-committed reversal signal (carried from iter-210 plan):** if the prover finds the
flat-whiskering bridge `W_whiskerLeft_of_flat` itself bottoms out in `MonoidalClosed` or a
strong-monoidal `pushforward`, the ⊗-invertibility group law is as blocked as the old route →
**pause TS, pivot to the Quot engine** (do NOT autopilot another helper round — this would be
the same pattern that fired DISPROVEN iters 205–208).

## 3. Cosmetic blueprint cleanups (non-blocking; fold into the iter-211 writer round if the gate writer runs anyway)

From bp-reviewer `bp-gate210` (`logs/iter-210/blueprint-reviewer-bp-gate210-report.md`):
- TS chapter §"Internal-consistency check" (~L1283): stale prose still says the associator
  "additionally needs the sheafification–tensor absorption iso" — eliminated by the iter-210
  re-scoping; update to match.
- TS lemma title (L1025): "The commutative monoid of ⊗-iso-classes and its units" — body is now
  correctly scoped to ⊗-invertible objects; align the title for consistency.
- `Albanese_Thm32RationalMapExtension.tex` / `thm:rational_map_to_av_extends`: cross-check
  whether the `\lean{...}` pin is genuinely absent (the sibling pin lives in
  `AbelianVarietyRigidity.tex` as `\lean{AlgebraicGeometry.rationalMap_to_av_extends}`).
- `AbelianVarietyRigidity.tex` / `lem:rigidity_eqOn_dense_open` and
  `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`: prose retains "single genuinely-deep
  residual sorry" wording superseded by an iter-162 axiom-clean `% NOTE`.

## 4. Standing strategic context (no new action this iter)

- **Quot engine is HELD** (not started) pending the USER RR-pause decision. strategy-auditor
  `quot-spike210` re-estimated it at ~3400–5500 LOC, every component Mathlib-absent, with hidden
  roots `R^i f_*` (i≥1) and Relative Proj. RR-free CONFIRMED.
- **Route-1 cone deletion gate remains closed:** Route-2 autoduality `J^∨ ≅ J` is classically
  RR-dependent (theta divisor) and is being second-verified (EGK Thm 2.1 / Poincaré bundle)
  before any Route-2 investment.
- COE remains PAUSED (7th consecutive iter).

## Blocked / do-not-retry
- **TS realization (1) local-trivialization and (3) `J.W.IsMonoidal`**: both rejected by
  `ts-assoc-gate210` as renamed/packaged `MonoidalClosed` walls. Do NOT re-route the associator
  through either. Only realization (2) flat-whiskering is live.
- The old δ-route / abstract-adjoint `tensorObj_restrict_iso` route (iters 205–208): dead;
  superseded by the ⊗-invertibility pivot. Do not revive.
