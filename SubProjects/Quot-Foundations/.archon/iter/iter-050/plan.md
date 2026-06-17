# Iter 050 — Plan (Quot-Foundations)

## TL;DR
2 prover lanes (GF make-or-break + GR-quot fresh scaffold); SNAP route re-decided (no prover, per
CHURNING corrective). All 3 mandatory critics + analogist dispatched; all must-fixes actioned.

## Decision made
- **GF — `FlatteningStratification.lean` [mathlib-build]:** progress-critic STUCK/make-or-break. Dispatch the
  CONCRETE seam-1a route (transport `σ.π` along existing `overRestrictPullbackIso` through epi-preserving
  `pullback U.ι` — infra verified to exist). Lane chains 1a→assembly→G1→G3→close genericFlatness. Reverse
  signal: if 1a stalls AGAIN, escalate + pivot (no more helper rounds).
- **GR-quot — `GrassmannianQuot.lean` (NEW) [mathlib-build]:** UNCLEAR/fresh; strategy-critic SOUND. Scaffold
  + build PROCEED-now (`chartQuotientMap`, `represents`-sig) + attempt the hard Archon-original
  `Scheme.Modules.glue`; riders scaffold w/ sorry. Reuse existing `IsLocallyFreeOfRank` (QuotScheme.lean:253).
- **SNAP — no prover (CHURNING corrective).** analogist found Analogue 1 (abelian `W.monoidal` coequalizer
  transfer); route (b) + Analogue 4 proven dead. blueprint-writer re-routed `lem:sheafTensorPow_add` + added
  crux `lem:isIso_sheafification_whiskerRight_unit` + `cor:sheafTensorObjAssoc`. Prover iter-051.

## Must-fixes actioned
- strategy-critic FBC CHALLENGE → residual-risk acknowledgement + closure-escalation plan in STRATEGY Routes.
- strategy-critic format → STRATEGY 16.7→11.6 KB, terse Status tags, per-iter narrative removed.
- blueprint-reviewer GR-quot partial → fast-path writer (glue construction path) → scoped recheck CLEARED.
- Fixed duplicate `def:is_locally_free_of_rank` label (predicate already at QuotScheme.lean:253; GR reuses).
- seam-1c prose generalised (dropped spurious "quasi-coherent").

## Subagent skips
- None. progress-critic, strategy-critic, blueprint-reviewer (+grquot recheck), mathlib-analogist, 3
  blueprint-writers, blueprint-clean all dispatched.
