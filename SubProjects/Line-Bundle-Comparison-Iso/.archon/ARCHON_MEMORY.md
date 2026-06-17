<!-- ARCHON_MEMORY.md — condensed project knowledge for all agents.
     Written by the plan agent and archon discuss. Read by all agents.

     HARD LIMITS: max 10 bullets · ~600 chars total.
     Prune before adding. Only keep what would surprise an agent reading
     the code fresh. Do NOT duplicate things obvious from the codebase.

     Good candidates: dead-end tactics, files not to touch, Mathlib gap
     coordinates, protected invariants, per-file hazards, standing routes
     to avoid, axioms that must not be accepted.

     Bad candidates: things already obvious from the code or PROGRESS.md,
     current sorry counts, task-specific details that change every iter.
-->
- `exists_tensorObj_inverse` is import-cycle gated; do not finish it inside `TensorObjSubstrate.lean`.
- D3′ cocycle `sheafificationCompPullback_comp_tail`: NatTrans-level via `conjugateEquiv_comp`, template `pullbackObjUnitToUnit_comp`; never splice a `.app P` δ-square. (`d3cocycle006`)
- DUAL `sliceDualTransport`/`sliceDualTransportInv` + ring-swap helpers in `DualInverse/SliceTransport.lean`; forward `sliceDualTransport` naturality CLOSED, 3 sorries left (inv-naturality root L444 + left/right_inv). Never apply `inv ε`/`dualUnitRingSwap` pointwise (whnf→timeout); rotate via `IsIso.inv_comp_eq`→forward ε-square through `appIso_hom_naturality_apply`+`dualUnitRingSwap_apply`. (`dualnat006`)
- AJC `extendScalars`/`pullback0`/`pullbackLanDecomposition` Lan block is DEAD code — do NOT port.
