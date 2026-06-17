# Lean-vs-blueprint check — iter-264 — engine Čech file

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

This iter the prover landed `pushPullMap_id` (identity functor law of the push–pull functor `G`)
as a real closed lemma; `pushPullMap_comp` (the composition/pentagon law) remains deferred to an
in-file comment block. Report:
- whether the blueprint statements match the Lean signatures (no fake/placeholder statements);
- whether the chapter gives enough proof detail for the still-open decls (the remaining 4 file
  sorries and the deferred `pushPullMap_comp`);
- any blueprint→Lean or Lean→blueprint drift.
Flag must-fix vs major vs minor.
