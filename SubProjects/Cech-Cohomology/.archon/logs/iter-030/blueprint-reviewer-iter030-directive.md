# Blueprint-reviewer — iter-030 (HARD GATE)

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). This is the HARD GATE
for the prover lanes this iter.

## Context
The consolidated chapter `Cohomology_CechHigherDirectImage.tex` was just edited (blueprint-writer +
blueprint-clean) to reflect a **resolved design fork** in the 02KG affine phase:
- `injective_cech_acyclic` is being re-parameterized to a raw finite family of opens (cover-agnostic),
  so the `BasisCovSystem.injective_acyclic` field is discharged directly by the family-form lemma.
- `lem:cover_datum_bridge` repinned to `coverOpen_affineOpenCoverOfSpan` (open-level identity).
- `lem:affine_surj_of_vanishing` rewritten to the local-surjectivity route (gap-fill
  `toSheaf_preservesEpimorphisms` + `Presheaf.IsLocallySurjective` + `ses_cech_h1`), with 4 new
  helper/Mathlib-anchor blocks.
- `lem:qcoh_iso_tilde_sections`: presentation lemma block added, accessors bundled, 01I8 3-step
  decomposition remark added.

## Specifically gate these files' chapter (consolidated chapter covers them)
This iter's prover lanes will run on `FreePresheafComplex.lean` (family-form re-parameterization of
the free Čech resolution) and `QcohTildeSections.lean` (01I8 global generation). Both are covered by
`Cohomology_CechHigherDirectImage.tex`. Confirm:
- `lem:injective_cech_acyclic` is complete + correct for the family-form (arbitrary finite family of
  opens, no covering hypothesis) — formalize-ready for the re-parameterization.
- `lem:qcoh_iso_tilde_sections` + `lem:qcoh_iso_tilde_sections_of_presentation` +
  `rem:o1i8_decomposition` are complete + correct + formalize-ready for the 01I8 lane.
- The `affine_surj_of_vanishing` / `affineCoverSystem` blocks (next-iter lane) are coherent and their
  `\uses{}` acyclic, but they do NOT gate this iter.

## Output
Per-chapter checklist (complete / correct, must-fix-this-iter findings). Apply the HARD GATE verdict
for `Cohomology_CechHigherDirectImage.tex`. Note any broken `\uses{}`, isolated nodes, or `\lean{}`
pins that name non-existent declarations. Also surface any unstarted-phase blueprint gaps.
