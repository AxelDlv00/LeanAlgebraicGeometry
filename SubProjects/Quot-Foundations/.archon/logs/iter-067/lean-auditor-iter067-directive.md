# Lean Auditor Directive

## Slug
iter067

## Files
Audit all project `.lean` files under `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/`.

## Focus
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean` — heavily modified this iter (~700 new LOC: transport-chain lemmas between `chartLocus_rel` and `grPointOfRankQuotient_rel`, plus a `freeMap_chartMatrixHom` cluster near the end). Check for dead-end proofs, suspect `@inv`/instance workarounds, excuse-comments, duplicated helpers.
- `AlgebraicJacobian/Picard/GlueDescent.lean` — NEW file (split from GrassmannianQuot this iter; the split crashed mid-move and two compile fixes were applied: an added import and a `.symm` on an `eqToIso` argument at ~L1165). Verify the moved layer carries no duplicate declarations vs. the rest of the tree and no half-moved dead stubs.
- Heartbeat overrides (`set_option maxHeartbeats`) — flag unjustified ones.
