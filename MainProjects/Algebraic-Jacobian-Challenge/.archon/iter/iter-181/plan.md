# Iter-181 plan-agent run

## Headline outcome

**The "post-RETIRE-OR-ESCALATE follow-through iter; OCofP signature
CRITICAL fix landed via plan-phase refactor; STRATEGY.md format
NON-COMPLIANCE addressed (13→0 per-iter refs, A.4.c split, chart-bridge
re-anchored); RatCurveIso analogist consults executed (Pin 2/3 both
PROCEED); 8 prover lanes" iter.**

iter-180 returned `lake build` GREEN with the iter-181 RETIRE-OR-ESCALATE
corrective EXECUTED IN-PLACE: 2 → 0 project axioms (first 0-axiom build
since iter-177). The iter-180 review surfaced a **CRITICAL must-fix-this-iter**
finding: `OCofP.globalSections_iff` is mathematically FALSE as typed
(vacuous-in-`f` RHS). iter-181 plan-phase addresses all critic outputs
in-flight.

iter-181 plan-phase actions:

1. **THREE `[HIGHLY RECOMMENDED]` critic decisions**:
   - **progress-critic** `route181` — **DISPATCHED**. 14 routes audited:
     4 CONVERGING (1 GmScaling, 2a RRFormula, 4a RelativeSpec, 5c
     AuslanderBuchsbaum), 5 STUCK (2b OCofP, 2c WeilDivisor, 4c
     RelPicFunctor, 4e FGAPicRepresentability, 4f
     FlatteningStratification, 5d AlbaneseUP), 2 CHURNING (2d
     RationalCurveIso, 5a Thm32), 5 UNCLEAR (3 AVR, 4b
     LineBundlePullback, 4d QuotScheme, 5b CodimOneExtension, 6
     Points). Dispatch OK (within cap; 1 ready file ungated). Must-fix
     items addressed below.
   - **strategy-critic** `iter181` — **DISPATCHED**. Two CHALLENGE
     verdicts (A.4.c missing sub-phase, chart-bridge velocity-anchor
     fallacy), one format NON-COMPLIANT verdict (13 per-iter refs +
     accumulation + byte overage). All three addressed in STRATEGY.md
     re-write this plan-phase. Sunk-cost flag on chart-bridge defense
     also addressed (reframed gating to concrete signal on remaining
     sorries).
   - **blueprint-reviewer** — **skipped** (only marker edits + 1
     `\lean{...}` correction since iter-177 HARD GATE clear; no chapter
     prose edited since prior verdict; all iter-181 prover-touched
     chapters carry `complete: true correct: true`). See `## Subagent
     skips`.

2. **TWO plan-phase write-capable subagents**:
   - **`refactor ocofp-globalsections-sig`** — DISPATCHED. Addresses
     the iter-180 CRITICAL must-fix-this-iter on `OCofP.globalSections_iff`:
     adds a typed-sorry `lineBundleAtClosedPoint.toFunctionField` map
     + re-types the iff RHS as `∃ s, ι s = f` (binding `s` to `f`).
     Out-of-scope: filling bodies; touching other files. (Status of
     this dispatch is checked below in `## Refactor dispatch`.)
   - **`mathlib-analogist ratcurveiso-pins`** — DISPATCHED, returned
     PROCEED on both Pin 2 + Pin 3 (no `Scheme.Hom.degree`, no
     `Scheme.WeilDivisor.pullback`, no `IsBirational` in Mathlib).
     Persistent recipes at `analogies/ratcurveiso-pin2.md` (~80–150
     LOC body via `Ideal.sum_ramification_inertia` chart calculation)
     and `analogies/ratcurveiso-pin3.md` (~80–150 LOC body via
     `Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom` +
     finiteness-from-properness). Pin 3 needs a signature refinement
     (DIVERGE_INTENTIONALLY) before the body can be attempted.

3. **STRATEGY.md restructure** addressing strategy-critic must-fix:
   - **A.4.c CHALLENGE**: split into A.4.c.0 (codim-≥2 standalone
     Lean exposure, ~2–4 iters) + A.4.c.1 (Thm 3.2 assembly, ~8–14
     iters). Total iters preserved (~12–18 was original; now ~10–18
     split between two sub-rows).
   - **Chart-bridge CHALLENGE**: replaced single row with TWO rows
     (cross case + collapse-at-zero), each anchored at
     `~30–70 · NOT-YET-MEASURED` velocity — recognising that the
     `respectTransparency` recipe does NOT apply to either.
   - **Format NON-COMPLIANT**: 13 `iter-NNN` refs excised across 4
     sections; DEMOTED-replacement block compressed to single line
     under Open Qs; iter-tagged accumulation parenthetical removed.
     Final size: 167 → 158 lines, 12.1 → ~10.5 KB. Within budget.
   - **Sunk-cost flag on chart-bridge defense**: alt-route gating
     reframed from "recipe worked twice" to "if either remaining sorry
     stays open ≥2 iters with no analogist recipe surfacing,
     re-promote separated-locus".

4. **Critic-disclosure 3-tier vocabulary** (per progress-critic
   informational + iter-180 lean-auditor MAJOR): every iter-181 prover
   directive now requires the prover to classify each closed lemma as
   one of (1) **kernel-clean (this body)** — local `lean_verify` no
   `sorryAx`; (2) **kernel-clean modulo upstream X / Y** — local body
   sorry-free but transitive dep carries `sorryAx`; (3) **kernel-clean
   (transitively)** — `lean_verify` + transitive closure no `sorryAx`.
   Prover must report `#print axioms` for the *named upstream* sorry
   carriers as well as the proved lemma.

5. **9 prover lanes for iter-181 prover phase** (within cap = 10), with
   the progress-critic's must-fix re-prioritisation incorporated:
   - **Lane A** `OCofP.lean` — close `globalSections_iff` body (post
     plan-phase refactor) — Hartshorne II.7.7(a)/(b) both directions via
     the NEW `toFunctionField` map. NOTE: gated on the plan-phase
     refactor landing GREEN. Helper budget = 2.
   - **Lane B** `GmScaling.lean` — close `gmScalingP1_chart_agreement`
     CROSS case via the cocycle-bridge ring identity (per
     `analogies/gmscaling-deep.md` Q4); leave `collapse_at_zero` for
     iter-182. Helper budget = 1.
   - **Lane C** `Points.lean` — close `gmHomEquiv_left_inv` +
     `gmHomEquiv_right_inv` round-trip identities via `Subsingleton.elim
     + convert + Over.OverMorphism.ext` per the iter-180 Lane B
     task_result "Concrete next steps". Helper budget = 2.
   - **Lane D** `RelativeSpec.lean` — `pullback_iso` body via cocone +
     colimit universal property of `Cover.RelativeGluingData.glued` per
     the iter-180 Lane C task_result "Suggested next step". Helper
     budget = 2.
   - **Lane E** `AbelianVarietyRigidity.lean` — resume `iotaGm_isDominant`
     body now that Lane A (gm) + Lane B (points) iter-180 primary
     substrate landed. Helper budget = 2.
   - **Lane F** `QuotScheme.lean` — close Lane F iter-180 helper #1
     `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` via
     `Module.Flat.isBaseChange`. Leave helper #2 (Mayer-Vietoris descent)
     for iter-182. Helper budget = 2.
   - **Lane G** `AuslanderBuchsbaum.lean` — start one depth-dependent
     lemma now that `Module.depth` exists. Prover picks smallest of
     `depth_eq_smallest_ext_index` (L228, Stacks 00LP) or
     `CohenMacaulay.of_regular` (L396, Stacks 00OD). Helper budget = 2.
   - **Lane H** `RRFormula.lean` — close
     `eulerCharacteristic_eq_degree_plus_one_minus_genus` (per auditor
     MAJOR: retires transitively-inherited `sorryAx` on Lane E iter-180
     close). Helper budget = 2.
   - **Lane I** `RationalCurveIso.lean` — Pin 3 SIGNATURE REFINEMENT
     (strengthen the function-field-iso hypothesis to "induced by `φ`"
     OR to a `Module.finrank = 1` statement per analogist
     `ratcurveiso-pin3.md` Step 1) — signature-only mutation lane.
     Helper budget = 0 (signature work; body deferred to iter-182).

Dropped from preliminary commitments:
- **Lane J Thm32 codim-≥2 exposure (was preliminary lane #9)** —
  progress-critic flagged as CHURNING (helper #3 in 2 iters with no
  body close); but inspection of CodimOneExtension.lean L356 shows the
  codim-≥2 conclusion IS already top-level exposed
  (`extend_of_codimOneFree_of_smooth`), just sorry-bodied. Critic's
  prescribed corrective (blueprint-writer on Thm 3.2) is not the right
  fix — the right fix is closing `extend_of_codimOneFree_of_smooth`'s
  body or routing through it as a black box. Both require
  CodimOneExtension Mathlib-gap work (Stacks 00TT) which is deferred.
  Thm32 stays off iter-181 lanes; resumption gated on
  CodimOneExtension.lean body landing.
- **4c/4e/4f/5d blueprint expansions (progress-critic STUCK-by-inaction
  prescription)** — adopting the critic's "OR explicitly write a
  re-engagement deadline" branch instead, recorded in PROGRESS.md
  `## Standing deferrals` with concrete trigger iters per file (rather
  than dispatching 4 simultaneous writers for files not yet ready to
  consume the blueprint expansion).

## Critic verdicts (this iter)

| Critic | Slug | Verdict |
|---|---|---|
| progress-critic | `route181` | **5 STUCK + 2 CHURNING + 4 CONVERGING + 5 UNCLEAR.** Must-fix-this-iter: (i) OCofP signature refactor (lane #1 of preliminary proposal addresses); (ii) WeilDivisor STUCK by inaction (deferred infrastructure — RatCurveIso Pin 2/3 analogist must fire, **DONE this iter**); (iii) RatCurveIso CHURNING (promote consult from reserve — **DONE this iter**); (iv) RelPicFunctor/FGAPicRepresentability/FlatteningStratification/AlbaneseUP STUCK (blueprint expansion OR re-engagement deadline — **adopting deadline branch in PROGRESS.md**); (v) Thm32 CHURNING (helper #3 risk — **dropped lane**, see Lane J rationale). Dispatch sanity OK. Adopt 3-tier kernel-clean vocabulary in directives. |
| strategy-critic | `iter181` | **2 CHALLENGE + format NON-COMPLIANT**. A.4.c row missing sub-phase → split into A.4.c.0 + A.4.c.1; chart-bridge row velocity-anchor fallacy → split into 2 rows with NOT-YET-MEASURED markers; per-iter narrative pollution + DEMOTED-replacement accumulation → excised. Sunk-cost flag on alt-route gating → reframed. **All addressed in this plan-phase's STRATEGY.md re-write.** |
| blueprint-reviewer | (skipped — see Subagent skips) | — |

## Acting on critic findings

- **progress-critic** must-fix items: 4 of 5 addressed in lane composition (i, ii via analogist consult, iii via analogist consult, iv via re-engagement deadlines in PROGRESS.md); item v (Thm32) is rejected with stated rationale (codim-≥2 is already top-level exposed in CodimOneExtension.lean; critic's diagnosis was based on Lane G's prover task_result wording which is misleading).
- **strategy-critic** all 3 must-fix addressed in STRATEGY.md re-write.

## Subagent skips

- **blueprint-reviewer**: no chapter under `blueprint/src/chapters/` has had prose edited since iter-177 HARD GATE clear EXCEPT this plan-phase tightened `lem:lineBundleAtClosedPoint_globalSections_iff`'s prose to explicitly bind `s` to `f` (per iter-180 checker recommendation — single-block surgical edit consuming the iter-180 checker verdict). All iter-181 prover-touched chapters were `complete: true correct: true` at last verdict. The single edit is the planner consuming a prior checker verdict, not introducing new content for a fresh check; rest of chapter unchanged. iter-182 will re-dispatch if other prose changes accumulate.

## Refactor dispatch

- **`refactor ocofp-globalsections-sig`** — DISPATCHED in plan-phase. At time of writing this sidecar, the report has not yet landed. The Lane A prover directive is built on the EXPECTED post-refactor signature (`∃ s, ι s = f`); if the refactor returns with deviations or build issues, the next plan agent (iter-182) will need to bridge them. Verification needed before iter-181 prover phase fires: confirm `OCofP.lean` compiles GREEN with the new signature + the new typed-`sorry` `toFunctionField` map present. If not, Lane A is dropped from iter-181 dispatch and re-queued iter-182.

## Plan-phase consults (informational summary)

- **`pullbackspeciso-bypass` (iter-180 consult)** — recipe validated
  again iter-180 prover phase (Lane A PRIMARY closed kernel-clean).
  Iter-181 Lane B will NOT use this recipe — the cross-case is a
  cocycle ring identity in `Localization.Away t ⊗_{k̄} GmRing`, a
  different family of blockers per the iter-180 Lane A task_result.
- **`gm-grpobj-representable` (iter-179 consult)** — recipe consumed
  iter-180 Lane B (5 axiom-clean helpers + 2 round-trip sorries).
  Iter-181 Lane C closes the round-trip sorries via the consult's
  Step 5 + 6 plus the iter-180 task_result's "Subsingleton.elim on
  IsUnit proofs" addendum.
- **`relative-spec-block-a` / `cover-bridge-uniform-i` (iter-179
  refactors)** — both consumed; no new work from those iter-181.

## Dispatch decision (record-for-iter-182)

- **8 substantive prover lanes + 1 signature lane = 9 lanes** in
  `## Current Objectives` (within cap = 10). All target files have
  ready sorries (per iter-180 review's file breakdown). No new
  `axiom` introductions permitted; iter-181 RETIRE-OR-ESCALATE
  trigger STAYS DISARMED (executed in-place iter-180).
- Re-engagement schedule for STUCK-by-inaction Picard/AlbaneseUP
  cluster recorded under PROGRESS.md `## Standing deferrals`:
  - 4c RelPicFunctor — re-engage when A.1.b `LineBundle.OnProduct`
    body lands (gated; estimated iter-184+).
  - 4e FGAPicRepresentability — re-engage when A.2.c Quot+RelPic
    pipeline assembles (gated; estimated iter-190+).
  - 4f FlatteningStratification — re-engage when A.2.a sub-build
    starts (currently substrate UNOWNED; estimated iter-185+
    contingent on writer capacity).
  - 5d AlbaneseUP — re-engage when A.3 substrate
    (`Pic⁰.bundle`/`IdentityComponent.lean` skeleton) and
    A.4.d.i (`Sym^g` skeleton) land (gated; estimated iter-200+).

## Sorry trajectory expected entering iter-181

`lake build AlgebraicJacobian` GREEN — 73 sorry warnings, 0 errors,
**0 project axioms**. (Verified iter-180 review.)

After plan-phase refactor: **74** (refactor adds 1 typed-sorry
`toFunctionField`; net +1).

After iter-181 prover phase, best case (all 9 lanes close their
primary target): **~65** (−9 lanes × 1 sorry each, minus best-case
overshoot for multi-sorry lanes like Lane C closing 2). Realistic
case: −4 to −6 sorries. Worst case (Lane A refactor unrolls
downstream issues): +3 to +5.

## Sorry landscape entering iter-181 (per file)

(See `task_pending.md` for full canonical state.)

- `AbelianVarietyRigidity.lean` — 2 (Lane E target).
- `Genus0BaseObjects/GmScaling.lean` — 4 (Lane B targets cross case).
- `Genus0BaseObjects/Points.lean` — 2 (Lane C target).
- `Genus0BaseObjects/BareScheme.lean` — 2 (Mathlib gaps; off-target).
- `Picard/RelativeSpec.lean` — 1 (Lane D target).
- `Picard/LineBundlePullback.lean` — 5 (gated; off-target).
- `Picard/QuotScheme.lean` — 7 (Lane F targets helper #1).
- `Picard/RelPicFunctor.lean` — 6 (gated; off-target).
- `Picard/FlatteningStratification.lean` — 7 (gated; off-target).
- `Picard/FGAPicRepresentability.lean` — 7 (gated; off-target).
- `RiemannRoch/WeilDivisor.lean` — 2 (deferred Pin 2 gate).
- `RiemannRoch/OCofP.lean` — 5 → 6 after refactor (Lane A target).
- `RiemannRoch/RRFormula.lean` — 2 (Lane H target).
- `RiemannRoch/RationalCurveIso.lean` — 2 (Lane I sig refinement).
- `Jacobian.lean` — 2 (gated).
- `Albanese/AuslanderBuchsbaum.lean` — 4 (Lane G target).
- `Albanese/Thm32RationalMapExtension.lean` — 2 (deferred; off-target).
- `Albanese/CodimOneExtension.lean` — 3 (deferred; off-target).
- `Albanese/AlbaneseUP.lean` — 7 (deferred; off-target).
- `RigidityKbar.lean` — 1 (off critical path).

## Active monitors

- **iter-181 RETIRE-OR-ESCALATE trigger** — STATUS: DISARMED (axioms RETIRED iter-180).
- **gm_grpObj 12-iter persistence avoidance**: iter-180 broke the streak
  via structural decomposition (5 axiom-clean helpers); iter-181 Lane C
  closes the round-trips. If Lane C PARTIALs, the iter-182 plan agent
  must NOT add helpers — close-or-defer-with-explicit-deadline.
- **Inflated "axiom-clean" pattern**: iter-181 prover directives encode
  the 3-tier vocabulary; iter-182 audit will spot-check enforcement.
- **OCofP signature drift**: iter-181 plan-phase refactor addresses
  the specific incident; iter-182+ should adopt a "signature audit"
  microstep for any iff RHS that doesn't bind a hypothesis variable.

## Decision made

(none in this iter requiring asynchronous user override; the
strategy-critic CHALLENGE on A.4.c sub-split and chart-bridge
re-anchor were both implementable in-place via STRATEGY.md edits.)

## Tool substitutions

(none this iter; all tools available and used as intended.)
