# progress-critic pc257 — convergence audit (iter-257 plan phase)

Assess per-route convergence over the last K=5 iters. For each route: are we closing
sorries / making structural advances, or churning helpers around an unmoving residual?
Give a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for CHURNING/STUCK,
name the corrective TYPE (blueprint expansion / Mathlib-idiom consult / structural refactor /
route pivot). Also run dispatch-sanity on the proposed objective set (item at bottom).

## Route TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean`

Target: the dual-inverse chain feeding `exists_tensorObj_inverse` (RPF group inverse / loc-triv⟹invertible bridge).
- iter-252: sorry 2→2; PARTIAL (`homOfLocalCompat`); helpers added.
- iter-253: sorry 2→2; PARTIAL (`homOfLocalCompat` sub-step (b) closed).
- iter-254: sorry 2→2; PARTIAL (sub-step (a) closed, (c) ~90%).
- iter-255: sorry 2→2; PARTIAL (`homOfLocalCompat` M-leg closed; narrowed to one f-leg smul bridge).
- iter-256: sorry 2→1; **`homOfLocalCompat` CLOSED axiom-clean** (5-iter CHURNING streak broken).
- Remaining sorry: `dual_restrict_iso` Step-4 (L259) — the presheaf-level dual-pushforward
  commutation across an open immersion. Recurring blocker phrase: "slice-site transport (leg A)";
  a concrete recipe exists (`analogies/dual252.md`: leg B = `restrictScalarsRingIsoDualEquiv` closed,
  leg A = `sliceDualTransport` Beck–Chevalley build; PLUS an unverified cheaper alternative —
  derive from the closed `tensorObj_restrict_iso` via inverse-uniqueness). This iter a mathlib-analogist
  is being run on Step-4 BEFORE any prover dispatch (per your iter-256 corrective).
- Strategy A.1.c.sub: Iters-left ~5–9; phase OVER_BUDGET (≈23 elapsed vs 6–11 estimated).

## Route TS-cmp — `Picard/TensorObjSubstrate.lean`

Target: pullback-monoidality sub-lemmas D1′–D4′ → `IsInvertible.pullback`.
- iter-251–254: D1′ work; PARTIAL; helper churn (multiple monoidal-instance bridges).
- iter-255: **D1′ `pullbackTensorMap_natural` CLOSED axiom-clean** (sorry 2→1).
- iter-256: D3′ `pullbackTensorMap_restrict` — PARTIAL; reversing signal fired AS ARMED (the planner's
  "mirror `pullbackObjUnitToUnit_comp`" recipe was DISPROVEN — `pullbackTensorMap` is not an adjunction
  transpose; it is a hand-built 4-fold composite). Prover scaffolded the decl + left a precise in-file
  ROADMAP (4-square comp_δ build: Sq1 `sheafificationCompPullback`-comp, Sq4 `pullbackValIso`-comp,
  Sq2 ring-map reconciliation). sorry 1→2 (new scaffold). Blueprint must-fix flagged (statement/sketch
  mismatch) — being fixed this iter before re-dispatch.
- Strategy A.1.c.sub: same row as TS-inv (Iters-left ~5–9).

## Route engine — `Picard/LineBundleCoherence.lean` (NEW)

Target: `IsLocallyTrivial ⟹ IsFinitePresentation` (A.2.c on-path coherence entry).
- iter-256: file created; 5 sorry stubs; compiles; **site-instance de-risk RESOLVED POSITIVELY**
  (all four slice-site instances present). Fresh route (1 iter of data). Blueprint must-fix flagged
  (finiteness-bridge under-specification on `chartPresentation`/`isFinitePresentation`) — being fixed
  this iter before opening bodies.
- Strategy A.2.c-engine: Iters-left ~85–140 (dominant pole); this entry ~120–250 LOC.

## Proposed iter-257 objective set (dispatch-sanity)

M=3 prover lanes, all import-independent, within the 10 cap:
1. `Picard/TensorObjSubstrate/DualInverse.lean` — attack `dual_restrict_iso` Step-4 (route armed by the
   analogist this iter; decompose leg A / or take the inverse-uniqueness alt).
2. `Picard/TensorObjSubstrate.lean` — D3′ 4-square comp_δ build (blueprint realigned this iter).
3. `Picard/LineBundleCoherence.lean` — full lane: close the easy decls + chartPresentation/isFinitePresentation
   (blueprint finiteness-bridge fixed this iter).

Question for you: is M=3 sound here, or should one lane wait (e.g. Step-4 still needs more recipe work
than one analogist consult provides)? Flag any lane you'd hold.
