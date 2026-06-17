# Iter 031 — Objectives (per-lane targets)

## Lane 1 — FBC `Cohomology/FlatBaseChange.lean` [fine-grained]
- Build `base_change_mate_fstar_reindex_legs_link_cancelEUnit` (clean-term; splices atom
  `base_change_mate_inner_eCancel_eUnit` @~1538 in term mode).
- Build `base_change_mate_fstar_reindex_legs_link_cancelPullbackComp` (splices
  `base_change_mate_inner_eCancel_pullbackComp` @~1567).
- Build `base_change_mate_fstar_reindex_legs_link_survivor` (Seam 1 → `base_change_mate_inner_value`).
- Assemble `base_change_mate_fstar_reindex_legs` @1461 = `link_distributeCollapse` + the 3 wrappers, one
  closing `exact` chain. Cascade `gstar_transpose` @1833 (same mechanism).
- Out of scope: affine @2014, FBC-B @2036. Budget boundary (Open Q2).

## Lane 2 — QUOT `Picard/QuotScheme.lean` [mathlib-build]
- Build bridge-C step 2: `(Spec R).ringCatSheaf.over U ≅` (transport of) `U.toScheme.ringCatSheaf`.
- Step 3: lift to modules via `SheafOfModules.pushforwardPushforwardEquivalence`.
- Step 4: compose with `Scheme.Modules.restrictFunctorIsoPullback` ⟹
  `AlgebraicGeometry.Scheme.Modules.overRestrictIso`.
- Axiom-clean; precise handoff if blocked at step 2.

## Lane 3 — GR `Picard/GrassmannianCells.lean` [mathlib-build] (SCAFFOLD — new decls)
- Build `AlgebraicGeometry.Grassmannian.cocyclePhiId` (Φ=id ring identity; `IsLocalization.ringHom_ext` +
  reuse `cocycle_imageMatrix_eq`).
- Build the `cocycle` field, `theGlueData : Scheme.GlueData`, `Grassmannian.scheme := theGlueData.glued`.
- Min bar: `cocyclePhiId` axiom-clean.
