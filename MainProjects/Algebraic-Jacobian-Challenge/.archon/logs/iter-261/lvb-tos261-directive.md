# Lean-vs-blueprint — TensorObjSubstrate.lean (iter-261)

Verify bidirectionally between ONE Lean file and its blueprint chapter.

Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

This iter the prover (a) extracted a NEW sub-lemma `sheafificationCompPullback_comp` (Sq1 of D3′,
~L2439) and (b) opened `pullbackTensorMap_restrict` (D3′ `lem:pullback_tensor_map_basechange`, ~L2503)
to a paste-ready form. Both retain typed `sorry`. Check:
- Does the blueprint's D3′ / Sq decomposition (search `lem:pullback_tensor_map_basechange`, `Sq1`,
  `sheafificationCompPullback`) describe the Sq1 sub-lemma the Lean code now isolates? Is the chapter's
  account of the 4-square paste accurate, or does it still misdescribe a step as definitional/rfl?
- Any signature mismatch between `\lean{...}` hints and the actual Lean decl names.
- Flag must-fix items that block re-dispatch of these decls. Report bidirectionally (Lean→blueprint AND
  blueprint→Lean; the chapter may be too thin). Write to your task_results file.
