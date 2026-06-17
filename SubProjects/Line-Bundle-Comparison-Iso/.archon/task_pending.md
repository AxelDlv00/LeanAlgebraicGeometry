# Pending Tasks
<!-- Current open-task set, last-known state only. Per-attempt detail → iter sidecars. -->

## DUAL route — `TensorObjSubstrate/DualInverse/SliceTransport.lean` (chapter `Picard_TensorObjSubstrate.tex`) — `prove`
STATE: **GREEN with 3 dispatchable sorries** (forward `sliceDualTransport` naturality CLOSED — recipe validated).
Recipe: `analogies/dualnat006.md` + the closed forward square is the working template — mirror it.
Rotate `inv ε` MORPHISM-LEVEL, never pointwise (pointwise → whnf timeout).
- `sliceDualTransportInv.naturality` (L444) — ROOT, mirror of the closed forward square. `apply hom_ext;
  intro W; haveI := isIso_ε_restrictScalars_appIso f _; rw [IsIso.inv_comp_eq]` → forward ε-square; close
  via `φ.naturality` through `appIso_hom_naturality_apply` + `dualUnitRingSwap_apply` + `restrictScalarsComp'App`.
- `sliceDualTransport.left_inv` (L724) + `.right_inv` (L726) — `hom_inv_id` round-trips; use `hom_ext`/
  round-trip, NOT `ext z`; unblock once the inv-naturality root closes.

## D3′ route — `TensorObjSubstrate.lean` (chapter `Picard_TensorObjSubstrate.tex`)
STATE: GREEN. `sheafificationCompPullback_comp_tail` + caller CLOSED iter-006 (→ task_done). Residual:
- `pullbackTensorMap_restrict` (L3144) — Sq3/Sq4 interleave; iter-007 effort-broken into 3 blueprint
  bricks (`lem:sheafify_pullbackcomp_hom_inv_cancel`, `lem:sheafify_tensor_unit_iso_comp`,
  `lem:pullback_val_iso_comp`). Blueprint bricks gate-cleared this iter (adequate). NEXT: scaffold the
  3 bricks into Lean (`sheafifyMap_pullbackComp_hom_inv_id`, `sheafifyTensorUnitIso_comp`,
  `pullbackValIso_comp`), prove bottom-up, then close L3144. Recipe: `d3cocycle006.md` + chapter bricks.
- `exists_tensorObj_inverse` (L712) — consumes `dual_restrict_iso` (DUAL, downstream). Deferred (import cycle).

## Completeness audit (user-requested) — DONE
3-seed cone COMPLETE vs AJC: 108/108 nodes, cone sizes 52/36/32 exact, `DualInverse` decls complete.
Diffs = AJC dead-code Lan block (not ported) + out-of-scope Route-A. Nothing required missing.

## Scaffold targets (NOT fill-sorry — decls do not exist yet, also absent from AJC Lean)
- `LineBundlePullback.lean` `pullbackTensorIsoOfLocallyTrivial` (seed 1) — after `pullbackTensorMap_restrict` + D4′.
- `LineBundlePullback.lean` `pullback_tensorObj_iso` (`lem:pullback_compatible_with_tensorobj`).
- `RelPicFunctor.lean` `PicSharp.addCommGroup_via_tensorObj` (seed 3) — gated on both routes.

## Tracked debt
- ~97 lean_aux decls with no blueprint entry (`leandag unmatched`). Scheduled `Coverage + file-split
  cleanup` phase: blueprint blocks for load-bearing helpers + `private` for internals; split
  `TensorObjSubstrate.lean` (3152 LOC).
