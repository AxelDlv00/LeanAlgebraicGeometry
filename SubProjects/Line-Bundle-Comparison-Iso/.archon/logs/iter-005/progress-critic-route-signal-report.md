# Progress Critic: route-signal
**Iter:** 005

## Routes
- **`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`**: CHURNING. Sorry 4->4; +1 helper; PARTIAL x2; then plan-only x2; blockers repeat (`restrictScalarsLaxε`/`NatTrans.naturality`, round-trip cancellation).
  - Corrective: Fill all ready lanes.
- **`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`**: CHURNING. Sorry 3->3; +1 helper; PARTIAL x2; then plan-only x2; blockers repeat (`leftAdjointCompNatTrans_assoc`/`conjugateEquiv`, `sheafificationCompPullback_comp_tail`).
  - Corrective: Fill all ready lanes.

## Dispatch Sanity
- **Verdict**: OK. 2 objectives, 2 ready lanes, cap 10; no under-dispatch or bloat.

## Must-fix-this-iter
- Route `DualInverse.lean`: CHURNING - stop plan-only drift; dispatch the ready lane.
- Route `TensorObjSubstrate.lean`: CHURNING - stop plan-only drift; dispatch the ready lane.

## Overall
- 2 routes churning by avoidance; current proposal matches the 2 ready lanes, so dispatch is OK.
