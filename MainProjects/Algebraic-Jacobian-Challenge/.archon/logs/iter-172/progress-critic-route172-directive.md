# Progress-critic directive (iter-172)

## Slug
route172

## Context

Multi-route convergence audit. Three routes are live; assess each.

## K = last 4 iters of signals per route

### Route 1: genus-0 base case (`Genus0BaseObjects.lean` — `gmScalingP1` body + supports)

- **STRATEGY.md row**: `genus-0 rigidity` — `gmScalingP1` body + collapse-at-zero. `Iters left ~3-5; ~200-270 LOC remaining · ~80/it realized`. Phase entered iter-165.
- **Elapsed in current phase**: iter-165 → iter-171 = 7 iters.
- **Signals last 4 iters (iter-168 → iter-171)**:
  - **iter-168**: 4 axiom-clean Lane A exports landed + 3 honest-scaffold-sorry exports. `gm_grpObj` 3rd-iter deferral. PARTIAL.
  - **iter-169**: armed-trigger ESCALATION fired. Three independent routes attempted; each hit a Mathlib gap. NO body landed. `ga_grpObj` + `ga_smooth` DELETED. PARTIAL (no body).
  - **iter-170**: lane died to API-500 with 0 file edits before body-first test ever ran. ERROR.
  - **iter-171**: armed-trigger re-attempted per iter-170 reviewer recommendation. **Body skeleton LANDED**: `gmScalingP1` (L742) is now concrete `Over.homMk ((cover).glueMorphisms ...)`. THREE named internal scaffold sorries factored: `gmScalingP1_chart` (L695), `gmScalingP1_chart_agreement` (L705), `gmScalingP1_over_coherence` (L721). SECONDARY: `homogeneousLocalizationAwayIso_aux_left` rewritten via cancel-surjective, depending on new helper `mvPolyToHomogeneousLocalizationAway_surjective` (L372). `algebraKbarAway` instance + 2 chart ring-maps axiom-clean. PARTIAL (body-skeleton acceptance per iter-171 plan).
- **Sorry counts on `Genus0BaseObjects.lean`**: iter-168 9 → iter-169 8 (deleted `ga_grpObj`) → iter-170 8 (no edits) → iter-171 10 (net +2 from body-skeleton scaffolding split).
- **Recurring blocker phrases**: none anymore — iter-171 broke the 5-iter "build supports / defer body" pattern.
- **Iter-171 lean-vs-blueprint-checker `g0bo171`**: PASS. 13 pinned signatures match.

### Route 2: Route A.1 (Picard `RelativeSpec.lean` file-skeleton)

- **STRATEGY.md row**: `Route A.1 — Relative Picard / line-bundle pullback`. `Iters left ~6-10; ~700-1100 LOC · ~0/it`. Phase entered iter-171 plan dispatch.
- **Elapsed in current phase**: 1 iter (iter-171 only).
- **Signals last 4 iters**:
  - iter-168 → iter-170: NO PROVER DISPATCH (Route A had zero dispatch for 5 consecutive iters per iter-171 progress-critic `route171` finding).
  - iter-171 plan-phase: `blueprint-writer route-a1-decompose` dispatched twice (first failed; retry killed mid-write). **Picard_RelativeSpec.tex DOES NOT EXIST on disk**.
  - iter-171 prover phase: no prover lane on A.1.
- **Recurring blocker phrase**: "blueprint-writer didn't land".
- **Sorry counts**: N/A (file doesn't exist).

### Route 3: RR.1 (`RiemannRoch/WeilDivisor.lean` file-skeleton)

- **STRATEGY.md row**: `genus-0 RR bridge — genusZero_curve_iso_P1 (in-tree sub-build COMMITTED)`. `Iters left ~12-20; ~1500-2500 LOC · ~0/it`. Phase entered iter-171 plan dispatch.
- **Elapsed in current phase**: 1 iter.
- **Signals last 4 iters**:
  - iter-168 → iter-170: deferred (upstream-Mathlib option).
  - iter-171 plan-phase: `blueprint-writer rr-bridge-subbuild` LANDED successfully — `RiemannRoch_WeilDivisor.tex` exists (445 LOC, 9 `\lean{...}` pins).
  - iter-171 prover phase: no prover lane on RR.1.
- **Sorry counts**: N/A (file doesn't exist yet).

## Iter-172 PROGRESS.md `## Current Objectives` proposal

1. **`Genus0BaseObjects.lean`** — multi-sorry Lane A continuation:
   - PRIMARY 1: close `mvPolyToHomogeneousLocalizationAway_surjective` (L372, ~60-80 LOC via `Away.adjoin_mk_prod_pow_eq_top` at d=1).
   - PRIMARY 2: close `gmScalingP1_over_coherence` (L721, mechanical via `Scheme.Cover.hom_ext`).
   - PRIMARY 3: close `gmScalingP1_chart kbar i` (L695, ~30 LOC per chart via `pullbackSpecIso ≫ Spec.map _ ≫ Proj.awayι`; gated on PRIMARY 1 closing `aux_left` axiom-clean).
   - SECONDARY: `gmScalingP1_chart_agreement` (L705, cocycle once chart morphisms land).
2. **`RiemannRoch/WeilDivisor.lean`** — NEW file-skeleton Lane C (scaffold from `RiemannRoch_WeilDivisor.tex`). 9 declarations stubbed with `sorry`. Pending blueprint-reviewer HARD GATE clearance scoped to RR.1 chapter this iter (same-iter fast path).
3. **`Picard/RelativeSpec.lean`** — NEW file-skeleton Lane B (scaffold from `Picard_RelativeSpec.tex`). Pending re-dispatch of `blueprint-writer route-a1-retry2` landing the chapter THIS iter + scoped blueprint-reviewer HARD GATE clearance (same-iter fast path). DROPPED if writer fails for the third time.

## Asks

1. Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR).
2. For Route 1: does the iter-171 body-skeleton landing satisfy CHURNING-reversal? Or are the 3 named internal sorries another helper-churn pattern in disguise?
3. For Routes 2/3: dispatch-sanity check on the iter-172 lane proposal.
4. Specific corrective if any verdict is CHURNING / STUCK.
5. Any `Iters left` estimate that no longer matches the realized velocity.
