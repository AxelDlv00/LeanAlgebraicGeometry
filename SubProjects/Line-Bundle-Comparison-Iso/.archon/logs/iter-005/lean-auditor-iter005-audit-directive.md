# Lean Auditor Directive

## Slug
iter005-audit

## Scope (files)
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`

## Focus areas (optional)
- new helper lemmas and comments added in iter-005
- remaining open proof obligations in the two touched files

## Known issues
- `TensorObjSubstrate.lean` still has open proof obligations in `sheafificationCompPullback_comp_tail` and `pullbackTensorMap_restrict`
- `DualInverse.lean` was changed to close the slice-transport chain; verify comments/proof shape around the new helper `dualUnitRingSwap_apply`
