# Lean ↔ blueprint check — CechAcyclic.lean (iter-020)

Verify bidirectionally one Lean file against its blueprint chapter.

- Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean
- Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
  (this is the consolidated chapter; it `% archon:covers` CechAcyclic.lean. The
  CechAcyclic-relevant blueprint blocks are the section-form `lem:cech_acyclic_affine`,
  `def:qcoh_sections_localized`, `lem:section_cech_homology_exact`, and the
  `SectionCechModule` / away-localisation material.)

This session added (per task_results/CechAcyclic.md): `iInf_fin_succ` (private),
`basicOpen_sprod`, `qcohSectionsAwayLocalized` (named target, tilde case),
`qcohRestriction_eq_comparison`. Two blueprint decls remain unbuilt
(`sectionCech_homology_exact`, `sectionCech_affine_vanishing`).

Report:
(a) Does the Lean follow the blueprint — any fake/placeholder statements, signature
    mismatches with the `\lean{...}`-named blocks, or claims of proof where a sorry remains
    (note: line 109 `sorry` is the intentional superseded relative-form `CechAcyclic.affine`).
(b) Is the blueprint adequate to guide the remaining formalization (esp. the step-(c)
    `sectionCech_homology_exact` Ab-product↔pi homology bridge the prover flagged as
    needing an effort-break)? If the chapter is too thin for that, say so.
