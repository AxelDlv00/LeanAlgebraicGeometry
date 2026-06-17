# lean-vs-blueprint — DualInverse.lean (iter-256)

Lean file:
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

Blueprint chapter (consolidated; declares `% archon:covers` for both DualInverse.lean
and TensorObjSubstrate.lean):
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

Focus on the lemma `homOfLocalCompat` (blueprint label
`lem:sheafofmodules_hom_of_local_compat`), which was just CLOSED this iter
(axiom-clean). Verify bidirectionally:
(a) does the Lean statement of `homOfLocalCompat` match the blueprint statement
    (signature, hypotheses, the compatible-family-of-local-morphisms claim)?
(b) is the blueprint's sub-step (a)/(b)/(c) decomposition still accurate now that the
    proof is closed — or does any prose describe a route that the final proof did not take?
Also check `dual_restrict_iso` (label `lem:dual_restrict_iso`) — still PARTIAL (Step-4
sorry). Confirm the blueprint marks/notes it as partial appropriately.
Report any `\lean{...}` pin mismatches.
