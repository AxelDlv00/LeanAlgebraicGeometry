# Progress-critic directive — iter-008

Assess convergence per active route. Two routes, K=4 iters of signals.

## Route DUAL — `DualInverse/SliceTransport.lean` (+ `DualInverse.lean`)
Goal: close ε-naturality + round-trip sorries for the dual-inverse slice transport.
- iter-004: RED/churn — `sliceDualTransport` naturality whnf-timeout dead end.
- iter-005: file RED (6 compile errors, regression). 0 sorries closed.
- iter-006: file still RED (unrepaired). 0 prover edits landed. progress-critic verdict was STUCK.
- iter-007: refactor GREENED file (typed sorry at 6 broken sites) + SPLIT churning machinery into
  new `SliceTransport.lean`. Prover then CLOSED forward `sliceDualTransport.toFun.naturality`
  (+map_add/map_smul) via morphism-level recipe `analogies/dualnat006.md` (first successful exec).
  Sorry count 4 → 3.
- Helpers added/iter: iter-007 added ~7 helper lemmas (dualUnitRingSwap*, unitRelabelSwap*,
  appIso_hom_naturality_apply, sliceDualTransport_naturality_apply) — all CLOSED, load-bearing.
- Remaining 3 sorries (L444 `sliceDualTransportInv.naturality` ROOT, L724 left_inv, L726 right_inv):
  inv-naturality = mirror of the now-closed forward square (helpers in place); left/right_inv =
  hom_inv_id round-trips blocked only on the root.
- STRATEGY `Iters left`: ~2–4. Entered current (SliceTransport) phase: iter-007.

## Route D3′ — `TensorObjSubstrate.lean`
Goal: close `pullbackTensorMap_restrict` (L3144) — the Sq3/Sq4 coherence paste.
- iter-005: no decisive D3′ progress.
- iter-006: CLOSED `sheafificationCompPullback_comp_tail` (6-iter STUCK node) + `_comp` + `_comp_natTrans`
  (3 closures) via `analogies/d3cocycle006.md`; `pullbackTensorMap_restrict` PARTIAL (TOS sorries 3→2).
- iter-007: D3′ PAUSED (1-iter, sanctioned) → converted to decomposition-prep: effort-breaker split
  the Sq3/Sq4 residual into 3 \uses-linked bricks (sheafify_pullbackcomp_hom_inv_cancel,
  sheafify_tensor_unit_iso_comp, pullback_val_iso_comp). No prover ran.
- iter-008 plan: scaffold the 3 bricks into Lean + prove bottom-up, then close L3144.
- STRATEGY `Iters left`: ~3–5. Entered current phase: iter-006.

## Proposed iter-008 objectives (2 files)
1. `DualInverse/SliceTransport.lean` — close 3 sorries (L444 root → L724/L726).
2. `TensorObjSubstrate.lean` — scaffold 3 bricks + prove bottom-up → close `pullbackTensorMap_restrict` (L3144).

Return per-route verdict (CONVERGING/CHURNING/STUCK/UNCLEAR) + named corrective for any CHURNING/STUCK.
