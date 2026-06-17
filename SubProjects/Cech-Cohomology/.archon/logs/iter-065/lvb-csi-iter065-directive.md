# Lean-vs-blueprint — CechSectionIdentification (iter-065)

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; this file is one of its `% archon:covers` targets)

This iter the prover CLOSED `pushPull_coprod_prod_empty` (empty base case, via new helper
`isZero_modules_of_isEmpty`) and `coprodToProd_isIso_of_equiv` (whiskerEquiv reindex step),
cascading `pushPull_sigma_iso` (Stub 2) and `pushPull_eval_prod_iso` (Stub 4) to axiom-clean.
Remaining open: Stub 5 (`cechSection_complex_iso`, ~line 1418) and Stub 6 (~line 1477).

Report bidirectionally:
- Lean → blueprint: do the closed proofs match their blueprint statements? Any fake/placeholder
  statements, signature mismatches? Note that `pushPull_coprod_prod_empty` blueprint says "both
  sides terminal" but the Lean proves it via the empty-scheme zero-object route — is that a
  material divergence or a sound alternative?
- Blueprint → Lean: is the chapter detailed enough for the still-open Stubs 5/6? Is the new helper
  `isZero_modules_of_isEmpty` (no blueprint entry yet) something the chapter should cover?
- Flag any must-fix-this-iter items.
