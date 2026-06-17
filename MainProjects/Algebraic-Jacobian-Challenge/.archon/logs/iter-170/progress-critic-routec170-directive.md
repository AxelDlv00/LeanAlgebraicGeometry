# Progress-Critic Directive — Slug `routec170`

## Active route under scrutiny

**The genus-0 base case via the 𝔾_m-scaling shortcut**, headlined by the body of `gmScalingP1 : ℙ¹ × 𝔾_m → ℙ¹` in `AlgebraicJacobian/Genus0BaseObjects.lean`. iter-165 opened the scaffold; iter-166/167/168/169 each landed ~120-370 LOC of support infrastructure but never the body.

`AlgebraicJacobian/Genus0BaseObjects.lean` is the active file. `AlgebraicJacobian/AbelianVarietyRigidity.lean` is downstream of it but file-disjoint (its 2 remaining sorries are gated on either Lane A's `gmScalingP1` body landing or upstream Mathlib RR machinery).

## Last 5 iters' signals

| Iter | G0BO sorry count | New helpers added in G0BO | gmScalingP1 body status | Prover status |
|------|------------------|---------------------------|--------------------------|----------------|
| 165 | scaffold opened (+9 = 9) | 4 base objects + the 3 ℙ¹ points + `gmScalingP1` scaffold + `gmScalingP1_collapse_at_zero` scaffold | bare `:= sorry` (iter-165 scaffold) | PARTIAL (scaffold landed) |
| 166 | 9 (−3 + 3 = 0 net via Lane A 𝔾_m-shortcut closures) | 3 ℙ¹ points closed axiom-clean via `pointOfVec`; outer body of `morphism_P1_to_grpScheme_const` closed (sorryAx-propagating to 5 helper sorries on G0BO + RR bridge) | bare `:= sorry` | PARTIAL |
| 167 | 9 (+4 closed, +3 new) | 4 axiom-clean Lane B exports (`gmRing_isDomain`, `gm_irreducibleSpace`, `projGm_locallyOfFiniteType`, `projGm_geomIrred`); 3 scaffold-sorry exports (`projectiveLineBar_isReduced` [BORDERLINE], `gm_geomIrred`, `projGm_isReduced`) | bare `:= sorry` | PARTIAL |
| 168 | 9 (+1 closed `projectiveLineBar_isReduced` axiom-clean iter-168, +1 new `homogeneousLocalizationAwayIso_aux_left`) | Step 1 `projectiveLineBarAffineCover` axiom-clean; Step 3 `projectiveLineBar_isReduced` axiom-clean; Step 2 `homogeneousLocalizationAwayIso` iso skeleton with `aux_left` residual sorry; 5 helper ring-homs | bare `:= sorry` | PARTIAL (Steps 1+3 closed, Step 2 partial, Steps 4-7 not attempted) |
| 169 | 9 → 8 (−1 via `ga_grpObj` deletion; PRIMARY bodies unchanged) | None new — 4 hygiene items: docstring refreshes on `aux_left` + `projectiveLineBar_isReduced`, section-(E) header refresh, `ga_grpObj` deletion | bare `:= sorry` (3 routes attempted, all blocked) | PARTIAL (armed-trigger escalation) |

## Recurring blocker phrases

- "Mathlib does not ship..." (iter-166, iter-167, iter-168, iter-169)
- "Mathlib gap" or "Mathlib-side blocker" (iter-167, iter-168, iter-169 for multiple sub-declarations)
- "structural setup via..." / "scaffold partial" (iter-168, iter-169 for iso `aux_left`)
- "out of scope for this iter" / "LOC budget" (iter-167, iter-168 prover task results)
- "deferred to upstream Mathlib" (iter-168, iter-169 for RR bridge `genusZero_curve_iso_P1`)

## STRATEGY.md inputs

From `STRATEGY.md` row 2 (genus-0 rigidity):
- `Iters left`: `~5-12`
- `LOC (remaining · realized/it)`: `~1500-3500 · base-case infra +~390 LOC iter-165`
- Phase entered current state at iter-164 (decision: 𝔾_m-scaling shortcut). We are now at iter-170.

Elapsed since iter-164: 6 iters. Estimated remaining at iter-167: 5-12. Consistency check: `≈1500-3500 ÷ ~80/iter (averaged across iter-165-168 net G0BO LOC added per iter ≈ 80-100)` = ~15-44 iters. The STRATEGY.md estimate of 5-12 looks aggressive.

## The planner's iter-170 dispatch proposal

**1 file: `AlgebraicJacobian/Genus0BaseObjects.lean`** with the following objectives (PRIMARY = must-land; SECONDARY = optional / file-disjoint):

PRIMARY-1: Close `homogeneousLocalizationAwayIso_aux_left` (L364, the iso residual). Analogist `gmscaling-deep` (iter-168) gives the "cancel surjective" route via `Away.adjoin_mk_prod_pow_eq_top` (~30-60 LOC). Closing this lifts `homogeneousLocalizationAwayIso` to fully axiom-clean and unblocks the Step B chart-side scheme morphisms downstream.

PRIMARY-2: Close `projGm_isReduced` (L819, the BORDERLINE finding per lean-auditor `iter169`). Audit identifies this as closable via `IsReduced.of_openCover` over the pullback cover of `D₊(X i) × Gm` — same precedent as `projectiveLineBar_isReduced` closing iter-168 (~30-60 LOC).

SECONDARY-1: Scaffold Step A ring maps `gmScalingP1_chart1_ringMap` + `gmScalingP1_chart0_ringMap` as named declarations (~10-20 LOC each) per `analogies/gmscaling-deep.md` Q3. These are 1-shot ring-map constructions using `MvPolynomial.eval₂RingHom`.

NOT attempted: the `gmScalingP1` body itself (per the "no 5th-iter helper round" iter-169 commitment AND because Step B requires the iso to be fully axiom-clean first).

Decomposition commitment: this is option (c) inline chart-glue at scale, decomposed across 3-4 iters. iter-170 = aux_left + projGm_isReduced + scaffold Step A; iter-171 = complete Step A + start Step B; iter-172 = complete Step B + cross-chart agreement; iter-173 = `Scheme.Cover.glueMorphisms` to deliver the body.

## Specific questions

1. **Verdict per route.** Given the 5-iter pattern + the iter-170 lane proposal above, is the route CONVERGING / UNCLEAR / CHURNING / STUCK? Be specific about which of these signals tips your verdict.

2. **If CHURNING: corrective.** Is the corrective "stop adding helpers; pivot route" (per the standard CHURNING corrective)? Or is the new commitment (a bounded 3-4-iter decomposition with named per-iter milestones AND a strategy-critic-validated route decision) the right corrective? Be explicit whether decomposition WITH commitment counts as "helper churn" or as the structural fix to it.

3. **PRIMARY-1 + PRIMARY-2 escalation criteria.** If iter-170 lands BOTH PRIMARYs AND scaffolds Step A — is that decisive evidence of route-soundness, or do you require more? If iter-170 lands NEITHER PRIMARY, the route should escalate to option (a) [Mathlib upstream] or option (b) [accept `[CharZero]`]? Be specific about which signals decide.

4. **STRATEGY.md "5-12 iters" estimate review.** Is this defensible given the iter-165 → iter-170 actual velocity, or does it need a >30% downgrade (e.g. to 10-20 iters)?

## Strict context discipline reminder

This directive intentionally omits STRATEGY.md verbatim and the blueprint chapter — your value is fresh-context on the trajectory. The signals above are extracted; treat them as your only inputs.

Output to `task_results/progress-critic-routec170.md`.
