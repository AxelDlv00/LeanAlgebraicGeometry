# Lean ↔ blueprint check — TensorObjSubstrate (iter-265)

Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

This iter the prover added the axiom-clean bridge `forget_map_pushforward_map`
(presheaf↔sheaf forget/pushforward compatibility, `rfl`) and wired it into
`sheafificationCompPullback_comp_tail`, but the tail still ends in `sorry` (the
R1/R5 recovery — a composite-adjunction sheafification mate step that is NOT rfl).
Check bidirectionally:
- Does the chapter's `lem:pullback_tensor_map_basechange` Sq1-tail / binding
  obligation paragraph match the Lean `sheafificationCompPullback_comp` /
  `_tail` structure? Is the new bridge reflected, and is the remaining R1/R5
  step described with enough detail to guide a prover?
- Flag any signature mismatch, fake/placeholder statement, or over/under-marking.
Report Lean→blueprint AND blueprint→Lean, with any must-fix-this-iter findings.
