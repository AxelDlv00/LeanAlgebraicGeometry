# Progress Critic Directive

## Slug
route183

## Iter
183

## Active routes / files under review

### Route 1 — Genus-0 chart-bridge (`Genus0BaseObjects/GmScaling.lean`)

- **Started at iter**: 165 (Genus0BaseObjects scaffold)
- **Iters audited**: 179–182

#### Sorry counts per iter
- iter-179: 4
- iter-180: 4
- iter-181: 4
- iter-182: 4

#### Helpers added per iter
- iter-179: `gmScalingP1_chart_PLB_eq` reduction + refactor on cross01 (1 helper)
- iter-180: 0 (RETIRE-OR-ESCALATE corrective: 2 TEMP axioms RETIRED)
- iter-181: 0 (new named helper `cross01` exposed; diagonal + cross-by-swap axiom-clean)
- iter-182: `gmScalingP1_cover_intersection_X_iso` axiom-clean (1 helper via Mathlib `Proj.pullbackAwayιIso`)

#### Prover statuses per iter
- iter-179: PARTIAL — Step 3.1 stuck on `pullbackSpecIso_hom_base` rewrite
- iter-180: SUCCESS-via-RETIRE — `gmScalingP1_chart_PLB_eq` closed; 2 TEMP axioms RETIRED
- iter-181: PARTIAL — substantive intermediate; diagonal+cross-by-swap closed
- iter-182: PARTIAL — new axiom-clean helper landed; cocycle body gated on aggregated projection lemmas

#### Recurring blocker phrases
- "aggregated projection lemmas" / "iso composition" — iter-181, iter-182
- "Mathlib gap, build project-side" — iter-181 (WRONG diagnosis; iter-182 found Mathlib HAS the iso)

#### Strategy estimate vs reality
- **Iters left**: `~2–4` (per STRATEGY.md "Genus-0 rigidity — chart-bridge cross-case body" row)
- **Elapsed iters in current phase**: ~4 since iter-179 entered the cocycle-body sub-phase

#### Planner's current proposal for this iter
Lane B continuation: 2 named projection lemmas (`iso_inv_comp_fst`/`snd`)
~30-40 LOC each, then cocycle closure ~10 LOC. Helper budget = 2.

---

### Route 2a — Riemann–Roch RR.2 formula (`RiemannRoch/RRFormula.lean`)

- **Started at iter**: 175 (file-skeleton)
- **Iters audited**: 179–182

#### Sorry counts per iter
- iter-179: 2
- iter-180: 3 (Lane E added helpers)
- iter-181: 3
- iter-182: 3 (DEFERRED — gated on OcOfD opening; not dispatched iter-182)

#### Helpers added per iter
- iter-180: 0 inline (degree-plus-one closed); +1 helper `eulerCharacteristic_sheafOf_zero`
- iter-181: 2 substantive helpers (`eulerCharacteristic_sheafOf_zero`, `_single_add`)
- iter-182: 0 (deferred — file not dispatched per planner intent; but deferred-by-validator)

#### Prover statuses per iter
- iter-180: PARTIAL — degree-plus-one body closed; sorryAx-tainted upstream
- iter-181: PARTIAL — helpers gated on RR.3 sheafOf
- iter-182: NOT DISPATCHED (planner deferred; planValidate honored deferral)

#### Recurring blocker phrases
- "gated on RR.3 sheafOf body" / "gated on OcOfD opening" — iter-181, iter-182

#### Strategy estimate vs reality
- **Iters left**: `~8–12` per STRATEGY.md "Genus-0 RR.2" row
- **Phase started at iter**: 175

#### Planner's current proposal for this iter
Re-defer (file STILL gated on OcOfD opening; Lane K opens OcOfD this iter).
RRFormula prover lane fires iter-184 once OcOfD pins exist.

---

### Route 2b — `O_C(P)` global sections (`RiemannRoch/OCofP.lean`)

- **Started at iter**: 175 (file-skeleton)
- **Iters audited**: 179–182

#### Sorry counts per iter
- iter-179: 5
- iter-180: 5 (Lane D structural split: Iff into mp/mpr helpers)
- iter-181: 7 (refactor for `toFunctionField` signature; +2 helpers)
- iter-182: 7 (DEFERRED — Lane A planned but planValidate inverted intent)

#### Helpers added per iter
- iter-180: 2 (`globalSections_iff_mp`, `_mpr`)
- iter-181: 1 (`toFunctionField` typed sorry)
- iter-182: 0 (file NOT DISPATCHED despite Lane A planned)

#### Prover statuses per iter
- iter-180: PARTIAL — Iff split, helpers gated on lineBundleAtClosedPoint type-level
- iter-181: PARTIAL — sig refactor landed (toFunctionField pin)
- iter-182: NOT DISPATCHED (planValidate deferred)

#### Recurring blocker phrases
- "gated on toFunctionField body" — iter-181

#### Strategy estimate vs reality
- **Iters left**: `~8–12` per STRATEGY.md "Genus-0 RR.3" row
- **Phase started at iter**: 175

#### Planner's current proposal for this iter
Lane A re-dispatch (was deferred iter-182): sig amend
`lineBundleAtClosedPoint` to add `(hPcoh : Order.coheight P = 1)`;
scaffold carrier + presheaf bodies + sheaf-property typed sorry via
Hartshorne subsheaf-of-`K_C` recipe per
`analogies/ocofp-sheaf-internalhom.md`. PARTIAL acceptable. Helper budget = 5.

---

### Route 2d — Rational curve isomorphism (`RiemannRoch/RationalCurveIso.lean`)

- **Started at iter**: 175 (file-skeleton)
- **Iters audited**: 179–182

#### Sorry counts per iter
- iter-179: 2
- iter-180: 2
- iter-181: 2 (Pin 3 sig refinement landed)
- iter-182: 3 (plan-phase Pin 2 sig+poleDivisor refactor; Lane I body work DEFERRED by validator)

#### Helpers added per iter
- iter-179: 0
- iter-180: 0
- iter-181: 0 (Pin 3 sig only)
- iter-182: 1 (plan-phase `Scheme.Hom.poleDivisor` typed-sorry def)

#### Prover statuses per iter
- iter-179: PARTIAL — Pin 2 wrapper sig only
- iter-180: PARTIAL — Pin 2 wrapper sig only
- iter-181: PARTIAL — Pin 3 sig refinement only
- iter-182: NOT DISPATCHED (planValidate deferred Lane I body)

#### Recurring blocker phrases
- "sig refactor + body in same iter" — iter-181 must-fix; iter-182 attempted but body deferred

#### Strategy estimate vs reality
- **Iters left**: `~8–12` per STRATEGY.md "Genus-0 RR.4" row
- **Phase started at iter**: 175

#### Planner's current proposal for this iter
Lane I CRITICAL re-dispatch: close Pin 2 wrapper body (post-refactor)
via witness `D := Scheme.Hom.poleDivisor φ` + `rfl` on equality + named
helper sorry `poleDivisor_degree_eq_finrank`. **THIS IS THE 5TH CONSECUTIVE
ITER WITH SIG-ONLY ACTIVITY** — body MUST land or escalate per
iter-182 review must-fix.

---

### Route 3 — Abelian Variety Rigidity (`AbelianVarietyRigidity.lean`)

- **Started at iter**: 167+ (post-iotaGm decomposition)
- **Iters audited**: 179–182

#### Sorry counts per iter
- iter-179: 2
- iter-180: 2
- iter-181: 2 (named helper `iotaGm_range_isOpen` extracted)
- iter-182: 2 (new helper `iotaGm_isOpenImmersion` extracted; main body 2 LOC)

#### Helpers added per iter
- iter-180: 1 (closure refactor)
- iter-181: 1 (`iotaGm_range_isOpen` named helper)
- iter-182: 1 (`iotaGm_isOpenImmersion` strictly-stronger helper)

#### Prover statuses per iter
- iter-180: PARTIAL
- iter-181: PARTIAL — disclosure tier improved
- iter-182: PARTIAL — chart-1 sub-tasks (b)+(f) residual

#### Recurring blocker phrases
- "chart-1 factorisation chase" / "chart-1 open immersion" — iter-181, iter-182

#### Strategy estimate vs reality
- **Iters left**: (not separately rowed; falls under Route C genus-0 rigidity arm)

#### Planner's current proposal for this iter
Lane E continuation: close sub-task (b) `onePt.left` chart-1 factorisation (~30-50 LOC) + sub-task (f) chart-1 open immersion via `IsOpenImmersion.of_isLocalization` (~30-60 LOC). Helper budget = 2.

---

### Route 4a — `RelativeSpec` body (`Picard/RelativeSpec.lean`)

- **Started at iter**: 171 (placeholder body)
- **Iters audited**: 179–182

#### Sorry counts per iter
- iter-179: 2
- iter-180: 1 (Lane C closed coequifibered helper)
- iter-181: 1 (5-helper recipe identified)
- iter-182: 1 (DEFERRED — Lane D not dispatched by validator)

#### Helpers added per iter
- iter-180: 2 (axiom-clean helpers via `coequifibered_iff_forall_isLocalizationAway`)
- iter-181: 1 axiom-clean + 1 sorry helper (Iso.mk wrapper sorry-free)
- iter-182: 0 (NOT DISPATCHED)

#### Prover statuses per iter
- iter-180: SUCCESS (Lane C, 2→1)
- iter-181: PARTIAL — 5-helper hand-off
- iter-182: NOT DISPATCHED

#### Recurring blocker phrases
- "5-helper recipe pending" — iter-181, iter-182

#### Strategy estimate vs reality
- **Iters left**: `~6–10` per STRATEGY.md "A.1.a — RelativeSpec" row
- **Phase started at iter**: 171

#### Planner's current proposal for this iter
Lane D re-dispatch: close `pullback_iso_construction` body per
iter-181 5-helper recipe: hoist functor abbrev (Helper 3) + forward
via `glueMorphismsOfLocallyDirected` (Helper 4) + backward via
`colimit.desc` (Helper 5) + `Iso.mk` assembly (Helper 6) + 2 inverse-law
closures (Helpers 7-8). Helper budget = 5.

---

### Route 4d — Quot scheme pullback (`Picard/QuotScheme.lean`)

- **Started at iter**: 175 (file-skeleton)
- **Iters audited**: 179–182

#### Sorry counts per iter
- iter-179: 7
- iter-180: 8 (+1 from structural split)
- iter-181: 8 (substantive helper `_of_isAffineOpen_of_isAffineBase` added)
- iter-182: 8 (DEFERRED — Lane F PIVOT not dispatched by validator)

#### Helpers added per iter
- iter-180: 2 substantive helpers
- iter-181: 1 substantive helper
- iter-182: 0 (NOT DISPATCHED)

#### Prover statuses per iter
- iter-180: PARTIAL
- iter-181: PARTIAL — analogist iter-182 recommends PIVOT
- iter-182: NOT DISPATCHED

#### Recurring blocker phrases
- "decompose more helpers" — iter-181 (WRONG strategy per iter-182 analogist consult)

#### Strategy estimate vs reality
- **Iters left**: (rolled into A.2.b.iii Quot assembly row, "~36-72")
- **Phase started at iter**: 175

#### Planner's current proposal for this iter
Lane F PIVOT re-dispatch: add typed-sorry `Scheme.Modules.pullback_app_isoTensor`
def (LOAD-BEARING gap) + collapse iter-181 `_of_isAffineBase` helper body
through it + `Module.Flat.isBaseChange`. Helper budget = 1.

---

### Route 5c — Auslander–Buchsbaum (`Albanese/AuslanderBuchsbaum.lean`)

- **Started at iter**: 175+
- **Iters audited**: 179–182

#### Sorry counts per iter
- iter-179: 3
- iter-180: 4 (helper `length_le_ringKrullDim_of_isRegular` axiom-clean + new typed sorry)
- iter-181: 4
- iter-182: 3 (Lane G SUCCESS — `depth_of_short_exact` closed Tier-2)

#### Helpers added per iter
- iter-180: 1 axiom-clean
- iter-181: 1 named `exists_isRegular_of_regularLocal` typed sorry (analogist recommends PIVOT)
- iter-182: 2 private helpers (`ext_vanish_of_natCast_lt_depth`, `natCast_add_one_le_of_le_sub_one`)

#### Prover statuses per iter
- iter-180: PARTIAL
- iter-181: PARTIAL
- iter-182: SUCCESS Tier-2 (the sole net-closure of the iter)

#### Strategy estimate vs reality
- **Iters left**: `~12–20` per STRATEGY.md "A.4.b — Auslander–Buchsbaum import" row

#### Planner's current proposal for this iter
Lane G continuation: target `auslander_buchsbaum_formula` (L326) via
SES splitting + Stacks 090V base case, OR `depth_eq_smallest_ext_index`
(L228 — substantive inductive chase). Pick the latter per chapter
guidance. Helper budget = 2.

---

### Route 4b — `LineBundle.Pullback` (`Picard/LineBundlePullback.lean`)

- **Started at iter**: 171
- **Iters audited**: 179–182

#### Sorry counts per iter
- All 4 iters: 5 sorries unchanged

#### Helpers added per iter
- All 4 iters: 0 (file not dispatched; gated on Route 4a)

#### Prover statuses per iter
- All 4: NOT DISPATCHED (gated)

#### Strategy estimate vs reality
- **Iters left**: `~2–4` per STRATEGY.md "A.1.b" row
- **Status**: gated on A.1.a body landing

#### Planner's current proposal for this iter
Continue deferral (gated on Route 4a `pullback_iso_construction` body landing).

---

### Route NEW K — `RiemannRoch/OcOfD.lean` file-skeleton

- **Started at iter**: 183 (file does not yet exist; chapter LANDED iter-182)
- **Iters audited**: N/A (fresh route)

#### Planner's current proposal for this iter
Lane K opens the file as file-skeleton lane per iter-182 chapter
(`RiemannRoch_OcOfD.tex`). Statements + `\lean{...}` pins for
`WeilDivisor.sheafOf`, `sheafOf_zero`, `sheafOf_singlePoint`,
`sheafOf_ses_single_add`. Mechanical file-skeleton dispatch; HARD
GATE clears via this iter's mandatory blueprint-reviewer dispatch.

---

### Route NEW M — `Albanese/CoheightBridge.lean` file-skeleton

- **Started at iter**: 183 (file does not yet exist; chapter writing this iter plan-phase)
- **Iters audited**: N/A (fresh route)

#### Planner's current proposal for this iter
Lane M scaffolds new file `Albanese/CoheightBridge.lean` per
`analogies/stacks-00tt-coheight.md` recipe (~60-100 LOC). Requires
plan-phase blueprint-writer for `Albanese_CoheightBridge.tex` chapter.

---

## PROGRESS.md proposal (this iter)

The planner's `## Current Objectives` list it is about to commit:

- **File count**: 10
- **Files**:
  - `AbelianVarietyRigidity.lean` (Lane E)
  - `Albanese/AuslanderBuchsbaum.lean` (Lane G)
  - `Albanese/CoheightBridge.lean` (Lane M — NEW file)
  - `Genus0BaseObjects/GmScaling.lean` (Lane B)
  - `Picard/QuotScheme.lean` (Lane F PIVOT)
  - `Picard/RelativeSpec.lean` (Lane D)
  - `RiemannRoch/OCofP.lean` (Lane A)
  - `RiemannRoch/OcOfD.lean` (Lane K — NEW file)
  - `RiemannRoch/RationalCurveIso.lean` (Lane I — CRITICAL body close)
  - `RiemannRoch/RRFormula.lean` (Lane H follow-through — gated on K landing)

- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**:
  none identified beyond the 10 listed. (Standing deferrals: LineBundlePullback gated on 4a; RelPicFunctor + FlatteningStratification + FGAPicRepresentability + AlbaneseUP + Thm32 + CodimOneExtension all gated on multi-iter substrate.)

- **Dispatch cap (from --max-objectives)**: 10

## Out of scope

Off-limits this iter (not assessed by you):
- `AlbaneseUP.lean` body — gated iter-200+
- `CodimOneExtension.lean` body — gated on CoheightBridge (Lane M) landing + 00TT
- `Thm32RationalMapExtension.lean` body — gated on CodimOneExtension body
- `Jacobian.lean` body — gated on both genus arms
- `RigidityKbar.lean` — off critical path
- `BareScheme.lean` — Mathlib gaps (gated)
- `RelPicFunctor.lean`, `FlatteningStratification.lean`, `FGAPicRepresentability.lean` — standing deferrals
- `WeilDivisor.lean` non-constant branch — gated on RatCurveIso Pin 2 body
- `Points.lean` — DONE iter-181
