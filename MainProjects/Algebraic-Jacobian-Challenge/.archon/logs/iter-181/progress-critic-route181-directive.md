# progress-critic directive (iter-181, slug: route181)

You are evaluating whether each active route is **converging**, **churning**, **stuck**, or **unclear**. K = last 4 iters (177–180).

Project axiom count: **0** project axioms entering iter-181 (iter-180 retired the 2 TEMP axioms in `Genus0BaseObjects/GmScaling.lean`). `lake build` GREEN with 73 sorry warnings.

## Active routes the planner is considering for iter-181

### Route 1 — Genus-0 chart-bridge (`Genus0BaseObjects/GmScaling.lean`)

- Strategy `Iters left` cell (post iter-180): row reads "1 (axiom-laundered; **kernel-only contract VIOLATED until retired — Trigger: iter-181 RETIRE-OR-ESCALATE**)" — but iter-180 closed the PRIMARY (`gmScalingP1_chart_PLB_eq`) axiom-clean via the empirically-verified `respectTransparency` recipe, deleted both TEMP axioms, and replaced 2 remaining axiom-launderings with honest sorries. The row needs re-estimation this plan-phase.
- Entered current phase (chart-bridge body): iter-178 (iter-178 RelativeSpec, iter-179 cover-bridge refactor + Lane A partial via heartbeat sink, iter-180 Lane A primary axiom-clean + 2 TEMP axioms retired).
- Signals (iter-177→180):
  - sorries-in-file: 3+2axioms → 3+2axioms → 3+2axioms → 4+0axioms (after structural decomposition; net +1 honest sorry, −2 axioms — best-case on axiom critical-axis)
  - helpers added: iter-178 cover-bridge refactor uniform-i + chart_PLB_eq stages; iter-179 +partial-stages; iter-180 0 new helpers (recipe applied straight)
  - prover statuses: iter-178 PARTIAL+deferred, iter-179 PARTIAL+reversal-triggered, iter-180 PARTIAL+SUCCESS RETIRE-OR-ESCALATE EXECUTED
  - blocker phrases: "heartbeat sink", "Algebra.compHom chain" (RESOLVED iter-180 via Decision-4)
- 2 honest sorries remain: `gmScalingP1_chart_agreement` cross case + `gmScalingP1_collapse_at_zero`. Both honestly-named (no laundering). The Lane A task_result raises an iter-181 escalation question: is the gate "recipe works on the load-bearing lemma" (PRIMARY closed) or "all 3 bodies axiom-clean" (2 honest sorries remain)?

### Route 2 — Genus-0 RR bridge chain (`RR.1/RR.2/RR.3/RR.4`)

- Files: `RiemannRoch/{WeilDivisor, RRFormula, OCofP, RationalCurveIso}.lean`
- Strategy `Iters left`: RR.1 ~4–8, RR.2 ~8–12, RR.3 ~8–12, RR.4 ~8–12 (all anchored at `~30/it · gated`).
- Entered current phase: iter-178 active.
- Signals (iter-177→180) per file:
  - **RRFormula.lean**: 3→3→3→2 (iter-180 Lane E closed `l_eq_degree_plus_one_of_genus_zero` axiom-clean modulo transitive upstream sorry; 4-iter STUCK-by-inaction streak BROKEN; auditor MAJOR on inflated "axiom-clean" claim — the body itself is clean, but inherits `sorryAx` via upstream).
  - **OCofP.lean**: 5→5→5→5 (iter-180 Lane D structural Iff split landed but token +1 internal to `globalSections_iff`; **iter-180 review surfaced a CRITICAL must-fix-this-iter signature bug on `globalSections_iff` — vacuous-in-`f` RHS makes the iff false as typed; counterexample `f = f_Q^{-1}` for any closed `Q ≠ P`**).
  - **WeilDivisor.lean**: 2→2→2→2 (deferred iter-180 — Pin 2 RatCurveIso gate).
  - **RationalCurveIso.lean**: 4→3→2→2 (Pin 1 closed iter-179; Pins 2,3 deferred — Hartshorne II.6.9 + Stacks 0AVX Mathlib gaps; iter-181 analogist consults queued).

### Route 3 — AVR genus-0 closure (`AbelianVarietyRigidity.lean`)

- Strategy `Iters left`: implicit (depends on chart-bridge body + RR.4); 2 sorries.
- Entered current phase: iter-175 (`iotaGm_isDominant` opened); deferred iter-180 pending Lane A + Lane B.
- Signals: 2→2→2→2 sorries (iter-180 file untouched per "Off-limits" clause; gates may clear post-iter-180).

### Route 4 — Route A Picard/FGA scaffolding

Sub-routes:
- **4a Picard/RelativeSpec.lean** — 2→2→2→1 (iter-180 Lane C closed `coequifibered` kernel-clean via 2 axiom-clean helpers; `pullback_iso` deferred iter-181+).
- **4b Picard/LineBundlePullback.lean** — 5→5→5→5 (gated on `pullback_iso`).
- **4c Picard/RelPicFunctor.lean** — 6→6→6→6 (gated on A.1.b).
- **4d Picard/QuotScheme.lean** — 6→6→6→7 (iter-180 Lane F honest 2-helper substantive split landed; net +1 sorry).
- **4e Picard/FGAPicRepresentability.lean** — 7→7→7→7 (gated).
- **4f Picard/FlatteningStratification.lean** — 7→7→7→7 (gated).

### Route 5 — Albanese / Thm32 / CodimOneExtension / AlbaneseUP

- **5a Albanese/Thm32RationalMapExtension.lean** — 1→1→1→2 (iter-180 Lane G Option (a) split into 2 named helpers; conjunction wrapper axiom-clean; helper #2 deviates from directive — Lemma 3.3 alone insufficient).
- **5b Albanese/CodimOneExtension.lean** — 4→3→3→3 (iter-179 Path D2 landed; iter-180 untouched).
- **5c Albanese/AuslanderBuchsbaum.lean** — 6→5→5→4 (iter-180 Lane H closed `Module.depth` body kernel-clean first-attempt; auditor 178C docstring fix iter-179; structurally unblocks 4 depth-dependent lemmas).
- **5d Albanese/AlbaneseUP.lean** — 7→7→7→7 (gated; bundle helper depends on A.3 substrate).

### Route 6 — `Genus0BaseObjects/Points.lean` (`gm_grpObj`)

- Strategy: implicit (deferral persistence is the signal).
- Entered current phase: iter-169 first deferred.
- Signals: 1→1→1→2 (iter-180 Lane B 11-iter deferral PARTIALLY BROKEN; 5 axiom-clean helpers + 2 named substantive round-trip sorries; net +2 sorries but structural progress dramatic).

## Planner's PROGRESS.md `## Current Objectives` proposal for iter-181

(file count: target ≤10 lanes)

Tentative proposal:
1. **`AlgebraicJacobian/RiemannRoch/OCofP.lean`** — execute the iter-180 CRITICAL must-fix-this-iter signature fix on `globalSections_iff` (rename RHS to `∃ s, ι s = f` shape). [refactor lane + body close in same iter]
2. **`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`** — Lane A finish: close `gmScalingP1_chart_agreement` cross case + `gmScalingP1_collapse_at_zero` using the validated `respectTransparency` recipe + cover/cocycle helpers.
3. **`AlgebraicJacobian/Genus0BaseObjects/Points.lean`** — Lane B finish: close `gmHomEquiv_left_inv` + `gmHomEquiv_right_inv` round-trip identities via `Subsingleton.elim` on the `IsUnit` proofs + `convert` + `Over.OverMorphism.ext` chain.
4. **`AlgebraicJacobian/Picard/RelativeSpec.lean`** — close `pullback_iso` body via cocone-over-affine-cover + colimit universal property of `Cover.RelativeGluingData.glued`.
5. **`AlgebraicJacobian/AbelianVarietyRigidity.lean`** — resume `iotaGm_isDominant` body now that Lane A's PRIMARY + Lane B's substrate are partly landed.
6. **`AlgebraicJacobian/Picard/QuotScheme.lean`** — close one of the two Lane F helpers (helper 1 `_of_isAffineOpen` via `Module.Flat.isBaseChange` is most concrete).
7. **`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`** — start one of the depth-dependent lemmas (`depth_eq_smallest_ext_index` or `CohenMacaulay.of_regular`) now that the `depth` body exists.
8. **`AlgebraicJacobian/RiemannRoch/RRFormula.lean`** — close `eulerCharacteristic_eq_degree_plus_one_minus_genus` (per auditor MAJOR: this would retire the transitively-inherited sorryAx in `l_eq_degree_plus_one_of_genus_zero`).
9. **`AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`** — expose the codim-≥2 piece of Milne 3.1 as a standalone lemma so `av_codimOneFree_of_indeterminacy` closes by 2-line case-split.
10. **(reserve slot — likely a queued mathlib-analogist consult on idealsheaf-dual or smooth-stalk; consult is plan-phase, not prover)**.

## What I want you to check

1. Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with rationale grounded in the signals above.
2. Whether the planner's proposed iter-181 dispatch addresses the must-fix-this-iter findings (esp. OCofP CRITICAL signature bug from iter-180 review).
3. Whether any route should be replaced or any new file added (UNDER_DISPATCH risk).
4. Whether the chart-bridge `Iters left` row in STRATEGY.md should be re-estimated (was "1 — RETIRE-OR-ESCALATE", now post-execution best-case on axiom axis with 2 honest sorries remaining).
5. The "axiom-clean" inflated-claim pattern Lane E exhibited (auditor MAJOR) — should the planner's iter-181 directive language adopt a "transitively-clean" / "kernel-clean modulo upstream" distinction?
6. Whether the iter-180 review-flagged CRITICAL OCofP signature bug is a **strategy-level** issue (the chapter's prose drifted from the Lean type, exposing a signature drift pattern) or a one-off Lean-side fix.

Report under `task_results/progress-critic-route181.md` (auto-written by the wrapper).
