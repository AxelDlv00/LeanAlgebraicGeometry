# lean-vs-blueprint-checker directive — TensorObjSubstrate (iter-271)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

Lean file:
  /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

Blueprint chapter (consolidated, `% archon:covers` this file):
  /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

Specific points to check:
- This iter only advanced `sheafificationCompPullback_comp_tail` by one closed tactic plus a
  `have hwr` device; the file still carries a `sorry` there and ~18 `sorry` occurrences total.
  Confirm the blueprint does not mark any of these still-open declarations as complete, and that
  the chapter's prose for the `sheafificationCompPullback` composition-coherence lemma is
  detailed enough to guide the remaining mate-calculus close.
- Check that every `\lean{...}` in the chapter resolves to a real declaration in this file
  (flag any renamed/removed targets).
- Report blueprint→Lean: is any declaration the chapter promises missing from the Lean file?

Report bidirectionally with any must-fix-this-iter findings.
