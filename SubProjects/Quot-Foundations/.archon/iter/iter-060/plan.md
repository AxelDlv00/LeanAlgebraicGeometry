# Iter 060 — Plan (Quot-Foundations)

## TL;DR
GF `genericFlatness` CLOSED iter-059 (critical path DONE) → moved to STRATEGY ## Completed. 2 prover lanes:
**SNAP** fill `relTensorProj.naturality` (ModuleCat-presheaf route); **GR** resolve the cold-build OOM
ceiling (lean `bundleTransition_self`). C2 effort-broken (L1/L2/L3) for iter-061; FBC stays parked.

## State verified first-hand
FlatteningStratification 0 sorries (GF done ✓). GrassmannianQuot 4, SectionGradedRing 1 (L658), QuotScheme
4 (high-level chain — `hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/`representable`, GATED on SNAP+Snapper,
NOT the stale "annihilator+P2" ramp note). Cold `lake build GrassmannianQuot` stalled >21min then killed —
corroborates iter-059 OOM ceiling.

## Critics (both CONVERGING)
- progress-critic: GR must-fix BEFORE C2 = OOM ceiling (refactor/lean); SNAP dispatch relTensorProj now;
  don't over-bundle GR → C2 PROVE deferred to iter-061. SNAP analogist only if route fails.
- blueprint-reviewer (full): GF chapter clean; SNAP relTensorProj "mathematically ready (sketch
  sufficient)"; GR C2 under-specified → effort-broke it; FBC-A2 bypass ILLUSORY (keep parked).

## Decision made — SNAP gate REBUTTAL
blueprint-reviewer marked SectionGradedRing "HARD GATE: NOT complete" on a single must-fix: a `\lean{}` pin
for `lem:snap_ztensor_whisker_localIso`. REBUTTED for the relTensorProj lane: that node (a) has a complete
informal proof, (b) has NO Lean decl yet so no pin is possible, (c) is a DOWNSTREAM node NOT in
relTensorProj's dependency cone. The reviewer itself says the relTensorProj dispatch is "mathematically
ready." → gate clear for relTensorProj; pin logged as future hygiene. Reverse if the prover finds the
relTensorProj blueprint actually inadequate.

## GR resource-fix rationale
OOM (exit137) blocks cold-build + sync_leanok for the whole GR chain. Lean the maxHeartbeats-1e6
`bundleTransition_self` proof term first (cheap, low-risk); report proof-local-vs-file-wide so iter-061 can
decide a file split (standing parallelism directive). LSP provers still operate, so the lane is productive.

## Subagents this iter
effort-breaker (C2 → L1/L2/L3 + infra; effort 1814→895), blueprint-clean (GR chapter purity), full
blueprint-reviewer, progress-critic.

## Subagent skips
- strategy-critic: routes/goal/decomposition UNCHANGED. STRATEGY edits = completion-bookkeeping (GF-geo →
  Completed), estimate refresh, stale-scope correction on QUOT-defs (annihilator+P2 are done; real remainder
  is the SNAP-gated top-level chain), FBC stays parked. No route swap / phase split. The one live strategic
  question (FBC un-park) was authoritatively answered by the blueprint-reviewer reading the actual blueprint.
  Matches iter-058/059 "status-refresh only" precedent.
