# Progress Critic Directive

## Slug

route187

## Iter

187

## Active routes / files under review

K = 4 (iter-183 through iter-186).

### Route: `AlgebraicJacobian/RiemannRoch/OCofP.lean` (Lane A — Route Genus-0 RR.3 / O_C(P) global sections)

- **Started at iter**: ~iter-168 (skeleton scaffold; substantive body work from iter-181)
- **Iters audited**: iter-183 to iter-186

#### Sorry counts per iter
- iter-183: 7
- iter-184: 7 (NOT_DISPATCHED — Anthropic weekly quota fire at session turn 1; $0 / 0 tokens / 0 edits)
- iter-185: 7
- iter-186: 7 (file rose to 10 mid-iter via refactor agent adding 3 typed sorries in `carrierSubmodule` scaffold; prover closed all 3 → returned to 7)

#### Helpers added per iter
- iter-183: 0 (NOT_DISPATCHED in iter-182; iter-183 PARTIAL)
- iter-184: 0 (NOT_DISPATCHED)
- iter-185: 1 (`carrierSet` Set helper landed; analogist dispatched `mathlib-analogist ocofp-carrierset-submodule-api` returning BUILD_PROJECT_HELPER verdict)
- iter-186: 2 new instance helpers (`instNonemptyTopOpen`, `instAlgebraKbarFunctionField`) + refactor agent landed `carrierSubmodule` (3 closure sorries since closed). 0 ad-hoc accumulation.

#### Prover statuses per iter
- iter-183: PARTIAL — carrierSet shape lands but no body progress
- iter-184: NOT_DISPATCHED (quota)
- iter-185: PARTIAL — analogist consult dispatched (verdict gates iter-186)
- iter-186: SUCCESS (3 of 3 closure sorries closed axiom-clean; 7 pre-existing sorries unchanged); refactor agent partial (Steps 1+2 of 5 landed; Steps 3-5 deferred iter-187)

#### Prover count per iter (files dispatched)
- iter-183: 1 of ~6 ready (NOT_DISPATCHED route)
- iter-184: 1 of ~6 ready (NOT_DISPATCHED quota)
- iter-185: 1 of ~9 ready (only the analogist consult, not a prover)
- iter-186: 1 of 10 ready (Lane A re-dispatched with refactor pickup)

#### Recurring blocker phrases
- "carrierSet → Submodule upgrade gated" appears in iter-181 and iter-183 reports — RESOLVED iter-185+186 via analogist + refactor.
- "lineBundleAtClosedPoint body needs sheaf-of-modules wrapper" — present iter-181+; still pending after iter-186 refactor partial (Steps 3+4+5 deferred).

#### Deferral language per iter
- iter-183: "iter-184+ on the body" — substrate gap.
- iter-185: "iter-186+ after analogist verdict" — RESOLVED.
- iter-186: "Steps 3+4+5 deferred to iter-187 (refactor re-dispatch)".

#### Route status changes per iter
- iter-183 to iter-186: active throughout; never deferred or off-critical-path.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (verbatim from Genus-0 RR.3 row, post iter-185 critic edit): "~20–30 (revised)"
- **Elapsed iters in current phase**: 19 (started iter-168; iter-186 is iter 19)
- **Phase started at iter**: iter-168

#### Planner's current proposal for this iter
Re-dispatch refactor for Steps 3+4+5 (carrierPresheaf functor + presheaf_isSheaf + replace L233+ body). Continue Lane A prover on the resulting closure sorries.

---

### Route: `AlgebraicJacobian/Picard/LineBundlePullback.lean` (Lane A.1.b)

- **Started at iter**: iter-185 (file-skeleton planted iter-174; first body attempt iter-186)
- **Iters audited**: iter-183 to iter-186

#### Sorry counts per iter
- iter-183: 5 (skeleton)
- iter-184: 5 (NOT_DISPATCHED — quota)
- iter-185: 5 (gated on A.1.a body — but iter-185 Lane D HARD-BAR SUCCESS unblocked it)
- iter-186: **0** (5 → 0, ALL closed axiom-clean on first body attempt)

#### Helpers added per iter
- iter-183 / 184 / 185: 0 (gated)
- iter-186: 0 (closures via direct Mathlib application; `@[reducible]` on `OnProduct` was the key structural insight)

#### Prover statuses per iter
- iter-183: gated
- iter-184: NOT_DISPATCHED
- iter-185: NEW lane (planning)
- iter-186: **SUCCESS** (5 → 0 closed kernel-axiom-clean on first attempt)

#### Prover count per iter (files dispatched)
- iter-185: 0 of 9 ready (lane planning only)
- iter-186: 1 of 10 ready (first body dispatch)

#### Recurring blocker phrases
- None — direct Mathlib pseudo-functoriality applications (`pullbackComp`, `pullbackCongr`, `pullback.lift_snd`).

#### Deferral language per iter
- iter-185: "iter-186+ first body attempt — gated on A.1.a body".

#### Route status changes per iter
- gated through iter-185; ACTIVATED iter-186 with SUCCESS.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.1.b row): "~2–4"
- **Elapsed iters in current phase**: 1 (iter-186)
- **Phase started at iter**: iter-186 (body work; skeleton iter-174)

#### Planner's current proposal for this iter
Open NEW Lane A.1.b follow-up: `IsInvertible` predicate wrapper around the 5 axiom-clean iter-186 declarations + tensor-quotient refinement (iter-185 review NOTE annotation flags this). ~50-100 LOC, low risk given iter-186 momentum.

---

### Route: `AlgebraicJacobian/Picard/QuotScheme.lean` (Lane F)

- **Started at iter**: ~iter-170 (skeleton); body work from iter-180+
- **Iters audited**: iter-183 to iter-186

#### Sorry counts per iter
- iter-183: 9
- iter-184: 9 (NOT_DISPATCHED — quota)
- iter-185: 9 (PIVOT directive landed Step 1 helper `pullback_app_isoTensor_unitAtV` axiom-clean; helper accumulation 1)
- iter-186: 9 (Step 2 baseMap axiom-clean + Step 4 IsBaseChange Prop factored as named typed-sorry helper; net 0 sorry change, structural decomposition advanced)

#### Helpers added per iter
- iter-183: 0
- iter-184: 0 (NOT_DISPATCHED)
- iter-185: 1 (`pullback_app_isoTensor_unitAtV`)
- iter-186: 2 (`pullback_app_isoTensor_baseMap`, `pullback_app_isoTensor_baseMap_isBaseChange`)

#### Prover statuses per iter
- iter-183: PARTIAL substantive
- iter-184: NOT_DISPATCHED
- iter-185: PARTIAL substantive
- iter-186: PARTIAL substantive (Step 2 closed; Step 4 deferred iter-187+)

#### Prover count per iter (files dispatched)
- iter-183: 1 of ~6 ready
- iter-184: 1 of ~6 ready (NOT_DISPATCHED)
- iter-185: 1 of 9 ready
- iter-186: 1 of 10 ready

#### Recurring blocker phrases
- "IsBaseChange Prop on the baseMap" — gating phrase iter-185 + iter-186.
- "Tilde-isoTop route" / "Stacks 02KE" — recurring substrate phrase iter-184+.

#### Deferral language per iter
- iter-185: "Step 4 IsBaseChange deferred iter-186"
- iter-186: "Step 4 IsBaseChange deferred iter-187+"

#### Route status changes per iter
- active throughout; never deferred.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.2.b.iii Quot assembly row): "~36–72"
- **Elapsed iters in current phase**: ~16 (iter-170 onward)
- **Phase started at iter**: iter-170

#### Planner's current proposal for this iter
Step 4 close: `pullback_app_isoTensor_baseMap_isBaseChange` body via Tilde route (with explicit `[IsQuasiCoherent N]` assumption added) OR Module.Flat.isBaseChange route. ~80-150 LOC.

---

### Route: `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (Lane H)

- **Started at iter**: ~iter-173 (chapter pinned)
- **Iters audited**: iter-183 to iter-186

#### Sorry counts per iter
- iter-183: 2
- iter-184: 2 (NOT_DISPATCHED — quota)
- iter-185: 1 (closed `finrank_H0_toModuleKSheaf_eq_one` Tier-1 axiom-clean ~50 LOC)
- iter-186: 2 (sorry +1 — Tier-3 monolithic typed-sorry decomposed into 3 sub-helpers; 1 of 3 closed axiom-clean (`eulerCharacteristic_iso`), 2 remain (`eulerCharacteristic_shortExact_add` + `eulerCharacteristic_skyscraperSheaf`))

#### Helpers added per iter
- iter-185: 0 (consumer closure)
- iter-186: 3 sub-helpers (1 closed + 2 typed-sorry); structural decomposition.

#### Prover statuses per iter
- iter-183: PARTIAL
- iter-184: NOT_DISPATCHED
- iter-185: SUCCESS + PARTIAL
- iter-186: PARTIAL substantive (decomposition into Hartshorne IV.1's 3-piece structure)

#### Prover count per iter (files dispatched)
- iter-185: 1 of 9 ready
- iter-186: 1 of 10 ready

#### Recurring blocker phrases
- "eulerCharacteristic substrate" — gating phrase from iter-183.
- "skyscraper-χ identification" / "H¹ vanishing flasque" — iter-186-NEW.

#### Deferral language per iter
- iter-185: "eulerChar helper body iter-186+"
- iter-186: "iter-187+ for skyscraper H⁰ half (~30-60 LOC axiom-clean); H¹ flasque-vanishing gated on Mathlib"

#### Route status changes per iter
- active throughout.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (Genus-0 RR.2 row): "~8–12"
- **Elapsed iters in current phase**: 13 (started iter-174)
- **Phase started at iter**: iter-174

#### Planner's current proposal for this iter
Lane H continuation: close `eulerCharacteristic_skyscraperSheaf` H⁰ half (~30-60 LOC axiom-clean) via `constantSheafGammaHom_linearEquiv` chain; H¹ vanishing wrapped as a separate flasque-cohomology gating sub-helper.

---

### Route: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (Lane I)

- **Started at iter**: ~iter-178 (Pin 2 wrapper iter-183 breakthrough)
- **Iters audited**: iter-183 to iter-186

#### Sorry counts per iter
- iter-183: 3
- iter-184: 3 (NOT_DISPATCHED — quota)
- iter-185: 3 (BLOCKED — server-side 529 outage, no directive change)
- iter-186: 3 (BLOCKED — CRITICAL FINDING surfaces iter-186 directive misread: circular dep — `Hom.poleDivisor_degree_eq_finrank` cannot close until `Hom.poleDivisor` body lands; 78-LOC scaffold added inline; 0 closures)

#### Helpers added per iter
- iter-183: Pin 2 wrapper landed
- iter-184: 0 (NOT_DISPATCHED)
- iter-185: 0 (BLOCKED 529)
- iter-186: 0 (only inline by-block scaffold commentary)

#### Prover statuses per iter
- iter-183: PARTIAL (Pin 2 breakthrough)
- iter-184: NOT_DISPATCHED
- iter-185: BLOCKED (529)
- iter-186: PARTIAL + CRITICAL (circular dep finding)

#### Prover count per iter (files dispatched)
- iter-183: 1 of ~6 ready
- iter-186: 1 of 10 ready

#### Recurring blocker phrases
- "Hom.poleDivisor body iter-187+" — iter-183, iter-185, iter-186.
- "Ideal.sum_ramification_inertia" — iter-181, iter-183, iter-185, iter-186.
- "circular dependency" — iter-186 NEW (CRITICAL surfacing).

#### Deferral language per iter
- iter-183: "iter-184+ via Ideal.sum_ramification_inertia"
- iter-185: "iter-186+ via the same"
- iter-186: "PRIMARY (rotate order): iter-187 Hom.poleDivisor body first; then helper"

#### Route status changes per iter
- active throughout.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (Genus-0 RR.4 row): "~8–12"
- **Elapsed iters in current phase**: 9 (started iter-178)
- **Phase started at iter**: iter-178

#### Planner's current proposal for this iter
**REORDER per Lane I CRITICAL**: target `Hom.poleDivisor` body L290 first (~80-150 LOC) via direct Finsupp construction over `φ⁻¹(∞)` OR Weil-divisor pullback route. After that lands, re-fire the helper scaffold.

---

### Route: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (Lane B)

- **Started at iter**: ~iter-153 (cocycle bridge work; chapter expansion + recipe iter-181+)
- **Iters audited**: iter-183 to iter-186

#### Sorry counts per iter
- iter-183: 4
- iter-184: 4 (Recipe 1 partial — 2 globally-active simp helpers landed; Recipes 2/3 quota-truncated)
- iter-185: 4 (5-iter CHURNING confirmed; mathlib-analogist `gmscaling-projection-idiom` dispatched returning Recipe 1 + 2 + 3 sub-recipes)
- iter-186: 4 (Recipe 2/3 BLOCKED on Mathlib simp coverage gap; III.a refactor landed but didn't unblock; **MANDATORY DECREMENT GATE 4→3 MISSED**)

#### Helpers added per iter
- iter-183: 0 (PARTIAL)
- iter-184: 2 (`pullback_map_fst_proj`, `pullback_map_snd_proj` — Recipe 1)
- iter-185: 0 + analogist verdict
- iter-186: 0 named-decl helpers (III.a refactor — structural; budget +2 unspent)

#### Prover statuses per iter
- iter-183 to iter-186: PARTIAL 4-of-4 iters; CHURNING confirmed iter-186.

#### Prover count per iter (files dispatched)
- iter-183 / 185 / 186: 1 each
- iter-184: 1 dispatched (quota-truncated mid-flight)

#### Recurring blocker phrases
- "pullback.map ... ≫ pullbackRightPullbackFstIso.inv adjacency not Mathlib-simp-covered" — iter-184, iter-185, iter-186.
- "cocycle's residual normal form is not Mathlib-canonical" — iter-186 NEW.
- "simp made no progress" empirical at iter-186.
- "Recipe 2/3 BLOCKED on Mathlib simp coverage gap" — iter-186 NEW.

#### Deferral language per iter
- iter-183: "iter-184 chapter rewrite + recipe"
- iter-184: "iter-185 re-fire Recipes 2/3"
- iter-185: "iter-186 mandatory pivot trigger"
- iter-186: "iter-187 path (III.b) before pivot, then (III.c) separated-locus if III.b misses"

#### Route status changes per iter
- active iter-183 through iter-186; **path-c separated-locus alternative becomes mandatory iter-187** per iter-185 STRATEGY.md Open Q failure-mode trigger.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (Genus-0 rigidity chart-bridge cross-case row): "~2–4"
- **Elapsed iters in current phase**: 5 (started iter-182 with the recipe iteration)
- **Phase started at iter**: iter-182

#### Planner's current proposal for this iter
**Failure-mode trigger fires**: iter-187 should open the genus-0 separated-locus alternative (Recipe III.c per iter-186 chapter expansion) — i.e. extend `𝔸¹ → A` via valuative criterion then a separate constancy argument; chart-bridge cross-case work pauses. Lane B prover work iter-187 dispatches with III.c directive (~80-120 LOC).

---

### Route: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (Lane G)

- **Started at iter**: ~iter-175 (skeleton iter-170+)
- **Iters audited**: iter-183 to iter-186

#### Sorry counts per iter
- iter-183: 3
- iter-184: 2 (SUCCESS: both `depth_eq_smallest_ext_index` residuals Tier-1 axiom-clean)
- iter-185: 3 (Lane G PIVOT — extracted `regularLocal_inductive_step` substrate helper with 1 inline sorry; iter-185 task_result + lean-vs-blueprint-checker pivot)
- iter-186: 2 (closed R⧸(x) bridge inline sorry → 2 named typed-sorries remain: `auslander_buchsbaum_formula` L835 + `exists_isSMulRegular_quotient_isRegularLocal_succ` L975)

#### Helpers added per iter
- iter-183: 0
- iter-184: 2 of 2 budget used (both axiom-clean)
- iter-185: 1 (`regularLocal_inductive_step` substrate helper)
- iter-186: 0 net (closures axiom-clean modulo named typed sorries)

#### Prover statuses per iter
- iter-183: PARTIAL
- iter-184: SUCCESS (HARD BAR met)
- iter-185: SUCCESS + PIVOT
- iter-186: SUCCESS (gate hit 3→2)

#### Prover count per iter (files dispatched)
- iter-183 to iter-186: 1 each.

#### Recurring blocker phrases
- "Stacks 00NQ IsDomain extraction" — iter-184, iter-185, iter-186.

#### Deferral language per iter
- iter-184: "Stacks 00NQ iter-185+"
- iter-185: "iter-186 closes R⧸(x) bridge; substrate helper iter-187+"
- iter-186: "iter-187+ work paths: Koszul-homology / Mathlib upstream / project formalisation Stacks 00NQ ~300 LOC"

#### Route status changes per iter
- active throughout.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.4.b row): "~12–20"
- **Elapsed iters in current phase**: 11 (started iter-175)
- **Phase started at iter**: iter-175

#### Planner's current proposal for this iter
Continue Lane G on `exists_isSMulRegular_quotient_isRegularLocal_succ` body (L975 sorry) via the project-side Stacks 00NQ formalisation (preferred per analogies/isregularlocalring-isdomain.md) OR Koszul-homology bypass. ~30-80 LOC.

---

### Route: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane E)

- **Started at iter**: ~iter-160 (RigidityKbar split iter-150s; consolidated chapter iter-167)
- **Iters audited**: iter-183 to iter-186

#### Sorry counts per iter
- iter-183: 3
- iter-184: 2 (SUCCESS sub-task (b) iotaGm_onePt_chart1_factor axiom-clean)
- iter-185: 2 (PARTIAL — sub-task (f) appTop residual refined into focused identity)
- iter-186: 2 (PARTIAL — appTop residual further refined into 6-step iter-187 closure recipe with focused fact `r_1.appTop(isLocElem) = 1`)

#### Helpers added per iter
- iter-183 / 185: 0
- iter-184: 0 (HARD BAR achieved with 0/0 helper budget)
- iter-186: 0 (refinement was structural)

#### Prover statuses per iter
- iter-183: PARTIAL
- iter-184: SUCCESS
- iter-185: PARTIAL (CONVERGING)
- iter-186: PARTIAL (focused identity recipe — CONVERGING refinement)

#### Prover count per iter (files dispatched)
- iter-183 to iter-186: 1 each.

#### Recurring blocker phrases
- "appTop ring-map equation residual" — iter-184, iter-185, iter-186.
- "ΓSpecIso_naturality + pullbackSpecIso telescoping" — iter-185, iter-186.

#### Deferral language per iter
- iter-185: "iter-186 close via Spec.map_appTop chain"
- iter-186: "iter-187 add helper `r_1_appTop_isLocElem_eq_one` + telescope simp chain"

#### Route status changes per iter
- active throughout.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (Genus-0 rigidity chart-bridge collapse-at-zero row): "~2–4" — note this lane targets the appTop sub-task of `iotaGm_chart1_composition_isOpenImmersion`, not collapse-at-zero directly.
- **Elapsed iters in current phase**: ~3 (intensive iter-184 to iter-186)
- **Phase started at iter**: iter-184

#### Planner's current proposal for this iter
Lane E close: add helper `r_1_appTop_isLocElem_eq_one` (~10-15 LOC: cancel_mono on Proj.awayι + IsOpenImmersion.lift_appTop chain) + telescope simp chain in `iotaGm_chart1_composition_isOpenImmersion` per the iter-186 task_result's documented 6-step recipe. Helper budget = 1.

---

### Route: `AlgebraicJacobian/Picard/IdentityComponent.lean` (NEW lane, iter-185+)

- **Started at iter**: iter-186 (file skeleton)
- **Iters audited**: iter-184 plan-phase (chapter writer dispatch) + iter-185 file-skeleton + iter-186 first body

#### Sorry counts per iter
- iter-184: file not present (chapter written this iter)
- iter-185: 5 (NEW FILE; file-skeleton landed 5 typed sorries)
- iter-186: 5 (redistributed — `IdentityComponent` body no longer carries direct sorry; substantive content in NEW private helper `identityComponentCarrier`; `isOpenSubgroupScheme` open-half closed axiom-clean; closed-half reduced to narrow Set-closedness inline sorry)

#### Helpers added per iter
- iter-185: 5 typed-sorry scaffolds + `\lean{...}` pins (path B chapter split iter-186 plan-phase introduced 4-5 new pins for declarations not yet in Lean)
- iter-186: 1 new helper (`identityComponentCarrier`)

#### Prover statuses per iter
- iter-185: PARTIAL (file-skeleton scaffold)
- iter-186: PARTIAL (body-substance test PASS for IdentityComponent; closed-immersion half PARTIAL on narrow Set-closedness sorry)

#### Prover count per iter (files dispatched)
- iter-185: 1 of 9 ready (file-skeleton)
- iter-186: 1 of 10 ready (first body)

#### Recurring blocker phrases
- "LocallyConnectedSpace X.toTopCat from IsLocallyNoetherian Mathlib gap" — iter-186 NEW.

#### Deferral language per iter
- iter-185: "first body attempt iter-186"
- iter-186: "iter-187+ for identityComponentCarrier body + closed-half + 5 new chapter pins (isSubgroupHomomorphism / isFiniteTypeGeometricallyIrreducible / baseChangeIso / Pic0Scheme.finrank_eq_genus / kPoints_iff_kerDegree)"

#### Route status changes per iter
- NEW lane iter-186; active.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.3 row): "~16–28"
- **Elapsed iters in current phase**: 2 (iter-185 + iter-186)
- **Phase started at iter**: iter-185

#### Planner's current proposal for this iter
Open NEW IdentityComponent file-skeleton extension lane for 5 new chapter pins (`isSubgroupHomomorphism`, `isFiniteTypeGeometricallyIrreducible`, `baseChangeIso`, `Pic0Scheme.finrank_eq_genus`, `Pic0Scheme.kPoints_iff_kerDegree`). Scaffold as typed sorries with substantive signatures. Helper budget = 0 (just scaffolding).

---

## PROGRESS.md proposal (this iter)

The planner's `## Current Objectives` list it is about to commit. Used for the dispatch-sanity check.

- **File count**: 9
- **Files**: `OCofP.lean` (Lane A), `LineBundlePullback.lean` (Lane A.1.b follow-up), `QuotScheme.lean` (Lane F), `RRFormula.lean` (Lane H), `RationalCurveIso.lean` (Lane I REORDERED), `GmScaling.lean` (Lane B PIVOT to path c), `AuslanderBuchsbaum.lean` (Lane G), `AbelianVarietyRigidity.lean` (Lane E), `IdentityComponent.lean` (NEW lane file-skeleton extension)
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: `CodimOneExtension.lean` (deferred pending Lane M↓ iter-187 chapter audit — see below; ready post blueprint-reviewer clearance), `OcOfD.lean` (`sheafOf_zero` body L150 from iter-185+ directive — has chapter coverage); `WeilDivisor.lean` non-constant branch (gated on Lane I body); `RelativeSpec.lean` (gated on the prior verdicts post iter-183 5-helper landing — STRATEGY says A.1.a body-level work functionally complete).
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope

- `RelPicFunctor.lean`, `FlatteningStratification.lean`, `FGAPicRepresentability.lean` — substrate-gated multi-iter substrate; not in iter-187 prover dispatch.
- `AlbaneseUP.lean`, `SymmetricPower.lean` (planned) — iter-200+.
- `Thm32RationalMapExtension.lean` — gated on CodimOneExtension body.
- `RigidityKbar.lean` — off critical path.
- `BareScheme.lean` — Mathlib gaps; iter-187+ deferred.
