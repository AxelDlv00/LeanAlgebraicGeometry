# Iter 009 — Plan

## Decision made
- **Re-dispatch both lanes, identical carried-forward directives.** iter-008 was a verified
  TOTAL no-op: both prover lanes died at session start on `fable-prover` capacity (0 events,
  0 edits, empty `task_results/`, empty `git diff`). Working tree = byte-identical iter-007 end
  state (re-verified: SliceTransport L444/L724/L726, TensorObjSubstrate L712/L3144 sorries intact;
  ALL GREEN). The iter-008 directives never executed → they carry forward verbatim, neither
  validated nor invalidated. iter-007's CONVERGING ×2 verdicts remain the live read.
  - DUAL (`SliceTransport.lean`): close ROOT `sliceDualTransportInv.naturality` (L444) by mirroring
    the iter-007-closed forward square via `analogies/dualnat006.md` (rotate `inv ε` morphism-level,
    `IsIso.inv_comp_eq`; NEVER pointwise → whnf timeout), then L724/L726 round-trips fall out.
  - D3′ (`TensorObjSubstrate.lean`): scaffold+prove the 3 bricks bottom-up
    (`sheafifyMap_pullbackComp_hom_inv_id` → Sq3 `sheafifyTensorUnitIso_comp` → Sq4
    `pullbackValIso_comp`), then assemble `pullbackTensorMap_restrict` (L3144) per
    `analogies/d3cocycle006.md` (`erw` for carrier-spelling).
  - Reversal signal: if the DUAL ROOT still won't close by mirroring the (proven) forward square,
    the `sliceDualTransport` *shape* becomes the effort-breaker target. If `fable-prover` capacity-
    fails a SECOND consecutive iter, escalate a model-switch to TO_USER (config.json is user-only).

## Why no subagent corrective this iter
- No churning/stuck signal exists to act on: iter-008 produced ZERO trajectory data (infra death,
  not a math wall). A 0-event iter must not be misread as STUCK. The only real prover iter since the
  recipes were authored is iter-007, which CONVERGED on both routes (forward naturality closed; Sq1
  closed). Both lanes have concrete, validated recipes → straight re-dispatch is correct, not a
  repeated-blocker re-wording.
- Coverage debt (~97 `lean_aux`) stays the deferred `Coverage + file-split` phase — authoring 97
  entries while two lanes edit the same consolidated chapter would race. Deliberate, not silent.

## Subagent skips
- blueprint-reviewer: no chapter edited since prior dispatch (iter-008 blueprint-writer + scoped
  rescope008 CLEARED the HARD GATE for `Picard_TensorObjSubstrate.tex`, which covers BOTH objective
  files; iter-008 prover no-op added no helpers → no blueprint delta). Prior verdict cleared the
  gate for both active files; no must-fix remains live (B1/B2/B3 fixed iter-008).
- strategy-critic: STRATEGY.md SHA-unchanged since iter-008; prior verdict (arc8) SOUND with no live
  CHALLENGE/REJECT. Routes/estimates unchanged (iter-008 made no progress to recalibrate).
- progress-critic: prior iter ran no effective prover phase (0 events — infra capacity death, no new
  trajectory data to assess); iter-007 verdicts CONVERGING ×2 remain live with no must-fix. Per
  descriptor skip condition (no new trajectory data).
