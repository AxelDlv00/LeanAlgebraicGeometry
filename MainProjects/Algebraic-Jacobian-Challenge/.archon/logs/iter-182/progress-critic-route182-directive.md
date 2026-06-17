# Convergence Critique — iter-182

## Slug
route182

## Iteration
182

## Active routes / files this iter is considering

### Route 1 — Genus-0 (chart-bridge frontier)

- File: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (cross01 + collapse_at_zero)
- Last 5 iter sorry counts (file): iter-177 4+2-axioms; iter-178 4+2-axioms; iter-179 4+2-axioms; iter-180 4+0-axioms (TEMP axioms RETIRED); iter-181 4+0-axioms (1 inline sorry → named cross01 helper)
- Helpers added per iter: iter-178 0; iter-179 0; iter-180 1 PRIMARY axiom-clean lemma `gmScalingP1_chart_PLB_eq`; iter-181 1 helper `gmScalingP1_chart_agreement_cross01`
- Statuses: iter-178 INCOMPLETE / iter-179 INCOMPLETE / iter-180 PARTIAL+SUCCESS / iter-181 PARTIAL
- Recurring blocker phrase: "respectTransparency recipe does not generalize to cross case"; "intersection ring `Away 𝒜 (X 0 · X 1)` not packaged in Mathlib"
- STRATEGY.md row for "chart-bridge cross-case body": `Iters left ~2–4`; `~30–70 · NOT-YET-MEASURED`. Route entered current phase iter-177.

### Route 2a — `RiemannRoch/RRFormula.lean`

- Last 5 file sorry counts: iter-177 4; iter-178 4; iter-179 4; iter-180 2 (Lane E success); iter-181 3 (Lane H +1 induction helper)
- Helpers: iter-180 0; iter-181 2 (`eulerCharacteristic_sheafOf_zero`, `eulerCharacteristic_sheafOf_single_add`)
- Statuses: iter-180 SUCCESS / iter-181 PARTIAL
- Recurring blocker phrase: "gated on RR.3 sheafOf body" (`RiemannRoch/OcOfD.lean` does NOT exist yet)
- STRATEGY.md row "Genus-0 RR.2 — RR formula for genus 0": `Iters left ~8–12`; gated.

### Route 2b — `RiemannRoch/OCofP.lean`

- Last 5 file sorry counts: iter-177 4; iter-178 4; iter-179 5; iter-180 5; iter-181 7 (refactor +1 + Lane A split +1)
- Helpers: iter-180 2 directional split; iter-181 1 typed-sorry `toFunctionField` + 2 directional helpers
- Statuses: iter-179 PARTIAL / iter-180 PARTIAL / iter-181 PARTIAL (GATE RISK PARTIAL as scoped)
- Recurring blocker phrase: "gated on `toFunctionField` / `lineBundleAtClosedPoint` body — Sheaf internal-Hom + ModuleCat forget Mathlib gap"
- STRATEGY.md row "Genus-0 RR.3 — O_C(P) global sections": `Iters left ~8–12`; gated.

### Route 2c — `RiemannRoch/WeilDivisor.lean`

- Last 5 file sorry counts: iter-177 2; iter-178 2; iter-179 2; iter-180 2; iter-181 2 (untouched)
- Helpers: 0 across the window
- Statuses: deferred each iter; no prover dispatch
- Recurring blocker: "gated on RatCurveIso Pin 2 body"
- STRATEGY.md row "Genus-0 RR.1 — Weil divisors": `Iters left ~4–8`; `~150–350 · ~30/it`. Route entered phase iter-174.

### Route 2d — `RiemannRoch/RationalCurveIso.lean`

- Last 5 file sorry counts: iter-177 3 (skeleton); iter-178 3; iter-179 3 (1 closed by 178A excuse fix); iter-180 2; iter-181 2 (Lane I sig refinement, no body)
- Helpers: iter-178 0; iter-179 0; iter-180 0; iter-181 0 (helper budget = 0)
- Statuses: iter-178 SUCCESS (sig) / iter-179 INCOMPLETE / iter-180 INCOMPLETE / iter-181 SUCCESS (sig refinement)
- Recurring blocker: "Pin 2 signature weakened-wrong → must refactor THIS iter before any body work" (lean-vs-blueprint-checker iter-181 must-fix-this-iter)
- STRATEGY.md row "Genus-0 RR.4 — rational ⟹ ≅ ℙ¹": `Iters left ~8–12`; gated.

### Route 3 — `AbelianVarietyRigidity.lean` (`iotaGm_isDominant`)

- Last 5 file sorry counts: iter-177 2; iter-178 2 (dead-end); iter-179 2; iter-180 OFF-LIMITS; iter-181 2 (Lane E structural advance; inline sorry → named `iotaGm_range_isOpen`)
- Helpers: iter-181 1
- Statuses: iter-181 PARTIAL (disclosure tier shallowed one level)
- Recurring blocker: "chart-1 section extraction of `gmScalingP1` not yet packaged" — same blocker as Route 1 cross01

### Route 4a — `Picard/RelativeSpec.lean`

- Last 5 file sorry counts: iter-177 0 (CRIT placeholder body); iter-178 0 (placeholder); iter-179 3 (Block A; honest scaffold +3); iter-180 2 (Lane C closed coequifibered); iter-181 1 (Lane D closed; helper2 sorry-bodied)
- Helpers: iter-179 1; iter-180 2; iter-181 2
- Statuses: iter-179 COMPLETE refactor / iter-180 SUCCESS / iter-181 PARTIAL
- Recurring blocker: "`HasColimit` synthesis fails through `let`-bound `d`"
- STRATEGY.md row "A.1.a — RelativeSpec": `Iters left ~6–10`; `~200–400 · ~50/it`.

### Route 4b — `Picard/LineBundlePullback.lean`

- Last 5: 5 sorries each, no prover work in window
- Helpers: 0
- Statuses: deferred each iter
- Recurring blocker: "gated on A.1.a `pullback_iso` body" — now nearly landed
- STRATEGY.md row "A.1.b — LineBundle.Pullback": `Iters left ~2–4`; gated.

### Route 4c — `Picard/RelPicFunctor.lean`

- 6 sorries each, no prover work in window
- Recurring blocker: "STUCK by inaction"; gated on A.1.b
- STRATEGY.md row "A.1.c": `Iters left ~10–17`; gated. Standing deferral iter-184+.

### Route 4d — `Picard/QuotScheme.lean`

- Last 5: iter-177 7; iter-178 7; iter-179 7; iter-180 7; iter-181 8 (Lane F +1 substantive helper)
- Helpers: iter-180 2 (mate split); iter-181 2 (rfl-bridge + affine-base substantive)
- Statuses: iter-180 PARTIAL / iter-181 PARTIAL
- Recurring blocker: "section-vs-tensor-product identification of Scheme.Modules.pullback at affine opens — Mathlib gap"
- STRATEGY.md row "A.2.b.iii — Quot assembly": `Iters left ~36–72`; gated. (NOTE: this file is much smaller in scope than full Quot — the iter-181 work targeted only the canonicalBaseChangeMap helper.)

### Route 4e — `Picard/FGAPicRepresentability.lean`

- 7 sorries each, no work in window; standing deferral iter-190+

### Route 4f — `Picard/FlatteningStratification.lean`

- 7 sorries each, no work in window; standing deferral iter-185+

### Route 5a — `Albanese/Thm32RationalMapExtension.lean`

- Last 5: iter-177 2; iter-178 2 (untouched); iter-179 2 (Lane E re-engagement); iter-180 2 (Lane G split into 2 helpers); iter-181 2 (deferred per critic-rejection rationale)
- Helpers: iter-179 1; iter-180 2 (named split)
- Statuses: iter-179 PARTIAL / iter-180 PARTIAL / iter-181 DEFERRED
- Recurring blocker: "gated on CodimOneExtension `extend_of_codimOneFree_of_smooth` body"
- STRATEGY.md row "A.4.c.1 — Thm 3.2 assembly": `Iters left ~8–14`; gated. iter-181 rejected progress-critic's codim-≥2 corrective with rationale (codim-≥2 already top-level exposed).

### Route 5b — `Albanese/CodimOneExtension.lean`

- Last 5: iter-177 3; iter-178 3 (Path D2 structural advance); iter-179 3; iter-180 3; iter-181 3 (deferred)
- Helpers: iter-178 1 named substantive
- Recurring blocker: "Stacks 00TT + coheight-to-Krull-dim Mathlib gaps"
- STRATEGY.md row "A.4.a — Lemma 3.3 codim-1": `Iters left ~40–80`; `~1500–2500 · gated`. Dominant Route-A risk.

### Route 5c — `Albanese/AuslanderBuchsbaum.lean`

- Last 5: iter-177 6; iter-178 6; iter-179 5 (Lane F substantive structural advance); iter-180 4 (Lane H `Module.depth` body kernel-clean); iter-181 4 (Lane G structural)
- Helpers: iter-178 1; iter-179 1; iter-180 0 (kernel-clean); iter-181 1 substantive `length_le_ringKrullDim_of_isRegular` axiom-clean
- Statuses: iter-179 PARTIAL / iter-180 SUCCESS / iter-181 PARTIAL
- Recurring blocker: "`IsRegularLocalRing → IsDomain` not in Mathlib" (Stacks 00NQ)
- STRATEGY.md row "A.4.b": `Iters left ~12–20`; `~500–700 · gated`.

### Route 5d — `Albanese/AlbaneseUP.lean`

- 7 sorries each, no work in window; standing deferral iter-200+

### Route 6 — `Genus0BaseObjects/Points.lean` (`gm_grpObj`)

- Last 5: 2 → 2 → 2 → 2 → 0 (CLOSED iter-181)
- Statuses: iter-181 SUCCESS kernel-clean
- **FULLY RESOLVED iter-181** — 11-iter STUCK pattern broken. No further iter-182 work on this route.

## STRATEGY.md context

(`Iters left` quoted verbatim from STRATEGY.md `## Phases & estimations` rows; only relevant rows.)

## Planner's PROPOSAL for iter-182 prover dispatch (objective list)

Working set under consideration (still being scoped):

1. `RiemannRoch/RationalCurveIso.lean` — Pin 2 BODY (post plan-phase refactor on signature)
2. `RiemannRoch/OCofP.lean` — `lineBundleAtClosedPoint` or `toFunctionField` body (if mathlib-analogist returns recipe)
3. `Genus0BaseObjects/GmScaling.lean` — `cross01` body (if chart-1-section analogist lands recipe)
4. `AbelianVarietyRigidity.lean` — `iotaGm_range_isOpen` body (coordinated with #3)
5. `Picard/RelativeSpec.lean` — `pullback_iso_construction` body (5-helper recipe in iter-181 task_result)
6. `Picard/QuotScheme.lean` — `_of_isAffineOpen_of_isAffineBase` body OR Mayer-Vietoris helper #2 body
7. `Albanese/AuslanderBuchsbaum.lean` — `exists_isRegular_of_regularLocal` body (if mathlib-analogist returns recipe) OR pivot to `depth_of_short_exact`

Plus plan-phase write-capable subagents (not prover lanes):

- `refactor pin2-sig-strengthen` — refactor Pin 2 signature in RationalCurveIso.lean per lean-vs-blueprint-checker iter-181 must-fix-this-iter
- `blueprint-writer ratcurveiso-pin3-prose` — Pin 3 chapter prose + canonical [Algebra K(C') K(C)] instance docs + add `\lean{...}` pin for OCofP toFunctionField

## Required output

Per-route CONVERGING / CHURNING / STUCK / UNCLEAR with named corrective.
Dispatch sanity: am I over/under-dispatching given the cap of 10 lanes?
Specifically: should Lane H (RRFormula) be re-attempted this iter despite the
`OcOfD.lean` file not existing yet, or is the right corrective to schedule
opening that file as a file-skeleton lane instead?
