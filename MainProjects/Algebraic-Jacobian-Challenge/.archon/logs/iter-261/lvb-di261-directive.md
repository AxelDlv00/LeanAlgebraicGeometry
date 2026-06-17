# Lean-vs-blueprint — DualInverse.lean (iter-261)

Verify bidirectionally between ONE Lean file and its blueprint chapter.

Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(DualInverse.lean is covered by Picard_TensorObjSubstrate.tex — see its `% archon:covers` lines.)

This iter the prover built a partial route-2 construction of `sliceDualTransport` (~L184): leg-A
(slice-Hom reindex across `f.opensFunctor`) ∘ leg-B (`restrictScalarsRingIsoDualEquiv`-style ring-iso
codomain swap). 7 typed `sorry` remain; codomainMap is blocked on two named frictions. Check:
- Does the blueprint chapter (search `lem:dual_restrict_iso`, `sliceDualTransport`,
  `restrictScalarsRingIsoDualEquiv`, leg A / leg B / Beck–Chevalley) describe this route-2 construction
  accurately, including the leg-A reindex and the leg-B `inv (ε (restrictScalars β))` codomain swap?
- Any `\lean{...}` hint pointing at a wrong/renamed decl.
- Flag must-fix items. Report bidirectionally. Write to your task_results file.
