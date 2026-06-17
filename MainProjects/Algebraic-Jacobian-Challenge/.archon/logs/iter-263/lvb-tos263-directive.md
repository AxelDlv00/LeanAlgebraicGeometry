# lean-vs-blueprint-checker directive (iter-263)

Verify ONE Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

This iter the prover closed `sheafificationCompPullback_comp` (the D3′ Sq1 lemma) and
relocated its residual to a new helper `sheafificationCompPullback_comp_tail`. Check:
(a) does the chapter's Sq1 sketch (lem:pullback_tensor_map_basechange and the Sq1
paragraph) describe the now-named residual — the composite-adjunction-unit coherence
`B_{h≫f}.unit` (the non-`rfl` sheafification analog of `unitToPushforwardObjUnit_comp`)?
(b) Is the chapter adequate to guide closing `sheafificationCompPullback_comp_tail` and
`pullbackTensorMap_restrict`, or is it too thin (must-fix → blueprint-writer)?
Report Lean→blueprint AND blueprint→Lean. Name any signature/label mismatch.
