# Lean ↔ blueprint check — HigherDirectImage.lean vs Cohomology_HigherDirectImage.tex

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/HigherDirectImage.lean
- Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_HigherDirectImage.tex
- Decls: `def:higher_direct_image` (`higherDirectImage`),
  `lem:higher_direct_image_quasi_coherent`, `lem:higher_direct_image_affine_vanishing`,
  `thm:flat_base_change_higher`.

Key questions: (a) the Lean `higherDirectImage` carries an extra
`[HasInjectiveResolutions X.Modules]` hypothesis not in the blueprint prose — is this a
faithful formalization or a signature mismatch the blueprint should record? (b) Are the
three `sorry`-bodied lemmas' Lean signatures consistent with the blueprint statements
(hypotheses: quasi-coherence, `1 ≤ i`, flatness/qcqs)? (c) Is the blueprint detailed
enough to guide the eventual proofs, or too thin?

Write your report to your task_results file.
