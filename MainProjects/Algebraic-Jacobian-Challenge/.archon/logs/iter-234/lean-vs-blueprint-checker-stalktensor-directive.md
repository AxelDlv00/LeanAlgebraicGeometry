# Lean ↔ blueprint check — StalkTensor.lean

Bidirectionally verify ONE Lean file against its blueprint chapter.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (consolidated chapter; the StalkTensor content is `\label{lem:stalk_tensor_commutation}` in `\label{sec:tensorobj_stalk_tensor}`, plus `lem:stalk_tensor_desc_forward`).

This iter landed 4 new axiom-clean declarations in the Lean file: `stalkTensorDescU_smul`, `stalkTensorDesc_germ`, `stalkTensorLinearMap` (stage iii, the `R_x`-linear packaging of the forward comparison map), and `stalkTensorLinearMap_germ_tmul`.

Check:
- Lean → blueprint: do the Lean statements match the blueprint's staged prose (stages i–iii)? Is any Lean decl a fake/placeholder relative to what the chapter claims?
- Blueprint → Lean: does the chapter's stage (iii) prose (`stalkTensorLinearMap`) accurately reflect the Lean signature? Are the still-unbuilt stages (iv reverse map, v `stalkTensorIso` bundle) clearly marked as not-yet-formalized in the prose, so no `\lean{}` pin falsely claims an unbuilt iso exists? In particular check whether `lem:stalk_tensor_commutation` carries a `\lean{...}` pin that points at an unbuilt `stalkTensorIso`.
- Flag whether the chapter is detailed enough to guide the stage (iv)/(v) build.

Report bidirectionally with any must-fix-this-iter findings.
