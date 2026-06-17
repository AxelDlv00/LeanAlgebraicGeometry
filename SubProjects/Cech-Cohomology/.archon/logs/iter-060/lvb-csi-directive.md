# Lean ↔ Blueprint Checker Directive

## Slug
csi

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

(This is a consolidated chapter covering several files; it declares
`% archon:covers AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`. Focus only on the
blocks whose `\lean{...}` targets live in CechSectionIdentification.lean — primarily the Stub-1
geometric backbone family: `cechBackbone_left_sigma`, `widePullbackBaseCongr`, `coverInterProdIso`,
`widePullback_overX_eq_prod`, `widePullback_coproduct_iso`, `overProd_coproduct_distrib`, plus the
four remaining stubs `pushPull_sigma_iso`, `pushPull_eval_prod_iso`, `cechSection_complex_iso`,
`cechSection_contractible`.)

## Known issues
- The four stubs above (`pushPull_sigma_iso`, `pushPull_eval_prod_iso`, `cechSection_complex_iso`,
  `cechSection_contractible`) are intentional `sorry` holes — do not flag their existence, only a
  type/blueprint mismatch.
- Stubs 5/6 (`cechSection_complex_iso`/`cechSection_contractible`) target the AUGMENTED complex
  `D'_aug = (sectionCechComplex).augment ε hε` (corrected in iter-058); the non-augmented form is
  provably wrong. Verify the Lean signatures still match the augmented blueprint target.
- This iter the prover closed `cechBackbone_left_sigma` (Stub 1) and added helpers
  `widePullbackBaseCongr` and `coverInterProdIso`. These two helpers currently have NO blueprint
  block (coverage debt, already noted for the planner) — report them under blueprint-adequacy but
  they are not a must-fix.
