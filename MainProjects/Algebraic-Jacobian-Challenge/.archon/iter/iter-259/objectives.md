# Iter-259 objectives (per-file detail)

## 1. `Picard/SheafOverEquivalence.lean` — close `restrictOverIso` + `unitOverIso` [prove] (PRIMARY)
- `overEquivalence` CLOSED iter-258 (axiom-clean). 2 mechanical sorries remain.
- `restrictOverIso` (body L~233): `pushforwardComp (=Iso.refl)` + `pushforwardNatIso` along the `eqToIso`
  of `Over.forget U` vs `U.ι.opensFunctor ⋙ e.functor` (both `V↦V.left`); mirror `restrictFunctorAdjCounitIso`.
- `unitOverIso` (leaf L~276): `(asIso (unitToPushforwardObjUnit (phiOver U))).symm`; close the leaf via
  `unitToPushforwardObjUnit_val_app_apply` ⇒ section = `(phiOver U).hom.app W` (ring iso by `hφ`) ⇒
  reflect RingCat→AddCommGrp. Reflection chain + `IsIso (phiOver U)` already built above.
- Recipe: `analogies/overeq258.md`; prior task_result detail in this iter's archived report.
- Bar: close both → `chartOverIso` chain fully axiom-clean → engine + dual unblocked next iter.

## 2. `Picard/TensorObjSubstrate.lean` — D3′ Sq2b → `pullbackTensorMap_restrict` [prove]
- pc259 STUCK (iter-258 ghost run); this is the FIRST real attempt of the η→δ recipe.
- Recipe `analogies/d3sq2b258.md`: build the PresheafOfModules-level Sq2b (`pullbackComp` monoidality) by
  η→δ port of the COMPILING `pullbackObjUnitToUnit_comp` (L910); transpose via
  `(pullbackPushforwardAdjunction _).homEquiv.injective` + `Adjunction.leftAdjointOplaxMonoidal_δ`; bookkeeping
  from `Adjunction.isMonoidal_comp`; `erw` for assoc/`map_comp`. Then 4-square assembly (Sq1/Sq3/Sq4) + the
  closed `rfl` reconcile close `pullbackTensorMap_restrict`. Keep D1′/D2′ GREEN; do NOT touch L715.
- Reversing signal: a step with NO analog in `pullbackObjUnitToUnit_comp` ⇒ typed sorry + report; no new helper.

## HELD (not dispatched)
- `Picard/TensorObjSubstrate/DualInverse.lean` — gated on shared root fully green (avoids import race);
  `sliceDualTransport` = one-liner consumer next iter; fix stale L287–315 WARM-CONTEXT block on re-open.
- `Picard/LineBundleCoherence.lean` — locally sorry-free; auto axiom-clean once root closes.
- RPF, FGA, Cohomology/*, Albanese/*, RR.*/Genus0 (paused/gated) — see PROGRESS.md held lanes.
