---
name: dualinverse-naturality-wall
description: DualInverse.lean sliceDualTransport naturality wall = missing restrictScalarsLaxε ε-NatTrans; round-trips bypass it via hom_ext
metadata:
  type: project
---

`Picard/TensorObjSubstrate/DualInverse.lean` — the residual sorries split into TWO classes
(iter-306 finding):

**Class 1 — ε-naturality WALL (architectural, NOT tactic friction):** `sliceDualTransport`
`naturality` (refine_1), `sliceDualTransportInv` naturality (~L388), and `dual_restrict_iso`
isoMk naturality (~L760) ALL need the lax-monoidal-ε naturality of `ModuleCat.restrictScalars`
across the restriction square — the NatTrans the blueprint NOTE names
`PresheafOfModules.restrictScalarsLaxε`. **It does NOT exist** in the codebase
(`lean_local_search restrictScalarsLax` → empty) and mathlib's `CategoryTheory.ε_naturality` is
End-monoidal only (functor-category), useless for `restrictScalars` across two distinct base ring
maps `β_X1`/`β_Y1`. Building it = lax-monoidal-naturality of `R ↦ restrictScalars` in the ring map.
This is the iter-306 reversing-signal wall. Recommended fix (per signal): a `.map`-only categorical
rebuild that never forms `dualUnitRingSwap` pointwise, so naturality becomes functorial.

**Class 2 — round-trips BYPASS the wall:** `left_inv`/`right_inv` (refine_5/6) reduce via
`intro φ; apply PresheafOfModules.hom_ext; intro W''` to PER-COMPONENT equalities (naturality fields
are proof-irrelevant under `hom_ext`). These need only the existing ε-cancellation lemmas
`dualUnitRingSwap_comp_dualUnitRingSwapInv` / `dualUnitRingSwapInv_comp_dualUnitRingSwap` +
`Iso.inv_hom_id`/`hom_inv_id` of `f.appIso` + `eqToHom`/`restrictScalarsId'App` collapse. Likely
closeable WITHOUT new infra — cheapest unblock. (iter-306 left them as structured per-component
sorries.) See [[ts-assoc-flatness-gap]].
