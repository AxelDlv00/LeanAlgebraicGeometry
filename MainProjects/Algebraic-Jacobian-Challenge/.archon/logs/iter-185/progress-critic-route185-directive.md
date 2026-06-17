# Progress Critic Directive

## Slug
route185

## Iteration window
K = 4 (iters 181, 182, 183, 184)

## Cross-cutting context

**Iter-184 was rate-limit-truncated.** The user's Anthropic max-account weekly token quota fired during iter-184 prover dispatch. 4 of 10 lanes ran (B, E, G, M↓ produced substantive work); **6 lanes NOT_DISPATCHED at turn 1 with `total_cost_usd: 0` / `num_turns: 1` / `input_tokens: 0`** (lanes A, D, F, H, I, K). Quota resets 2026-05-28T07:00:00Z (today is 2026-05-25 — 3 days out).

For the 6 NOT_DISPATCHED lanes you must NOT count iter-184 as a "didn't progress" signal — the lane simply didn't fire, no work was attempted, no helpers were churned. For trajectory inference treat iter-184 as missing data for those lanes (look at iter-181, 182, 183 only).

## Routes / lanes the planner is considering for iter-185

Each block below: signals extracted across last K=4 iters, STRATEGY.md `Iters left` estimate, and the iter at which the route entered its current phase. The planner is considering all 10 lanes for iter-185 prover dispatch.

---

### Lane A — `RiemannRoch/OCofP.lean`

- iter-181 sorry: 7 → 7 (PARTIAL, helper added)
- iter-182 sorry: 7 → 7 (NOT_DISPATCHED by planValidate attrition)
- iter-183 sorry: 7 → 7 (PARTIAL — sig amend + carrier scaffold; 2 axiom-clean private helpers)
- iter-184 sorry: 7 → 7 (NOT_DISPATCHED — weekly limit)
- Helpers added across K=4: 3 (carrierSet, carrierSet_mono, sig amend with hPcoh)
- Recurring blocker phrases: "carrierSet → Submodule upgrade gated"; "sheaf-property pin stays typed-sorry"
- Prover statuses (4 iters): PARTIAL / NOT_DISPATCHED / PARTIAL / NOT_DISPATCHED
- STRATEGY.md `Iters left`: Genus-0 RR.3 — O_C(P) global sections, **~8-12 iters**, body gated
- Phase entry iter: ~iter-167 (RR-bridge skeleton landed)
- Iter-184 had **HARD BAR**: "close ≥1 existing body sorry this iter; new typed sorries acceptable only if unblocking a downstream closure." Was NOT_TESTED due to rate-limit.
- Iter-185 planner intent: re-dispatch with same HARD BAR.

---

### Lane B — `Genus0BaseObjects/GmScaling.lean`

- iter-181 sorry: 4 → 4
- iter-182 sorry: 4 → 4 (PARTIAL — helper landed)
- iter-183 sorry: 4 → 4 (CHURNING — 5-iter confirmed; analogist consult triggered iter-184)
- iter-184 sorry: 4 → 4 (PARTIAL — Recipe 1 axiom-clean; Recipes 2/3 truncated mid-flight by weekly limit at turn 22, $2.02)
- Helpers added across K=4: 4 (2 simp helpers Recipe 1; 2 named projection lemmas across earlier iters)
- Recurring blocker phrases: "pullback.map ≫ pullback.fst/snd not @[simp]"; iter-184 RESOLVED via `pullback_map_fst_proj` / `pullback_map_snd_proj` helpers
- Prover statuses (4 iters): PARTIAL / PARTIAL / CHURNING-confirmed / PARTIAL (truncated)
- STRATEGY.md `Iters left`: Genus-0 rigidity chart-bridge cross-case body, **~2-4 iters**
- Phase entry iter: iter-180 (current chart-bridge work)
- Iter-184 directive sorry decrement gate (4 → ≤3) NOT MET, but that was rate-limit truncation, not directive-miss.
- Iter-185 planner intent: re-fire lane to execute Recipe 2 + Recipe 3 (helpers Recipe 1 already landed iter-184).

---

### Lane D — `Picard/RelativeSpec.lean`

- iter-181 sorry: 1 → 1 (PARTIAL)
- iter-182 sorry: 1 → 1 (NOT_DISPATCHED by planValidate attrition)
- iter-183 sorry: 1 → 2 (PARTIAL — structural; bare sorry replaced by 5-helper structured proof; 3 axiom-clean + 2 narrowly-scoped Tier-3)
- iter-184 sorry: 2 → 2 (NOT_DISPATCHED — weekly limit)
- Helpers added across K=4: 5 (iter-183 5-helper proof split)
- Recurring blocker phrases: "IsAffineOpen.map_fromSpec transparency"; "per-piece factorisation via 3-iso chain (hPre + isoOpensRange + pullback_iso_affine_piece.symm)"
- Prover statuses (4 iters): PARTIAL / NOT_DISPATCHED / PARTIAL-structural / NOT_DISPATCHED
- STRATEGY.md `Iters left`: A.1.a — **~3-6 iters** (revised iter-184 from ~6-10 per OVER_BUDGET finding; original estimate set iter-170 → 14 elapsed)
- Phase entry iter: iter-170
- Iter-184 had **HARD BAR**: "close BOTH Tier-3 helpers; failure to close both = iter-185 structural refactor / blueprint expansion escalation." Was NOT_TESTED due to rate-limit.
- Iter-185 planner intent: re-dispatch with same HARD BAR. Do NOT escalate 15-iter trigger from iter-184 NOT_DISPATCHED — rate-limit, not churning.

---

### Lane E — `AbelianVarietyRigidity.lean`

- iter-181 sorry: 1 → 1 (axiom-clean closure for `morphism_P1_to_AV_constant`)
- iter-182 sorry: 1 → 2 (PARTIAL — anomalous Thm32 bonus; new helper)
- iter-183 sorry: 2 → 3 (PARTIAL — structural; `iotaGm_isOpenImmersion` parent body sorry-FREE; 2 new Tier-3 sub-task helpers + 2 axiom-clean aux)
- iter-184 sorry: 3 → 2 (**SUCCESS** — sub-task (b) `iotaGm_onePt_chart1_factor` closed Tier-1 axiom-clean, 13 LOC body, helper budget 0/0)
- Helpers added across K=4: 4
- Recurring blocker phrases: "decomposition cadence" (resolved iter-184 via HARD BAR drop sub-task (f))
- Prover statuses (4 iters): SUCCESS / PARTIAL / PARTIAL-structural / **SUCCESS** (HARD BAR met)
- STRATEGY.md `Iters left`: consolidated chapter; AVR Route C foundation, ~3-5 iters until rigidity arm closes (rest gated on RR-bridge for genus-0 ⟹ ℙ¹)
- Phase entry iter: iter-179 (decomposition into sub-tasks)
- Iter-185 planner intent: pick up sub-task (f) `iotaGm_chart1_composition_isOpenImmersion` (iter-184 explicitly dropped per HARD BAR; iter-185 is the right iter to resume).

---

### Lane F — `Picard/QuotScheme.lean`

- iter-181 sorry: 8 → 8 (PARTIAL)
- iter-182 sorry: 8 → 8 (NOT_DISPATCHED by planValidate attrition)
- iter-183 sorry: 8 → 9 (PARTIAL-PIVOT — new load-bearing typed-sorry def `Scheme.Modules.pullback_app_isoTensor`; consumer body restructured)
- iter-184 sorry: 9 → 9 (NOT_DISPATCHED — weekly limit)
- Helpers added across K=4: 1 (the load-bearing typed-sorry def iter-183)
- Recurring blocker phrases: "abstract internal-Hom route NEEDS_MATHLIB_GAP_FILL"; iter-181 analogist pivot directive: BUILD_PROJECT_HELPER for `pullback_app_isoTensor`
- Prover statuses (4 iters): PARTIAL / NOT_DISPATCHED / PARTIAL-PIVOT / NOT_DISPATCHED
- STRATEGY.md `Iters left`: A.2.b.iii Quot assembly — **~36-72 iters**, body gated
- Phase entry iter: ~iter-178
- Iter-184 directive was: "start `pullback_app_isoTensor` BODY via Tilde-isoTop route (Stacks 01HQ/01I8). Acceptable: ≥1 substantive step closes." UNCLEAR / one more iter without body substance → CHURNING (per iter-184 progress-critic).
- Iter-185 planner intent: re-dispatch with same directive. Iter-185 would be the 2nd-iter-without-body-substance trigger.

---

### Lane G — `Albanese/AuslanderBuchsbaum.lean`

- iter-181 sorry: 4 → 4 (PARTIAL)
- iter-182 sorry: 4 → 3 (**SUCCESS — Tier-2** — LES of Ext via 3-branch case split + ENat tsub bridge + 2 private helpers; sole net closure of iter-182)
- iter-183 sorry: 3 → 3 (PARTIAL-restructured — 1 NEW Tier-1 axiom-clean helper; base case + 2 backward steps kernel-clean; 2 named residual sorries)
- iter-184 sorry: 3 → 2 (**SUCCESS** — both residuals on `depth_eq_smallest_ext_index` inductive step closed Tier-1 axiom-clean; helper budget 0/2 — PRIMARY HARD BAR met)
- Helpers added across K=4: 3 (`ext_smul_eq_zero_of_mem_annihilator` iter-183; existing helpers reused iter-184)
- Recurring blocker phrases: "LES chase"; "Nakayama"; (these are productive recipes, not stuck signals)
- Prover statuses (4 iters): PARTIAL / SUCCESS-Tier2 / PARTIAL-restructured / **SUCCESS** (HARD BAR met)
- STRATEGY.md `Iters left`: A.4.b — **~12-20 iters**, body gated
- Phase entry iter: iter-180 (active work)
- Iter-184 task_result: **AB formula NOT attempted** this iter — gap analysis shows it needs minimal-finite-free-resolutions + Stacks 00MF + snake-lemma + depth-drops-by-one (4 substrate gaps, 4-8 iters), NOT the "30-60 LOC" the iter-184 planner estimated.
- Iter-184 task_result + lean-vs-blueprint-checker iter184-auslander: A.4.a's downstream `CohenMacaulay.of_regular` consumer does NOT actually use `auslander_buchsbaum_formula` directly — it uses regular-sequence-length-equals-Krull-dim. Recommend **pivot Lane G to `exists_isRegular_of_regularLocal`** (Stacks 00NQ, the actual CM consumer blocker).
- Iter-185 planner intent: pivot Lane G to `exists_isRegular_of_regularLocal` per iter-184 recommendation.

---

### Lane H — `RiemannRoch/RRFormula.lean`

- iter-181 sorry: 3 → 3 (PARTIAL)
- iter-182 sorry: 3 → 3 (NOT_DISPATCHED by planValidate attrition)
- iter-183 sorry: 3 → 2 (PARTIAL + net **−1** — duplicate `sheafOf` retired via OcOfD re-export; 2 induction step bodies closed; 2 new Tier-3 helpers)
- iter-184 sorry: 2 → 2 (NOT_DISPATCHED — weekly limit)
- Helpers added across K=4: 2 (iter-183 Tier-3: `finrank_H0_toModuleKSheaf_eq_one`, `eulerCharacteristic_sheafOf_succ`)
- Recurring blocker phrases: "Cohomology_StructureSheafModuleK H⁰-bridge"; "OcOfD.sheafOf_ses_single_add SES + χ-additivity"
- Prover statuses (4 iters): PARTIAL / NOT_DISPATCHED / PARTIAL+net−1 / NOT_DISPATCHED
- STRATEGY.md `Iters left`: Genus-0 RR.2 — **~8-12 iters**, body gated
- Phase entry iter: ~iter-175
- Iter-184 directive: close 2 Tier-3 helpers via the named recipes. UNCLEAR / NOT_TESTED.
- Iter-185 planner intent: re-dispatch with same directive.

---

### Lane I — `RiemannRoch/RationalCurveIso.lean`

- iter-181 sorry: 4 → 3 (PARTIAL — Pin 2 sig-only iter; net −1 closure)
- iter-182 sorry: 3 → 3 (PARTIAL — Pin 2 sig refactor landed but BODY deferred — 4 consecutive sig-only iters by then)
- iter-183 sorry: 3 → 3 (**SUCCESS — STREAK BROKEN** — Pin 2 wrapper body sorry-free; 5-consec-sig-only-iter streak broken; new Tier-3 helper `Hom.poleDivisor_degree_eq_finrank`)
- iter-184 sorry: 3 → 3 (NOT_DISPATCHED — weekly limit)
- Helpers added across K=4: 4 (Pin 2 wrapper, poleDivisor def, `poleDivisor_degree_eq_finrank`, plus aux)
- Recurring blocker phrases: (the sig-only streak was resolved iter-183)
- Prover statuses (4 iters): PARTIAL / PARTIAL-sig-only / **SUCCESS-streak-broken** / NOT_DISPATCHED
- STRATEGY.md `Iters left`: Genus-0 RR.4 — **~8-12 iters**, body gated
- Phase entry iter: ~iter-176
- Iter-184 directive: close `poleDivisor_degree_eq_finrank` body via `Ideal.sum_ramification_inertia` (~80-150 LOC; analogy file `analogies/ratcurveiso-pin2.md` Decision 2). UNCLEAR / NOT_TESTED.
- **DO NOT escalate Route 2d** — iter-183 breakthrough is intact; iter-184 was rate-limit-truncated.
- Iter-185 planner intent: re-dispatch with same directive.

---

### Lane K — `RiemannRoch/OcOfD.lean`

- iter-181 sorry: file did not exist
- iter-182 sorry: file did not exist
- iter-183 sorry: 0 → 4 (NEW FILE — file-skeleton landed; 4 chapter-pinned declarations as Tier-3 typed sorries)
- iter-184 sorry: 4 → 4 (NOT_DISPATCHED — weekly limit)
- Helpers added across K=4: 4 (the file-skeleton itself)
- Recurring blocker phrases: (fresh route, no recurring blockers)
- Prover statuses (4 iters): n/a / n/a / NEW-FILE / NOT_DISPATCHED
- STRATEGY.md `Iters left`: bundled into Genus-0 RR.2 — **~8-12 iters**
- Phase entry iter: iter-183 (the file was just created)
- Iter-184 directive: attempt `sheafOf_zero` body (~30-60 LOC; rewrite to `toModuleKSheaf` via structure-sheaf iso). UNCLEAR / NOT_TESTED.
- Iter-185 planner intent: re-dispatch with same directive.

---

### Lane M↓ — `Albanese/CodimOneExtension.lean`

- iter-181 sorry: 3 → 3
- iter-182 sorry: 3 → 3 (NO-EDIT — deferral respected; honest Mathlib-gap search log)
- iter-183 sorry: 3 → 3 (NO-EDIT — gated on iter-184 CoheightBridge landing)
- iter-184 sorry: 3 → 3 (PARTIAL — directive-expected structural; Krull-dim half closed Tier-1 axiom-clean via iter-183 CoheightBridge import; `IsRegularLocalRing` half remains as Stacks 00TT gap typed sorry)
- Helpers added across K=4: 0 (the iter-184 work used iter-183 CoheightBridge bridge in-place)
- Recurring blocker phrases: "Stacks 00TT gap" — the `IsRegularLocalRing` half is genuinely an unowned Mathlib gap; needs blueprint expansion (per lean-vs-blueprint-checker iter184-codimone)
- Prover statuses (4 iters): n/a / NO-EDIT / NO-EDIT / PARTIAL-directive-expected
- STRATEGY.md `Iters left`: A.4.a — **~40-80 iters**, body gated
- Phase entry iter: ~iter-178 (skeleton landed)
- Iter-184 directive: structural split of `hreg_dim` conjunction. ACCEPTED outcome — Lane M↓ acceptance criterion MET.
- Iter-185 planner intent: candidate to defer this iter (the `IsRegularLocalRing` half needs blueprint expansion first, per iter-184 lean-vs-blueprint-checker `iter184-codimone`).

---

### NEW Lane (IdentityComponent file-skeleton) — `Picard/IdentityComponent.lean`

- File does not yet exist on disk
- Blueprint chapter `Picard_IdentityComponent.tex` LANDED iter-184 plan-phase (writer dispatch `pic0-identity-component-chapter`; 561 lines, 5 declarations + 4 proof blocks). Wired into `content.tex`.
- Blueprint-doctor flagged "covers missing file" iter-184 — deliberate; iter-185 mandatory blueprint-reviewer audits the chapter, and on HARD GATE clearance a file-skeleton prover lane can ship the bare declarations.
- STRATEGY.md `Iters left`: A.3 — **~16-28 iters**, substrate `GroupScheme.IdentityComponent` UNOWNED in Mathlib
- Phase entry iter: A.3 is currently UNSTARTED in code (blueprint just landed iter-184)
- This is a fresh route; the planner has no signals to read. Treat as UNCLEAR.

---

## Iter-185 planner's `## Current Objectives` proposal

The plan agent is leaning toward dispatching ≤10 lanes:

1. `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane E — pick up sub-task (f), iter-184 explicitly dropped)
2. `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (Lane G — pivot to `exists_isRegular_of_regularLocal`)
3. `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (Lane B — Recipe 2 + Recipe 3, helpers from iter-184)
4. `AlgebraicJacobian/Picard/IdentityComponent.lean` (NEW — file-skeleton lane, gated on blueprint-reviewer iter-185 HARD GATE clearance)
5. `AlgebraicJacobian/Picard/QuotScheme.lean` (Lane F — re-dispatch iter-184 directive)
6. `AlgebraicJacobian/Picard/RelativeSpec.lean` (Lane D — re-dispatch iter-184 HARD BAR)
7. `AlgebraicJacobian/RiemannRoch/OCofP.lean` (Lane A — re-dispatch iter-184 HARD BAR)
8. `AlgebraicJacobian/RiemannRoch/OcOfD.lean` (Lane K — re-dispatch iter-184 directive)
9. `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (Lane H — re-dispatch iter-184 directive)
10. `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (Lane I — re-dispatch iter-184 directive)

**Lane M↓ (CodimOneExtension) deferred** for iter-185 pending blueprint expansion of `Albanese_CodimOneExtension.tex` to spell out Stacks 00TT for the `IsRegularLocalRing` half.

Please return CONVERGING / CHURNING / STUCK / UNCLEAR per route + dispatch-sanity check on the 10-lane list + any must-fix corrective recommendations. Pay particular attention to:

- whether the iter-184 NOT_DISPATCHED outcomes (lanes A, D, F, H, I, K) should be treated as missing data or as continuing the prior trajectory;
- whether Lane B's iter-184 RESOLVED-then-TRUNCATED outcome counts as breaking the 5-iter CHURNING (Recipe 1 axiom-clean landed but Recipes 2/3 didn't run);
- whether Lane G's pivot from AB-formula to `exists_isRegular_of_regularLocal` is the right corrective (per iter-184 task_result + checker);
- whether deferring Lane M↓ to await blueprint expansion is the right call this iter.

Report at `.archon/task_results/progress-critic-route185.md`.
