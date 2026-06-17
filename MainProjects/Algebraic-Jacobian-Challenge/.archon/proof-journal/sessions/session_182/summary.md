# Session 182 — Summary (iter-182)

## Metadata

- **Session**: 182 (= iter-182)
- **Stage**: prover
- **Build at close**: `lake build AlgebraicJacobian` GREEN — 8355/8355 jobs, 0 errors, **75 sorry warnings**, **0 project axioms**
- **Sorry trajectory**: 76 entering → **75 exiting** (−1 net by declaration)
- **Axioms**: 0 → 0 (zero-axiom build retained for the 3rd consecutive iter)
- **Dispatched lanes**: **10** (meta.json) — 5 productive, 5 honest no-ops
- **Files edited**: 5 (AVR, GmScaling, AuslanderBuchsbaum, AlbaneseUP, Thm32)
- **Edits per file** (from `attempts_raw.jsonl`): AuslanderBuchsbaum 11, GmScaling 4, AVR 2, AlbaneseUP 2, Thm32 1

## CRITICAL — Dispatch divergence from plan

The planner's iter-182 plan named **7 active prover lanes** (A B D E F G I = OCofP, GmScaling, RelativeSpec, AVR, QuotScheme, AuslanderBuchsbaum, RatCurveIso). The `planValidate` step instead **dispatched 10 lanes (objectivesProposed=20, objectivesDispatched=10, objectivesDeferred=10)** with the following divergence:

- **PLANNED → DISPATCHED (3/7)**: GmScaling ✓, AVR ✓, AuslanderBuchsbaum ✓
- **PLANNED → DEFERRED (4/7)**: OCofP, RelativeSpec, QuotScheme, RatCurveIso — **all four were the planner's recipe-armed substantive-work targets** (Lane A's Hartshorne sheaf recipe, Lane D's 5-helper iter-181 hand-off, Lane F's PIVOT typed-sorry def, Lane I's combined-iter Pin 2 body — the iter-182 must-fix from the progress-critic Route 2d 3-iter avoidance trigger)
- **DISPATCHED but PROGRESS.md `## Off-limits` (7/10)**: AlbaneseUP, CodimOneExtension, Thm32, BareScheme, Points, Jacobian, FGAPicRepresentability — 5 returned correct NO-EDIT; 2 (AlbaneseUP, Thm32) returned anomalous structural advances

**The dispatch reordering inverted planner intent**: the harness deferred the 4 lanes carrying iter-182's recipe-armed body work and dispatched 7 explicitly off-limits files. The single tracked substantive closure (Lane G AuslanderBuchsbaum) was the lone PLANNED ∩ DISPATCHED productive lane.

This is a **process issue**, not a planner or prover issue. Recommendation in `recommendations.md`.

## Per-target outcomes (10 dispatched lanes)

### 1. AVR / `iotaGm_range_isOpen` (Lane E) — PARTIAL structural advance

**Result**: refactor to strictly-stronger named helper `iotaGm_isOpenImmersion`. Main lemma body now 2 lines (`haveI := iotaGm_isOpenImmersion (kbar := kbar); exact IsOpenImmersion.isOpen_range _`). Helper carries the substantive content with a single honest sorry + documented strategy + structural reductions (`Over.lift_left`, `simp only [Over.comp_left, Over.id_left, Over.toUnit_left]`, `change` to `glueMorphisms` form).

- File sorries unchanged 2 → 2; disclosure tier improved one level.
- Helper budget 1/2; recipe steps (a)+(c)+(d)+(e) of the analogist recipe encoded.
- Residual sub-tasks (b) chart-1 factorisation of `onePt.left` + (f) chart-1 open-immersion conclusion ~60–110 LOC iter-183.
- Dead end logged: `exact IsOpenImmersion.isOpen_range _` directly fails (typeclass synthesis blocked); `rw [Over.lift_left, ...]` in one tactic fails ("motive not type correct"); `Proj.awayι_isOpenImmersion` is anonymous instance not a named lemma.

### 2. GmScaling / `gmScalingP1_chart_agreement_cross01` (Lane B) — PARTIAL structural advance + kernel-clean helper

**Result**: new kernel-clean helper `gmScalingP1_cover_intersection_X_iso` (~67 LOC) landed using Mathlib's **`Proj.pullbackAwayιIso`** — the iter-182 analogist's KEY finding. The iter-181 task_result's plan to build a project-side `Away_X0_X1_iso` is DROPPED (Mathlib ships it at `ProjectiveSpectrum/Basic.lean:258`).

- File sorries unchanged 4 → 4; new helper kernel-clean `{propext, Classical.choice, Quot.sound}`.
- Cocycle body itself remains PARTIAL: `cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv` lifts the goal cleanly, but the 7-stage iso chain expands to ~800-line composition that `simp` cannot collapse without aggregated `_inv ≫ fst/snd` projection lemmas.
- Iter-183 recipe: `@[simps]` annotation OR 2 manual projection lemmas (~30-40 LOC each), then cocycle closes in ~10 LOC via `Spec.map_injective` + `Algebra.TensorProduct.tmul_mul_tmul` + `IsLocalization.Away.mul_invSelf`.

### 3. AuslanderBuchsbaum / `depth_of_short_exact` (Lane G) — SUCCESS (Tier-2)

**Result**: closed Tier-2 (kernel-clean modulo upstream `depth_eq_smallest_ext_index` typed sorry). PIVOT per `analogies/isregularlocalring-isdomain.md` from `exists_isRegular_of_regularLocal` to `depth_of_short_exact` was the right call.

- File sorries 4 → 3 (**net −1; the only file-count closure this iter**).
- 2 new private helpers: `ext_vanish_of_natCast_lt_depth` (Tier-2 modulo same upstream), `natCast_add_one_le_of_le_sub_one` (Tier-1 axiom-clean, verified via inline `#print axioms`).
- 3-branch case analysis (LES chase via `Ext.covariant_sequence_exact₁/₂/₃`):
  - branch 1 `min(depth N', depth N'') ≤ depth N` via postcomp by `S.g` + exact₂
  - branch 2 `min(depth N, depth N' - 1) ≤ depth N''` via postcomp by extClass + exact₃ + ENat tsub bridge
  - branch 3 `min(depth N, depth N'' + 1) ≤ depth N'` via case-split on `i = 0` (mono → `postcomp_mk₀_injective_of_mono`) vs `i ≥ 1` (exact₁ lift)
- Verified axioms: `[propext, sorryAx, Classical.choice, Quot.sound]` — matches `depth_eq_smallest_ext_index`'s set; sorryAx propagates only through the named upstream.
- Tooling trap logged: `simpa using h0` timed out at 200000 heartbeats (`whnf` cannot reduce `(postcomp ...) e = (postcomp ...) 0`). Workaround: `apply hinj; simpa using hef` splits injectivity application before simp normalisation.

### 4. AlbaneseUP / `albanese_universal_property` (off-limits; dispatched anomalously) — PARTIAL structural advance

**Result**: monolithic body sorry replaced by named typed-sorry helper `albanese_eq_iff_symmetricPower_eq`. Headline theorem body is now **sorry-free assembly** (`have key := ...; obtain ⟨ψ, hψ_sym, huniq_sym⟩ := descentThroughBirationalSigma ...; exact ⟨ψ, (key ψ).mpr hψ_sym, ...⟩`), transitively tainted via 2 named substantive helpers.

- Net file declaration warnings 7 → 7 (monolithic body sorry → named helper sorry); grep `:= sorry` count 7 → 8 (new helper definition).
- Tooling trap: docstring-after-docstring fails with `unexpected token /--; expected lemma`; relocate helper to its own §5.5 section.

### 5. Thm32 / `av_codimOneFree_of_indeterminacy` (off-limits; dispatched anomalously) — PARTIAL branch refactor

**Result**: bare top-level `sorry` replaced with case-split on `indeterminacy_pure_codim_one_into_grpScheme f`'s disjunction. **Branch 1 closed axiom-clean** via new helper `codimOneFree_of_indeterminacyLocus_eq_empty` at L290; branch 2 remains gated on `indeterminacy_codimGe2_of_smooth_of_complete` from CodimOneExtension iter-184+.

- File sorries 2 → 2 (one inline sorry refactored into branch + helper).
- Branch-2 discharge ~10 LOC once CodimOneExtension exposes the codim-≥2 standalone lemma.
- Sorry 1 (`av_isIntegral_of_smooth_geomIrred` L194 `IsReduced A.left` from `[Smooth A.hom]`) unchanged — confirmed Stacks 034V/02G4 Mathlib gap at b80f227.

### 6–10. NO-EDIT lanes (5)

- **CodimOneExtension** — off-limits per PROGRESS.md `iter-183+ post-CoheightBridge`; honest NO-EDIT with verified Mathlib-gap search log (Stacks 00TT + `ringKrullDim_stalk_eq_coheight` both absent at b80f227).
- **BareScheme** — off-limits Mathlib-gap scaffolds; NO-EDIT with new `informal/<theorem>.md` sketches for the geom-irred + smoothness routes.
- **Points** — DONE iter-181 (kernel-clean `gm_grpObj`); NO-EDIT per "never modify working proofs".
- **Jacobian** — both sorries off-limits (gated on RR.4 chain + Route A cascade); protected sig on L326 forbids reformatting; NO-EDIT.
- **FGAPicRepresentability** — standing deferral iter-190+; sibling `PicSharp`/`divFunctor` not yet at compatible signatures; NO-EDIT.

## Key findings / patterns discovered

1. **Mathlib's `Proj.pullbackAwayιIso` ships the inner intersection iso** — re-confirmed via Lane B kernel-clean landing. Iter-181's "build project-side `Away_X0_X1_iso`" plan is wrong; KB entry needs adding.
2. **`set_option backward.isDefEq.respectTransparency false` recipe is non-portable**: iter-180 closed diagonal, iter-181 confirmed cross-case needs distinct strategy (cocycle-bridge via intersection iso), iter-182 cross01 confirms (cancel_epi works but downstream simp doesn't fire on opaque iso composition).
3. **LES-of-Ext via `Ext.covariant_sequence_exact₁/₂/₃` + ENat tsub bridges** is the canonical Mathlib idiom for SES depth-bound chase. The triple-branch case split (mono at i=0, exact₁/₂/₃ for general i) is reusable for any SES depth proof.
4. **`Cover.hom_ext` + `IsOpenImmersion.isOpen_range` + chart-1 factorisation** is the route for `iotaGm_isOpenImmersion`; the analogist Decision 4 from `intersection-ring-cross01` covers Route 3 (AVR) as well as Route 1.
5. **Recurring tooling trap**: dispatcher's `planValidate` step reorders / reassigns prover lanes against the planner's `## Current Objectives` priority. Out of 10 dispatched, only 3 were on the planned active-lane list.

## Blueprint markers updated (manual)

- None this iter. The `sync_leanok` phase ran (`iter: 182, added: 2, removed: 2, chapters_touched: 4`) — see `.archon/sync_leanok-state.json`.
- No `\mathlibok` additions warranted (all prover task results gate on substrate, not Mathlib re-exports).
- No `\lean{...}` rename corrections needed (no renames across the prover lanes).
- No stale `\notready` to strip.
- Prover task results suggest two **iter-183 plan-phase blueprint-writer dispatches**:
  - GmScaling task_result L102-105: add brief note pointing to `analogies/intersection-ring-cross01.md` Decision 2 — Mathlib alignment fact (no new `\lean{...}` pin).
  - AlbaneseUP task_result L123-128: consider adding a `\lean{Pic0.albanese_eq_iff_symmetricPower_eq}` pin in `Albanese_AlbaneseUP.tex` as new §5.5 between `lem:descent_through_birational_sigma` and `thm:albanese_universal_property`.

## Blueprint doctor

`.archon/logs/iter-182/blueprint-doctor.md` reports **1 finding**:

> chapter `RiemannRoch_OcOfD.tex` covers `AlgebraicJacobian/RiemannRoch/OcOfD.lean`, which does not exist

This is **expected**: the iter-182 plan-phase blueprint-writer landed the new chapter as preparation for iter-183 Lane K (the file-skeleton lane was explicitly deferred 1 iter per `iter/iter-182/plan.md ## Decision made`). The orphan `% archon:covers` will clear when iter-183 opens the file. No action needed this iter; flag for iter-183 plan agent to ensure Lane K actually fires.

## Plan-phase subagent dispatches (recapped from iter-182 plan.md)

- **progress-critic `route182`** — UNDER_DISPATCH + 9 must-fix-this-iter items (addressed in plan composition)
- **strategy-critic `iter182`** — SOUND verdict; all iter-181 CHALLENGEs retired
- **blueprint-reviewer** — SKIPPED with rationale (iter-181 checker dispatches consumed; iter-183 mandatory dispatch re-verifies writer edits)
- **5 mathlib-analogist consults** (all COMPLETE; recipes landed in `analogies/`)
- **2 blueprint-writers** (Pin 2/3 prose + OcOfD skeleton, both COMPLETE)
- **1 refactor** (`pin2-sig-strengthen`, COMPLETE)

## Recommendations for the next plan iteration

See `recommendations.md` — top priorities:

1. **Re-fire the 4 planner-intended lanes that planValidate deferred** (OCofP, RelativeSpec, QuotScheme, RatCurveIso). All recipe-armed; all have current substantive content waiting.
2. **Investigate the dispatch reordering**: the planValidate step's queue is selecting against off-limits files instead of for active lanes. If this isn't a planner-side specification bug, it needs a harness-level fix.
3. **Open Lane K (`RiemannRoch/OcOfD.lean` file-skeleton)** as committed in iter-182 plan.md `## Iter-183 (preliminary commitments)`. Blueprint chapter has landed; blueprint-doctor flag will clear.
4. **Close GmScaling cross01 cocycle** via `@[simps]` or 2 projection lemmas (~100-120 LOC).
5. **Close AVR `iotaGm_isOpenImmersion` body** via chart-1 factorisation + open-immersion composition.
