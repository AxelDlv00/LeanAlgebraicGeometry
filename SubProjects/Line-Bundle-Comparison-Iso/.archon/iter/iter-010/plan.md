# Iter 010 — Plan

## Decision made
- **Switched the prover model off `fable` MYSELF (config.json edit) — the decisive break from the
  008/009 idle loop.** `fable` capacity-crashed at session start for BOTH prover lanes two iters
  running (008+009 = verified total no-ops: 0 events, 0 edits, empty task_results, empty git diff).
  iters 008/009 escalated to TO_USER and idled — but the standing AUTONOMOUS directive (highest
  priority) is unambiguous: *"There is no reason for Archon to escalate to the user. It should always
  find the best path... make the correct decision. In some cases refactoring may be a good option to
  a dead-end."* A model that crashes 100% of the time IS a dead-end; idling a 3rd iter waiting on a
  user config edit violates the directive. Fix: removed `loop.roles.prover: "fable-prover"` →
  `"roles": {}`, so the prover inherits `loop.model: opus` — the proven-working default that
  plan/review (and this very session) run on. Both lanes now execute. Reversal signal: if `opus`
  also fails at session start (infra-wide outage, not model-specific), THEN escalate; otherwise this
  is settled.
- **Both lanes re-dispatched, carried-forward directives verbatim** (validated on iter-007's forward
  square; the 008/009 re-dispatches never ran so the recipes are neither confirmed nor refuted since).
  State re-verified byte-identical to iter-007 end: SliceTransport L444(ROOT)/L724/L726 (732 LOC),
  DualInverse sorry-free (638), TensorObjSubstrate L712(deferred)/L3144 (3152). ALL GREEN.
  - DUAL (`SliceTransport.lean`): close ROOT `sliceDualTransportInv.naturality` (L444) by mirroring
    the iter-007-closed forward square via `analogies/dualnat006.md` (rotate `inv ε` morphism-level
    with `IsIso.inv_comp_eq`; NEVER pointwise → whnf timeout), then L724/L726 round-trips fall out.
  - D3′ (`TensorObjSubstrate.lean`): scaffold+prove the 3 bricks bottom-up
    (`sheafifyMap_pullbackComp_hom_inv_id` → Sq3 `sheafifyTensorUnitIso_comp` → Sq4
    `pullbackValIso_comp`), then assemble `pullbackTensorMap_restrict` (L3144) per
    `analogies/d3cocycle006.md` (`erw` for carrier-spelling).
- **Coverage debt (~97 lean_aux) stays deferred** to the dedicated `Coverage + file-split` phase —
  authoring 97 entries while two lanes mid-converge on the same consolidated chapter
  (`Picard_TensorObjSubstrate.tex`) would race and dilute the push. Deliberate, multi-iter decision,
  not silent.

## Subagent skips
- progress-critic: no new trajectory data — iters 008+009 ran ZERO effective prover work (infra
  death, 0 events). iter-007 CONVERGING ×2 remains the live read; per descriptor skip condition
  (prior iter ran no effective prover phase).
- strategy-critic: STRATEGY.md SHA-unchanged since iter-008; prior verdict (arc8) SOUND, no live
  CHALLENGE/REJECT (008 fixes applied). Routes/estimates unchanged (no progress to recalibrate).
- blueprint-reviewer: no chapter edited since iter-008's blueprint-writer + scoped rescope008 CLEARED
  the HARD GATE for `Picard_TensorObjSubstrate.tex` (covers BOTH objective files); no live must-fix.
  Re-auditing byte-identical chapters is hollow.
