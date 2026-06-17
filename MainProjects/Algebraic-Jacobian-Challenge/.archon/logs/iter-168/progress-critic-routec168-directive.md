# Progress-critic directive — slug `routec168`

## Iteration

168 (plan phase).

## Active routes

ONE active route this iter: **Route C genus-0 base case** (the only critical-path
arm with live prover work; Route A is off-critical-path / deferred; Cohomology /
Differentials / Rigidity / RigidityKbar all 0 sorries).

### Route C — Genus0BaseObjects.lean (Lane A) + AbelianVarietyRigidity.lean (Lane B)

The two files share one route: Lane B's helper consumes Lane A's exports. Treat
as a single route with two prover lanes that ship together.

#### STRATEGY.md `## Phases & estimations` — verbatim rows

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| **Route C genus-0 rigidity** | Rigidity chain + Cor 1.5 + Cor 1.2 CLOSED axiom-clean; base case route RESOLVED = `𝔾_m`-scaling shortcut; concrete ℙ¹/𝔾ₐ/𝔾ₘ + `gmScalingP1` scaffold landed iter-165 | ~5–12 | ~1500–3500 · base-case infra +~390 LOC iter-165 | `σ_×:ℙ¹×𝔾_m→ℙ¹` scaling; concrete ℙ¹/𝔾_m group objects; density+separated; genus-0⟹ℙ¹ RR bridge | scaffold landed; RR bridge `genusZero_curve_iso_P1` is now the long pole |

Phase entered "scaffold landed" state at iter-165.

#### Last K=4 iters of signal data (iter-164 → iter-167)

**Sorry counts per iter (Genus0BaseObjects.lean / AbelianVarietyRigidity.lean / GLOBAL):**

| Iter | G0BO | AVR | GLOBAL | Net |
|---|---|---|---|---|
| iter-164 entry | (file not yet created) | 3 | 6 | baseline |
| iter-165 exit | 9 | 3 | 12 | +9 G0BO scaffold (planned, NEW-file dispatch) |
| iter-166 exit | 6 | 6 | 15 | G0BO −3 (3 ℙ¹-points closed axiom-clean); AVR +3 (Lane B helper inlined 5 sorries, RR bridge unchanged) |
| iter-167 exit | 9 | 2 | 14 | G0BO +3 (3 NEW scaffold sorries Lane B consumes); AVR −4 (5 aux closed via Lane A exports + 1 hoisted as `iotaGm_isDominant`) |

**Net trajectory over K=4 iters:** GLOBAL 12 → 15 → 14 (one decrement net). The
sorry-elimination signal is genuine on the AVR (Lane B) side; G0BO (Lane A)
file's sorry count is NET +0 across iter-166 → iter-167 even though 3 ℙ¹-points
closed (because 3 NEW scaffold sorries were added to support Lane B's collapse).

**Helpers added per iter (Lane A side, named top-level decls):**

- iter-165: 4 main objects (`ProjectiveLineBar`, `Ga`, `Gm`, `gmScalingP1`) + ~10
  typeclass bridges (`projectiveLineBar_isProper`, `gm_isAffine`,
  `gm_locallyOfFinitePresentation`, etc., 5 axiom-clean).
- iter-166: 3 named points (`zeroPt`, `onePt`, `inftyPt`) axiom-clean via
  shared `pointOfVec`.
- iter-167: 4 axiom-clean instances (`gmRing_isDomain`, `gm_irreducibleSpace`,
  `projGm_locallyOfFiniteType`, `projGm_geomIrred`) + 3 scaffold-sorry exports
  (`projectiveLineBar_isReduced`, `gm_geomIrred`, `projGm_isReduced`).

**Prover statuses (file-level):**

| Iter | Lane A status (G0BO) | Lane B status (AVR) |
|---|---|---|
| iter-165 | COMPLETE (PARTIAL gate met — NEW-file scaffold landed) | (no AVR work this iter — Lane 1) |
| iter-166 | PARTIAL (3 of 7 plan-flagged closed; 3 CRITICAL + 3 OPT-IN deferred) | PARTIAL (signature refactor + outer body + 5 helper sorries) |
| iter-167 | PARTIAL (PRIMARY gate missed: 2/4 product/Proj instances axiom-clean) | COMPLETE for PRIMARY (5 aux sorries closed) |

**Recurring blocker phrases over K=4 iters (Lane A):**

- "deferred — substantial chartwise glue, ~3-4 sub-lemmas worth" (`gmScalingP1` body — present iter-165, iter-166, iter-167)
- "estimated 80-150 LOC, multi-step" (`gm_grpObj` — present iter-165, iter-166, iter-167)
- "Mathlib gap on `HomogeneousLocalization.Away` is-domain" (`projectiveLineBar_isReduced`, NEW iter-167)
- "Mathlib gap on `Smooth → GeometricallyReduced` scheme-level bridge"
  (`projGm_isReduced`, NEW iter-167)
- "tensor-localization-of-domains bridge missing" (`gm_geomIrred`, NEW iter-167)

#### Planner's proposed `## Current Objectives` for iter-168

ONE file (Lane A single-drill — Lane B has its 5 aux closed and waits on Lane A's
`gmScalingP1` body to lift `iotaGm_isDominant` to axiom-clean; no Lane B
parallel work is available this iter).

1. **`AlgebraicJacobian/Genus0BaseObjects.lean`** — PRIMARY = build
   `homogeneousLocalizationAwayIso ≃+* MvPolynomial Unit kbar` (~30 LOC,
   identified by the iter-167 prover as the single lever unlocking 3 closures);
   then use it to close `projectiveLineBar_isReduced` axiom-clean (via
   `IsReduced.of_openCover` over `Proj.affineOpenCover`); plus carry to start
   `gmScalingP1` body's chartwise glue. OPT-IN = `ga_grpObj` (analogist's FREE
   2-3 LOC via `AffineSpace.homOverEquiv`).

Basenames: `Genus0BaseObjects.lean`. File count: 1.

## What the critic should assess

1. **Verdict on Route C as a single route across the two files: CONVERGING /
   CHURNING / STUCK / UNCLEAR?**

   Note the apparent tension: G0BO's file-level sorry count is NET +0 across
   iter-166 → iter-167, but the AVR-side sorry count dropped from 6 → 2 (-4) in
   the same period because the 3 Lane A NEW scaffold exports were exactly the
   bridges Lane B needed. Is this churn (helpers proliferating, residual
   unchanged on the file's own count) or progress (route-level residual
   collapsing, just bookkept under a different file)?

2. **Specifically on `gmScalingP1` body and `gm_grpObj`** (both 3-iter deferred
   now: iter-165, iter-166, iter-167). Is this escalation-watch-trigger
   territory? The planner's intent for iter-168 is to attack
   `homogeneousLocalizationAwayIso` (an upstream helper) rather than
   `gmScalingP1` directly — does that count as "another helper round" (the
   CHURNING failure mode) or as principled decomposition (the helper unlocks
   3 named downstream closures and is itself a single ~30 LOC ring-level
   isomorphism)?

3. **Single-lane vs multi-lane**: with Lane B done for its current scope
   (waiting on Lane A's `gmScalingP1` for `iotaGm_isDominant`), is the
   single-lane drill on Lane A the right load? Or should the planner open a
   second lane (e.g. on AVR's `genusZero_curve_iso_P1`, the RR-bridge long
   pole)?

4. **Dispatch-sanity check**: file count 1 (Genus0BaseObjects.lean only), with
   a tightly-scoped PRIMARY (the iso helper + one named closure) + OPT-IN
   (`ga_grpObj` if FREE). Right scope, or under/over-dispatched?

## Constraints

- Read ONLY this directive. Do NOT open STRATEGY.md, blueprint chapters, iter
  sidecars, or task results.
- Verdict per route. Concrete corrective action if not CONVERGING.
