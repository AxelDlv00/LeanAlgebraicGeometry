# Directive — lean-vs-blueprint-checker (iter-046)

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(the relevant block is `lem:tile_section_localization` around line ~4833, plus its `\uses{}` ancestors
`lem:tile_scalar_compat`, `lem:tile_scalar_compat_genV`, `lem:tile_image_opens_identities`,
`lem:section_isLocalizedModule_of_presentation`, `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`,
`lem:modulesSpecToSheaf_smul_eq`, `lem:modulesRestrictBasicOpen_smul_eq`).

## What to check
1. Lean → blueprint: this iter the prover landed `tile_section_localization` (the keystone leaf) plus
   supporting decls `isScalarTower_restrictScalars_obj`, `tileReconcileEquiv`,
   `tileReconcileEquiv_apply`, `tileReconcileEquiv_symm_apply`, `tile_restrict_map_apply`. Does the Lean
   statement of `tile_section_localization` match the blueprint lemma statement (the `IsLocalizedModule`
   / `Γ(D(g),F)_f ≅ Γ(D(gf),F)` claim)? Is the formalized proof route (restrictScalars-carrier descent,
   two-layer transport) the one the blueprint Step 1–5 describes, or has the blueprint sketch drifted?
2. Blueprint → Lean: are the 5 new supporting decls covered by blueprint blocks, or are they uncovered
   coverage debt? Which `\uses{}` edges, if any, are now inaccurate?
3. Flag fake/placeholder statements, signature mismatches, or a blueprint too thin to have guided this
   formalization.

## Output
Bidirectional report: Lean→blueprint findings AND blueprint→Lean findings, each tagged
must-fix-this-iter / major / minor. Note explicitly whether the `\lean{}` pin is correct.
