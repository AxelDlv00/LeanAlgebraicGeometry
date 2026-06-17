# Lean Auditor Directive

## Slug
iter006

## Scope (files)
- /home/archon/proj/Line-Bundle-Comparison-Iso/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/proj/Line-Bundle-Comparison-Iso/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

## Focus areas
- The D3′ cocycle region of TensorObjSubstrate.lean (sheafificationCompPullback_comp_natTrans, sheafificationCompPullback_comp_tail, pullbackTensorMap_restrict): heavy use of `erw`, `set_option maxHeartbeats 1600000`, and cross-elaboration defeq matching this iter. Assess whether these are sound or fragile/laundering.
- Excuse-comments and dead-end proof scaffolding left behind by superseded attempts.

## Known issues
- Sorries at exists_tensorObj_inverse (L690, deferred by design) and pullbackTensorMap_restrict (L2971, known-open) are tracked; report their presence but they are not new defects.
