# Lean ↔ blueprint check — CechSectionIdentification.lean (iter-061)

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(consolidated chapter; this file is one of its `% archon:covers` entries). The relevant blueprint
labels for this file's Stub-2 chain: `lem:isIso_modules_of_toPresheaf`, `lem:pushPull_binary_coprod_prod`,
`lem:pushPull_coprod_prod`, `lem:pushPull_sigma_iso`, plus Stubs 4/5/6
(`pushPull_eval_prod_iso`, `cechSection_complex_iso`, `cechSection_contractible`).

## What to verify (bidirectional)
1. **Lean → blueprint:** the new decls `isIso_modules_of_toPresheaf`, `isIso_prodLift_of_isLimit`,
   `coprodDecompMap` — do their Lean signatures match the blueprint statements they claim to formalize?
   `isIso_modules_of_toPresheaf` is claimed to be `lem:isIso_modules_of_toPresheaf` (L1). The other two
   are `lean_aux` helpers with no blueprint block — flag them for coverage.
2. **Fake/placeholder check:** are any of the 4 remaining `sorry` stubs (Stubs 2/4/5/6) typed at a
   statement that does NOT match the blueprint (e.g. non-augmented vs augmented form for Stubs 5/6)?
   Recall the iter-056 finding: Stubs 5/6 must target the AUGMENTED `D'_aug`. Confirm they still do.
3. **Blueprint → Lean:** is `lem:pushPull_binary_coprod_prod` stated in the blueprint with enough
   detail to formalize, given the prover got blocked on `isIso_coprodDecompMap` (the binary keystone)?
   Report if the chapter is too thin to guide the L2 formalization.

## Output
Bidirectional report: Lean-follows-blueprint findings AND blueprint-adequacy findings. Flag any
must-fix-this-iter. Write to your task_results file.
