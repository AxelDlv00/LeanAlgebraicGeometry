# Blueprint-reviewer directive — iter-019

Audit the WHOLE blueprint (all chapters under `blueprint/src/chapters/`), per your standard
per-chapter completeness + correctness checklist. This is the HARD GATE for this iter's prover
dispatch.

This iter the consolidated chapter `Cohomology_CechHigherDirectImage.tex` was edited (the other two
chapters are unchanged since your iter-017 clear):
- `lem:higher_direct_image_presheaf` re-signed to the resolution form
  (`\lean{...higherDirectImage_iso_sheafify_presheafHomology}`); a new engine block
  `def:cohomology_sheaf_is_sheafify_homology` (`\lean{PresheafOfModules.homologyIsoSheafify}`) was added.
- 44 prover-created helper names were bundled into four blocks' `\lean{...}` lists (no math change).

The prover lanes I intend to dispatch THIS iter (gate them):
1. `CechBridge.lean` → `lem:cech_complex_hom_identification`.
2. `FreePresheafComplex.lean` → `lem:cech_free_complex_quasi_iso` (+ `def:cover_structure_presheaf`).
3. `CechAcyclic.lean` → `def:qcoh_sections_localized` + `lem:section_cech_homology_exact` +
   `lem:cech_acyclic_affine` (section form).

For each chapter give `complete: true|false` and `correct: true|false`, and list any
must-fix-this-iter findings. I especially need to know whether the three lane targets above are
well-formulated and ready for formalization. Note: the strategy-critic already flagged (and I have
recorded in STRATEGY.md) that the re-signed `lem:higher_direct_image_presheaf` RELOCATES rather than
eliminates the absolute-`Hᵏ(f⁻¹V,G)` obligation to its downstream consumers — if the P5a block's
prose now honestly reflects that (the blueprint-writer + blueprint-clean were directed to say so),
that is acceptable and not a must-fix; flag only if it still overclaims.
