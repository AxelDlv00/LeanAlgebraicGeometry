# Lean ↔ blueprint check — iter-047

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Scope
This iteration added six declarations to the Lean file:
`isLocalizedModule_of_exact`, `overlap_target_eq`, `presheaf_map_comp₂_apply`,
`overlap_section_localization`, `qcoh_section_isLocalizedModule`, `qcoh_section_kernel_comparison`.

Check bidirectionally:
1. Lean → blueprint: do the statements of `qcoh_section_isLocalizedModule` (blueprint label
   `lem:qcoh_section_isLocalizedModule`) and `qcoh_section_kernel_comparison`
   (`lem:qcoh_section_kernel_comparison`) match their blueprint blocks? Are the `\lean{...}` pins
   correct? Which of the 4 new infra decls lack any blueprint entry (coverage debt)?
2. Blueprint → Lean: the prover reports the Lean dependency direction is INVERTED from the
   blueprint: in Lean `qcoh_section_kernel_comparison := IsLocalizedModule.iso ρ_f` and consumes
   `qcoh_section_isLocalizedModule` as its instance, whereas the blueprint has
   `lem:qcoh_section_isLocalizedModule \uses lem:qcoh_section_kernel_comparison`. Also, the keystone
   was built directly via the abstract `isLocalizedModule_of_exact` (no blueprint node), not via
   `lem:qcoh_section_kernel_comparison`. Confirm whether this is a real `\uses`-direction
   discrepancy the planner must fix, and whether it introduces any circularity.

Report must-fix vs soon items, and whether the blueprint is adequate detail for what the Lean did.
