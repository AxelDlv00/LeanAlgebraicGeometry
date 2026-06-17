# lean-vs-blueprint-checker — DualInverse.lean ↔ Picard_TensorObjSubstrate.tex

Compare exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
- Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
  (this chapter `% archon:covers` DualInverse.lean — find the dual-inverse / hom-of-local-compat blocks within it)

This iter the prover authored `homLocalSection` (new, axiom-clean — the blueprint's load-bearing
`localSection`) and reduced `homOfLocalCompat` to a compiling scaffold + one sorry; `dual_restrict_iso`
Step-4 was untouched. Report:
(a) Lean→blueprint: is `homLocalSection` covered by the chapter? Is there a `\lean{...}` block for it,
    or should one be flagged as missing? Any fake/placeholder/signature-mismatch in the covered decls
    (`homOfLocalCompat`, `dual_restrict_iso`, `dual_isLocallyTrivial`)?
(b) blueprint→Lean: is the chapter detailed enough on the sheaf-of-homs gluing (`homOfLocalCompat`
    compatibility/conversion/linearity) to guide the remaining sorry?
Flag must-fix items explicitly.
