# lean-vs-blueprint-checker directive — Vestigial.lean ↔ Picard_TensorObjSubstrate.tex (iter-237)

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(This consolidated chapter declares `% archon:covers` for TensorObjSubstrate.lean, StalkTensor.lean, and
Vestigial.lean — focus on the blocks pinning Vestigial.lean decls.)

## What changed this iter (context for the check, not a conclusion to rubber-stamp)
Six decls were added to Vestigial.lean, closing `isLocallyInjective_whiskerLeft_of_W`:
`isLocallyInjective_of_injective_stalk`, `injective_stalk_of_isLocallyInjective`,
`isIso_stalkFunctor_map_of_W`, `isLocallyInjective_whiskerLeft_of_W`, `W_whiskerLeft_of_W`,
`W_whiskerRight_of_W`.

## Specific things to verify
1. **`lem:stalk_tensor_commutation_naturality_right`** (≈ line 2151) pins
   `\lean{PresheafOfModules.stalkTensorIso_naturality_right}`. This declaration **does not exist** in the Lean
   (the prover inlined the B-naturality argument as a `have key` inside `isLocallyInjective_whiskerLeft_of_W`
   rather than proving it standalone). Report this as a Lean→blueprint mismatch (dangling `\lean{}` pin) and
   recommend the resolution (drop the pin / convert the block to a `% NOTE:` describing the inlining, since
   no standalone decl backs it).
2. **`lem:islocallyinjective_whiskerleft_via_stalk`** → `isLocallyInjective_whiskerLeft_of_W` and
   **`lem:W_implies_stalkwise_iso`** → `isIso_stalkFunctor_map_of_W`: confirm signatures match and the
   blueprint proof sketch matches the actual three-movement Lean proof.
3. The proof block of `lem:islocallyinjective_whiskerleft_via_stalk` (≈ line 2226) has a `\uses{...}` whose
   closing brace spans multiple lines and a `\leanok` token appears INSIDE the braces (line ~2228). Report
   whether the `\uses` list is well-formed and whether `lem:W_implies_stalkwise_iso` /
   `lem:stalk_tensor_commutation_naturality_right` are correctly referenced.
4. Whether the blueprint is now adequate to guide the (already-done) formalization, or whether the prose
   over/under-specifies relative to the Lean.

## Output
Bidirectional report (Lean→blueprint AND blueprint→Lean), with any must-fix-this-iter findings clearly marked.
Write to your task_results report.
