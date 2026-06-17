# Lean ↔ blueprint check — CechSectionIdentification.lean

Verify bidirectionally one Lean file against its blueprint chapter.

Lean file:
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

Blueprint chapter:
- /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
  (consolidated chapter; the relevant blocks are the Stub-1 split: `lem:cechBackbone_obj_widePullback`,
  `lem:widePullback_openImm_inter`, `lem:coproduct_distrib_fibrePower`, and `lem:cech_backbone_left_sigma`,
  plus Stubs 2/4/5/6).

This iter the prover added 6 axiom-clean declarations for the Stub-1 geometric backbone:
`mem_iInf_opens_of_finite` (private), `widePullback_openImm_inter`, `cechBackbone_obj_widePullback`,
`coverArrowOverCofan`, `coverArrowOverIsColimit`, `coverArrowOverSigmaIso`. The hard
`coproduct_distrib_fibrePower` was NOT built (genuine multi-cycle gap), and the assembled
`cechBackbone_left_sigma` (Stub 1) plus Stubs 2/4/5/6 remain `sorry` (lines ~189/239/330/424/481).

Report:
(a) Lean → blueprint: do the added declarations match their blueprint blocks
    (`lem:cechBackbone_obj_widePullback`, `lem:widePullback_openImm_inter`, and the
    `coverArrowOverSigmaIso` leaf)? Any fake/placeholder/vacuous statement or signature mismatch?
    Is `coverArrowOverSigmaIso` (+ its two cofan helpers) covered by a blueprint block, or is it a new
    leaf still missing one?
(b) blueprint → Lean: confirm the iter-056-corrected Stubs 5/6 target (the AUGMENTED complex
    `D'_aug`, NOT the non-augmented `D'`) is reflected in the chapter, and that the remaining stub
    statements (189/239/330/424/481) are honest holes whose blueprint specs are now correct (not the
    disproved-as-written specs).
