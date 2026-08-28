Implemented and committed `MilneLib/Tensor.lean` as `575ea622f9`.

Added:

- `MilneLib.quotTensorEquivQuotSMul`
- `[simp] MilneLib.quotTensorEquivQuotSMul_mk_tmul`
- `MilneLib.quotTensorEquivQuotSMul_comp_mkQ_rTensor`

The alias exposes Mathlib’s canonical
`(R ⧸ I) ⊗[R] M ≃ₗ[R] M ⧸ (I • ⊤)` equivalence. The narrow Lean check, rebuilt project, LSP diagnostics, declaration checks, and axiom scans all pass.
