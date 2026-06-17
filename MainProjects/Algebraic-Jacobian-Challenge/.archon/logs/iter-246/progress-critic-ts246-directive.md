# Progress-critic directive — iter-246

Assess convergence per active route. Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR.
Also run dispatch-sanity on the proposed objective list (item 6).

---

## Route TS — `Picard/TensorObjSubstrate.lean` (A.1.c.sub critical-path substrate)

The lane builds the locally-trivial-restricted pullback–tensor comparison iso
`pullbackTensorIsoOfLocallyTrivial` (and the `IsInvertible.pullback` corollary). It **pivoted route
at iter-245** off a general strong-monoidal pullback build onto a loc-triv chart-chase. The pivot was
a one-time, evidence-based scope reduction (the general build was adversarially confirmed unnecessary).

Signals, last 5 iters (per-iter prover output on this file):

| iter | prover status | new axiom-clean decls landed | file sorry count | recurring blocker phrase |
|------|---------------|------------------------------|------------------|--------------------------|
| 241  | PARTIAL | presheaf-monoidal scaffolding | 2 → 2 | "Mathlib-scale / no extendScalars" |
| 242  | PARTIAL | 2 (presheafPushforwardLaxMonoidal, presheafPullbackOplaxMonoidal = δ map) | 2 → 2 | "pullbackTensorIso confirmed Mathlib-scale" |
| 243  | PARTIAL | 2 (pullbackTensorMap = δ_sheaf, pullbackValIso) | 2 → 2 | "forward bridge Mathlib-scale" |
| 244  | PARTIAL | 7 (D1 pullbackLanDecomposition + 6 carriers/adjunctions) | 2 → 2 | "D2/D3 structurally Mathlib-absent" |
| 245  | PARTIAL | 2 (isIso_pullbackTensorMap_of_isIso_sheafifyDelta = reduction brick, + 1 helper) | 2 → 2 | "η-bridge not yet built (mate calculus)" |

Key context for your read:
- The canonical critical-path sorry counter has been **flat (2 → 2) for 7 iters (239–245)** — each iter
  lands axiom-clean infrastructure bricks but neither of the two deferred sorries
  (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) has closed.
- iter-245 was a route PIVOT (a soundness-before-budget catch): it abandoned a 20–38-iter general build
  for an ~8–16-iter loc-triv chart-chase and landed the reduction brick that collapses every remaining
  target (D2'/D3'/D4'/corollary) to a single goal shape `IsIso (a_Y.map δ …)`. So the loc-triv route is
  exactly **1 iter old**.
- The proposed iter-246 objective: build D2' (the η-bridge `IsIso (a_Y.map (η (pullback φ')))`, the
  unit-side analog of the PROVEN axiom-clean `pullbackObjUnitToUnit_comp`, ~60–120 LOC mate calculus),
  then D3'/D4'/corollary as far as reachable. mathlib-build mode.

Strategy phase row (A.1.c.sub): current **Iters-left estimate = 8–16**; the loc-triv route phase was
**entered at iter-245** (elapsed in current route = 1 iter). The general-build phase that preceded it
ran iters 244 only (D1) before the pivot.

Question for you: Is route TS CHURNING (each iter adds helpers but the residual never shrinks, recipe
rotating), or is the structural collapse (everything now funnels through one δ-iso goal) genuine
convergence on the new route? Note the route is only 1 iter old, but it inherits 7 iters of flat-counter
history on the same file under prior routes.

---

## Route RPF — `Picard/RelPicFunctor.lean` (A.1.c.fun, PROPOSED new parallel lane)

Fresh lane proposed for iter-246 (PARALLELIZATION per a standing user directive). It has NOT been under
active prover work in the last 5 iters (it was last touched iter ~235, then held pending the substrate).
Single file-local sorry: `addCommGroup` instance body (L269, `exact sorry`). The proposed objective:
author `addCommGroup` (group on loc-triv iso-classes) consuming the loc-triv comparison iso via a
TYPED-SORRY BRIDGE declaration (the bridge's discharge is exactly route TS's D4' objective — sanctioned
Mathlib-gradient parallelization), and upgrade `PicSharp.functorial` off the `0` stub.

Signals: no recent prover trajectory (held lane). Treat as UNCLEAR/fresh unless the proposed
parallelization shape itself looks unsound (e.g. the typed-sorry bridge can't actually be authored
because the consumer needs the iso's computational content, not just its existence).

Strategy phase row (A.1.c.fun): Iters-left ≈ 7–12; lane opening fresh this iter.

---

## Proposed `## Current Objectives` for iter-246 (dispatch-sanity, item 6)

2 files (of a 10 cap):
1. `Picard/TensorObjSubstrate.lean` — D2' η-bridge + D3'/D4'/corollary as far as reachable [mathlib-build]
2. `Picard/RelPicFunctor.lean` — author `addCommGroup` + `functorial` against a typed-sorry bridge [prove]

Check: are these two genuinely independent (no same-file collision)? Is the 2-lane load reasonable, or
is RPF premature given route TS's bridge isn't built yet?
