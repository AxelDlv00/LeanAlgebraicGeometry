# Lean Auditor Directive

## Slug
iter007

## Scope (files)
all

## Focus areas
- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean` (new this iter; ~5 new `_apply` helper lemmas + `sliceDualTransport`/`sliceDualTransportInv` defs; 3 `sorry`s).
- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` (split-source; check for stale docstrings referencing sorries/line-numbers that moved into SliceTransport.lean).

## Known issues
- SliceTransport.lean L444 (`sliceDualTransportInv` inv-naturality root), L724/726 (`sliceDualTransport` left_inv/right_inv) carry intentional typed `sorry`s — report them as open sorries, no need to flag as excuse-comments.
- TensorObjSubstrate.lean L712 (`exists_tensorObj_inverse`, import-cycle gated) and L3144 (`pullbackTensorMap_restrict` Sq3/Sq4 residual) are known open sorries.
