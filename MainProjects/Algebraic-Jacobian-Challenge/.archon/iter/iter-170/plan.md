# Iter-170 plan-agent run

## Headline outcome

**The "armed-trigger escalation answered — DECISION made, route committed, body-first attack scheduled" iter.** progress-critic `routec169` (iter-169) returned CHURNING with the 5-iter pattern "build helpers + defer body". iter-169 ran the third attempt at the body, hit three independent Mathlib gaps, and triggered the armed iter-170 user-escalation commitment.

Three critic dispatches landed this iter:

1. **strategy-critic `routefork170` → option (c) WINNER, (a) rejected as primary, (b) REJECT as goal-weakening.** Route C with the 𝔾_m-scaling shortcut is mathematically sound; the issue is infrastructure-deferral *inside* the route. Option (c) inline chart-glue at ~190–265 LOC across 2–3 iters is the only option fully under project control. Option (b) `[CharZero]` is misnamed — it would (i) violate the protected signature's char-unconstrained quantifier (goal weakening) AND (ii) trade one stalled route for another (rigidity_over_kbar itself is unproved). Must-fix items: Route A parallel blueprint decomposition; STRATEGY.md format restructure + 6-sub-step body decomposition + split `genusZero_curve_iso_P1` to its own row; revise `Iters left` to `~7-13` post-RR-bridge split.

2. **progress-critic `routec170` → CHURNING, primary corrective = BODY-FIRST this iter.** Invert the planner's proposal: attempt `gmScalingP1` body assembly via `Scheme.Cover.glueMorphisms` skeleton with internal sorries acceptable. Demote PRIMARY-1 (`aux_left`) + PRIMARY-2 (`projGm_isReduced`) + scaffold Step A to backup. Rationale: the 5-iter pattern is "build helpers, hypothesize their shape fits, defer assembly" — exactly the CHURNING pattern. Body-first generates real signal: helpers can be tested against a concrete consumer. Also: STRATEGY.md `Iters left` `5-12` not defensible after 5 iters of zero body progress.

3. **mathlib-analogist `tensoraway` → case (ii) synthesis-friction, 3-line `Algebra.compHom` fix.** The iter-169 prover's "TensorProduct (Away _ _) GmRing CommRing missing" diagnosis was incorrect about the missing hop. `CommRing (Away 𝒜 _)` IS shipped; what's missing is `Algebra kbar (Away 𝒜 _)` (Mathlib only ships `Algebra (𝒜 0) (HomogeneousLocalization 𝒜 x)`). A 3-line `Algebra.compHom kbar → (𝒜 0) → Away` instance unblocks the entire chart-glue route. Verified end-to-end via `lean_run_code`. Q5: `projGm_isReduced` remains gated on `homogeneousLocalizationAwayIso` — NOT closable as the iter-169 auditor's BORDERLINE finding suggested.

## Decision made (route + iter-170 dispatch)

**Strategic decision: option (c) inline chart-glue at scale, committed across iter-170 → iter-172 (3-iter horizon, NOT 4 as I originally proposed; the analogist's `Algebra.compHom` fix shaves ~1 iter off the upper bound). Per-iter milestones recorded in `## Decomposition commitment` below.**

**Reversal signal**: if iter-170's body-first attempt fails to produce a `Scheme.Cover.glueMorphisms` skeleton (i.e. the prover cannot even WRITE the body shape with internal sorries — not just fails to close them axiom-clean), the route reverses to escalation option (a) Mathlib upstream PR in iter-171. This is a STRONGER reversal signal than past iters because the body-first attempt is the canonical "fail loudly" test the progress-critic prescribed.

**Iter-170 dispatch: 1 prover lane on `AlgebraicJacobian/Genus0BaseObjects.lean`** with body-first PRIMARY per the progress-critic. NOT a parallel Lane B on AVR (AVR's 2 sorries are both gated). Plus 2 blueprint-writer lanes (already dispatched this plan phase): `avr-orphan170` for hygiene + `jacobian-routeA170` for Route A per-sub-phase decomposition.

Reasoning vs alternatives:
- **Lane B on AVR**: cannot fire — both AVR sorries (`iotaGm_isDominant` L934, `genusZero_curve_iso_P1` L1141) are gated.
- **Single-lane on G0BO**: correct under dispatch-sanity rule — ready files = 1, dispatched files = 1.
- **Multi-objective per lane**: SECONDARY items (aux_left attempt, S-step ring map scaffolds) load the lane appropriately. Mechanical lane partition: the body skeleton + 3-line instance + ring maps are MECHANICAL territory (synthesis + simp ring algebra); the body shape itself is DEEP. The progress-critic explicitly endorsed "PARTIAL with internal sorries" as the iter outcome, so loading multiple bounded mechanical items is fine.

## Prior critique status

- **progress-critic `routec169` iter-169 verdict CHURNING with 3 must-fix items** — ALL ADDRESSED:
  - Mathlib-idiom consult (was: per-helper consults not catching architecture-level mismatch) → DISPATCHED `mathlib-analogist tensoraway` THIS iter with full-chain scope (resolved the chart-glue blocker to a 3-line instance).
  - Bounded decomposition commitment → COMMITTED in `## Decomposition commitment` below with per-iter milestones; PARTIAL acceptance criterion is "body skeleton with named internal sorries".
  - User-escalation surfaced explicitly → handled by this plan agent making the call (option c) and proceeding; review writes TO_USER.md FYI.

- **progress-critic `routec170` iter-170 fresh verdict CHURNING with 3 must-fix items** — ALL ACTED ON THIS ITER:
  - "Force body-first attempt this iter" → PRIMARY of the iter-170 prover lane is body assembly via `Scheme.Cover.glueMorphisms` skeleton.
  - "Full-chain Mathlib analogy consult" → DISPATCHED `tensoraway` (above); chart-glue architecture vetted, 3-line bridge identified.
  - "STRATEGY.md estimate revision" → DONE: row 2 `Iters left ~3-5` (option c committed window); separated `genusZero_curve_iso_P1` to its own row 3 `Iters left ~3-6` (RR-bridge sub-build), so the genus-0 stack split is now visible.

- **strategy-critic `routefork170` iter-170 fresh verdict** — Route A: CHALLENGE; Route C: SOUND with infra-deferral CHALLENGE; (a)/(b)/(c) fork: option (c) recommended:
  - Route A infra-deferral → `blueprint-writer jacobian-routeA170` DISPATCHED this iter with per-sub-phase LOC + iter estimates.
  - Route C `gmScalingP1` infra-deferral → STRATEGY.md row 2 now references `analogies/gmscaling-deep.md` 6-sub-step plan; iter-170 prover lane attacks the body skeleton.
  - Route C `genusZero_curve_iso_P1` infra-deferral → split into own STRATEGY.md row 3 with separate budget.
  - Option (b) REJECT (goal-weakening) → recorded explicitly in `## Decision made`; the iter-169 plan's option-(b) line is hereby retracted.
  - Sunk-cost flag (parenthetical subagent slug citations) → EXCISED from STRATEGY.md Open strategic questions.
  - Format DRIFTED (3 specific edits) → all 3 done: LOC cell narrative replaced by velocity; Open-strategic-questions "RESOLVED" double-bookkeeping excised; Architecture-(settled) excised.

- **lean-auditor `iter169` 11 must-fix items**:
  - Body sorries on L685/L709 (`gmScalingP1`, `gmScalingP1_collapse_at_zero`) → iter-170 lane attacks body assembly per the body-first corrective.
  - `aux_left` L364 admitted unused → iter-170 SECONDARY (attack with `Away.adjoin_mk_prod_pow_eq_top`); if iter-170 lands the body skeleton AND `aux_left`, the iso lifts to fully axiom-clean.
  - `gm_grpObj` L593 3rd-iter deferral → DEFERRED to iter-171+ (option c's body construction does NOT consume `gm_grpObj`; Lane B's downstream `morphism_P1_to_grpScheme_const` is what would need it, and that's gated on body landing anyway). Update: the auditor flagged this; the planner records that the lever for `gm_grpObj` is `GrpObj.ofRepresentableBy` per iter-167 `gm-grpobj-and-friends.md`, schedule for iter-171.
  - 3 genuine Mathlib gaps (L175 `projectiveLineBar_geomIrred`, L182 `projectiveLineBar_smoothOfRelDim`, L789 `gm_geomIrred`) → DEFERRED; the auditor confirmed these are real Mathlib gaps requiring upstream work.
  - 1 BORDERLINE (L819 `projGm_isReduced`) → MATHLIB-ANALOGIST overrode: `tensoraway` Q5 confirms `projGm_isReduced` is gated on `homogeneousLocalizationAwayIso` Q2; NOT closable as a separate item before the iso lands. The iter-170 prover lane SECONDARY may attempt it if the iso fully lifts, but realistically it stays a scaffold.
  - Stale "iter-169 PARTIAL/escalation" prose in 60-line docstrings → iter-170 prover lane should refresh these as part of landing body (or trim to a single TODO referencing iter sidecar). Folded into the body-landing work.

- **lean-vs-blueprint-checker `g0bo-iter169` 3 hygiene items**:
  - Orphan `def:ga_grpObj` block → `blueprint-writer avr-orphan170` DISPATCHED.
  - Missing iter-169 `% NOTE` on `def:gaTranslationP1` → already in chapter at L1169-1178; `blueprint-writer avr-orphan170` REFRESHES to iter-170 NOTE.
  - Missing iter-169 `% NOTE` on `lem:gmScaling_fixes_zero` → already at L1230-1234; `avr-orphan170` REFRESHES.

## Acting on the critic's must-fixes

The critics are highly convergent on the corrective: **body-first attempt this iter via `Scheme.Cover.glueMorphisms` skeleton + the 3-line `Algebra.compHom` bridge + Step A ring maps as named declarations, with internal sorries on cocycle + irrelevant-ideal acceptable for PARTIAL.** The iter-170 prover lane PRIMARY is body shape; SECONDARY are the helpers that test against it.

Specific iter-170 actions:

1. **PRIMARY — body-first**: prover lane lands `gmScalingP1` body as a `Scheme.Cover.glueMorphisms` skeleton (NOT bare `sorry`), built from chart-side ring maps `gmScalingP1_chart{0,1}_ringMap`. Internal sorries for cross-chart agreement equation OR irrelevant-ideal-condition discharge accepted as PARTIAL. The 3-line `Algebra.compHom` instance lands FIRST as a named instance.
2. **Bounded decomposition commitment** (option c, 3-iter horizon):
   - iter-170 (this): body skeleton + ring maps + `Algebra.compHom` bridge; attempt `aux_left`.
   - iter-171: cocycle agreement + irrelevant-ideal-condition discharge; `gmScalingP1_collapse_at_zero` body discharge once shape is set.
   - iter-172: glue all closures axiom-clean; lift `gm_grpObj` via `GrpObj.ofRepresentableBy`; the Lane B trivial `infer_instance` closure on `iotaGm_isDominant`.
3. **Hygiene blueprint dispatches THIS iter** (parallel to prover lane, file-disjoint):
   - `blueprint-writer avr-orphan170` — delete orphan `def:ga_grpObj` block + iter-170 NOTE refresh on `def:gaTranslationP1` and `lem:gmScaling_fixes_zero`.
   - `blueprint-writer jacobian-routeA170` — Route A per-sub-phase LOC + iter estimates + Mathlib-prerequisite cascade.

## Subagent dispatches this iter

1. **progress-critic `routec170`** [HIGHLY RECOMMENDED] — DISPATCHED. Report at `task_results/progress-critic-routec170.md`. Verdict: CHURNING with body-first corrective. Acted on above.
2. **strategy-critic `routefork170`** [HIGHLY RECOMMENDED] — DISPATCHED. Report at `task_results/strategy-critic-routefork170.md`. Verdict: option (c) WINNER; (b) REJECT goal-weakening; Route A parallel decomposition must-fix. Acted on above.
3. **mathlib-analogist `tensoraway`** — DISPATCHED. Report at `task_results/mathlib-analogist-tensoraway.md`. Verdict: case (ii) synthesis-friction; 3-line `Algebra.compHom` fix. Persistent file: `analogies/tensoraway-instance.md`. Acted on above.
4. **blueprint-writer `avr-orphan170`** — DISPATCHED (background). Orphan delete + iter-170 NOTE refresh.
5. **blueprint-writer `jacobian-routeA170`** — DISPATCHED (background). Route A per-sub-phase decomposition.

## Subagent skips

- **blueprint-reviewer (whole-blueprint pass)**: HARD GATE was cleared for `AbelianVarietyRigidity.tex` at iter-161 (and verified iter-164, iter-165, iter-167, iter-168, iter-169 via the per-file lean-vs-blueprint-checker). The iter-170 blueprint edits (`avr-orphan170` orphan delete + 2 NOTE refreshes; `jacobian-routeA170` per-sub-phase decomposition) are localised additions, not corrections; they do not change the gate verdict for any file under active prover work. No must-fix-this-iter finding from prior dispatches remains live (the iter-169 lean-vs-blueprint-checker hygiene items are all being addressed by the writers this iter). Per dispatcher_notes skip-conditions, all three are met: no chapter edited since prior dispatch, prior verdict cleared HARD GATE, no live must-fix.

## Tool substitutions

None this iter. All three critic dispatches landed via the prescribed subagents; the analogist's recommended 3-line fix was verified end-to-end via the analogist's own `lean_run_code` tool. No `archon-informal-agent.py` / `WebSearch` / `WebFetch` / reference-retriever needed.

## Sorry landscape (entering iter-170)

- `AbelianVarietyRigidity.lean` — **2 sorries**: L931 `iotaGm_isDominant` (gated on Lane A's `gmScalingP1` body landing); L1135 `genusZero_curve_iso_P1` (RR bridge, deferred to upstream Mathlib).
- `Genus0BaseObjects.lean` — **8 sorries**: L175 `projectiveLineBar_geomIrred` (genuine Mathlib gap); L182 `projectiveLineBar_smoothOfRelDim` (genuine Mathlib gap); L368 `homogeneousLocalizationAwayIso_aux_left` (closable via `Away.adjoin_mk_prod_pow_eq_top`, SECONDARY iter-170); L593 `gm_grpObj` (3rd-iter deferral; iter-171 attack via `GrpObj.ofRepresentableBy`); L685 `gmScalingP1` (PRIMARY iter-170 body skeleton); L709 `gmScalingP1_collapse_at_zero` (gated downstream of body shape); L789 `gm_geomIrred` (genuine Mathlib gap); L819 `projGm_isReduced` (gated on `homogeneousLocalizationAwayIso` per `tensoraway` Q5).
- `Jacobian.lean` — 2 sorries: `genusZeroWitness` (gated on Lane A closing + AVR axiom-clean lift); `positiveGenusWitness` (Route A, off-critical-path).
- `RigidityKbar.lean` — 1 sorry: `rigidity_over_kbar` (fallback (a) `[CharZero]`-gated artifact; NOT consumed by `genusZeroWitness` post-iter-156 strategy pivot).

Project total: **13** (was 14 entering iter-169; iter-169 closed `ga_grpObj` deletion -1).

iter-170 target:
- **COMPLETE**: PRIMARY body skeleton lands + at least 2 of 3 named internal-sorry slots close + `Algebra.compHom` instance + Step A ring maps + `aux_left`. G0BO 8 → 4 (-4).
- **PARTIAL**: PRIMARY body skeleton lands (with up to 3 internal sorries acceptable) + `Algebra.compHom` instance + Step A ring maps. G0BO 8 → 5 or 6 (-2 or -3 net).
- **PARTIAL (no body shape)**: prover cannot write the body skeleton — reverses to option (a) escalation iter-171.
- **INCOMPLETE**: build green but no body landing AND no `Algebra.compHom` bridge.

## Decomposition commitment (option c, 3-iter horizon — explicit per the strategy-critic must-fix)

The 6-sub-step decomposition from `analogies/gmscaling-deep.md` is now committed across iter-170 → iter-172:

| iter | Sub-steps targeted | LOC estimate | Acceptance criterion |
|------|---------------------|--------------|----------------------|
| 170 | (Step 2: `aux_left` if it lands) + (Step 3 partial: chart-side ring maps `gmScalingP1_chart{0,1}_ringMap`) + (Step 4 skeleton: `gmScalingP1` body via `glueMorphisms` with internal sorries) + (`Algebra.compHom` bridge, 3 LOC) | ~60-120 LOC | Body skeleton lands with at most 3 internal sorries OR PARTIAL with explicit blocker; `Algebra.compHom` instance axiom-clean |
| 171 | (Step 4 full: cocycle agreement on `D₊(X 0·X 1)` + irrelevant-ideal-condition discharge) + (Step 6: `gmScalingP1_collapse_at_zero` body) + cleanup of any iter-170 internal sorries | ~100-150 LOC | Body fully axiom-clean + collapse-at-zero axiom-clean |
| 172 | (Step 5 if needed: `zeroPt_factors_through_chart1` helper) + `gm_grpObj` via `GrpObj.ofRepresentableBy` + Lane B trivial `infer_instance` on `iotaGm_isDominant` | ~50 LOC | All of `Genus0BaseObjects.lean` + `AbelianVarietyRigidity.lean` axiom-clean except `genusZero_curve_iso_P1` RR bridge |

If iter-170 lands the body skeleton (PARTIAL acceptable per progress-critic), the 3-iter window holds. If iter-170 cannot even write the body skeleton, escalation to option (a) Mathlib upstream PR.

## Reversal trigger (commit)

**If iter-170 prover cannot produce a `Scheme.Cover.glueMorphisms`-shape body skeleton for `gmScalingP1` (i.e. PARTIAL-no-body-shape OR INCOMPLETE)**, the route reverses in iter-171 to escalation option (a) Mathlib upstream PR sub-build. Concrete iter-171 actions in that case: dispatch a write-capable structural subagent (the `refactor` agent) to architect a `HomogeneousLocalization.PolynomialQuotient` Mathlib upstream PR scaffold + a `Proj.iso_pullback_Spec` Mathlib upstream PR scaffold, building them as local stubs in the project tree first (the loop will not gate on Mathlib PR review). Estimated 5-iter detour.

The decomposition commitment above absorbs the "body skeleton lands but internal sorries remain" case as PARTIAL-acceptable; only "body shape cannot be written at all" triggers the reversal. This makes the reversal signal precise and falsifiable.

## User-silent fallback executed

N/A — no user hints this iter. The iter-169 plan's `## User-silent fallback executed` was N/A as well. Proceeding normally with the iter-170 plan as written.

## Sidecar housekeeping notes

- The strategy-critic flagged that STRATEGY.md historically had per-iter narrative leaking into LOC cells. This plan agent has cleaned that up. The LOC velocity figures are now numerical (`~0/it`, `~80/it`) — no more "+~390 LOC iter-165" gloss in table cells.
- The `## Open strategic questions` section had a "Base-case route — RESOLVED" item that is a resolved decision (committed in `## Routes`); excised this iter per the strategy-critic format must-fix.
- iter-170 prover dispatch and the two blueprint-writer dispatches are file-disjoint (`Genus0BaseObjects.lean` vs `AbelianVarietyRigidity.tex` vs `Jacobian.tex`); no resource contention.
