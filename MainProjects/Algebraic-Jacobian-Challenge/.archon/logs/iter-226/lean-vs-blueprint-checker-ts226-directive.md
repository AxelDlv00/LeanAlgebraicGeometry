# lean-vs-blueprint-checker directive — iter-226

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_QuotScheme.tex` (if a different chapter declares `% archon:covers ... TensorObjSubstrate.lean ...`, use that one instead — check the `covers` annotations near chapter tops).

## What changed this iter

One new lemma was added, axiom-clean and sorry-free:
`AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict` (the "locally-iso ⇒ iso"
B-connector of the d.2-free descent re-route for `exists_tensorObj_inverse`). It is NOT
yet `\lean{}`-pinned in any chapter (the plan agent deferred adding a named block).

## Questions

1. Lean → blueprint: does the new B-connector lemma correspond to anything in the chapter?
   Is there a blueprint block it should be pinned to (so `sync_leanok` can track it), or is
   it pure Lean-level infrastructure with no math statement of its own? Report whether a
   `lem:...` block ought to be added (a plan-agent action), and if so, suggest a label.
2. Blueprint → Lean: for the still-open `exists_tensorObj_inverse` (`lem:tensorobj_inverse_invertible`
   or similar), is the chapter's proof sketch adequate to guide the remaining A-bridge
   (morphism descent) and C-bridge (dual-vs-restriction) work, or is it too thin?
3. Any fake/placeholder statements, signature mismatches, or `\lean{...}` pins pointing at
   renamed/non-existent declarations in this file's chapter coverage.

Name any must-fix-this-iter findings explicitly. Do not read PROGRESS.md / STRATEGY.md.
