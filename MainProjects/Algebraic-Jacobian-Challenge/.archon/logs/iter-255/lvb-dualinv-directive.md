# lean-vs-blueprint-checker — DualInverse

Verify ONE Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
- Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
  (DualInverse is covered by the TensorObjSubstrate chapter — check for `% archon:covers` near its top;
   if a separate chapter exists for DualInverse use that instead.)

Focus: `homOfLocalCompat` (still one inner `sorry`, f-leg smul bridge) and `dual_restrict_iso` (Step-4 sorry).
Confirm blueprint sub-step (a)/(b)/(c) decomposition for `homOfLocalCompat` matches the Lean proof structure,
and that the f-leg native↔restrictScalars-𝟙 bridge is described. Report bidirectionally; flag thin blueprint
blocks. Note any `\lean{...}` name mismatch.
