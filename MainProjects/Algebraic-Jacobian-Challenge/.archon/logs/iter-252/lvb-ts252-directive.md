# lean-vs-blueprint-checker — TensorObjSubstrate.lean ↔ Picard_TensorObjSubstrate.tex

Compare exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

This iter the prover worked on `sheafifyTensorUnitIso_hom_natural` (reduced its proof to an
element-level residual) and authored/gated `pullbackTensorMap_natural` (D1′). Report:
(a) Lean→blueprint: any decl whose `\lean{...}` block is fake/placeholder/signature-mismatched, or
    any prover decl with no blueprint coverage;
(b) blueprint→Lean: any chapter block too thin to guide the formalization the Lean code clearly
    needed, or a `\lean{...}` pointing at a renamed/nonexistent decl.
Flag must-fix items explicitly.
