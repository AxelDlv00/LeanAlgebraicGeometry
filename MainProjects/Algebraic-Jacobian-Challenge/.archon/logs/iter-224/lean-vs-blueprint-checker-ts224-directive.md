# lean-vs-blueprint-checker directive — iter-224

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## What changed this iter
The declaration `PresheafOfModules.internalHomEval` had its `naturality` field (previously a
typed `sorry`) closed with a complete, axiom-clean proof. The corresponding blueprint block is
`lem:internal_hom_eval` (statement + proof, around lines 2608–2673), pinned via
`\lean{PresheafOfModules.internalHomEval}`.

## Checks requested (bidirectional)
- Lean -> blueprint: does the closed `internalHomEval` proof faithfully realise the blueprint's
  stated evaluation morphism `M ⊗_R M^∨ → R, s⊗φ ↦ φ(s)` and its naturality/restriction-commutation
  argument? Any signature or content mismatch, fake/placeholder statement, or overclaim?
- blueprint -> Lean: the `lem:internal_hom_eval` block carries a `% NOTE:` (lines ~2614–2620)
  written when only the per-object `internalHomEvalApp` existed and the full morphism was an open
  obligation. That obligation is now discharged. Report whether the `% NOTE:` text is now stale and
  should be updated/removed by the review agent (the checker only REPORTS; it does not edit).
- Confirm the `\lean{...}` pins on `lem:internal_hom_eval`, `def:presheaf_dual`,
  `lem:presheaf_internal_hom_restriction` match existing declaration names in the Lean file.
- Flag any block whose blueprint detail was too thin to have guided this proof, or any
  remaining-sorry declaration whose blueprint claims completion.

Report must-fix-this-iter items explicitly.
