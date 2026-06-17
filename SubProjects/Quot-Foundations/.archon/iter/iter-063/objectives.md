# Iter 063 — Objectives detail

## Lane 1 — GR-quot (`GrassmannianQuot.lean`)
L3 chain, sequential from the proven ATOM:
- (a) FINISH `matrixEnd_pullback` (L981 sorry) — biproduct transport, per-entry → `scalarEnd_pullback`
  (proven L933). Term-mode `(pullback p).map_comp`; `biproduct.hom_ext'`/cofan + `pullbackObjFreeIso_hom_naturality`.
- (b) BUILD `baseChange_bridge` (forward-pinned) — ΓSpecIso identification of glue base-change maps with
  L1 ring homs (`awayInclLeft`/`awayInclRight`/`cocycleΘIJ`). Re-break candidate.
- (c) BUILD `bundleTransition_cocycle_transport` (forward-pinned) — pure assembly: a/b + L1 + L2.
- C2 `bundleTransition_cocycle` (L1048 sorry) — `apply Iso.ext` + feed L3 into `_hC2`.
- Riders (if C2 closes): `universalQuotient` (L1068) → `tautologicalQuotient` (L1079) → `represents` (L1573).
- Hygiene: rewrite stale section NOTE L316–322 to match the actual equalizer `glue` construction.

## Lane 2 — SNAP (`SectionGradedRing.lean`)
- `relativeTensorCoequalizerIso` (L693, scaffolded this plan phase; 2 sorries: cofork condition + body).
- 3-step: objectwise (`RelativeTensorCoequalizer.isColimitCofork`) → promote
  (`evaluationJointlyReflectsColimits`, VERIFIED `Mathlib/.../FunctorCategory/Basic.lean:103`) → apex
  (`PresheafOfModules.Monoidal.tensorObj_obj`, verified). `AddCommGrpCat` category; `change`/transport idioms.

## Deferred
- Coverage debt (19 dag-unmatched, all private/helper) — fold into chapters when next edited (rationale: plan.md).
- FBC (parked), QUOT top-level chain (blocked on SNAP), GR-repr (after riders).
