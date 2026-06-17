# Iter 055 — Objectives (Quot-Foundations)

3 prover lanes (1 file each), independent — no import/edit race.

| # | File | Mode | Target | Status entering |
|---|------|------|--------|-----------------|
| 1 | `Picard/FlatteningStratification.lean` | prove | CLOSE `genericFlatness`: fill `gf_common_basicOpen_basis` (L2912) + build `gf_flat_locality_assembly` + cover scaffold (L3057) | 2 sorries; **STUCK, hard deadline this iter** |
| 2 | `Picard/GrassmannianQuot.lean` | prove | close `pullbackObjUnitToUnit_comp` (L595) → `pullbackFreeIso_comp` → `functor.map_comp` (L605) → `functor` DROPS; then attempt `glue` | 6 sorries; CHURNING-borderline (functor.map_id dropped iter-054) |
| 3 | `Picard/SectionGradedRing.lean` | mathlib-build | build `relativeTensorCoequalizerIso` (presheaf promotion) → crux `isIso_sheafification_whiskerRight_unit` → `tensorObjAssoc`/`tensorPowAdd` | 0 sorries; CHURNING-MECHANICAL (no-op-filter dropped iter-051+054 — keyword now on filename line) |

## Recipes (full detail in PROGRESS.md + task_results iter-054)
- **GF (1):** Step-3 realisation via `isLocalization_basicOpen` + `IsLocalization.surj` + `basicOpen_mul`/`basicOpen_res`; assembly over `Module.flat_of_isLocalized_span` (R=Γ(S,U), B=Γ(X,W)); cover scaffold via `[QuasiCompact p]` + `Scheme.Hom.isCompact_preimage` + per-patch `genericFlatnessAlgebraic`.
- **GR (2):** conjugate route — `comp_homEquiv` factor + `unit_conjugateEquiv` + `conjugateEquiv_pullbackComp_inv`, `pullbackComp` OPAQUE, defeq-bridge `have key`.
- **SNAP (3):** `evaluationJointlyReflectsColimits` lift + `tensorObj_obj` apex id; crux via `W.monoidal` + `localIso_toPresheaf_map_unit` + `isIso_sheafification_map_iff`.

## Failure contingencies
- GF not closing ⟹ escalate next iter (re-spec/break assembly), NOT verbatim re-queue.
- SNAP promotion not Mathlib-constructible ⟹ precise handoff + escalate, no more helper layers.
