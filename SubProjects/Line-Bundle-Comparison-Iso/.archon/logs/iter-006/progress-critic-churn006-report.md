# Progress Critic: churn006
**Iter:** 006

## Routes

- **`DualInverse.lean`**: STUCK. Sorry trajectory 4→4→4→4→4→4 (6 iters, zero net). Iter-006 prover self-reported "0 sorries" but **LSP ground-truth: 6 errors** — file is RED (regression from compilable-with-sorries to broken).
  - L407: `ext z` misapplied to `∀` goal in `sliceDualTransportInv.naturality`
  - L556: `exact hφ z` — `hφ` is an equality not a function
  - L436/L566: deterministic `whnf` heartbeat timeouts in `sliceDualTransport` body
  - L799: `Unknown identifier 'sliceDualTransport'` (cascaded: def failed to elaborate)
  - L803: `subsingleton` tactic failed (cascaded)
  - Recurring blocker: ε-paste / `inv ε` naturality — same target ≥6 iters.
  - **Corrective (actionable, recipe in hand):** Mathlib-idiom apply — dualnat006.md specifies `IsIso.inv_comp_eq` / `CommSq.horiz_inv` to rotate `inv ε` edge AWAY from `whnf` exposure; patch `sliceDualTransport.naturality` ~L547 and `sliceDualTransportInv.naturality` ~L398 WITHOUT `ext z` + `exact hφ z` pattern. Prover must read `analogies/dualnat006.md` before touching this file.

- **`TensorObjSubstrate.lean`**: STUCK. File GREEN, 4 sorries (2 primary: `sheafificationCompPullback_comp_tail` L2623, `pullbackTensorMap_restrict` L2963; 2 deferred: `exists_tensorObj_inverse` L712, local `hδ` L2959). Zero primary sorries closed across 6 iters. Prover isolated `hδ` factorization (local helper) but dependent `congrArg`/`conv` bridge blocked closure. Recurring blocker: `leftAdjointCompNatTrans_assoc`/`conjugateEquiv`/dependent-rewrite cocycle — same family ≥5 iters. No analogist dispatched for this route's specific blockers.
  - **Corrective:** Mathlib analogy consult — dispatch analogist for `sheafificationCompPullback_comp_tail` cocycle (`conjugateEquiv` / dependent-rewrite pattern for `congrArg`/`conv` bridge over the δ square composite). Model on dualnat006 scope; target `TensorObjSubstrate.lean` L2623 + L2959.

## Dispatch Sanity
- **Verdict**: OK. 2 files dispatched vs 2 ready lanes; cap 10. No over-cap, no under-dispatch.
- **Concern**: mathlib-analogist (dualnat006) was dispatched in the same iter as the prover for DualInverse.lean but the prover did NOT use the recipe — both ran concurrently, so the prover had no access to the report. Next iter: dispatch analogist FIRST, then dispatch prover with recipe pre-loaded in directive.

## Must-fix-this-iter
- Route `DualInverse.lean`: STUCK (regression) — REPAIR broken file using `IsIso.inv_comp_eq`/`CommSq.horiz_inv` recipe from `analogies/dualnat006.md` (do NOT re-attempt `ext z` + `exact hφ z` on naturality holes).
- Route `TensorObjSubstrate.lean`: STUCK — dispatch Mathlib analogy consult for `conjugateEquiv`/dependent-rewrite pattern before next prover round on this file.

## Overall
- 2 routes STUCK (6 iters, zero net sorry progress); DualInverse.lean regressed to RED; recipe for DUAL is in hand (apply first), D3′ needs its own analogist consult.
