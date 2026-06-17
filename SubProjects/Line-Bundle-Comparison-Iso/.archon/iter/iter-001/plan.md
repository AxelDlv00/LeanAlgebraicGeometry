# Iter 001 — Plan

Fresh extraction (A.1.c.sub). Build GREEN (8322 jobs, exit 0; only style warnings).
6 open sorries in 2 active files. First plan phase on this subproject.

## State established
- Real sorries: `DualInverse.lean` {388,525,627,629 (dual_restrict_iso Step-4 isoMk
  naturality), 760 (sliceDualTransport), + sliceDualTransportInv@298}; `TensorObjSubstrate.lean`
  {712 (exists_tensorObj_inverse), 2623 (sheafificationCompPullback_comp_tail),
  2851 (pullbackTensorMap_restrict)}.
- All 6 named targets exist as decls + have blueprint entries.
- **Trap caught**: frontier nodes `lem:pullback_tensor_iso_loctriv` &
  `lem:pullback_compatible_with_tensorobj` pin to decls that DON'T EXIST
  (`pullbackTensorIsoOfLocallyTrivial`, `pullback_tensorObj_iso`) — they are
  SCAFFOLD/roadmap targets (the seeds), NOT fill-sorry. Do NOT tell a prover to
  "prove" them. Same for seed 3 `addCommGroup_via_tensorObj`. Dropped them from
  prover objectives (prior PROGRESS wrongly told prover to "also attempt" them).

## Subagents
- strategy-critic (init-sc): all 3 routes SOUND, 0 CHALLENGE/REJECT. Format DRIFTED
  → fixed in-place: folded `## Out of scope` into Open questions; relabeled
  `conjugateEquiv_whiskerLeft` as to-build helper (base `conjugateEquiv` is the import).
- blueprint-reviewer (init-bp): chapter `Picard_TensorObjSubstrate.tex` complete:true /
  correct:PARTIAL → BLOCKED on ONE stale proof block (`lem:tensorobj_inverse_invertible`
  "Infrastructure-blocked" language). Offered same-iter fast path.
- blueprint-writer (gatefix): rewrote that block to a real 3-step proof; leandag clean.
  Found the 7 "coverage-debt" helpers the reviewer named ALREADY have blueprint entries
  (reviewer's sample was inaccurate).
- blueprint-reviewer (rescope): fast-path scoped re-review of fixed chapter — pending.

## Decision made
- Take the sanctioned same-iter fast path: writer-fix → green build → scoped re-review
  → dispatch provers THIS iter. Avoids a wasted gate-wait iter.
- Coverage debt (91 lean_aux w/o blueprint entry): DEFER as tracked work, not blocked
  on this iter. Rationale: seed-cone blueprint is complete+correct; the 91 are mature
  accumulated helpers from the parent that don't block the 6 sorries; reviewer's
  load-bearing sample was already covered. Will dispatch a focused coverage pass once
  the active sorries converge. Reversal signal: a frontier node turns out to depend on
  an unblueprinted helper (would corrupt dispatch order).

## Subagent skips
- progress-critic: iter 001, no prior prover phase ran on this subproject — no
  trajectory data to assess. (descriptor skip condition: "prior iter ran no prover phase").

## Tool substitutions
- none.
