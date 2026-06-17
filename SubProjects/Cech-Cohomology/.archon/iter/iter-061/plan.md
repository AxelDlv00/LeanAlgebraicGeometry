# Iter-061 plan — processed 2 keystone closures; honored BOTH CHURNING verdicts with executed correctives (not deferral); dispatched 2 ready lanes

## Entering state (verified)
- iter-060 ran 2 mathlib-build lanes, both PARTIAL-with-keystone-closure (+7 axiom-clean decls):
  - **CSI: Stub 1 `cechBackbone_left_sigma` CLOSED** (universe reduction `𝒰.I₀≃Fin n`). sorry 5→4.
  - **OpenImm: `hjt` CLOSED** (`jShriekOU_transport_along_iso` via `CorepresentableBy.uniqueUpToIso`).
    sorry 3→2.
- Project real sorry: **11→9** (4 CSI Stubs 2/4/5/6 + OpenImm `hqc`/`_comp` + CAR hSec + frozen P5b +
  dead `CechAcyclic.affine`). Build GREEN.
- Review (iter-060): lean-auditor 0 must-fix; lvb-csi 0 red-flags; lvb-openimm 1 must-fix (stale NOTE,
  already fixed in iter-060 review). Coverage debt: 5 unmatched (4 iter-060 helpers + dead `affine`).

## What I did this phase
1. Processed both iter-060 prover results → `task_done.md` (iter-060 entry) + `task_pending.md`
   (iter-061 status). Cleared the 2 prover + 3 iter-060 review result files.
2. **progress-critic `iter061`** → **BOTH routes CHURNING** (PARTIAL×K rule). Acted on both this iter
   (the critic explicitly endorsed "do the cheap correctives, then dispatch both provers" — NOT defer):
   - Route A corrective (blueprint expansion) → **effort-breaker** on `pushPull_coprod_prod`.
   - Route B corrective (Mathlib-idiom consult) → **mathlib-analogist** + a recorded rebuttal of the
     borderline reading.
3. **blueprint-writer `iter061`** → added standalone `lem:pushPull_coprod_prod`, cleared 4-helper
   coverage debt (bundled into `lem:cech_backbone_left_sigma` / `lem:jshriek_transport_along_iso`),
   trimmed stale `\uses`.
4. **effort-breaker `pushpull-coprod`** → split `pushPull_coprod_prod` into L1 `isIso_modules_of_toPresheaf`
   + L2 `pushPull_binary_coprod_prod` + induction node; `pushPull_sigma_iso` edge intact.
5. **mathlib-analogist `pushforward-restriction`** → **PROCEED**; canonical recipe (`QuasicoherentData.bind`
   template, `Over.iteratedSliceEquiv` swap); `analogies/pushforward-commutes-restriction.md`.
6. **blueprint-clean `iter061`** → purity (2 edits), confirmed both new `\uses` anchors exist.
7. **blueprint-reviewer `iter061`** → **HARD GATE CLEARS** for both lanes; 2 soon-items (isolated
   coyoneda anchors on the DONE `jshriek_transport_along_iso` — deferred, not on a live lane).
8. Refreshed STRATEGY estimate cells (throughput SLIPPING; substance unchanged). Wrote PROGRESS objectives
   (2 lanes), this sidecar, objectives.md.

## Decision made — D1: honor BOTH CHURNING verdicts with executed correctives, then dispatch (not defer)
- **Route A (CSI) — ACCEPT the CHURNING corrective.** The critic is right that throwing the
  ~200–400 LOC `pushPull_coprod_prod` monolith reproduces the under-specified setup that caused the
  Stub-1 multi-iter stall. So I effort-broke it FIRST (L1 reflection wrapper / L2 binary base /
  induction) — the same decompose-first discipline that converged Stub 1. Then I dispatch the
  mathlib-build prover at the NEW small leaves (L1 is a 2-line ready first leaf). This is the sanctioned
  post-decomposition dispatch, not a re-throw of the monolith.
- **Route B (OpenImm) — REBUT the borderline CHURNING + run the named insurance consult.** The verdict
  is "the weakest possible CHURNING reading" (the critic's own words): PARTIAL×3 at the MINIMUM K=3, the
  residual SHRANK every iter (core→homological-half→hjt→hqc; sorry 3→2), blockers are non-recurring, and
  it is 1 sorry from done. That trajectory is CONVERGING, not stalling — the CHURNING is purely the
  mechanical PARTIAL×K rule firing at threshold. I still ran the critic's named corrective (mathlib-analogist
  on `pushforward_commutes_restriction`) because it is cheap insurance on the final leaf and a
  mis-targeted prover iter here is costly relative to the route's budget. Result was strongly positive:
  it CONFIRMED the route is canonical AND handed back a far more concrete recipe (copy `QuasicoherentData.bind`,
  swap to `Over.iteratedSliceEquiv`) than the prover had. So Route B IS dispatched this iter.

## Why dispatch both provers this iter (not an effort-break-only iter)
The iter-058 precedent (effort-break-only, defer prover) applied because the monolith had NO decomposition
to dispatch against. Here, after the effort-breaker + analogist, BOTH lanes have small, named, gate-CLEAR
ready leaves with concrete recipes. mathlib-build mode attacks fresh leaves bottom-up and hands off a clean
decomposition if blocked (no broken sorries). Dispatching now is the efficient honoring of the critic's
"then dispatch both provers" endorsement — one iter of restructure+dispatch, not a wasted defer iter.

## Subagent skips
- strategy-critic: STRATEGY.md substance unchanged since iter-059's SOUND verdict (same two routes, same
  Route-A decomposition, same Need#1 transport; the one CHALLENGE — Need#1 necessity — was RESOLVED
  iter-059 and remains resolved). This iter's only STRATEGY edit is refreshing two `Iters left` estimate
  cells per the progress-critic's throughput note — a calibration refresh, not a route/phase/decomposition
  change. Convergence was independently audited by the (mandatory) progress-critic this iter.

## Risks / watch
- **CSI Stub-2 L2** (`pushPull_binary_coprod_prod`, the substantive ~200 LOC node) is the real difficulty;
  the effort-breaker pre-flagged a finer cut (comparison-map / disjoint-preimage geometric fact /
  sectionwise identification). If the prover stalls there, re-break L2 next iter — do NOT brute-force.
- **Throughput:** both phases have exceeded their original `Iters left`. If Stub 2 / `hqc` do NOT close
  iter-061, revise estimates again iter-062 (Route B would hit OVER_BUDGET).
- The 2 isolated coyoneda `_mathlib` anchors are a recorded next-iter cleanup (PROGRESS Next-iter plan #4).
