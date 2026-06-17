# Iter 004 — Objectives

1. `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
   - Close `sliceDualTransport.naturality` and `sliceDualTransportInv.naturality` with the shared ε-naturality paste.
   - Then close `sliceDualTransport.left_inv` and `sliceDualTransport.right_inv` by round-trip cancellation through `f.appIso`, `image_preimage_of_le`, and the dual-unit swap simp lemmas.
   - Use the blueprint-pinned `homOfLocalCompat` directly if the inverse chain needs the global A-bridge; do not create more helper lemmas unless a proof step genuinely cannot be expressed otherwise.

2. `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
   - Attack `sheafificationCompPullback_comp_tail` with the non-circular `leftAdjointCompNatTrans_assoc` fallback.
   - If that lands, try `pullbackTensorMap_restrict` in the same session; otherwise leave it blocked.
   - Do not touch `exists_tensorObj_inverse`.
