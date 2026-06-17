# lean-vs-blueprint — OpenImmersionPushforward.lean

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; this file is declared under `% archon:covers .../OpenImmersionPushforward.lean`.
The relevant blueprint declarations are `lem:open_immersion_pushforward_comp` and the
`higherDirectImage_openImmersion_acyclic` / corepresentability material.)

## What changed this iter (iter-055)
- New axiom-clean corepresentability decls: `sectionsFunctorCorepIso`, `rightDerivedNatIso`,
  `jShriekOU_homEquiv_nat`, `sectionsFunctor_additive`, `toPresheafOfModules_additive`.
- `higherDirectImage_openImmersion_acyclic` residual reshaped to a coyoneda→Ext + change-of-scheme
  Serre leaf (`sorry` at line 306).
- `higherDirectImage_openImmersion_comp` re-signed to canonical `A ≅ B` (no longer `Nonempty`);
  body `sorry` at line 372, blocked on `_acyclic`.

## Report
(a) Does the Lean follow the blueprint — any fake/placeholder/vacuous statements, signature mismatches
    with the `\lean{}` targets, weakenings? (b) Is the blueprint adequate to guide closing the two
    residuals, or too thin? (c) Are the 5 new corepresentability decls present in the blueprint, or
    is this coverage debt? Flag must-fix-this-iter items explicitly.
