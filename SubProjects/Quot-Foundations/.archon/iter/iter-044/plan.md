# Iter 044 — Plan (Quot-Foundations)

## TL;DR
2 import-independent prover lanes: **QUOT close gap2** (Piece A route-1 chain L1–L6 + 1-line final close) and
**FBC keystone `_legs_conj`** (RE-ENGAGED via the analogist's factored `conjugateEquiv_symm_comp` route — the
monolithic-β was the 7-iter trap, not the route). Blueprint: effort-broke Piece A (2177→517, 6 sub-lemmas);
wrote the Piece B coverage-debt block; wired 2 isolated leandag nodes. STRATEGY de-drifted + re-scoped.

## Decision made — re-engage FBC as a lane (not park)
- **Chosen:** dispatch BOTH lanes this iter. Initial read was "park FBC" (7-iter wall, off critical path),
  but the mathlib-analogist returned a concrete NEW route: discharge the keystone as a chain of the 3
  axiom-clean legs via `conjugateEquiv_symm_comp` + whiskering (mirror `leftAdjointCompNatTrans₀₂₃`), with
  NO monolithic β. Both critics converged: progress-critic's must-fix ("consult must yield a re-engagement
  gate") fires affirmatively; strategy-critic CHALLENGE ("decomposition, not indefinite parking") demands
  exactly this. FBC is parallel-safe with QUOT (different file) and is the independent 2nd lane that
  mitigates the Piece-A concentration risk. Reversal signal: if `adjL`/`adjR` construction itself resists,
  partial-progress handoff (mathlib-build) — do NOT revert to monolithic β.
- **Why not 3 lanes:** SNAP (no chapter yet), GF-G1/annihilator/P2 (gap2-gated or same file), FBC-A2 (same
  file as keystone), GR-repr (new file) — none scaffold-ready. 2 is the genuine max (progress-critic OK).

## Critic dispositions
- **progress-critic `iter044`:** QUOT CONVERGING; FBC STUCK→re-engagement gate satisfied; dispatch OK.
- **strategy-critic `iter044` CHALLENGE×2:** (1) FBC → committed lane (above); (2) concentration risk →
  FBC = independent 2nd lane; SNAP re-scoped BLOCKED→NEXT, Q4 RelativeSpec tag-pin added; format de-drifted.
- **blueprint-reviewer `iter044`:** QUOT gate CLEAN; FBC content ✓✓ — sole must-fix = stale `\leanok`
  (sync_leanok's deterministic domain, not agent-editable, non-blocking, auto-fixed post-prover).

## Subagent skips
- None skipped — all three [HIGHLY RECOMMENDED] (blueprint-reviewer, progress-critic, strategy-critic)
  dispatched; plus effort-breaker (Piece A) + mathlib-analogist (FBC) + blueprint-clean.
