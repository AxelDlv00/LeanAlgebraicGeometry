# Iter 009 — Objectives (per-lane detail)

State at iter start (= iter-007 end; iter-008 no-op): ALL GREEN, 5 sorries.

## Lane 1 — DUAL · `DualInverse/SliceTransport.lean` · prove
- L444 ROOT `sliceDualTransportInv.naturality` — mirror iter-007 forward square;
  `analogies/dualnat006.md`; morphism-level `IsIso.inv_comp_eq`, never pointwise `inv ε`.
- L724 `left_inv`, L726 `right_inv` — `hom_inv_id` round-trips, unblock once ROOT lands.
- Carried from iter-008 (never executed). Recipe validated on forward square iter-007.

## Lane 2 — D3′ · `TensorObjSubstrate.lean` · prove
- Scaffold+prove 3 bricks bottom-up: `sheafifyMap_pullbackComp_hom_inv_id` (easiest, no project
  \uses) → Sq3 `sheafifyTensorUnitIso_comp` → Sq4 `pullbackValIso_comp` (both `erw`).
- Then assemble `pullbackTensorMap_restrict` (L3144). Recipe `analogies/d3cocycle006.md`.
- Carried from iter-008 (never executed).

## Deferred (unchanged)
- L712 `exists_tensorObj_inverse` (import-cycle; closes via DUAL chain).
- `RelPicFunctor.lean` consumer (third seed) BLOCKED on both routes.
- Coverage/file-split phase (~97 lean_aux; TensorObjSubstrate 3152-LOC split).
