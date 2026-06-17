# lean-vs-blueprint-checker — TensorObjSubstrate (iter-262)

Bidirectional check of ONE Lean file against ONE blueprint chapter.

- Lean file: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (consolidated; declares `% archon:covers` for TensorObjSubstrate.lean,
  StalkTensor.lean, Vestigial.lean, DualInverse.lean — focus on the
  TensorObjSubstrate.lean content, esp. `pullbackTensorMap_restrict` / Sq1
  `sheafificationCompPullback_comp` / `exists_tensorObj_inverse`).

This iter the prover added `sheaf_unit_comp_pushforward_pullbackComp_inv` and
advanced the Sq1 lemma `sheafificationCompPullback_comp` (R0-peel; still ends
in `sorry`). Report:
(a) whether the Lean follows the blueprint (fake/placeholder statements,
    signature mismatches with `\lean{...}`),
(b) whether the blueprint is adequate to guide the remaining Sq1 / D3′ work, or
    too thin / misdescribes the genuine residual (the iter-260 must-fix was that
    the Sq2b prose falsely claimed the μ-residual was definitional — check the
    Sq1 prose does not have the analogous overclaim).

Read only the two files named. Absolute paths:
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
