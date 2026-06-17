# Blueprint-reviewer directive — iter-047 whole-blueprint audit

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) per your standard per-chapter
completeness + correctness checklist.

## What changed this iter (for your context, not a scope limit — review everything)
- `lem:tile_section_localization` (the last keystone-feeding leaf) LANDED axiom-clean in iter-046.
- This iter (047) a blueprint-writer + blueprint-clean pass edited ONLY
  `Cohomology_CechHigherDirectImage.tex`:
  - added two scaffolding blocks: `lem:tileReconcileEquiv`
    (`\lean{AlgebraicGeometry.tileReconcileEquiv}`) and `lem:isScalarTower_restrictScalars_obj`
    (`\lean{AlgebraicGeometry.isScalarTower_restrictScalars_obj}`);
  - bundled 3 private helper names into existing `\lean{...}` lists;
  - fixed two stale `\uses{}` edges on `lem:tile_section_localization` (removed
    `lem:qcoh_finite_presentation_cover` from the statement, removed `lem:tile_scalar_compat`
    from the proof, added `lem:tileReconcileEquiv` + `lem:isScalarTower_restrictScalars_obj`).

## Gate decision I need from you
The NEXT prover lane builds `lem:qcoh_section_kernel_comparison`
(`\lean{AlgebraicGeometry.qcoh_section_kernel_comparison}`) in `QcohTildeSections.lean`. Per the
HARD GATE, that lane may dispatch only if `Cohomology_CechHigherDirectImage.tex` is
`complete: true` AND `correct: true` with no must-fix finding touching the kernel-comparison block
or its `\uses` cone. Confirm specifically:
- Is `lem:qcoh_section_kernel_comparison`'s block (statement + proof sketch + `\uses{}`) complete
  and detailed enough to formalize, and are its `\uses` deps (`qcoh_finite_presentation_cover`,
  `qcoh_section_equalizer`, `localized_module_map_exact_mathlib`, `tile_section_localization`)
  all present and correctly wired?
- Did the two new scaffolding blocks introduce any correctness or wiring error?

Report your per-chapter checklist and an explicit complete/correct verdict for
`Cohomology_CechHigherDirectImage.tex`, listing any must-fix-this-iter items.
