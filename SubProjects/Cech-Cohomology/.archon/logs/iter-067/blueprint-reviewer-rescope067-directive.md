# Blueprint-reviewer directive — slug `rescope067` (SCOPED fast-path)

Scoped re-review to clear the HARD GATE for `CechSectionIdentification.lean` after the must-fix from
your `iter067` dispatch was patched.

## What was flagged and what was fixed

Your `iter067` audit returned `correct: partial` on `Cohomology_CechHigherDirectImage.tex` with ONE
must-fix: the three augmentation helpers (`lem:mapHC_augment_iso`, `lem:map_augment_cond`,
`lem:augmentCochainIso`) were in the PROOF `\uses{}` of `lem:cechSection_complex_iso` but not its
STATEMENT `\uses{}`, leaving them isolated in the leandag (which builds edges from statement-level
`\uses{}` only).

Patch applied this iter:
- Added `lem:mapHC_augment_iso, lem:map_augment_cond, lem:augmentCochainIso` to the **statement**
  `\uses{}` of `lem:cechSection_complex_iso`.
- Added `\uses{lem:map_augment_cond}` to the **statement** of `lem:mapHC_augment_iso`.
- `archon dag-query isolated`/`unmatched` now show the three helpers connected (the only remaining
  isolated/unmatched nodes are the two long-known dead ones: `lem:pullbackObjUnitToUnit_mathlib` and
  `lean:AlgebraicGeometry.CechAcyclic.affine` — both pre-existing, non-blocking, not part of this lane).

## Task

Re-review the consolidated chapter `Cohomology_CechHigherDirectImage.tex` — focused on the
`CechSectionIdentification.lean` region (the augmentation helpers, the `coreIso` chain
`lem:coverInterOpen_inf_distrib`/`lem:coreIso_obj_iso`/`lem:coreIso_comm`, `lem:cechSection_complex_iso`,
`lem:cechSection_contractible`). Confirm whether the gate now CLEARS for `CechSectionIdentification.lean`:
is the chapter coverage of that file **complete + correct** with no remaining must-fix-this-iter finding?
Report the verdict (complete/correct booleans) and any residual must-fix.
