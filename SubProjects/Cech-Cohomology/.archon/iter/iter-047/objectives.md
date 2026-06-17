# Iter-047 objectives

## Lane 1 (mathlib-build) — `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
Build the NEW declaration `qcoh_section_kernel_comparison` (`lem:qcoh_section_kernel_comparison`), the next
keystone-feeding leaf (frontier-READY; all 4 `\uses` deps DONE: `qcoh_finite_presentation_cover`,
`qcoh_section_equalizer`, `IsLocalizedModule.map_exact`, `tile_section_localization`).

- Source of truth: blueprint `lem:qcoh_section_kernel_comparison` in
  `chapters/Cohomology_CechHigherDirectImage.tex` (full equalizer→localize→match→kernels proof).
- Statement: for `X=Spec R`, qcoh `F`, `f∈R`, finite presentation cover `{g_j}` (span=R): the canonical
  `R`-linear `Γ(X,F)_f → Γ(D(f),F)` (localization lift of `ρ_f` at `powers f`) is an iso.
- Stretch (same lane): keystone `qcoh_section_isLocalizedModule` if the kernel comparison lands.
- Likely Mathlib need to confirm/build: localization commutes with finite products.
- Non-circularity hinge: sections-localise inputs only on the tiles (`tile_section_localization`), never on
  global `Γ(X,F)`; do NOT use `isLocalizedModule_of_span_cover` as glue.

## Gate status
- Blueprint HARD GATE: CLEARED (blueprint-reviewer `iter047`, complete + correct, 0 must-fix).
- progress-critic `routeb`: CONVERGING, dispatch=OK.
- Coverage debt: `unmatched` 6→1 (only the pre-existing dead `CechAcyclic.affine`).
