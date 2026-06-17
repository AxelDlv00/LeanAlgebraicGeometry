# lean-vs-blueprint-checker directive — CechAcyclic (iter-022)

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(this consolidated chapter declares `% archon:covers ... CechAcyclic.lean ...`; the
relevant blocks are `lem:section_cech_homology_exact`, `lem:section_cech_coface_match`,
`lem:section_cech_ab_exact`, `lem:cech_acyclic_affine` (section form), and the
`def:qcoh_sections_localized` / `lem:section_cech_product_equiv` infra blocks.)

## What landed this iter (claimed)
A new `section SectionCechTilde` with 16 axiom-clean decls closing the P3 L1 tilde-bridge:
`phiL`, `phi`, `phi_eq_phiL`, `restr_bridge`, `phiL_naturality`, `phi_naturality`,
`sectionProdAddEquiv`, `sectionToModuleAddEquiv`(+ `_apply`), `sectionProdEquiv_symm_apply`,
`sectionCechCofaceMatch` (= `lem:section_cech_coface_match`), `sectionCechAbExact`
(= `lem:section_cech_ab_exact`), and the public theorems `sectionCech_homology_exact`
(= `lem:section_cech_homology_exact`) and `sectionCech_affine_vanishing`
(= `lem:cech_acyclic_affine` §section form).

## Check specifically
- Do the landed theorems' Lean statements faithfully match the blueprint statements
  (no weakened hypotheses, no fake/placeholder statement)?
- Is the named target `lem:cech_acyclic_affine` (section form) genuinely proved for the
  tilde sheaf, and does the blueprint correctly scope the still-deferred general-qcoh
  reduction (F ≅ ~(ΓF), Stacks 01I8) so the Lean does not silently under-deliver?
- Bundled-helper coverage: many new helpers (`phiL`, `phi`, `restr_bridge`,
  `sectionProdAddEquiv`, etc.) are not yet in any `\lean{}` list — report which blueprint
  block each should attach to (Lean → blueprint direction).
- Blueprint → Lean: is any block too thin to have guided this formalization?

Write your report to task_results/.
