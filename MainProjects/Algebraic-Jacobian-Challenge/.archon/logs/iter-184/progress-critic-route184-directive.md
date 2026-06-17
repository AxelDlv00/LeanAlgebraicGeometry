# progress-critic — route184

## Iter

184 (planner is now composing the iter-184 prover lane set; iter-183 has just closed).

## Active routes — the planner's proposed iter-184 active lane set

For each route below: K=4 (iters 180/181/182/183) of trajectory signals
and the planner's iter-184 proposal. Lift `Iters left` and `entered`
verbatim from `STRATEGY.md` `## Phases & estimations`.

---

### Route 1 — Genus-0 chart-bridge cross-case (Lane B)

- **File**: `Genus0BaseObjects/GmScaling.lean`
- **STRATEGY row** (`Genus-0 rigidity — chart-bridge cross-case body`):
  Iters left ~2–4; phase entered iter-180.
- **K=4 signals**:
  - iter-180: 6 → 4 sorries; 4 axiom-clean helpers landed via
    `respectTransparency` recipe; diagonal closed.
  - iter-181: 4 → 4; PARTIAL (substantive helper `cross01`).
  - iter-182: 4 → 4; PARTIAL (axiom-clean helper
    `gmScalingP1_cover_intersection_X_iso` via `Proj.pullbackAwayιIso`).
  - iter-183: 4 → 4; PARTIAL — **5-iter CHURNING confirmed**; 5 attempts
    failed (Recipe 2 verbatim, aesop_cat, cancel_mono, IsOpenImmersion.lift_uniq,
    2 named typed-sorry projection lemmas reverted as Classical.choice
    body). Blocker: `inv (pullback.map ...) ≫ pullback.fst` collapse
    after `Iso.trans_inv` doesn't unify with Mathlib's `pullbackRightPullbackFstIso_inv_fst`
    naming. Recipe failure mode documented in detail; iter-184
    mathlib-idiom consult Q1/Q2/Q3 mandated.
- **iter-184 planner proposal**: re-fire Lane B AFTER `mathlib-analogist`
  consult (`gmscaling-projection-idiom`) returns with verdict on the 3 Qs
  in iter-183 task_result. NOT re-fired without consult.

---

### Route 2a — Genus-0 RR.2 (Lane H)

- **File**: `RiemannRoch/RRFormula.lean`
- **STRATEGY row** (`Genus-0 RR.2 — RR formula for genus 0`):
  Iters left ~8–12; phase entered iter-178.
- **K=4 signals**:
  - iter-180: opened the file; ~3 sorries.
  - iter-181: 2 → 3 (decomposition into 2 substantive helpers, gated on RR.3 sheafOf).
  - iter-182: NOT_DISPATCHED (planValidate attrition).
  - iter-183: 3 → 2 (−1; duplicate `sheafOf` retired via OcOfD re-export;
    2 induction step bodies closed; 2 new Tier-3 helpers
    `finrank_H0_toModuleKSheaf_eq_one`, `eulerCharacteristic_sheafOf_succ`).
- **iter-184 planner proposal**: continue Lane H — close the 2 new
  Tier-3 helpers via `Cohomology_StructureSheafModuleK` H⁰ bridge +
  `CategoryTheory.ShortExact.eulerChar_additive` (Mathlib gap or
  project-helper).

---

### Route 2b — Genus-0 RR.3 (Lane A)

- **File**: `RiemannRoch/OCofP.lean`
- **STRATEGY row** (`Genus-0 RR.3 — O_C(P) global sections`):
  Iters left ~8–12; phase entered iter-179.
- **K=4 signals**:
  - iter-180: 7 sorries.
  - iter-181: 7 → 7 PARTIAL (refactor `OCofP.globalSections_iff` sig fix).
  - iter-182: NOT_DISPATCHED (planValidate attrition).
  - iter-183: 7 → 7 PARTIAL — sig amend landed (`hPcoh : Order.coheight P = 1`
    on `lineBundleAtClosedPoint` + `toFunctionField` + 6-consumer ripple);
    `carrierSet` axiom-clean Hartshorne subsheaf-of-`K_C` Set-valued
    scaffold landed; `carrierSet_mono` axiom-clean.
- **iter-184 planner proposal**: continue Lane A — upgrade `carrierSet`
  to `Submodule` + scaffold presheaf assembly + sheaf-property typed
  sorry. Budget cap from iter-183 (≤ 7) drove deferral of upgrade;
  iter-184 can spend 2-3 new sorries on the upgrade.

---

### Route 2d — Genus-0 RR.4 rational ⟹ ℙ¹ (Lane I)

- **File**: `RiemannRoch/RationalCurveIso.lean`
- **STRATEGY row** (`Genus-0 RR.4 — rational ⟹ ≅ ℙ¹`):
  Iters left ~8–12; phase entered iter-176.
- **K=4 signals**:
  - iter-180: Pin 2 sig refactor (sig only, no body).
  - iter-181: Pin 2/Pin 3 analogist consults PROCEED (sig only).
  - iter-182: Pin 2 sig+body combined NOT achieved — body part
    NOT_DISPATCHED (planValidate attrition); only sig refactored.
  - iter-183: 3 → 3 CRITICAL — **Pin 2 wrapper body LANDED** via
    witness `D := Scheme.Hom.poleDivisor φ` + `rfl` + named Tier-3
    helper `poleDivisor_degree_eq_finrank`. 5th-consec-sig-only-iter
    streak BROKEN.
- **iter-184 planner proposal**: continue Lane I — close
  `poleDivisor_degree_eq_finrank` helper body (~80–150 LOC via
  `Ideal.sum_ramification_inertia` per
  `analogies/ratcurveiso-pin2.md` Decision 2). Pin 3 body separately
  iter-185+ via `instIsIsoToNormalizationOfIsIntegralHom`.

---

### Route 3 — Genus-0 AVR continuation (Lane E)

- **File**: `AbelianVarietyRigidity.lean`
- **STRATEGY row** (`Genus-0 rigidity — chart-bridge ...`): Iters left ~2–4
  (this row covers the cross-case body; Lane E is the AVR-side
  consumer in `iotaGm_isOpenImmersion`).
- **K=4 signals**:
  - iter-180: 2 sorries.
  - iter-181: 2 → 2 PARTIAL (introduced `iotaGm_range_isOpen` helper).
  - iter-182: 2 → 2 PARTIAL strictly-stronger refactor;
    `iotaGm_isOpenImmersion` axiom-clean helper landed.
  - iter-183: 2 → 3 (+1) PARTIAL structural — parent body sorry-FREE;
    2 new Tier-3 sub-task helpers `iotaGm_onePt_chart1_factor` (b) +
    `iotaGm_chart1_composition_isOpenImmersion` (f); 2 axiom-clean
    aux helpers (`iotaGm_inner_lift_compat`, `iotaGm_chart1_section`).
- **iter-184 planner proposal**: continue Lane E — close sub-task (b)
  range containment (~10–15 LOC `IsOpenImmersion.lift_fac` reduction
  per iter-183 task_result iter-184+ closure path) and start sub-task
  (f) `IsOpenImmersion.of_isLocalization`.

---

### Route 4a — RelativeSpec (Lane D)

- **File**: `Picard/RelativeSpec.lean`
- **STRATEGY row** (`A.1.a — RelativeSpec`): Iters left ~6–10; phase
  entered iter-170 (placeholder body).
- **K=4 signals**:
  - iter-180: 1 sorry (bare on `pullback_iso_construction`).
  - iter-181: 1 → 1; PARTIAL structural (5-helper recipe outlined).
  - iter-182: NOT_DISPATCHED (planValidate attrition).
  - iter-183: 1 → 2 (+1) PARTIAL — bare sorry replaced by 5-helper
    structured proof; 3 axiom-clean (`pullback_iso_affine_piece`,
    `pullback_cocone_desc_comp_fst`, `pullback_iso_desc_isIso` iSup
    branch); 2 narrowly-scoped Tier-3 (`pullback_cocone` naturality,
    `pullback_iso_desc_isIso` per-piece factorisation).
- **iter-184 planner proposal**: continue Lane D — close the 2 Tier-3
  helpers (`pullback_cocone` naturality via
  `IsAffineOpen.map_fromSpec` + transparency unfolds; per-piece IsIso
  via the explicit 3-iso factorisation outlined in iter-183
  task_result).

---

### Route 4b — LineBundlePullback (NOT in iter-184 active set)

- **File**: `Picard/LineBundlePullback.lean`
- **STRATEGY row** (`A.1.b — LineBundle.Pullback`): Iters left ~2–4;
  gated on A.1.a body landing.
- **K=4 signals**: not dispatched iters 180-183 (gated on Lane D).
- **iter-184 planner proposal**: NOT included (Lane D still partial; gate
  not lifted).

---

### Route 4d — QuotScheme PIVOT (Lane F)

- **File**: `Picard/QuotScheme.lean`
- **STRATEGY row** (`A.2.b.iii — Quot assembly`): Iters left ~36–72;
  gated on A.2.b.i + ii + A.2.a.
- **K=4 signals**:
  - iter-180: 7 sorries.
  - iter-181: 7 → 8 (decomposition attempt; iter-182 analogist
    consult declared it WRONG strategy).
  - iter-182: NOT_DISPATCHED (planValidate attrition).
  - iter-183: 8 → 9 (+1, expected per directive) PARTIAL PIVOT —
    new load-bearing typed-sorry def `Scheme.Modules.pullback_app_isoTensor`;
    consumer `_of_isAffineBase` body structured but inline-sorry
    remains for Beck–Chevalley compatibility step.
- **iter-184 planner proposal**: continue Lane F — start
  `pullback_app_isoTensor` body via `Tilde.isoTop` route
  (~120–200 LOC iter-184+); the consumer's BC-compatibility inline
  sorry can close once the helper has substance.

---

### Route 5 — Genus-0 RR.1 / WeilDivisor (NOT in active set iter-184)

- **File**: `RiemannRoch/WeilDivisor.lean`
- **K=4 signals**: 2 sorries; deferred iters 180-183 (gated on Lane I body).
- **iter-184 planner proposal**: NOT included (Lane I helper body
  iter-184 work; WeilDivisor non-constant branch follows iter-185+).

---

### Route 5c — AuslanderBuchsbaum (Lane G)

- **File**: `Albanese/AuslanderBuchsbaum.lean`
- **STRATEGY row** (`A.4.b — Auslander–Buchsbaum import`): Iters left
  ~12–20; phase entered iter-177.
- **K=4 signals**:
  - iter-180: 4 sorries.
  - iter-181: 4 → 4 (refactor; helpers added).
  - iter-182: 4 → 3 (−1 SUCCESS Tier-2) — `depth_of_short_exact`
    closed via LES-of-Ext 3-branch case split.
  - iter-183: 3 → 3 restructured — 1 NEW Tier-1 axiom-clean helper
    (`ext_smul_eq_zero_of_mem_annihilator`); base case + 2 backward
    steps closed kernel-clean on `depth_eq_smallest_ext_index`; 2
    named residual sorries on inductive-step branches.
- **iter-184 planner proposal**: continue Lane G — close the 2
  remaining named residuals on `depth_eq_smallest_ext_index` inductive
  step, then attempt `auslander_buchsbaum_formula` (the headline
  theorem of the file).

---

### Lane K — OcOfD bodies (NEW)

- **File**: `RiemannRoch/OcOfD.lean`
- **K=4 signals**: file created iter-183 with 4 Tier-3 typed sorries
  (sheafOf, sheafOf_zero, sheafOf_singlePoint, sheafOf_ses_single_add).
- **iter-184 planner proposal**: try to close `sheafOf_zero` and
  `sheafOf_singlePoint` bodies (the latter via the new
  `lineBundleAtClosedPoint` connection; the former gated on `sheafOf`
  body which is iter-185+).

---

### Lane M downstream — CoheightBridge consumer in CodimOneExtension

- **File**: `Albanese/CodimOneExtension.lean`
- **STRATEGY row** (`A.4.a — Lemma 3.3 ...`): Iters left ~40–80;
  but Lane M downstream is a NARROW consumer task: close the
  `hreg_dim` Krull-dim half via the new
  `ringKrullDimLE_of_coheight_eq_one` instance from iter-183 Lane M
  (CoheightBridge.lean axiom-clean).
- **K=4 signals**:
  - iter-180/181/182: standing deferral.
  - iter-183: NOT in active set; CoheightBridge.lean landed instead
    (4/4 axiom-clean).
- **iter-184 planner proposal**: NEW lane — narrow consumer task
  reducing `hreg_dim` from 2-part conjunction to just the
  `IsRegularLocalRing` half (the Krull-dim half closes via the new
  instance). Targeted ~20-40 LOC iter-184.

---

## Planner's iter-184 PROGRESS.md Current Objectives proposal (10 files at cap)

1. `Genus0BaseObjects/GmScaling.lean` (Lane B — re-fire post-analogist)
2. `AbelianVarietyRigidity.lean` (Lane E — sub-task (b) range
   containment + start (f))
3. `Albanese/AuslanderBuchsbaum.lean` (Lane G — close residual + start
   `auslander_buchsbaum_formula`)
4. `Albanese/CodimOneExtension.lean` (Lane M downstream — `hreg_dim`
   Krull-dim half via new CoheightBridge instance)
5. `Picard/RelativeSpec.lean` (Lane D — close 2 Tier-3 helpers)
6. `Picard/QuotScheme.lean` (Lane F — start
   `pullback_app_isoTensor` body)
7. `RiemannRoch/OCofP.lean` (Lane A — `carrierSet → Submodule` upgrade
   + presheaf assembly)
8. `RiemannRoch/OcOfD.lean` (Lane K bodies — `sheafOf_zero` +
   `sheafOf_singlePoint`)
9. `RiemannRoch/RRFormula.lean` (Lane H — close 2 new Tier-3 helpers)
10. `RiemannRoch/RationalCurveIso.lean` (Lane I — close
    `poleDivisor_degree_eq_finrank` helper body)

## Note for the critic

This is the planner's PROPOSAL. Lane B is contingent on
`mathlib-analogist gmscaling-projection-idiom` returning a usable
recipe; if the consult fails to produce concrete Q1/Q2/Q3 answers,
the planner will demote Lane B (NOT re-fire) and use the freed slot
for a deferred lane (BareScheme.lean is the most-likely-substituted
candidate). Surface dispatch-sanity concerns under
`## Dispatch sanity` and verdicts as you usually would.
