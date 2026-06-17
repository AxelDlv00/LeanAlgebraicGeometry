# Iter 054 — Plan (Quot-Foundations)

## TL;DR
3 prover lanes after a blueprint-prep round (effort-breaker + 2 writers + clean + whole-reviewer). HARD GATE
CLEARED on all 3 edited chapters. Coverage debt cleared. All 3 lanes get a prover THIS iter (progress-critic
UNDER_DISPATCH risk).

## Critic verdicts (actioned)
- **progress-critic `iter054`: GF=STUCK, GR=CHURNING, SNAP=CHURNING; dispatch UNDER_DISPATCH.** Sole critical
  risk = blueprint-prep with no provers. Corrective: provers on all 3 lanes this iter. GF effort-break+prover
  BOTH this iter is mandatory (deferring kills the route at the iter-055 deadline). SNAP CHURNING-rebuttal
  partially granted (objectwise `isColimitCofork` is genuine advance) but crux must ship.
- **blueprint-reviewer `iter054`: HARD GATE — ALL THREE CLEARED** (complete+correct, 0 must-fix). Doctor CLEAN
  (577 labels), leandag 0 unmatched. 2 LOW-sev non-blocking cleanups deferred to review phase.

## Decision made — prep + dispatch (not defer)
- **GF:** effort-breaker `gf-geo` split B2 into atomic B2.1–B2.4 + anchor `Scheme.basicOpen_res`. **Correctness
  fix it surfaced:** bare image `ḡ` of `g` does NOT give `D(g)=D(ḡ)` → `ḡ` is an explicit MATCHED datum; the
  real geometry (matched pairs exist) is isolated in B2.4. Prover (fine-grained) builds the chain → assembly →
  close. Chose dispatch-this-iter over prep-only: deadline is iter-055, two shots > one.
- **GR:** close `functor` via the named coherence `pullbackObjUnitToUnit_id` (recipe in hand) = the convergent
  ≥1-declaration-sorry drop; `glue` secondary. Blueprinted the coherence + coverage helpers.
- **SNAP:** mathlib-build the presheaf promotion → `relativeTensorCoequalizerIso` → crux. Writer rewrote the
  promotion proof to the verified route; objectwise brick already DONE.

## Subagent skips
- **strategy-critic:** STRATEGY edit this iter = status-refresh of the GF-geo row ONLY (algebra→geometry
  handoff within the UNCHANGED source-span route/phase/decomposition; estimate unchanged 1–2 iters). Prior
  verdict iter-053 SOUND, no live CHALLENGE. No strategic route/phase/decomposition change to challenge.
