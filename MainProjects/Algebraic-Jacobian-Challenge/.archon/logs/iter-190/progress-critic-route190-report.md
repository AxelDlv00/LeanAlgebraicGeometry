# Progress Critic Report

## Slug
route190

## Iteration
190

## Routes audited

### Route Lane A — `RiemannRoch/OCofP.lean`

- **Sorry trajectory**: 7 → 4 → 4 → 3 (iter-186 to iter-189); net −4 over K=4 window; −1 in final iter
- **Helper accumulation**: ~15+ helpers in iter-186 (refactor), 1 in iter-187, 2 in iter-188, 1 in iter-189; helpers tied to sorry closures in iters-186/187, 0 net sorry closure when helpers were added in iter-188, but iter-189 closed Case B axiom-clean via irreducibility argument with 1 helper
- **Recurring blockers**: Subtype-friction (`Set ↥C.left` vs `↑C.left.toTopCat`) appeared through iter-188, resolved in iter-189. No blocker persisting ≥3 iters in the current K window.
- **Avoidance patterns**: none
- **Prover status pattern**: DONE → DONE → DONE PARTIAL → DONE — one partial (iter-188 structural discovery) followed by a clean close in iter-189. Positive arc.
- **Throughput**: ON_SCHEDULE — ~10-20 iters estimated, entered iter-178; ~12 iters elapsed.
- **Verdict**: **CONVERGING**

**Advisory (not a must-fix)**: The 3 remaining sorries (`h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`, `exists_nonconstant_genusZero`) are **all downstream of RR.2.H¹ skyscraper-vanishing**, which is itself gated on an unwritten blueprint chapter. Dispatching a prover to OCofP iter-190 with these as the targets risks a PARTIAL status with 0 closures — the prover cannot advance through a substrate that has no blueprint chapter yet. If the H¹ chapter is NOT finalized in iter-190's plan phase, the OCofP prover dispatch should be **dropped** from the iter-190 proposal to avoid wasting a prover slot.

---

### Route Lane I — `RiemannRoch/RationalCurveIso.lean`

- **Sorry trajectory**: 5 → 3 → 2 → 2 (iter-186 to iter-189); net −3 in K=4 window; **flat for last 2 consecutive iters**
- **Helper accumulation**: 0 → 4 → 0 → 0; all helpers in iter-187 (typeclass binders), none since
- **Recurring blockers**: "Pin 2 FALSE AS STATED" — diagnosed in iter-189 only. Not yet ≥3 iters, but structurally definitive: the theorem's LHS is provably 0 (principal divisor degree by Hartshorne II.6.10) while the RHS is a positive finrank. This is not a Mathlib gap — it is a theorem-statement error requiring plan-phase structural correction before any prover can close Pin 2.
- **Avoidance patterns**: none
- **Prover status pattern**: DONE → DONE → DONE → DONE; all DONE, but each prover returned fewer closures than planned; Pin 3 Step 1 closed axiom-clean in iter-189 but Pin 2 was simultaneously diagnosed as unprovable.
- **Throughput**: SLIPPING — ~6-10 iters estimated, entered iter-180; ~10 iters elapsed. At top of estimate range, but Pin 2's structural conflict makes the estimate effectively void for that sorry. SLIPPING is the honest label.
- **Verdict**: **UNCLEAR**

Sorry trajectory was converging (5→3→2→2) but the last 2 iters are flat and the route has hit a different kind of wall: not a Mathlib gap, but a mathematically false theorem statement. CONVERGING fails (not strictly decreasing in K-window). CHURNING fails (helpers added in only 1 of 4 iters). STUCK fails on the formal K=4 window (count changed from 5 to 2). The correct characterization is **UNCLEAR because the structural situation fundamentally changed in iter-189**: a previously-CONVERGING route now has one sorry that is unprovable as stated and another (Pin 3 Step 2) that is independently closeable.

**Primary corrective** (must act this iter regardless of UNCLEAR verdict): **Refactor** — the plan-phase must make a binary decision on `Hom.poleDivisor`:
- Option (a): refactor `Hom.poleDivisor` to return the *positive part* `φ^*[∞]` (requires new `Scheme.WeilDivisor.positivePart` substrate, ~30-50 LOC)
- Option (b): rename `Hom.poleDivisor_degree_eq_finrank` to operate on `positivePart (Hom.poleDivisor φ)` (signature change only)
Either option requires blueprint coordination. Without this plan-phase decision, the prover dispatch for Pin 2 is vacuous — no axiom-clean closure is possible on the current theorem statement. Pin 3 Step 2 can proceed independently (prover dispatch valid for that sorry only).

---

### Route Lane G — `Albanese/AuslanderBuchsbaum.lean`

- **Sorry trajectory**: 3 → 3 → 2 → 2 (iter-186 to iter-189); net −1 in K=4 window; flat for last 2 iters
- **Helper accumulation**: 0 → 1 → 0 → 3; helpers in iter-187 (1 cotangent helper) and iter-189 (3 refactoring helpers); iter-189 helpers realigned the substrate without closing a sorry
- **Recurring blockers**: `isDomain_of_regularLocal` (Stacks 00NQ) confirmed absent from Mathlib at b80f227 — appears as the core blocker in iter-187 (analogist), iter-188 (prover), and iter-189 (prover) = **3 consecutive iters**
- **Avoidance patterns**: none — the refactoring in iter-189 was substantive structural progress (narrowing from Stacks 00NQ+00NU consolidated to pure 00NQ isolated)
- **Prover status pattern**: DONE → DONE → DONE → DONE PARTIAL — all statuses are DONE or better; iter-188 closed G1 axiom-clean (~150 LOC); iter-189 narrowed G2 substrate
- **Throughput**: ON_SCHEDULE — ~10-18 iters estimated, entered iter-184; ~6 iters elapsed
- **Verdict**: **CONVERGING** (with escalation advisory)

The K=4 trajectory shows genuine structural progress: G1 closed in iter-188, G2 substrate narrowed from a 2-gap consolidated sorry to a single pure Stacks 00NQ sorry in iter-189. The approach HAS changed structurally (iter-189 refactoring). The Mathlib gap is the sole remaining blocker and is confirmed-real and well-characterized.

**Escalation advisory**: The recurring `isDomain_of_regularLocal` absence has now been confirmed in 3 consecutive iters. The iter-190 prover MUST commit to one of the three closure strategies identified in the iter-189 prover report:
- (a) Project-side proof (~300 LOC using Krull's PIT + Krull intersection + prime avoidance — all Mathlib substrates confirmed present)
- (b) Mathlib upstream contribution (~50-100 LOC to a new `RingTheory/RegularLocalRing/Domain.lean`)
- (c) Koszul-homology bypass (requires Koszul complex API)

If iter-190 also defers this decision with another substrate reorganization, the route tips to CHURNING. The plan-phase must commit to one of (a)/(b)/(c) before dispatching the prover.

---

### Route Lane A.3.i — `Picard/IdentityComponent.lean`

- **Sorry trajectory**: 5 → 8 → 9 → 8 (iter-186 to iter-189); **net +3** from phase entry. 0 closures in iter-189 against a ≥2 target. HARD SCOPE CAP escalation trigger fired.
- **Helper accumulation**: 7 → 5 → 4 → 0 = 16 helpers added across 4 iters; helpers added in 3 of 4 iters (≥2 threshold)
- **Recurring blockers**: EGA IV₂ 4.5.8 (scheme-level connectedness of products) absent from Mathlib — appears in iter-187 scaffold, iter-188 (as structural gap), and iter-189 prover report = **3 consecutive iters**. `GrpObjAsOverPullback` `OverClass`/`asOver` bridging gap — iter-188 and iter-189. `Pic0Scheme` opacity (gated on QuotScheme lane) — iter-188 and iter-189.
- **Avoidance patterns**: none in the strict catalog sense, but the pattern of adding scaffolds every iter without closing them IS the churn signal here
- **Prover status pattern**: DONE → DONE → DONE → DONE; surface statuses all DONE, but iter-189's prover explicitly states "HARD BAR NOT MET (0 axiom-clean closures)" — the DONE status conceals 0 real progress
- **Throughput**: SLIPPING — ~4-8 iters estimated, entered iter-184; ~6 iters elapsed; net sorry count UP (+3) from phase entry
- **Verdict**: **CHURNING**

CHURNING fires via:
1. Helpers added in 3 of 4 iters (≥2) AND sorry count net WORSE than entry (5→8→9→8, net +3) — far worse than "unchanged" threshold
2. The HARD SCOPE CAP escalation trigger in iter-189's own prover report confirms: "if 0 closures, route transitions STUCK iter-190 → structural refactor on IdentityComponent.lean API shape"
3. Recurring EGA IV₂ 4.5.8 Mathlib gap across ≥3 iters

**Primary corrective**: **Mathlib analogy consult** — the EGA IV₂ 4.5.8 Mathlib gap (`isPreconnected_prod` at the scheme level) is the load-bearing blocker that blocks `isSubgroupHomomorphism`, which in turn blocks `isFiniteTypeGeometricallyIrreducible (QC+GI)` and `baseChangeIso`. Before any further prover work: dispatch `mathlib-analogist` specifically on (i) whether Mathlib has a scheme-level analog of `isConnected_prod` for group schemes, and (ii) whether `Scheme.GrpObjAsOverPullback` + `OverClass`/`asOver` bridging can be done in under 20 LOC. If no Mathlib path exists for (i), the prover must write a project-side `Scheme.isConnected_pullback_of_isGeometricallyConnected` substrate (~80-150 LOC) before the scaffold sorries can be closed. Running another prover round on the scaffolds without this decision is the failure pattern.

---

### Route Lane F — `Picard/QuotScheme.lean`

- **Sorry trajectory**: 9 → 11 → 11 → 13 (iter-186 to iter-189); **net +4** over K=4 window; sorry count has not decreased in any of the last 4 iters
- **Helper accumulation**: 0 → 2 → 1 → 2 = 5 helpers added in 3 of 4 iters (≥2); every helper round added named typed-sorry pins without closing them
- **Recurring blockers**: "Stacks 01HQ (`pullback_tildeIso`) pin unclosed" — iter-188 and iter-189. "HARD BAR NOT MET" on `_sectionLinearEquiv` — iter-188 and iter-189. The compositional bookkeeping gap ("8 transport pieces requiring individual verification") was named in iter-189.
- **Avoidance patterns**: none in the strict catalog sense; each prover round did produce a structural deliverable, but the deliverables have been accumulating rather than reducing
- **Prover status pattern**: DONE → DONE → DONE PARTIAL → DONE PARTIAL — PARTIAL in 2 of last 4 iters; HARD BAR not met in 2 consecutive iters
- **Throughput**: ON_SCHEDULE by count (12-16 iters estimated, entered iter-184; ~6 elapsed), but sorry count trends in the WRONG DIRECTION; any estimate is misleading when the route is net +4 in 4 iters
- **Verdict**: **CHURNING**

CHURNING fires:
1. Helpers added in 3 of 4 iters (≥2) AND sorry count net +4 (nowhere near "down by ≥1 per 2 iters")
2. PARTIAL prover status in 2 of 4 iters with HARD BAR missed both times

**Note on the iter-189 unbundle**: The iter-189 analogist verdict (Decision 4) said unbundling was the correct structural corrective. The unbundle DID land in iter-189 — two named individual pins (`tildeIso_of_isQuasicoherent_isAffineOpen` and `pullback_of_openImmersion_iso_restrict`) are now separately targetable. The iter-190 plan proposes closing Step 3 (`pullback_of_openImmersion_iso_restrict`, described as easiest, ~30-50 LOC) and this IS the right test of whether the unbundle was a genuine inflection point. **CHURNING is the correct verdict for the K=4 window**, but the iter-190 prover assignment (Step 3 closure) is also the right corrective action. If Step 3 closes axiom-clean in iter-190 as projected, the route will show its first actual sorry reduction and can be reclassified CONVERGING at iter-191.

**Primary corrective**: **Verify the unbundle inflection** — assign the iter-190 prover SPECIFICALLY to close Step 3 (`pullback_of_openImmersion_iso_restrict`) axiom-clean via the `hU.toSpecΓ_fromSpec` + `tilde.isoTop` naturality recipe documented in the iter-189 prover report. No new helpers, no further scope expansion. The hard bar for iter-190 Lane F is: **Step 3 closes axiom-clean or route escalates to user escalation for the Step 1 (Stacks 01I8) Mathlib gap**.

---

### Route Lane B — `Genus0BaseObjects/Cross01Substrate.lean`

- **Sorry trajectory**: 0 (new file, 1 iter); Substrate 1 (`IsClosedImmersion.lift_iff_range_subset`) closed axiom-clean (~80 LOC kernel-axioms-only)
- **Helper accumulation**: 0 helpers (direct close, no scaffolding needed)
- **Prover status pattern**: DONE — single iter, full close
- **Throughput**: UNCLEAR (1 iter of data; ~3-5 iters estimated)
- **Verdict**: **UNCLEAR** — fresh route, 1 iter of data; signals are entirely positive but insufficient for convergence assessment

Substrate 2 (`gmRing_tensor_homogeneousAway_isDomain`, ~50-80 LOC) is owed iter-190 per the plan commitment. The iter-189 prover report's recipe and the analogist substrate are documented. Prover dispatch for Substrate 2 is valid.

---

### Route Lane E — `AbelianVarietyRigidity.lean`

- **Sorry trajectory**: 2 → 2 → 2 → 2 (iter-186 to iter-189); **unchanged for all 4 iters**
- **Helper accumulation**: 0 → 0 → 0 → 0; no helpers added in any iter; the prover keeps attempting and failing without even scaffolding
- **Recurring blockers**: `Proj.appIso` accessibility / packaging issue — iter-188 and iter-189 (DONE BLOCKED and HALTED). The "image-mismatch on `(Proj.awayι).appTop`" structural impossibility from iter-188 motivated the analogist consult at iter-189. Analogist verdict (iter-189): proceed with refactor of `iotaGm_onePt_chart1_factor` packaging to `noncomputable def iotaGm_r_1` + paired lemmas + extracted range-containment lemma.
- **Avoidance patterns**: iter-189 was HALTED (prover not dispatched) to await analogist verdict — single-iter appropriate deferral, not an avoidance pattern
- **Prover status pattern**: DONE → DONE → DONE BLOCKED → HALTED — clear stall; last two active iters produced 0 closures
- **Throughput**: OVER_BUDGET — ~3-5 iters estimated; entered iter-176; **19 iters elapsed** = 3.8× the maximum estimate. This is the most over-budget route in the project.
- **Verdict**: **STUCK**

STUCK fires:
1. Sorry count unchanged across ALL 4 K-iters (2→2→2→2)
2. Prover status includes BLOCKED (iter-188, ≡ INCOMPLETE) AND HALTED (iter-189)
3. Recurring blocker (`appTop`/`Proj.appIso`) appears in 3 of 3 active iters (iter-186 through iter-188)

OVER_BUDGET at 19 elapsed vs max 5 estimate — the most extreme throughput violation of any active route.

**Primary corrective**: **Refactor** — the analogist verdict is PROCEED. Implement the `iotaGm_onePt_chart1_factor` → `iotaGm_r_1` packaging refactor this iter. The plan correctly proposes "refactor + prover" for iter-190. This must be executed without further delay — 19 iters of zero progress with a confirmed structural solution is indefensible. The refactor target is documented: `noncomputable def iotaGm_r_1` + paired lemmas + extracted range-containment lemma (~60-80 LOC per analogist estimate).

---

### Route Lane H — `RiemannRoch/RRFormula.lean`

- **Sorry trajectory**: 2 → 2 → 2 → 2 (iter-186 to iter-189); flat; but HALTED in iter-189 pending H¹ blueprint chapter write
- **Recurring blockers**: H¹ chapter unstarted — single-iter deferral (iter-189)
- **Avoidance patterns**: none (one-iter deferral is not ≥2 consecutive)
- **Prover status pattern**: DONE → DONE → DONE → HALTED — the HALT was deliberate and plan-coordinated
- **Throughput**: SLIPPING — H⁰ closed (~4 elapsed for H⁰ phase); H¹ phase estimate is ~8-12 iters, entered iter-185; ~5 elapsed
- **Verdict**: **UNCLEAR** — single-iter deliberate deferral pending blueprint chapter write; not enough signal yet on whether the H¹ chapter will unlock the sorry

If the iter-190 plan phase does NOT write the H¹ chapter and the prover is again HALTED, the route tips to CHURNING (avoidance pattern: ≥2 consecutive deferred iters). The plan's commitment to write H¹ this iter is load-bearing.

---

## PROGRESS.md dispatch sanity

- **File count**: 7 (cap: 10)
- **Over the cap**: no
- **Under-dispatch finding**: not definitive — multiple files with open sorries exist outside the proposal (CodimOneExtension: 8 sorries; GmScaling: 15 sorries; RelativeSpec: 7 sorries; OcOfD: 13 sorries; WeilDivisor: 4 sorries), but blueprint-chapter completeness for these files is not assessable from signals alone. They may be unready for prover dispatch.
- **Iter-over-iter trend**: proposal covers 7 active lanes; appropriate given the number of routes with confirmed-open blueprint chapters
- **Lane A (OCofP) dispatch concern**: as flagged above, the 3 remaining OCofP sorries are all gated on RR.2.H¹ skyscraper-vanishing. If the H¹ blueprint chapter is not written in iter-190's plan phase, the OCofP prover slot should be dropped or redirected to a ready file. Keeping it risks a wasted PARTIAL.
- **Lane I (RationalCurveIso) dispatch structure**: prover should work ONLY on Pin 3 Step 2 (independently closeable). Pin 2 corrective must come from the plan phase (option a or b decision). The directive's framing "Pin 2 corrective (positive-part route) + Pin 3 Step 2 substrate" correctly separates these — as long as the prover is NOT sent to close Pin 2 on the current theorem statement.
- **Verdict**: **OK** — file count 7 within cap 10; no under-dispatch given blueprint-readiness uncertainty on non-proposal files; one conditional flag on OCofP slot pending H¹ chapter status

---

## Must-fix-this-iter

- **Route Lane A.3.i** (IdentityComponent.lean): **CHURNING** — net +3 sorries from phase entry; 16 helpers added across 4 iters; HARD SCOPE CAP triggered with 0 closures in iter-189; EGA IV₂ 4.5.8 gap recurring ≥3 iters. Primary corrective: **Mathlib analogy consult** on scheme-level `isPreconnected_prod` and `GrpObjAsOverPullback`/`OverClass` bridging BEFORE any further prover dispatch. Why: no amount of prover work on the current scaffolds will close `isSubgroupHomomorphism` without first establishing whether the Mathlib gap can be bridged in the current framework or requires a project-side substrate.

- **Route Lane F** (QuotScheme.lean): **CHURNING** — net +4 sorries in 4 iters; 5 helpers added across 4 iters; HARD BAR missed 2 consecutive iters. Primary corrective: **verify the unbundle inflection** — assign prover ONLY to close Step 3 (`pullback_of_openImmersion_iso_restrict`) axiom-clean this iter; no new helper additions permitted. If Step 3 does not close axiom-clean, escalate to user escalation for the Step 1 (Stacks 01I8) Mathlib gap. Why: the unbundle claims to make pins individually closeable at 30-50 LOC; iter-190 is the test; if the claim fails, the route needs a different strategy.

- **Route Lane E** (AbelianVarietyRigidity.lean): **STUCK + OVER_BUDGET** — sorry count flat at 2 for all 4 K-iters; 19 iters elapsed vs 3-5 estimate (3.8× overbudget); prover status BLOCKED then HALTED; analogist verdict PROCEED with refactor. Primary corrective: **Refactor** — execute `iotaGm_onePt_chart1_factor` → `iotaGm_r_1` packaging refactor this iter without further delay. Why: a confirmed structural solution (the analogist verdict) has been waiting since iter-189; every additional iter of deferral is pure waste. STRATEGY.md estimate must be revised to reflect reality (4-6 iters remaining post-refactor, not 3-5 from iter-176).

- **Route Lane I** (RationalCurveIso.lean): **UNCLEAR with must-act flag** — Pin 2 is mathematically false as stated; no prover can close it on the current theorem statement. Primary corrective: **plan-phase structural decision** on `Hom.poleDivisor` (option a: positive-part construction; option b: theorem rename). Why: Pin 2 will remain a sorry indefinitely without this decision; the prover for iter-190 should be scoped ONLY to Pin 3 Step 2 until the plan decides.

- **Route Lane E OVER_BUDGET**: STRATEGY.md shows 3-5 iters left (entered iter-176, now iter-190 = 14 iters since directive entry, 19 iters total in current state). Revise the estimate to reflect realized velocity or escalate.

---

## Informational

**Lane A (OCofP)** — CONVERGING and the most straightforwardly healthy route. The conditional flag on the OCofP prover slot (gated on H¹ chapter readiness) is the only issue. If H¹ writes this iter, OCofP prover can target downstream sorries productively.

**Lane G (AuslanderBuchsbaum)** — CONVERGING but the 3-iter recurring Mathlib gap on `isDomain_of_regularLocal` is the one signal worth watching. The iter-190 plan must commit to one of the three closure strategies (a) project-side ~300 LOC, (b) Mathlib upstream ~50-100 LOC, or (c) Koszul bypass. If iter-190's prover produces another substrate reorganization without real progress on the gap itself, the route tips to CHURNING at iter-191.

**Lane B (Cross01Substrate)** — UNCLEAR but all positive. The Substrate 2 assignment is well-founded; the analogist recipe is documented. Expected to be a clean closer like Substrate 1.

**Lane H (RRFormula)** — the HALT was the right call. The one-iter deferral pending H¹ blueprint chapter write is appropriate. If the chapter lands in iter-190 plan phase, prover dispatch becomes valid iter-191.

---

## Overall verdict

Of 8 routes audited: **2 CONVERGING** (Lane A OCofP, Lane G AuslanderBuchsbaum); **2 CHURNING** (Lane A.3.i IdentityComponent, Lane F QuotScheme); **1 STUCK** (Lane E AbelianVarietyRigidity, also OVER_BUDGET); **3 UNCLEAR** (Lane I RationalCurveIso — structural conflict flag; Lane B Cross01Substrate — fresh; Lane H RRFormula — deliberate HALT).

Four routes require must-fix action this iter:
1. **Lane A.3.i**: stop adding helpers; dispatch mathlib-analogist on EGA IV₂ 4.5.8 / OverClass bridging before next prover round
2. **Lane F**: prover must close Step 3 axiom-clean (no new helpers); if it fails, escalate
3. **Lane E**: execute the refactor now; no more deferral — this route is 19 iters into a 3-5 iter estimate
4. **Lane I**: plan phase must decide on `Hom.poleDivisor` correction before the prover can do anything useful on Pin 2

The two CONVERGING routes (Lane A and Lane G) are healthy but carry conditional flags: Lane A's OCofP prover slot should be dropped if the H¹ blueprint chapter isn't written this plan phase; Lane G's prover must commit to a concrete closure strategy on `isDomain_of_regularLocal` rather than another substrate reorganization. Dispatch is OK (7 of 10 cap, appropriate coverage), with the OCofP conditionality noted.
