# Iter-247 plan-agent run

## Headline outcome

The **"architecture-first: break the `TensorObjSubstrate ↔ RelPicFunctor` import cycle, then dispatch BOTH
lanes the same iter"** iter. The iter-246 review's headline tension was: Lane TS converging on the critical
path, but Lane RPF mis-dispatched into an import cycle (the substrate it must cite lives downstream of it),
producing fragile local duplication (+3 sorries) instead of keepable progress. iter-246 review explicitly
prescribed iter-247 = architecture-first (relocate the substrate), then RPF. Executed: a `refactor` broke the
cycle (minimal: the cycle was caused by only 2 *dead* decls), both lanes are now gated-clear and dispatched.

## What I processed (iter-246 outcomes)
- **Lane TS** (TensorObjSubstrate.lean): D2' δ-wrapping landed axiom-clean (4 decls). The whole comparison
  iso now funnels to ONE residual — the η-bridge `IsIso (a_Y.map (η (pullback φ')))`, reduced to a precise
  concrete pushforward-side mate identity with all glue named. → task_done; result archived.
- **Lane RPF** (RelPicFunctor.lean): the iter-246 recipe ("cite TensorObjSubstrate decls") was INFEASIBLE —
  `TensorObjSubstrate.lean:9` imports `RelPicFunctor` (import cycle). Prover built a real `AddCommGroup`
  modulo 4 typed-sorry bridges from local pure-Mathlib copies (sorry 1→4); prover + review both flagged it
  "the wrong fix; architecture-first." → architectural finding, acted on this iter.

## Investigation (before deciding)
Grepped the actual cycle: ONLY `TensorObjSubstrate.lean:9` imports `RelPicFunctor`, and ONLY two decls there
reference it — `tensorObjOnProduct` (L706) and `addCommGroup_via_tensorObj` (L1532). Both are DEAD (used
nowhere but comments). So the cycle is removable by moving/deleting those 2 decls + flipping one import — far
cheaper than the prover's suggested full "Core.lean split." This made the refactor low-risk enough to run
same-iter and still dispatch both provers afterward.

## Decision made

**Chosen:** (1) `refactor` to break the cycle (move `tensorObjOnProduct` into RPF, delete the dead
`addCommGroup_via_tensorObj` stub, flip the import so `RelPicFunctor` imports `TensorObjSubstrate`, reorder
`AlgebraicJacobian.lean`); (2) honor the progress-critic CHURNING corrective with a mathlib-analogist consult
on the η-bridge API BEFORE dispatch; (3) dispatch BOTH lanes — Lane TS (η-bridge, HARD closure requirement) +
Lane RPF (rewire 4 bridges → upstream substrate, sorry 4→1) — using the sanctioned same-iter fast path to
re-clear the RPF chapter gate.

**Why (evidence):**
- The cycle is the root blocker for RPF and a recurring known issue (memory `rpf-import-cycle-blocks-tensorobj`).
  Lane TS will occupy `TensorObjSubstrate.lean` for ~5–13 more iters; leaving the cycle in place idles RPF
  that whole time. Breaking it now re-enables genuine parallel capacity (USER PARALLELISM directive) and fixes
  RPF's +3 sorry regression.
- The refactor is minimal/low-risk (2 dead decls + 1 import flip), verified COMPLETE & both files build clean,
  0 new sorries, TS sorry 2→1. So running provers on the refactored tree the same iter is safe — they run
  sequentially after the refactor, on different files (no edit conflict).
- progress-critic ts247: TS CHURNING (PARTIAL×5; offset), corrective = lightweight analogist on the η-bridge
  mate identity. Done → PROCEED (all glue exists; no shorter idiom; expect erw friction). The corrective is
  satisfied, not rebutted.
- RPF UNCLEAR (fresh route); the architecture-first refactor is confirmed the right corrective; monitoring =
  sorry returns to ≤1.

**LOC/risk weighed:** refactor ≈ tens of LOC moved, 0 risk realized (build green). Lane TS η-bridge
~60–120 LOC mate chase, API-confirmed. Lane RPF rewire ~ collapse 4 bridges to citations (mechanical-ish, the
construction already exists modulo the bridges).

**Cheapest reversing signals (armed):**
- Lane TS: if the η-bridge returns ANOTHER "named concrete residual" PARTIAL (no goal closure, no D3' brick),
  the sorry-stasis exemption is EXHAUSTED → iter-248 must classify STUCK and escalate to the user (do NOT
  pivot a 4th time). Diagnostic: "did the η-goal close OR a D3' brick land?"
- Lane RPF: if the rewire does NOT bring sorry to ≤1 (e.g. a bridge does not collapse to an upstream decl as
  expected), the substrate API shape — not the cycle — is the issue → mathlib-analogist on the specific decl
  next iter.

## Subagent skips

- **strategy-critic**: SKIP. STRATEGY.md is SHA-unchanged from iter-246 (no route/phase/estimation change this
  iter — the import-cycle fix is tactical/architectural, not a strategy change), and the prior verdict
  (ts246) was SOUND with all CHALLENGEs addressed and no live challenge. Skip conditions met.
- **blueprint-reviewer (full audit)**: not skipped — dispatched in scoped fast-path form on the one chapter
  edited this iter (RPF). The TS chapter is unchanged + cleared ts246; no other chapter feeds a live lane.
  (The full whole-blueprint audit ran ts246 with 0 unstarted-phase; nothing new opened this iter.)

## Notes
- Memory `rpf-import-cycle-blocks-tensorobj` updated to RESOLVED.
- The two RPF-dependent decls were DEAD before the refactor — moving/deleting them lost no proof content.
- analogies/eta247.md captures the η-bridge mate-chase rationale + verified citation list for future iters.
