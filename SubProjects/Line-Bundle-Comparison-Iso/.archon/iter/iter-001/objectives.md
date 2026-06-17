# Iter 001 — Objectives

2 prover lanes (both gated by `Picard_TensorObjSubstrate.tex`, gate CLEARED this iter).

| # | File | Mode | Targets | Blueprint |
|---|------|------|---------|-----------|
| 1 | `TensorObjSubstrate/DualInverse.lean` | fine-grained | (a) `sliceDualTransport` ≃ₗ (L760) → (b) `sliceDualTransportInv` (L298) → (c) `dual_restrict_iso` Step-4 naturality (L388/525/627/629) | `lem:slice_dual_transport`, `lem:slice_dual_transport_inv`, `lem:dual_restrict_iso` |
| 2 | `TensorObjSubstrate.lean` | fine-grained | `sheafificationCompPullback_comp_tail` (L2623) → `pullbackTensorMap_restrict` (L2851) if comp_tail lands | `lem:sheafificationcomppullback_comp_tail`, `lem:pullback_tensor_map_basechange` |

Deferred (not dispatched): `exists_tensorObj_inverse` (cross-file cycle — inverse from
downstream DUAL chain); 3 scaffold seed decls; 91-node coverage debt.

Key gotcha relayed to provers: `conjugateEquiv_whiskerLeft` is NOT a Mathlib lemma
(base `conjugateEquiv` is) — build as local `have` or use the surjectivity/injectivity
fallback. Recipe `analogies/d3-mate271.md`.
