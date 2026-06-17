# Lean-vs-blueprint — CechHigherDirectImage.lean (iter-261)

Verify bidirectionally between ONE Lean file and its blueprint chapter.

Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

This is a NEW scaffold file created this iter with honest type signatures for six blueprint
declarations (`def:cech_nerve`→`CechNerve`, `def:cech_complex`→`CechComplex`,
`lem:cech_acyclic_affine`→`CechAcyclic.affine`, `lem:cech_computes_cohomology`→
`cech_computes_higherDirectImage`, `def:cech_higher_direct_image`→`cechHigherDirectImage` (REAL body),
`lem:cech_flat_base_change`→`cech_flatBaseChange`). 5 typed `sorry`, 1 real def; builds clean. Check:
- Does each Lean signature faithfully formalize the corresponding blueprint statement (no fake/trivial
  `True`-like statements; the `Nonempty (… ≅ …)` packaging for the two comparison theorems is honest
  given comparison maps are not yet constructed)?
- Do the `\lean{...}` hints in the chapter match the actual decl names?
- Is the chapter detailed enough to later guide the proofs (especially `CechNerve`/`CechComplex`)?
- Flag must-fix items. Report bidirectionally. Write to your task_results file.
