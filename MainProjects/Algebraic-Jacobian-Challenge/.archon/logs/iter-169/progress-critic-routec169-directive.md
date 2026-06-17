# progress-critic — Route C convergence check after iter-168

## Slug
routec169

## Active route under review
Route C — genus-0 base case `ℙ¹ → A const` via the `𝔾_m`-scaling shortcut.

Active files this iter (the planner is considering for iter-169 prover dispatch):
1. `AlgebraicJacobian/Genus0BaseObjects.lean` — depth-conversion drill on `gmScalingP1` body via `mathlib-analogist gmscaling-deep` 6-step recipe.

## Strategy-snapshot for Route C
Per `STRATEGY.md` § "Phases & estimations" row "genus-0 rigidity":
- **Iters left**: ~5–12
- **LOC remaining · realized/it**: ~1500–3500 · base-case infra +~390 LOC iter-165
- **Key Mathlib needs**: `σ_×:ℙ¹×𝔾_m→ℙ¹` scaling action; concrete ℙ¹/𝔾_m group objects; density+separated; genus-0⟹ℙ¹ RR bridge
- **Risks**: scaffold landed; RR bridge `genusZero_curve_iso_P1` (no Mathlib RR) is now the long pole

Route C entered the "concrete ℙ¹/𝔾ₘ + `gmScalingP1` scaffold landed" phase at iter-165.
Elapsed since: iter-166, iter-167, iter-168 = 3 iters in this phase. iter-169 = 4th.

## Signals — last 4 iters

### iter-165
- Status: COMPLETE (skeleton landing). 4/4 base objects, 9 scaffold sorries opened (the new scaffold).
- Sorry count (G0BO): N/A → 9.
- Helpers added: 4 axiom-clean base objects + 3 ℙ¹-points + scaffold structure.
- Blocker phrase: none — clean skeleton.
- Verdict-impact: PROCEED.

### iter-166
- Status: PARTIAL (AVR refactor + scaffold-close).
- AVR closed `morphism_P1_to_grpScheme_const` + `rigidity_genus0_curve_to_grpScheme` body (with 5 helper sorries propagating).
- G0BO closed 3 of 7 plan-flagged scaffold sorries (3 ℙ¹-points axiom-clean).
- Sorry count: AVR 3→6 (carrying new helper sorries inside the body); G0BO 9→6.
- Blocker phrase: instance synthesis at V/W slots; deferred bodies of `gm_grpObj`, `gmScalingP1`, `gmScalingP1_collapse_at_zero`.

### iter-167
- Status: PARTIAL.
- AVR Lane B PRIMARY done: all 5 in-line `sorry`s in `morphism_P1_to_grpScheme_const_aux` eliminated; 4 closed by `infer_instance` after Lane A export landings; 1 hoisted to a named top-level `iotaGm_isDominant` (1 sorry, gated on Lane A).
- G0BO Lane A: 4 new axiom-clean exports (`projGm_locallyOfFiniteType`, `projGm_geomIrred`, `gmRing_isDomain`, `gm_irreducibleSpace`) + 3 NEW honest-scaffold-sorry exports (`projectiveLineBar_isReduced`, `gm_geomIrred`, `projGm_isReduced`). G0BO sorry footprint 6→9.
- Global sorry: 15→14 (-1).
- Blocker phrase: 2 CRITICAL deferred (`gmScalingP1`, `gmScalingP1_collapse_at_zero` bodies); `gm_grpObj` (3-iter deferred, escalation watch).
- progress-critic `routec168` verdict: **CHURNING** with 3 must-fix items.

### iter-168
- Status: PARTIAL (per iter-168 plan PARTIAL criterion).
- G0BO Lane A: closed Step 1 (`projectiveLineBarAffineCover`, axiom-clean, ~15 LOC) + Step 3 (`projectiveLineBar_isReduced`, axiom-clean, sidesteps the iso entirely via `IsReduced.of_openCover` + `Function.Injective.isDomain`). Step 2 (`homogeneousLocalizationAwayIso`) PARTIAL — forward direction + `aux_right` axiom-clean, `aux_left` round-trip is a residual `sorry`. Steps 4-6 (`gmScalingP1` body) + Step 7 (collapse-at-zero body) NOT attempted.
- Net sorry change: G0BO 9→9 (substitution: closed `projectiveLineBar_isReduced` L522 → axiom-clean; added `aux_left` L368 sorry). AVR 2→2. Global 14→14.
- Helpers added: ~370 LOC of new infrastructure (cover + 4 helper ring-homs + iso skeleton + axiom-clean `projectiveLineBar_isReduced`).
- Blocker phrase: "Time-budget decision: with Steps 1, 2-skeleton, 3 landing, did not have budget to attempt Steps 4-6 this iter."
- 4 of 5 plan-flagged PRIMARY targets met (Step 1 axiom-clean, Step 2 partial-skeleton, Step 3 axiom-clean, Steps 4-7 not attempted).

## Per-iter sorry/helper deltas (4-iter window for Genus0BaseObjects.lean + the AVR consumer chain)

| iter | G0BO sorries | AVR sorries (Lane B) | Total | Helpers added | Status |
|---|---|---|---|---|---|
| iter-165 entry | — | 7 | 15 | scaffold | COMPLETE skeleton |
| iter-165 exit | 9 | 7 | 15 | 4 base objects + 3 points | COMPLETE |
| iter-166 exit | 6 | 6 | 15 | 3 ℙ¹-points + AVR body | PARTIAL |
| iter-167 exit | 9 | 2 | 14 | 4 Lane A axiom-clean + 3 Lane A scaffold + AVR helper closure | PARTIAL |
| iter-168 exit | 9 | 2 | 14 | cover + iso skeleton + reduced | PARTIAL |

## Iter-168 plan's commitment for iter-169 (verbatim)
> Target body landing = **iter-168** (full transcription) OR **iter-169** (after iter-168 lands ≥steps 1+2). 4th consecutive deferral triggers user-escalation iter-169.

Iter-168 landed Step 1 axiom-clean but Step 2 only PARTIAL (`aux_left` residual). The "≥steps 1+2 axiom-clean" gate is not strictly met. The 4th-deferral trigger is technically ARMED for iter-169.

## Iter-168 prover's recommendation (verbatim)
> 1. **Close `aux_left`** via the "surjective + cancel" route...
> 2. **Alternative**: skip the iso entirely for Steps 4-6 — use the direct `Proj.fromOfGlobalSections` route from the chart-side ring maps `MvPoly (Fin 2) kbar → Away 𝒜 (X i) ⊗ GmRing` (sending `X i ↦ 1` for the irrelevant condition). This may be cleaner overall and would not require the iso to be axiom-clean.
> 3. **Tackle Steps 4-6 + 7** with the chosen route.

## Question for the critic

Is Route C still CONVERGING/CHURNING/STUCK after iter-168? Key considerations:

(a) iter-168 landed 2 axiom-clean substantive declarations (Step 1 + Step 3) — concrete depth-conversion, not just helpers.
(b) The headline target `gmScalingP1` body is still `sorry` — 4th consecutive iter.
(c) The plan committed to iter-169 closing the body OR escalating.
(d) The prover surfaced an alternative route (Option B: direct `Proj.fromOfGlobalSections`) that sidesteps `aux_left`.

If CONVERGING/UNCLEAR: confirm + recommend whether the planner should commit to Option A (close `aux_left` → iso → Steps 4-7) or Option B (pivot to direct route, drop the iso skeleton), and whether iter-169 PRIMARY = "land `gmScalingP1` body" is the right scope.

If CHURNING: name the corrective. Is the right corrective (i) close `aux_left` this iter, (ii) pivot to Option B, (iii) escalate the strategic question to the user (deferred 4 iters), or (iv) re-blueprint the chart-ring iso sub-build?

If STUCK: route-pivot is on the table. Name the alternative.

Please also re-evaluate the previously flagged "must-fix #2 — bounded decomposition commitment": iter-168 landed Steps 1 + 3 axiom-clean + Step 2 partial. Does that satisfy the bounded commitment, or does it count as another helper round?
