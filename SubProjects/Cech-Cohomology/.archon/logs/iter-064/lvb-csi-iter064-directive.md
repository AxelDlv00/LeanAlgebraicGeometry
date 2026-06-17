# Lean ↔ Blueprint Checker Directive

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(This is the CONSOLIDATED chapter; it carries `% archon:covers` for several
files including CechSectionIdentification.lean. Focus your review on the
Stub-1..6 / push–pull section-identification material and the finite
coproduct→product induction lemmas.)

## What to check
- Bidirectional: (a) does the Lean follow the blueprint (no fake/placeholder
  statements, `\lean{}` names resolve, proof structure matches), and (b) is the
  blueprint detailed enough to have guided this formalization?
- This iter the prover closed `coprodToProd_isIso_option` (Option-adjoining
  induction step) and the assemblies `pushPull_coprod_prod`, `pushPull_sigma_iso`
  (Stub 2), `pushPull_eval_prod_iso` (Stub 4). Remaining sorries:
  `pushPull_coprod_prod_empty` (empty base, residual = `IsZero` of a pulled-back
  module over the initial/empty scheme), `coprodToProd_isIso_of_equiv` (reindex
  via `whiskerEquiv`), and Stubs 5/6 (`cechSection_complex_iso`,
  `cechSection_contractible`).
- The prover created several helper lemmas (`coprodOverIncl`, `coprodToProdMap`,
  `coprodToProdMap_comp_π`, `piOptionIso_inv_π_none/some`, `pushPullObjCongr_hom`,
  `pushPull_binary_coprod_prod_hom`, `isIso_coprodToProdMap`) — check whether the
  blueprint has matching entries (coverage debt) and whether the two open
  induction-step lemmas (empty, reindex) have adequate informal proofs.
- Report any must-fix-this-iter findings (broken `\lean{}`, blueprint too thin
  to guide the 2 remaining induction leaves, signature mismatch).

## Output
Bidirectional report to your task_results.
