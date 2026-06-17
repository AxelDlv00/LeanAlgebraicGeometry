# lean-vs-blueprint-checker directive — iter-043

## The one Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

## Its blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(this consolidated chapter declares `% archon:covers` for the QcohTildeSections file; the
relevant blocks are `lem:tile_section_comparison`, `lem:tile_section_localization`,
`lem:tile_image_opens_identities`, `lem:qcoh_section_equalizer`, and the keystone
`lem:qcoh_section_isLocalizedModule`).

## What changed this iter
The prover added TWO new axiom-clean `rfl` lemmas that are NOT yet in the blueprint:
- `AlgebraicGeometry.modulesSpecToSheaf_smul_eq`
- `AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq`
Both are sub-ingredients of `lem:tile_section_comparison` (Sub-lemma B). The named targets
`tile_section_comparison` / `tile_section_localization` were NOT added (no sorry papered);
the obstruction was reduced to a single structure-sheaf ring identity, documented in an in-file
comment.

## Report bidirectionally
1. **Lean → blueprint:** Are the two new lemmas present in the chapter? (Expected: NO — flag as
   coverage debt for the planner.) Do any existing blueprint blocks have `\lean{}` pins that no
   longer match the Lean?
2. **Blueprint → Lean:** Is the `lem:tile_section_comparison` sketch still adequate given the
   prover's finding that the reconciliation reduces to ONE structure-sheaf ring identity (not the
   ~150-LOC cross-ring construction the sketch may describe)? Flag if the sketch now over- or
   under-specifies the real remaining content. Is the sketch's mechanism (base-ring descent
   `isLocalizedModule_powers_restrictScalars_of_algebraMap`, Sub-lemmas A/B) consistent with the
   actual Lean reduction route?

## Output
Bidirectional findings + any must-fix-this-iter to `task_results/lean-vs-blueprint-checker-qts.md`.
