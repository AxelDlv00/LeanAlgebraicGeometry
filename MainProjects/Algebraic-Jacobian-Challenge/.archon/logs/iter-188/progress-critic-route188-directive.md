# Progress Critic Directive

## Slug
route188

## Iter
188

## Active routes / files under review

### Route: `AlgebraicJacobian/RiemannRoch/OCofP.lean` (Lane A — RR.3 O_C(P))

- **Started at iter**: 167 (active body; Lane A is the carrierSubmodule API engine)
- **Iters audited**: iter-184 to iter-187

#### Sorry counts per iter (file-level)
- iter-184: 10 (pre-refactor)
- iter-185: 10 (refactor Steps 1+2; cascade closures owed)
- iter-186: 7 (refactor closed 3 cascade sorries; HARD BAR met)
- iter-187: 4 (refactor Steps 3+4+5 land + prover closes 3 more; HARD BAR met)

#### Helpers added per iter
- iter-184: ~0 (route was STUCK)
- iter-185: 2 (`instNonemptyTopOpen`, `instAlgebraKbarFunctionField`)
- iter-186: 2 (carrierSubmodule structural; closure helpers)
- iter-187: 2 (carrierPresheaf functor; sheaf-condition decomposition)

#### Prover statuses per iter
- iter-184: PARTIAL — Tier-1 cascade attempted
- iter-185: SUCCESS (refactor) — Steps 1+2 axiom-clean
- iter-186: SUCCESS — 3 cascade sorries closed axiom-clean
- iter-187: SUCCESS — 3 more cascade sorries closed (toFunctionField + globalSections_iff_mp/mpr)

#### Prover count per iter (files dispatched on Lane A or related)
- iter-184: 1 of 1 (Lane A dispatched)
- iter-185: 1 of 1
- iter-186: 1 of 1 (refactor + prover concurrent)
- iter-187: 1 of 1 (refactor + prover concurrent)

#### Recurring blocker phrases
- "carrierSet → Submodule upgrade gated" appeared iter-181/183 — RESOLVED iter-185+ (refactor landed).

#### Route status changes per iter
- iter-184: STUCK
- iter-185: CHURNING (CHURNING corrective)
- iter-186: SUCCESS (HARD BAR met)
- iter-187: SUCCESS (HARD BAR met; CHURNING → CONVERGING transition?)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (Genus-0 RR.3 row): `~20–30`
- **Elapsed iters in current phase**: 21 (entered RR.3 at iter-167)
- **Phase started at iter**: iter-167

#### Planner's current proposal for this iter
Cascade close `carrierPresheaf_isSheaf` body via `sheafForget` bridge
(~30 LOC axiom-clean). Pre-existing `lineBundleAtClosedPoint`
cascades-down (`h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`,
`exists_nonconstant_genusZero`) gated on substrate (LES, skyscraper
cohomology). HARD BAR: ≥1 sorry close iter-188.

---

### Route: `AlgebraicJacobian/Picard/LineBundlePullback.lean` (Lane A.1.b)

- **Started at iter**: 174 (file-skeleton at iter-185)
- **Iters audited**: iter-184 to iter-187

#### Sorry counts per iter
- iter-184: 5 (file-skeleton)
- iter-185: 5
- iter-186: 0 (BEST-CASE — 5 → 0 axiom-clean on FIRST body attempt)
- iter-187: 1 (IsLocallyTrivial subtype refinement; chart-iso named sorry)

#### Helpers added per iter
- iter-184: 0
- iter-185: 0
- iter-186: 5 declarations completed axiom-clean
- iter-187: 1 (`IsLocallyTrivial` predicate + `IsLocallyTrivial.pullback` helper)

#### Prover statuses per iter
- iter-184: scheduled
- iter-185: file-skeleton landed (refactor)
- iter-186: SUCCESS — first body attempt axiom-clean
- iter-187: PARTIAL — IsLocallyTrivial subtype refinement landed; 1 named sorry

#### Prover count per iter (Lane A.1.b)
- iter-186: 1 of 1
- iter-187: 1 of 1

#### Recurring blocker phrases
None.

#### Route status changes per iter
- iter-186: SUCCESS (BEST-CASE)
- iter-187: SUCCESS-EXTENSION (refinement to IsLocallyTrivial subtype)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.1.b row): `~2–4`
- **Elapsed iters in current phase**: 2 (entered body phase at iter-186)
- **Phase started at iter**: iter-186

#### Planner's current proposal for this iter
Close `IsLocallyTrivial.pullback` chart-iso via 3-step Mathlib chain
(`restrictFunctorIsoPullback` + `pullbackComp` + `pullbackObjUnitToUnit`).
~30-50 LOC axiom-clean likely.

---

### Route: `AlgebraicJacobian/Picard/QuotScheme.lean` (Lane F)

- **Started at iter**: 184 (Step 2 baseMap targets)
- **Iters audited**: iter-184 to iter-187

#### Sorry counts per iter
- iter-184: 9
- iter-185: 9
- iter-186: 9 (Step 2 axiom-clean; Step 4 IsBaseChange Prop typed sorry)
- iter-187: 11 (analogist-licensed refactor: +2 new substantive named typed sorries)

#### Helpers added per iter
- iter-184: 1 (`pullback_app_isoTensor_unitAtV`)
- iter-185: 1 (`pullback_app_isoTensor`)
- iter-186: 1 (`pullback_app_isoTensor_baseMap_isBaseChange`)
- iter-187: 2 (`pullback_tildeIso` Stacks 01HQ + `pushforward_isQuasicoherent` Stacks 01XJ)

#### Prover statuses per iter
- iter-184: PARTIAL — helper #1 axiom-clean
- iter-185: PARTIAL — helper #2 axiom-clean
- iter-186: PARTIAL — Step 2 baseMap axiom-clean; Step 4 typed sorry
- iter-187: PARTIAL — analogist-licensed refactor; +2 named typed sorries; baseMap_isBaseChange body typed sorry retained

#### Prover count per iter
- iter-184/185/186/187: 1 of 1 each

#### Recurring blocker phrases
- "IsBaseChange Prop" appeared iter-186 + iter-187 — corrective via analogist
  (`Module.Flat.isBaseChange` dropped as category mistake; threaded
  `[IsQuasicoherent]` through 9 sigs).

#### Route status changes per iter
- iter-185: PARTIAL
- iter-186: CHURNING (per iter-187 progress-critic verdict)
- iter-187: PARTIAL (analogist-licensed — addresses CHURNING)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.2.b.iii Quot assembly row): `~36–72`
- **Elapsed iters in current phase**: 4 (entered iter-184)
- **Phase started at iter**: iter-184

#### Planner's current proposal for this iter
Stitch `pullback_tildeIso` to section-level linearEquiv via `hV.isoSpec` +
`tilde.isoTop`; close `pullback_app_isoTensor_baseMap_isBaseChange` via
the assembled IsBaseChange transport. `pullback_tildeIso` body itself
(Stacks 01HQ ~115-200 LOC) stays deferred.

---

### Route: `AlgebraicJacobian/Picard/IdentityComponent.lean` (Lane A.3 / IdentityComponent)

- **Started at iter**: 185 (NEW FILE)
- **Iters audited**: iter-185 to iter-187

#### Sorry counts per iter
- iter-185: file-skeleton (5)
- iter-186: 5 (PARTIAL — body-substance test PASS; closed-half narrow sorry)
- iter-187: 9 (2 pre-existing closed + 5 new pinned scaffolds from iter-186 Path B split)

#### Helpers added per iter
- iter-185: 0 (skeleton only)
- iter-186: 1 (`identityComponentCarrier` private helper)
- iter-187: 5 new declarations (Path B split landed Lean-side: `isSubgroupHomomorphism`, `isFiniteTypeGeometricallyIrreducible`, `baseChangeIso`, `finrank_eq_genus`, `kPoints_iff_kerDegree`) + 1 helper (`identityComponent_locallyConnectedSpace`)

#### Prover statuses per iter
- iter-185: file-skeleton
- iter-186: PARTIAL
- iter-187: PARTIAL — 2 closures + 5 new substantive scaffolds

#### Prover count per iter
- iter-186/187: 1 of 1

#### Recurring blocker phrases
- "LocallyConnectedSpace EGA I 6.1.9" iter-186 + iter-187 — Mathlib gap.

#### Route status changes per iter
- iter-186: PARTIAL
- iter-187: PARTIAL (file-skeleton extension per planner directive)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.3 row): `~16–28`
- **Elapsed iters in current phase**: 3 (entered iter-185)
- **Phase started at iter**: iter-185

#### Planner's current proposal for this iter
Close `identityComponent_locallyConnectedSpace` axiom-clean via 4-step
EGA I 6.1.9 classical argument (~80-100 LOC) to unblock both
`identityComponentCarrier` and `isOpenSubgroupScheme` closed-half.

---

### Route: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (Lane G — A.4.b)

- **Started at iter**: 174
- **Iters audited**: iter-184 to iter-187

#### Sorry counts per iter
- iter-184: 5
- iter-185: 3 (depth_eq_smallest_ext_index residuals closed)
- iter-186: 2 (R⧸(x) bridge closed)
- iter-187: 3 (G1 cotangent dim drop substrate; +1 typed sorry on spanFinrank-dim-drop)

#### Helpers added per iter
- iter-185: 2 (Tier-1 residuals)
- iter-186: 0 (closure only)
- iter-187: 2 (`toCotangent_ne_zero_of_not_mem_sq` axiom-clean + `finrank_cotangentSpace_quot_span_singleton_succ` 1 typed sorry)

#### Prover statuses per iter
- iter-185: SUCCESS
- iter-186: SUCCESS (R⧸(x) bridge axiom-clean)
- iter-187: PARTIAL — G1 substrate landed with 1 named typed sorry

#### Prover count per iter
- iter-185: 1 of 1
- iter-186: 1 of 1
- iter-187: 1 of 1

#### Recurring blocker phrases
- "Stacks 00NQ regular local ⟹ domain" iter-186 + iter-187 — committed
  to project-side formalisation (Option 2 from `analogies/isregularlocalring-isdomain.md`).

#### Route status changes per iter
- iter-186: SUCCESS
- iter-187: CHURNING corrective in progress (sub-lane G1 substrate)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.4.b row, revised iter-187): `~10–18`
- **Elapsed iters in current phase**: 14 (entered iter-174)
- **Phase started at iter**: iter-174

#### Planner's current proposal for this iter
Close `finrank_cotangentSpace_quot_span_singleton_succ` body via
spanFinrank-dim-drop equation: (≥) lift-and-cons + (≤) Nakayama-extension.
~100-150 LOC. Sub-lane G2 joint induction (~200 LOC) iter-189+.

---

### Route: `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (Lane M↓ — A.4.a)

- **Started at iter**: 177 (skeleton)
- **Iters audited**: iter-184 to iter-187

#### Sorry counts per iter
- iter-184: 4
- iter-185: 3 (Krull-dim half closed Tier-1)
- iter-186: 3 (DEFERRED — chapter blueprint never reviewed mid-iter; HARD GATE held)
- iter-187: 3 (smooth → regular gap wrapped as narrow named typed sorry `isRegularLocalRing_stalk_of_smooth`)

#### Helpers added per iter
- iter-185: 1 (`hreg_dim`)
- iter-186: 0 (deferred)
- iter-187: 1 (`isRegularLocalRing_stalk_of_smooth` — narrow Stacks 00TT wrap)

#### Prover statuses per iter
- iter-185: PARTIAL (Tier-1 axiom-clean)
- iter-186: DEFERRED
- iter-187: REFACTOR-ACCEPTABLE (per directive; net 3 → 3 but structural quality improved)

#### Prover count per iter
- iter-185: 1
- iter-186: 0 (deferred)
- iter-187: 1

#### Recurring blocker phrases
- "Stacks 00TT smooth → regular Mathlib gap" iter-184 + iter-187 — wrapped
  iter-187 as narrow named sorry; downstream consumer axiom-clean modulo gap.

#### Route status changes per iter
- iter-185: PARTIAL
- iter-186: DEFERRED
- iter-187: REFACTOR-ACCEPTABLE

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.4.a row): `~40–80`
- **Elapsed iters in current phase**: 11 (entered iter-177)
- **Phase started at iter**: iter-177

#### Planner's current proposal for this iter
Lane M↓ DEFERRED iter-188 per "strategy decision needed" — choose
between (a) wait for Mathlib upstream of Smooth → IsRegularLocalRing,
(b) project formalisation via cotangent-complex (~200-300 LOC), or
(c) keep current narrow-typed-sorry state indefinitely. Decision deferred
to plan agent for iter-189.

---

### Route: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (Lane I — RR.4)

- **Started at iter**: 183 (skeleton)
- **Iters audited**: iter-184 to iter-187

#### Sorry counts per iter
- iter-184: 3
- iter-185: 3
- iter-186: 3 (BLOCKED + CRITICAL FINDING — circular dep on `Hom.poleDivisor` body)
- iter-187: 3 (STUCK → SOLVED — `Hom.poleDivisor` substantive via [Algebra K(ℙ¹) K(C)] binder; 1 narrow named sorry on `localParameterAtInfty`)

#### Helpers added per iter
- iter-184: 0
- iter-185: 0
- iter-186: 78-LOC scaffold for `Ideal.sum_ramification_inertia` chain (inline doc)
- iter-187: 1 (`localParameterAtInfty` substrate gap helper)

#### Prover statuses per iter
- iter-184: PARTIAL
- iter-185: PARTIAL
- iter-186: BLOCKED (circular dep)
- iter-187: SUCCESS — 4-iter STUCK route BROKEN

#### Prover count per iter
- iter-184/185/186/187: 1 of 1

#### Recurring blocker phrases
- "Hom.poleDivisor body sorry def" iter-184/185/186 — RESOLVED iter-187 via
  [Algebra K(ℙ¹) K(C)] typeclass binder pattern.

#### Route status changes per iter
- iter-184/185: PARTIAL
- iter-186: BLOCKED (STUCK verdict from iter-187 critic)
- iter-187: STUCK → SOLVED

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (Genus-0 RR.4 row): `~8–12`
- **Elapsed iters in current phase**: 5 (entered iter-183)
- **Phase started at iter**: iter-183

#### Planner's current proposal for this iter
Close `localParameterAtInfty` substrate (~30-50 LOC) via 4-step recipe
(chart-1 ratio coordinate + `germToFunctionField` injection + non-zero
witness). Then attempt `Hom.poleDivisor_degree_eq_finrank` body (no
longer circularly blocked).

---

### Route: `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (Lane H — RR.2)

- **Started at iter**: 174
- **Iters audited**: iter-184 to iter-187

#### Sorry counts per iter
- iter-184: 1
- iter-185: 1
- iter-186: 2 (structural decomposition; +1 sub-helper sorry)
- iter-187: 2 (DEFERRED — chapter writer fix `rrformula-h0h1split` in flight plan-phase)

#### Helpers added per iter
- iter-184: 0
- iter-185: 0
- iter-186: 3 sub-helpers (`eulerCharacteristic_shortExact_add` + `_iso` + `_skyscraperSheaf`)
- iter-187: 0 (DEFERRED)

#### Prover statuses per iter
- iter-184/185: PARTIAL (single Tier-3 sorry)
- iter-186: PARTIAL (decomposition; 1 of 3 sub-helpers axiom-clean — `_iso`)
- iter-187: DEFERRED per HARD GATE (writer fix in flight plan-phase)

#### Prover count per iter (Lane H)
- iter-184/185/186: 1 of 1
- iter-187: 0 (deferred)

#### Recurring blocker phrases
- "LES of Ext / H¹ flasque vanishing Mathlib gap" iter-184/185/186 —
  acknowledged iter-186 as multi-iter substrate.

#### Route status changes per iter
- iter-186: CHURNING + OVER_BUDGET (per iter-187 progress-critic verdict)
- iter-187: DEFERRED for blueprint writer corrective

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (RR.2 row, revised iter-187): `~6–14`
- **Elapsed iters in current phase**: 14 (entered iter-174)
- **Phase started at iter**: iter-174

#### Planner's current proposal for this iter
Lane H prover dispatch resumes iter-188 (chapter clearance gate from
iter-188 mandatory reviewer); target H⁰ half of skyscraper-χ
(`H0_skyscraperSheaf_finrank_eq_one`, ~30-60 LOC axiom-clean via
constantSheafGammaHom chain).

---

### Route: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (Lane B — Genus-0 chart-bridge cross-case)

- **Started at iter**: 181
- **Iters audited**: iter-184 to iter-187

#### Sorry counts per iter
- iter-184: 4
- iter-185: 4
- iter-186: 4 (5-iter CHURNING confirmed; mandatory gate 4→3 MISSED)
- iter-187: 4 (DEFERRED for blueprint writer corrective)

#### Helpers added per iter
- iter-185: 1 helper
- iter-186: 1 (III.a refactor `gmScalingP1_cover_intersection_X_iso` term-mode)
- iter-187: 0 (DEFERRED)

#### Prover statuses per iter
- iter-184/185/186: PARTIAL — III.a/III.b BLOCKED on Mathlib simp coverage gap
- iter-187: DEFERRED per HARD GATE (writer fix `avr-iiic-pivot-label` in flight)

#### Prover count per iter (Lane B)
- iter-184/185/186: 1 of 1
- iter-187: 0 (deferred)

#### Recurring blocker phrases
- "Mathlib simp coverage gap on pullback.map ≫ pullbackRightPullbackFstIso.inv"
  iter-184/185/186 — empirical, HARD wall, confirmed by progress-critic
  STUCK verdict.

#### Route status changes per iter
- iter-186: STUCK + OVER_BUDGET (per iter-187 progress-critic verdict)
- iter-187: DEFERRED for blueprint writer corrective (III.c pivot)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (chart-bridge cross-case row, revised iter-187): `~3–5`
- **Elapsed iters in current phase**: 6 (entered iter-182 with sorries; 5 elapsed STUCK iters per progress-critic)
- **Phase started at iter**: iter-182

#### Planner's current proposal for this iter
Lane B prover dispatch resumes iter-188 (chapter clearance gate from
iter-188 mandatory reviewer); execute (III.c) separated-locus recipe
per writer's expanded sketch (Stacks 01KU + `IsSeparated.diagonal_isClosedImmersion`
+ `prod.lift` + `IsClosedImmersion.lift`; ~80-120 LOC).

---

### Route: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane E — AVR appTop)

- **Started at iter**: 169 (E sub-lane on appTop identity)
- **Iters audited**: iter-184 to iter-187

#### Sorry counts per iter
- iter-184: 2
- iter-185: 2
- iter-186: 2 (PARTIAL — appTop residual refined into focused identity + 6-step iter-187 closure recipe)
- iter-187: 2 (DEFERRED per HARD GATE)

#### Helpers added per iter
- iter-184: 0
- iter-185: 0
- iter-186: 1 (refined focused identity)
- iter-187: 0 (DEFERRED)

#### Prover statuses per iter
- iter-184/185: PARTIAL
- iter-186: PARTIAL — structural advance (6-step recipe inline)
- iter-187: DEFERRED per HARD GATE

#### Prover count per iter (Lane E)
- iter-184/185/186: 1 of 1
- iter-187: 0 (deferred)

#### Recurring blocker phrases
- "appTop chain telescope" iter-184/185/186 — recipe documented inline.

#### Route status changes per iter
- iter-186: PARTIAL
- iter-187: DEFERRED for chapter MF-2 fix (shared chapter with Lane B)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (no explicit AVR row; falls under "Genus-0 RR.4" or off-table sub-lane)
- **Elapsed iters in current phase**: 18 (entered iter-169)
- **Phase started at iter**: iter-169

#### Planner's current proposal for this iter
Lane E prover dispatch resumes iter-188 (chapter clearance gate);
execute 6-step appTop recipe per iter-186 progress-critic corrective.
Helper budget = 1.

---

### Route: `AlgebraicJacobian/RiemannRoch/OcOfD.lean` (Lane J — OcOfD)

- **Started at iter**: 185
- **Iters audited**: iter-185 to iter-187

#### Sorry counts per iter
- iter-185: 4 (file-skeleton)
- iter-186: 4 (NOT DISPATCHED)
- iter-187: 3 (`sheafOf_zero` BLOCKED structurally; no file edits)

#### Helpers added per iter
- iter-185: 0 (skeleton)
- iter-186: 0
- iter-187: 0

#### Prover statuses per iter
- iter-185: file-skeleton
- iter-186: not dispatched
- iter-187: BLOCKED — empirical finding: `sheafOf_zero` axiom-cleanness blocked by `else sorry` in `sheafOf` body; only off-target body work would close

#### Prover count per iter
- iter-185: 1 (file-skeleton)
- iter-186: 0
- iter-187: 1 (BLOCKED)

#### Recurring blocker phrases
- "else sorry transitive sorryAx" iter-187 — empirical finding documented.

#### Route status changes per iter
- iter-186: not dispatched (planner under-dispatch flag)
- iter-187: BLOCKED structurally (DO NOT RETRY without `sheafOf` body widening)

#### Strategy estimate vs reality
- Lane J not on critical path (Hartshorne II.6 body off-target).
- **Phase started at iter**: iter-185

#### Planner's current proposal for this iter
Lane J prover dispatch SKIPPED iter-188 per iter-187 review DO_NOT_RETRY
finding; the only viable path is `sheafOf` body work (Hartshorne II.6
subsheaf-of-`K_C` recipe, ~100-200 LOC) which the project has not
committed to. Defer to STRATEGY.md row addition or iter-200+.

## PROGRESS.md proposal (this iter)

The planner's `## Current Objectives` list it is about to commit:

- **File count**: 9 (target — see below)
- **Files**:
  1. `RiemannRoch/OCofP.lean` (Lane A cascade `carrierPresheaf_isSheaf`)
  2. `Picard/LineBundlePullback.lean` (Lane A.1.b — close `IsLocallyTrivial.pullback` chart-iso)
  3. `Picard/QuotScheme.lean` (Lane F — section-level linearEquiv assembly)
  4. `Picard/IdentityComponent.lean` (Lane IdentityComponent — `identityComponent_locallyConnectedSpace`)
  5. `RiemannRoch/RationalCurveIso.lean` (Lane I — `localParameterAtInfty`)
  6. `Albanese/AuslanderBuchsbaum.lean` (Lane G G1 — spanFinrank-dim-drop body)
  7. `RiemannRoch/RRFormula.lean` (Lane H — H⁰ half post-chapter-clearance)
  8. `Genus0BaseObjects/GmScaling.lean` (Lane B — III.c separated-locus post-chapter-clearance)
  9. `AbelianVarietyRigidity.lean` (Lane E — 6-step appTop post-chapter-clearance)

- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**:
  - `Picard/RelativeSpec.lean` (2 sorries; A.1.a STUCK; chapter PASS)
  - `Albanese/AlbaneseUP.lean` (7 sorries; A.4.d.ii body gated; chapter PASS)
  - `Picard/RelPicFunctor.lean` (6 sorries; gated on A.1.b; chapter PASS)
  - `Picard/FlatteningStratification.lean` (7 sorries; gated on A.2.a; chapter PASS)
  - `Picard/FGAPicRepresentability.lean` (7 sorries; gated on Quot+RelPic; chapter PASS)
  - `Albanese/Thm32RationalMapExtension.lean` (2 sorries; gated on `extend_of_codimOneFree_of_smooth`)
  - `RiemannRoch/WeilDivisor.lean` (2 sorries; gated on `Hom.poleDivisor`)
  - `Albanese/CodimOneExtension.lean` (3 sorries; DEFERRED per strategy decision)
  - `RigidityKbar.lean` (1 sorry; off critical path)
  - `RiemannRoch/OcOfD.lean` (3 sorries; STRUCTURALLY BLOCKED — DO NOT RETRY)
  - `Genus0BaseObjects/BareScheme.lean` (2 sorries; Mathlib gaps off-target)
  - `Jacobian.lean` (2 sorries; gated terminal)

- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
- `Cohomology/StructureSheafModuleK.lean` (re-export shim).
- `Genus0BaseObjects.lean` (re-export shim).
- `Genus0BaseObjects/{ChartIso, Points}.lean` (0 sorries, done).
- `RigidityLemma.lean`, `Rigidity.lean`, `AbelJacobi.lean`, `Genus.lean` (0 sorries, done).
- `Albanese/CoheightBridge.lean` (0 sorries, done).
