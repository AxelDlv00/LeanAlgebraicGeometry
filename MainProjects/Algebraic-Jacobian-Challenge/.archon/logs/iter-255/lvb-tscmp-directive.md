# lean-vs-blueprint-checker — TensorObjSubstrate

Verify ONE Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

Focus: `pullbackTensorMap_natural` (blueprint `lem:pullback_tensor_map_natural`) was closed axiom-clean this
iter. Confirm the Lean statement matches the blueprint statement (no signature drift, no fake/placeholder),
and that the blueprint proof sketch matches what the Lean proof actually does. Report bidirectionally:
Lean→blueprint and blueprint→Lean. Note any `\lean{...}` name mismatch and any blueprint blocks that are too
thin to have guided the formalization.
