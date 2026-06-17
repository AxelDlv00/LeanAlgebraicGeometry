# Iter 067 — Objectives detail

## Lane 1 — GlueDescent.lean (NEW, conditional on refactor `split-glue-descent` landing green)
- β_ij `glueOverlapBaseChangeIso` (pre-split L2097 sorry inside `pushforwardCongr (ext V : 3)`):
  the four-functor site-level pushforward identification; templates =
  Mathlib `restrictFunctorAdjCounitIso`/`restrictFunctorComp` (AlgebraicGeometry/Modules/Sheaf.lean).
- Keystone `isIso_glueRestrictionHom` (pre-split L2134): σ_i equalizer lift route, steps 1–4 in
  the decl docstring; the limit-preservation instances + `glueIsoEqualizer` + the equalizer/prod
  comparison isos (`glueRestrictEqualizerIso`/`glueRestrictProdIso`) are PROVEN.
- `glue_unique` (blueprint `lem:gr_modules_glue_unique`, frontier-ready, no Lean decl yet) —
  joint faithfulness of chart restrictions (mono of `glue ⟶ ∏ (ι_i)_* M_i`); BUILD objective.
  Feeds `tautologicalQuotient_epi` in lane 2.

## Lane 2 — GrassmannianQuot.lean
- `grPointOfRankQuotient` (pre-split L3308) + `_rel` (L3317): Nitsure §5 chart-loci inverse
  (route in docstring; keystone-INDEPENDENT — can run in parallel with lane 1).
- `tautologicalQuotient_epi` (L3282): needs `glue_unique` from lane 1 — attempt only if it has
  landed (import refresh), else leave pinned with the route comment.
- `represents` inverse laws (L3339/L3344): ride on the above; attempt only with budget left.

## Lane 3 — SectionGradedRing.lean (conditional on scaffolder `snap-tensor` landing)
- `tensorObjAssoc` (cor:sheafTensorObjAssoc): associator via the CLOSED crux — both iterated
  sheaf tensors compare to the sheafified triple presheaf tensor through whiskered units
  (now isos); presheaf associator descends.
- `tensorPowAdd` (lem:sheafTensorPow_add): induction on m via associator + right-unitor base.
- `sectionsMul_assoc_unit` only if scaffolded (prereq check).

## Risk notes
- Throughput gate (progress-critic iter067): GR must close ≥2 sorried decls this iter or next
  iter reads CHURNING → corrective = blueprint expansion of the keystone descent route.
- If refactor ABORTED: lanes 1+2 collapse to one GrassmannianQuot lane, keystone first.
