# progress-critic route190 directive

## Mandate

Fresh-context audit of recent iter progress per active route. K=4 (iters
186 → 189). Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR
with named correctives.

## Routes considered for iter-190 prover dispatch

### Lane A — `RiemannRoch/OCofP.lean`

| Iter | Sorries | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| 186 | 7 | many (refactor) | DONE | Refactor ocofp-carrierset-submodule-api Steps 1+2 |
| 187 | 4 | 1 (`carrierPresheaf` etc) | DONE | Steps 3+4+5 refactor + 3 cascade closes axiom-clean |
| 188 | 4 | `carrierSubmoduleSheaf` + `trivAtBot` | DONE PARTIAL | structural sheaf-axiom fix landed; Case B failed |
| 189 | 3 | 1 (`map_val` inline) | DONE | Case B closed axiom-clean via direct irreducibility |

Strategy iters-left: ~10-20 (Genus-0 RR.3 row).
Strategy LOC realized/it: ~30.
Entered current phase at iter-178.
Recurring blocker phrases: subtype-friction (`Set ↥C.left` vs `↑C.left.toTopCat`)
mostly resolved iter-189. Remaining 3 sorries (h1_vanishing_genusZero L1154,
dim_eq_two_of_genusZero L1191, exists_nonconstant_genusZero L1249) are
downstream of RR.2.H¹ skyscraper-vanishing — NOT on this lane's iter-190
critical path.

### Lane I — `RiemannRoch/RationalCurveIso.lean`

| Iter | Sorries | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| 186 | 5 | 0 | DONE | 78-LOC inline doc on Hom.poleDivisor_degree_eq_finrank scaffold |
| 187 | 3 | 4 typeclass binders | DONE | `Hom.poleDivisor` body lands substantive; 1 localParameterAtInfty named sorry |
| 188 | 2 | 0 | DONE | `localParameterAtInfty` closed axiom-clean (4-step recipe) |
| 189 | 2 | 0 | DONE | Pin 3 Step 1 closed inline (function-field iso); Pin 2 diagnosed as **FALSE-AS-STATED** |

Strategy iters-left: ~6-10 (Genus-0 RR.4 row).
Strategy LOC realized/it: ~75.
Entered current phase at iter-180.
**CRITICAL**: iter-189 prover diagnosed structural conflict — the iter-187
body of `Hom.poleDivisor` produces a *principal* divisor (degree 0 by
Hartshorne II.6.10), but the theorem RHS `Module.finrank K(ℙ¹) K(C)` is
positive. Theorem is mathematically false as stated. Plan-phase needs to
decide between option (a) refactor `Hom.poleDivisor` to be the positive
part (~30-50 LOC `WeilDivisor.positivePart` substrate), or (b) rename
theorem to operate on `positivePart (Hom.poleDivisor)`.

### Lane G — `Albanese/AuslanderBuchsbaum.lean`

| Iter | Sorries | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| 186 | 3 | 0 | DONE | iter-186 substrate hooks |
| 187 | 3 | 1 | DONE | G1 cotangent dim drop helper scaffold |
| 188 | 2 | 0 | DONE | G1 closed kernel-only ~150 LOC |
| 189 | 2 | 3 (refactor narrow substrate) | DONE PARTIAL | G2 body assembled; substrate narrowed to pure Stacks 00NQ `isDomain_of_regularLocal` |

Strategy iters-left: ~10-18 (A.4.b row).
Strategy LOC realized/it: ~150-200 (substantive scaffolding).
Entered current phase at iter-184.
Substrate narrowed from consolidated 00NQ+00NU sorry to pure 00NQ
`isDomain_of_regularLocal`. Mathlib gap confirmed via multiple search
methods. iter-190+: project-side proof (~300 LOC) OR Mathlib upstream PR
(~50-100 LOC) OR Koszul-homology bypass.

### Lane A.3.i — `Picard/IdentityComponent.lean`

| Iter | Sorries | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| 186 | 5 | 7 (Path B split) | DONE | Path B refactor lands; +5 scaffold sorries |
| 187 | 8 | 5 (more scaffolds) | DONE | Path B scaffolds expanded |
| 188 | 9 | 4 helpers | DONE | identityComponent_locallyConnectedSpace axiom-clean ~50 LOC; net −1 sorry |
| 189 | 8 | 0 | DONE | HARD SCOPE CAP enforced; 0 closures (HARD BAR FAILED); 1 PARTIAL (LFT half axiom-clean inline) |

Strategy iters-left: ~4-8 (A.3.i row).
Strategy LOC realized/it: ~30.
Entered current phase at iter-184.
**HARD SCOPE CAP escalation TRIGGERED**: iter-189 closed 0 scaffold sorries
against ≥2 target. Per the prior iter's own monitor: "if 0 closures, route
transitions to STUCK iter-190 → refactor required."
Recurring blocker: scheme-level connectedness of products (EGA IV₂ 4.5.8
NOT in Mathlib at b80f227); `GrpObjAsOverPullback` `OverClass`/`asOver`
bridging needed; `Pic0Scheme` opacity until A.2.c body lands.

### Lane F — `Picard/QuotScheme.lean`

| Iter | Sorries | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| 186 | 9 | 0 | DONE | iter-186 Lane F PARTIAL |
| 187 | 11 | 2 named pins | DONE | analogist-licensed unbundle |
| 188 | 11 | 1 (`_sectionLinearEquiv` Σ-pair) | DONE PARTIAL | substantive content into helper; HARD BAR technically met |
| 189 | 13 | 2 (`tildeIso_of_isQuasicoherent_isAffineOpen` + `pullback_of_openImmersion_iso_restrict`) | DONE PARTIAL | unbundle landed; `_sectionLinearEquiv` body NOT closed (HARD BAR FAILED) |

Strategy iters-left: ~12-16 (A.2.c row, but Lane F is sub-task).
Strategy LOC realized/it: ~30.
Entered current phase at iter-184.
**3-iter helper-churn pattern: +2 sorries per iter, residual unchanged**.
The analogist verdict iter-189 said "unbundling makes targets individually
closable iter-190+ via 30-50 LOC each" — i.e. correct corrective IS the
unbundle, not adding helpers. Verify: does this look like CHURNING or
licensed structural progress?

### Lane B — `Genus0BaseObjects/Cross01Substrate.lean` (NEW iter-189)

| Iter | Sorries | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| 189 | 0 | n/a | DONE | NEW file. Substrate 1 axiom-clean. |

Strategy iters-left: ~3-5 (Genus-0 III.c row).
Strategy LOC realized/it: ~80.
First iter in current phase.
Substrate 1 axiom-clean. Substrate 2 (`gmRing_tensor_homogeneousAway_isDomain`)
owed iter-190.

### Lane E — `AbelianVarietyRigidity.lean` (HALTED iter-189)

| Iter | Sorries | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| 186 | 2 | 0 | DONE | III.c substrate |
| 187 | 2 | 0 | DONE | III.c substrate |
| 188 | 2 | 0 | DONE BLOCKED | Proj.appIso accessibility |
| 189 | 2 | n/a | HALTED | mathlib-analogist consult `lane-e-projappiso` → PROCEED with refactor |

Strategy iters-left: ~3-5.
Entered current phase at iter-176 (19 iters in current state).
Analogist verdict iter-189: refactor `iotaGm_onePt_chart1_factor` packaging
to `noncomputable def iotaGm_r_1` + paired lemmas + extracted range-
containment lemma. Realistic helper budget 60-80 LOC. iter-190: refactor +
prover.

### Lane H — `RiemannRoch/RRFormula.lean` (HALTED iter-189)

| Iter | Sorries | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| 186 | 2 | 0 | DONE | H⁰/H¹ split chapter |
| 187 | 2 | scaffold expansion + Hartshorne IV.1 verbatim quotes | DONE | blueprint-writer |
| 188 | 2 | 0 | DONE | H⁰ closed; H¹ localized into RR.2.H¹ Tier-3 typed sorry |
| 189 | 2 | n/a | HALTED | H1Vanishing chapter unstarted; defer until iter-190 plan-phase writes it |

Strategy iters-left: ~4-8 (RR.2 H⁰ row; RR.2 H¹ ~8-12).
Strategy LOC realized/it: H⁰ closed (~30/it); H¹ skeleton not yet started.
Entered current phase at iter-180.

## Sorry trajectory across iters

| Iter | Total sorries | Net Δ |
|---|---|---|
| 185 | 80 | n/a |
| 186 | 76 | −4 |
| 187 | 82 | +6 (directive-licensed scaffolds) |
| 188 | 77 | −5 |
| 189 | 78 | +1 |

## Planner's iter-190 `## Current Objectives` candidate set (sanity check this)

7 lanes proposed:
1. `Albanese/AuslanderBuchsbaum.lean` — Lane G2 substrate close
   (`isDomain_of_regularLocal`)
2. `RiemannRoch/RationalCurveIso.lean` — Lane I Pin 2 corrective
   (positive-part route) + Pin 3 Step 2 substrate
3. `Picard/IdentityComponent.lean` — Lane A.3.i refactor escalation
   (CHURNING → STUCK trigger fired iter-189)
4. `Picard/QuotScheme.lean` — Lane F close Step 3 pin
   (`pullback_of_openImmersion_iso_restrict`) — easiest of the 3 pins per
   iter-189 analogist verdict
5. `Genus0BaseObjects/Cross01Substrate.lean` — Lane B Substrate 2
   (`gmRing_tensor_homogeneousAway_isDomain` ~50-80 LOC)
6. `AbelianVarietyRigidity.lean` — Lane E refactor + helper close
   (post mathlib-analogist verdict PROCEED-with-refactor)
7. `RiemannRoch/OCofP.lean` — Lane A continued (downstream consumers
   `h1_vanishing_genusZero` etc — gated on RR.2.H¹)

## What I expect from you

- Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR.
- For CHURNING / STUCK: a named corrective per route.
- Dispatch-sanity check on the 7-lane proposal: am I dispatching the right
  set? Should I drop any? Should I add anything I missed?
- Estimation honesty check: do my Iters-left numbers in STRATEGY.md
  appear consistent with realized velocity (e.g. if Lane I is 6-10 iters
  left but Pin 2 just blew up the route, refresh).
