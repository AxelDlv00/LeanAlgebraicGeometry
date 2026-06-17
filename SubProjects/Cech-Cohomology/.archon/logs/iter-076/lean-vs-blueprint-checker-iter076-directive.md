# lean-vs-blueprint-checker — iter-076

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(consolidated; declares `% archon:covers …CechAugmentedResolution.lean`). Relevant blocks:
`lem:cechSection_isZero_homology` (≈9491) and `lem:cech_augmented_resolution` (≈7233).

## Check
- Does the new Lean `cechSection_isZero_homology` match `lem:cechSection_isZero_homology` (statement +
  `\uses` deps `cechSection_complex_iso`, `cechSection_contractible`,
  `isZero_homology_of_homotopy_id_zero`)?
- Does `cechAugmented_exact`'s closure (Step 3(d) now `exact cechSection_isZero_homology …`) match the
  blueprint sketch for `lem:cech_augmented_resolution`?
- Report bidirectionally (Lean→bp and bp→Lean). Read-only.
