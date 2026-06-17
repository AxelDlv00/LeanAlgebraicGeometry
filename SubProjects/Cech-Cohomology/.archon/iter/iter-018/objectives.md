# Iter-018 objectives (4 parallel lanes)

All blueprint-gate-clear (consolidated chapter `Cohomology_CechHigherDirectImage.tex`,
blueprint-reviewer iter017). All [prover-mode: mathlib-build]. Noop-filter status verified KEPT.

| # | File | Target decl(s) | Blueprint label(s) | Noop status |
|---|------|----------------|--------------------|-------------|
| 1 | `FreePresheafComplex.lean` | `coverStructurePresheaf`, `cechFreeComplex_quasiIso` | `def:cover_structure_presheaf`, `lem:cech_free_complex_quasi_iso` | exempt (keyword) |
| 2 | `CechBridge.lean` | `cechComplex_hom_identification` | `lem:cech_complex_hom_identification` | exempt (keyword) |
| 3 | `CechAcyclic.lean` | `qcohSectionsAwayLocalized`, `sectionCech_homology_exact`, `sectionCech_affine_vanishing` (+import PresheafCech) | `def:qcoh_sections_localized`, `lem:section_cech_homology_exact`, `lem:cech_acyclic_affine` | kept (has sorry) |
| 4 | `HigherDirectImagePresheaf.lean` (NEW) | `higherDirectImage_isSheafify_presheafCohomology` | `lem:higher_direct_image_presheaf` | exempt (new file + keyword) |

## Per-lane attempt notes (seed for next iter's review)

- **Lane 1 (P3b free)** — VALIDATED route iter-016: `PreservesHomology (evaluation … V)` ⇒ sectionwise
  homology; prepend-`i_fix` homotopy `dh+hd=id` (port `CombinatorialCech.*`); `Homotopy ⇒ HomotopyEquiv
  ⇒ toQuasiIso`. DEAD END: `ExtraDegeneracy`. First data point for `cechFreeComplex_quasiIso`.
- **Lane 2 (P3b bridge)** — `freeYonedaHomAddEquiv` (per-degree Ab-iso) + coproduct-hom-as-product;
  intertwine differentials; `isoOfComponents`. Target = Ab. 3-step recipe in the file's strategy comment.
  Now UNBLOCKED (both complexes exist). First data point.
- **Lane 3 (P3 L1)** — STUCK-route corrective (structural redesign, NOT a re-run). Bottom-up:
  qcoh-localized (carries the 01I8 globalisation Mathlib gap) → homology-exact → re-signed top. Old
  relative-form `CechAcyclic.affine` (line 109) superseded by Q4; leave as-is.
- **Lane 4 (P5a)** — new file, 01XJ leaf, route confirmed `analogies/p5a.md`. First data point;
  build axiom-clean as far as possible, hand off decomposition.
