# Iter 004 — Plan

## Decision made
- Keep both active lanes on `prove`, but freeze helper growth. The progress critic is CHURNING on both routes, so the next prover round has to force one end-to-end proof surface through instead of adding more scaffolding.
- DUAL: use the newly pinned A-bridge `homOfLocalCompat` as the glue for the inverse chain; close the ε-naturality pair first, then the round-trip cancellations.
- D3′: keep the non-circular `leftAdjointCompNatTrans_assoc` fallback for `sheafificationCompPullback_comp_tail`; only attempt `pullbackTensorMap_restrict` if the upstream cocycle closes.
- Reversal signal: if a prover round still only adds helpers or leaves the residual theorem unchanged, stop extending the local scaffold and dispatch more structural help before any further proof attempts.

## Blueprint / strategy updates
- `Picard_TensorObjSubstrate.tex` now pins `homOfLocalCompat`, its helper chain, and the A-bridge dependency in the inverse remark.
- `Picard_RelPicFunctor.tex` now states plainly that it is provisional scaffolding, not finished Lean.
- `STRATEGY.md` now names `homOfLocalCompat` as the A-bridge and keeps `dual_restrict_iso` dependent on it.

## Subagent skips
- blueprint-reviewer: standard wrapper unavailable in this runtime (`archon` CLI missing); used a direct fallback audit and patched the chapter inline instead.
- progress-critic: standard wrapper unavailable in this runtime; used a direct fallback audit to obtain the CHURNING verdict and route signals.
- strategy-critic: standard wrapper unavailable in this runtime; used the direct strategy re-audit after patching `STRATEGY.md`.
