# lean-vs-blueprint-checker — CechAcyclic.lean (iter-021)

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(this consolidated chapter declares `% archon:covers` for CechAcyclic.lean; the relevant blocks are the
`lem:section_cech_*` family — `lem:section_cech_product_equiv`, `lem:section_cech_coface_match`,
`lem:section_cech_ab_exact`, `lem:section_cech_homology_exact` — plus `lem:cech_acyclic_affine` and
`def:qcoh_sections_localized`.)

## What to check
- Lean → blueprint: do the 5 declarations added this iter (`sectionCechProductEquiv`,
  `sectionCechProductEquiv_apply`, `sectionCechFaceRestr`, `sectionCech_objD_apply`,
  `sectionCech_isZero_homology_of_objD_exact`) faithfully realize the blueprint sub-lemmas they claim, or
  are any fake/placeholder/partial relative to the prose?
- The prover reports the *abstract* coface match (`sectionCech_objD_apply`) is built but the
  fully-wired `sectionCechCofaceMatch` (with the tilde-F section identification via
  `qcohRestriction_eq_comparison`) is NOT — flag whether the blueprint's `lem:section_cech_coface_match`
  block adequately distinguishes the abstract part from the still-open tilde-bridge, or whether a Lean
  decl is claiming more than it proves.
- blueprint → Lean: is the chapter detailed enough to guide the remaining step (d)
  (`sectionCech_affine_vanishing`) and the tilde F-bridge the prover flagged as the blocker? Or is the
  blueprint too thin where the Lean clearly needs guidance?

## Output
Bidirectional report: must-fix items, signature mismatches, and an adequacy verdict on the chapter.
