# lean-vs-blueprint-checker — DualInverse (iter-262)

Bidirectional check of ONE Lean file against ONE blueprint chapter.

- Lean file: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (consolidated chapter that covers DualInverse.lean; focus on the
  `sliceDualTransport` / `dual_restrict_iso` / `dual_isLocallyTrivial` leg-A/leg-B
  prose, route-2).

This iter the prover added two named axiom-clean decls
`isIso_ε_restrictScalars_appIso` and `dualUnitRingSwap` (leg-B), filled the
`sliceDualTransport` codomainMap hole, and reduced its typed sub-sorries 7→6.
Report:
(a) whether the new Lean decls match the blueprint's leg-B description (route-2:
    leg-A Beck–Chevalley reindex ∘ leg-B `restrictScalarsRingIsoDualEquiv` / the
    ε-iso of restrictScalars),
(b) whether the chapter adequately specifies the remaining `sliceDualTransport`
    fields (invFun, map_add'/map_smul' via the internalHomObjModule-add bridge,
    left/right_inv) or is too thin to guide them. Check `\lean{...}` hints point
    at decls that exist.

Read only the two files named. Absolute paths:
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
