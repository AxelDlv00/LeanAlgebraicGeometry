---
name: d3-split-landed
description: iter-313 D3′ file-split landed; PullbackTensorComp.lean extracted; key sorry now accessible at line 502
metadata:
  type: project
---

iter-313 `d3-split` refactor: `TensorObjSubstrate.lean` tail (L2179–L2769) moved verbatim to new `AlgebraicJacobian/Picard/TensorObjSubstrate/PullbackTensorComp.lean` (634 lines). Build GREEN (8627 jobs). No un-privating needed. Two D3′ sorries now live in:
- `PullbackTensorComp.lean:502` — `key` inside `sheafificationCompPullback_comp` (LSP returns goal without timeout — unblock CONFIRMED)
- `PullbackTensorComp.lean:625` — `pullbackTensorMap_restrict` body sorry

**Why:** The upstream million-heartbeat lemmas in TensorObjSubstrate.lean caused 30s LSP timeout on `lean_goal` at `key`, blocking closure for 5 iters.

**How to apply:** The prover for Sq1 (`key`) should now target `PullbackTensorComp.lean:502`. The goal is the `leftAdjointUniq`-form 4-whisker cocycle; the entry point is the `rw [sheafificationCompPullback_eq_leftAdjointUniq (h ≫ f)]` at L500. See [[d3-sq1-recast-skeleton-310]] for the validated `respectTransparency false` knob.

`AlgebraicJacobian.lean` now imports `PullbackTensorComp` between `TensorObjSubstrate` and `TensorObjSubstrate.DualInverse`.
