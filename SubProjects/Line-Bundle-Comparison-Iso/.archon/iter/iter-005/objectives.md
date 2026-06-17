# Iter 005 — Objectives

1. `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
   - Close `sliceDualTransport.naturality` and `sliceDualTransportInv.naturality` with the shared epsilon-naturality paste.
   - Then close `sliceDualTransport.left_inv` and `sliceDualTransport.right_inv` by round-trip cancellation through `f.appIso`, `image_preimage_of_le`, and the dual-unit swap simp lemmas.
   - Keep `homOfLocalCompat` as the A-bridge; do not add new helper scaffolding.

2. `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
   - Attack `sheafificationCompPullback_comp_tail` with the non-circular `leftAdjointCompNatTrans_assoc` fallback.
   - If that lands, try `pullbackTensorMap_restrict` in the same session; otherwise leave `exists_tensorObj_inverse` deferred.
   - Do not touch `exists_tensorObj_inverse` directly.
