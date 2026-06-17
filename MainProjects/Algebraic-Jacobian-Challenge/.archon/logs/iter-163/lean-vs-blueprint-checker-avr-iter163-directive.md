# lean-vs-blueprint-checker — iter-163 (AbelianVarietyRigidity)

## The one Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`

## The one blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

## What to verify (bidirectional)

This iter the prover added two declarations:
- `AlgebraicGeometry.hom_additive_decomp_of_rigidity` ↔ `lem:hom_additivity_over_product` (≈tex L648)
- `AlgebraicGeometry.av_regularMap_isHom_of_zero` ↔ `lem:av_regular_map_is_hom` (≈tex L706)

Check:
1. Are the `\lean{...}` names in the chapter correct and the signatures faithful to the Lean
   declarations (no fake/placeholder statements; hypotheses match)?
2. **Specifically:** the Lean `av_regularMap_isHom_of_zero` carries THREE instance hypotheses on
   `A ⊗ A` — `[GeometricallyIrreducible (A ⊗ A).hom]`, `[LocallyOfFiniteType (A ⊗ A).hom]`,
   `[IsReduced (A ⊗ A).left]` — that the blueprint `lem:av_regular_map_is_hom` prose does NOT
   mention. Is this a faithfulness gap the chapter should record? (The review agent is adding a
   `% NOTE:` flagging it; confirm whether that suffices or whether a fuller Lean-encoding paragraph
   from a writer is warranted.)
3. Is the conclusion `IsMonHom α` an acceptable rendering of the blueprint's "α is a homomorphism"?
4. `\uses` edges: `lem:av_regular_map_is_hom` → `lem:hom_additivity_over_product` →
   `thm:rigidity_lemma`. Forward-acyclic? No laundering of the headline through a sorry?
5. Whether the chapter is thin anywhere the Lean clearly needed more guidance.

Report bidirectionally with severities; name any must-fix-this-iter findings explicitly.
