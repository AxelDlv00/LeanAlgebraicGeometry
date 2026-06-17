# Done Tasks
<!-- Resolved items, last-known state only. Per-attempt detail → iter sidecars. -->

- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap_apply` — solved helper from session 2; supports the DUAL inverse path and is now accounted for in the project state.
- `sheafificationCompPullback_comp_tail` (`lem:sheafificationcomppullback_comp_tail`) — CLOSED iter-006 (the 6-iter STUCK D3′ node) via `conjugateEquiv_comp` at NatTrans level (recipe `d3cocycle006.md`); its caller `sheafificationCompPullback_comp` is now sorry-free end-to-end. Also `sheafificationCompPullback_comp_natTrans` (prototype) and the `hδ`/Sq2b sub-sorry of `pullbackTensorMap_restrict`.
- `sliceDualTransport.toFun.naturality` (forward ε-square) — CLOSED iter-007 via the morphism-level recipe (`dualnat006.md`): extracted standalone `sliceDualTransport_naturality_apply`, closed pointwise through `appIso_hom_naturality_apply` + `dualUnitRingSwap_apply` + `φ.naturality_apply` (never sending `inv ε` through `whnf`). Also `map_add'`/`map_smul'`. This is the working template for the inv-naturality root (L444).
