# lean-vs-blueprint-checker directive — iter-236 — StalkTensor

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean

## Blueprint chapter (consolidated; covers StalkTensor.lean via `% archon:covers`)
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## What to check
- The headline deliverable this iter is `PresheafOfModules.stalkTensorIso`,
  pinned by `lem:stalk_tensor_commutation`. Verify the Lean iso's TYPE matches
  the blueprint statement: a canonical iso of `R.stalk x`-modules
  `(A ⊗ᵖ B).stalk x ≅ A.stalk x ⊗_{R.stalk x} B.stalk x`.
- Confirm the Lean statement is not a fake/placeholder (e.g. iso between
  identical types, or over the wrong ring).
- Report any `\lean{...}` pin whose target was renamed, and whether the chapter
  prose still matches the assembled five-stage construction.
- Report bidirectionally: Lean→blueprint AND blueprint→Lean (is the chapter
  detailed enough / now over-claiming or under-claiming).
