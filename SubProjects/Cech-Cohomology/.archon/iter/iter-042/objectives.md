# Iter-042 objectives

## Dispatched (1 lane, mathlib-build)

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` — `tile_section_localization` (+ Sub-lemmas A, B)
- **Goal:** build the last keystone leaf `tile_section_localization` — for qcoh `F`, `f g : R` (`g` a
  cover/overlap element): `IsLocalizedModule (Submonoid.powers f)` of the `R`-linear section restriction
  `Γ(D(g),F) → Γ(D(gf),F)`.
- **Blueprint (HARD-GATE-cleared this iter):** `Cohomology_CechHigherDirectImage.tex` —
  `lem:tile_section_localization`, `lem:tile_image_opens_identities` (A),
  `lem:tile_section_comparison` (B), `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap` (DONE).
- **Recipe:** the honest 5-step base-ring descent (see PROGRESS `## Current Objectives` #1). Build Sub-lemma A
  (cheap opens identities) → Sub-lemma B (~100–150 LOC natural `R_g`-linear section comparison — the genuine
  cost) → assemble via the DONE base-ring descent.
- **Dead-end to avoid:** the `restrict_obj`-rfl recipe is UNSOUND (global-vs-local-ring functor mismatch,
  verified iter-041). `analogies/keystone-descent.md`. Do NOT use `isLocalizedModule_of_span_cover` (circular).
- **Stop condition:** mathlib-build, no sorry. If Sub-lemma B stalls, leave partial progress + a finer
  decomposition; do NOT paper with a sorry.

## Not dispatched (rationale in plan.md D1)
- P5a frontier (`lem:cech_augmented_resolution`/`cechAugmented_exact`, `lem:cech_free_eval_prepend_homotopy`)
  — deep, unscaffolded, blueprint adequacy unverified; off the gate-cleared critical path this iter.
- `lem:tilde_restrict_basicOpen` — DORMANT Route-P asset; on the frontier but must NOT be resurrected.
- All DONE / off-limits files per PROGRESS `## Off-limits / not this iter`.
