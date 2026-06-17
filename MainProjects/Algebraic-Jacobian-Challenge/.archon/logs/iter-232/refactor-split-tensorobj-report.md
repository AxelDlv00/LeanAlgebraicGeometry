# Refactor Report

## Slug
split-tensorobj

## Status
COMPLETE

## Directive
**Problem:** Split the 2375-line `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` into
semantically-coherent sub-files to enable parallelism, isolate the live C-bridge build
target, and quarantine vestigial d.2 apparatus.

**Changes requested:** Create `AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean`
and `AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean`; rewrite the
main `TensorObjSubstrate.lean` to import both sub-files and contain only the
`AlgebraicGeometry.Scheme.Modules` public API + consumer.

## Changes Made

### File: `AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean` (NEW, 588 lines)

**What:** Created new file containing the quarantined vestigial sections.

**Contents:**
- `namespace PresheafOfModules` block with:
  - `section FlatWhisker` (≈L426–748 of original): `toPresheaf_whiskerLeft_app_tmul`,
    `toPresheaf_whiskerLeft_app_apply`, `isLocallySurjective_whiskerLeft`,
    `isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`,
    `W_whiskerRight_of_flat`
  - `section WhiskerOfW` (≈L630–726 of original): `isLocallyInjective_whiskerLeft_of_W`
    (carries the sorry), `W_whiskerLeft_of_W`, `W_whiskerRight_of_W`
  - `isIso_sheafification_map_of_W` (inside FlatWhisker, ≈L736–747)
  - `section StalkLinearMap` (≈L750–865 of original): `stalkLinearMap`,
    `stalkLinearMap_germ`, `stalkLinearMap_bijective_of_isIso`, `stalkLinearEquivOfIsIso`
- `namespace AlgebraicGeometry.Scheme.Modules` block with:
  - `section OverSliceSheafEquiv` (≈L2264–2375 of original): `overEquiv_image_cover_iff`,
    `overEquivInverseIsDenseSubsite`, `overSliceSheafEquiv`

**Why:** Quarantine vestigial route-(e) apparatus and the shared root `overSliceSheafEquiv`.

**Cascading:** None — this file has no importers beyond `TensorObjSubstrate.lean`.

---

### File: `AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean` (NEW, 1098 lines)

**What:** Created new file containing the foundational presheaf algebra for the C-bridge.

**Contents:**
- `section RestrictScalarsRingIsoTensor` (≈L103–340 of original): 
  `restrictScalarsRingIsoTensorEquiv`, `restrictScalarsRingIsoTensorEquiv_apply_tmul`,
  `restrictScalars_isIso_μ`, `restrictScalars_isIso_ε`, `restrictScalarsMonoidalOfRingEquiv`,
  `restrictScalars_isIso_μ_of_bijective`, `restrictScalars_isIso_ε_of_bijective`,
  `restrictScalarsRingIsoDualEquiv`
- `namespace PresheafOfModules` block (first, for lax monoidal, ≈L342–424 of original):
  `restrictScalarsLaxε`, `restrictScalarsLaxμ`, `restrictScalarsLaxMonoidal`
- `namespace PresheafOfModules` block (second, ≈L869–1611 of original):
  - `section PushforwardNatTrans`: `pushforwardNatTrans`, `pushforwardNatTrans_app_app_apply`
  - `section PushforwardCongr`: `pushforwardCongr`, `pushforwardCongr_hom_app_app`,
    `pushforwardCongr_inv_app_app`
  - `section PushforwardAdj`: `pushforwardPushforwardAdj`
  - `section StrongMonoidalRestrictScalars`: `isIso_of_isIso_app`,
    `restrictScalarsMonoidalOfBijective`
  - `namespace InternalHom` (first block): `termRingMap`, `termRingMap_naturality`,
    `globalSMul`, `globalSMul_hom_apply`, `globalSMul_one`, `globalSMul_zero`,
    `globalSMul_add`, `globalSMul_mul`, `homModule`, `restr`, `internalHomObjModule`,
    `restrictionMap`, `restrictionMap_add`, `restrictionMap_zero`, `hom_app_heq` (private),
    `restrictionMap_id`, `restrictionMap_comp`, `restrictionMap_comp_hom`,
    `restrictionMap_globalSMul`, `restrictionMapAddHom`, `internalHomPresheaf`,
    `restrictionMap_smul`
  - `namespace InternalHom` (second block — Assembly): `internalHom`
  - `namespace InternalHom` (third block): `termRingMap_terminal`
  - `section Dual`: `dual`, `evalLin`, `evalLin_add`, `evalLin_smul`, `internalHomEvalApp`,
    `internalHomEvalApp_tmul`, `restr_map_homMk` (private), `internalHomEval`,
    `dualPrecompEquiv`, `dualIsoOfIso`

**Why:** This is the foundational presheaf layer + C-bridge substrate where the upcoming
incremental C-bridge sub-build will land.

**Cascading:** None — no importers beyond `TensorObjSubstrate.lean`.

---

### File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (REWRITTEN, 768 lines)

**What:** Replaced 2375-line monolith with imports + remaining public API content.

**New imports:**
```lean
import AlgebraicJacobian.Picard.TensorObjSubstrate.Vestigial
import AlgebraicJacobian.Picard.TensorObjSubstrate.PresheafInternalHom
import AlgebraicJacobian.Picard.RelPicFunctor
```

**Retained content (`namespace AlgebraicGeometry.Scheme.Modules`):**
- `tensorObj`, `tensorObj_functoriality`, `IsInvertible`, `dual`, `dualIsoOfIso`
- `tensorObjIsoOfIso`, `tensorObj_unit_iso`, `tensorObj_left_unitor`, `tensorObj_right_unitor`,
  `tensorObj_braiding`, `tensorObj_assoc_iso`
- `restrictIsoUnitOfLE`, `tensorObj_restrict_iso`, `tensorObj_isLocallyTrivial`
- `isIso_of_isIso_restrict`, `homMk`, `toPresheaf_map_homMk`
- `exists_tensorObj_inverse` (carries sorry at L716)
- `tensorObjOnProduct`
- `namespace PicSharp`: `addCommGroup_via_tensorObj` (carries sorry at L762)

**The iter-230 diagnostic comment block** was kept intact (it contains no declarations and the directive allowed but did not require deletion; retained for historical context).

**Why:** Preserve the public import surface while removing the sections that moved to sub-files.

**Cascading:** `AlgebraicJacobian.lean` line 20 imports `AlgebraicJacobian.Picard.TensorObjSubstrate` unchanged — the transitive import closure is preserved.

## New Sorries Introduced
None. Zero new sorries were introduced anywhere.

## Sorry Locations After Split

| Sorry | Declaration | File | Line |
|-------|------------|------|------|
| 1 | `isLocallyInjective_whiskerLeft_of_W` | `TensorObjSubstrate/Vestigial.lean` | 267 |
| 2 | `exists_tensorObj_inverse` | `TensorObjSubstrate.lean` | 694 |
| 3 | `addCommGroup_via_tensorObj` | `TensorObjSubstrate.lean` | 759 |

All 3 code sorries moved verbatim with their declarations. No new sorries anywhere.

## Compilation Status

- `AlgebraicJacobian.Picard.TensorObjSubstrate.Vestigial`: **BUILDS CLEAN** (8318 jobs)
  - 1 expected sorry warning (`isLocallyInjective_whiskerLeft_of_W`)
- `AlgebraicJacobian.Picard.TensorObjSubstrate.PresheafInternalHom`: **BUILDS CLEAN** (8318 jobs)
  - 0 sorry warnings; style warnings only (line length, ext pattern) — pre-existing in original
- `AlgebraicJacobian.Picard.TensorObjSubstrate`: **BUILDS CLEAN** (8321 jobs)
  - 2 expected sorry warnings (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`)
- `AlgebraicJacobian` (root aggregator, full project): **BUILD COMPLETED SUCCESSFULLY** (8364 jobs)

`lake build` exit 0 confirmed for all targets.

## Import Graph

```
Mathlib
  └─ TensorObjSubstrate/Vestigial.lean       (standalone; 1 sorry)
  └─ TensorObjSubstrate/PresheafInternalHom.lean  (standalone; 0 sorries)
       ↖ both imported by ↘
  AlgebraicJacobian.Picard.RelPicFunctor
       └─ TensorObjSubstrate.lean             (2 sorries; public API)
              └─ AlgebraicJacobian.lean (unchanged import at line 20)
```

## Sorry Count

The full project `lake build` shows 81 sorry warnings. The pre-refactor working-tree state (with the original 2375-line `TensorObjSubstrate.lean`) also produced 81 sorry warnings — this refactor is a pure zero-delta move. The 1-warning discrepancy from the directive's stated "80" is pre-existing in the working tree (not caused by this refactor) and is outside the scope of this structural change.

## Notes for Plan Agent

1. **Import independence confirmed:** `Vestigial.lean` and `PresheafInternalHom.lean` are fully
   independent of each other (neither imports the other). They can be assigned to parallel
   prover agents without write-domain conflicts.

2. **C-bridge landing zone ready:** `PresheafInternalHom.lean` is now the dedicated file where
   the upcoming C-bridge sub-build (`dual_restrict_iso` → `dual_isLocallyTrivial`) should land.
   Future provers no longer pay the 2375-line context cost.

3. **`OverSliceSheafEquiv` in Vestigial:** The axiom-clean `overSliceSheafEquiv` is quarantined
   in `Vestigial.lean`. It remains available via `import AlgebraicJacobian.Picard.TensorObjSubstrate`
   (transitive). If the A-bridge or C-bridge provers need it directly, they can import
   `AlgebraicJacobian.Picard.TensorObjSubstrate.Vestigial` without paying for the full main file.

4. **Style warnings in PresheafInternalHom.lean:** Several line-length warnings (>100 chars)
   appear on long docstrings that were verbatim-copied from the original file. These were
   pre-existing in the original and do not affect correctness.

5. **`tensorObj_assoc_iso` reference to Vestigial:** The main `TensorObjSubstrate.lean` uses
   `PresheafOfModules.W_whiskerRight_of_W`, `W_whiskerLeft_of_W`, and
   `isIso_sheafification_map_of_W` from `Vestigial.lean`. These are transitively available
   through the import chain, confirmed by successful compilation.
