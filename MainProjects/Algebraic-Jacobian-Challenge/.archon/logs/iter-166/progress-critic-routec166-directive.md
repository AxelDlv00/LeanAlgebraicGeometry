# progress-critic directive (iter-166, slug `routec166`)

## Task

Per-route convergence audit of the genus-0 base case (Route C / 𝔾_m-scaling shortcut)
ahead of the iter-166 prover dispatch. The planner is deciding whether to fire two
parallel lanes — `AbelianVarietyRigidity.lean` refactor + proof close, and
`Genus0BaseObjects.lean` body closes. The iter-164 critic gave Route C as `CONVERGING`
with a watch tripwire for iter-166: "if iter-166 does not show the AVR refactor / proof
body started, verdict flips to `CHURNING`." We need a fresh read on whether
the planner's iter-166 lane choice avoids the tripwire and whether the route is still
converging given the iter-165 signals.

## Routes and last-K signals (K = 5, iter-161 through iter-165)

### Route C — genus-0 base case via 𝔾_m-scaling shortcut

**Active files:** `AlgebraicJacobian/AbelianVarietyRigidity.lean`,
`AlgebraicJacobian/Genus0BaseObjects.lean` (NEW iter-165),
`AlgebraicJacobian/Jacobian.lean` (consumer; gated).

**Bare-sorry counts per iter (project-wide):**

| Iter | Sorries | Δ | Notes |
|------|---------|----|-------|
| 161  | 6 | — | Rigidity chain Step-1 closed |
| 162  | 6 | 0 | chain closed axiom-clean (whole Rigidity Lemma proven) |
| 163  | 6 | 0 | Cor 1.5 + Cor 1.2 closed axiom-clean |
| 164  | 6 | 0 | hygiene + route resolution; AVR.tex chapter HARD-GATE cleared |
| 165  | 15 | +9 | NEW file `Genus0BaseObjects.lean` (4 main objects defined; 9 plan-allowed scaffold sorries; build green) |

**Helpers added per iter:**

| Iter | New named decls (project-side) | Lemma / def / instance count |
|------|--------------------------------|------------------------------|
| 161  | 5 connective lemmas in chain | 4 lemmas + 1 instance |
| 162  | `isIntegral_of_retract`, `rigidity_eqAt_closedPoint_…` | 2 lemmas (close Step-1) |
| 163  | `hom_additive_decomp_of_rigidity` (Cor 1.5), `av_regularMap_isHom_of_zero` (Cor 1.2) | 2 lemmas (axiom-clean) |
| 164  | (hygiene) signature lightening on Cor 1.5/Cor 1.2 | 0 new decls; docstring + instance refresh |
| 165  | NEW file: `ProjectiveLineBar`, `Ga`, `Gm`, `gmScalingP1` + 5 axiom-clean Mathlib bridges + 1 proven `projectiveLineBar_isProper` + 9 scaffold sorries | 4 main objects + 13 instances/defs (9 plan-allowed scaffolds) |

**Prover statuses (file-level) per iter:**

| Iter | Lane | Status | Headline |
|------|------|--------|----------|
| 161  | AVR.lean | COMPLETE | Step-1 chain closure |
| 162  | AVR.lean | COMPLETE | Rigidity Lemma whole-chain closed |
| 163  | AVR.lean | COMPLETE | Cor 1.5 + Cor 1.2 proven |
| 164  | AVR.lean | COMPLETE (hygiene) | docstring refresh + Cor 1.5/1.2 instance lightening |
| 165  | Genus0BaseObjects.lean (NEW) | PARTIAL (4/4 main objs, 3/4 axiom-clean primary instances, 9 scaffold sorries) | depth-conversion scaffold landed |

**Recurring blocker phrases:** none — no "Mathlib doesn't have it" / "deferred to next iter
because X" / "couldn't unify" patterns across iters 161–165. The iter-165 PARTIAL
outcome is plan-allowed (the PARTIAL gate scorecard explicitly authorized scaffold
sorries on `gmScalingP1`, `gmScalingP1_collapse_at_zero`, `gm_grpObj`, etc., naming them
as iter-166 lanes).

### STRATEGY current estimate for Route C base-case sub-phase

From `STRATEGY.md` `## Phases & estimations` (iter-164 cell, unchanged iter-165):

| Phase | Status | Iters left | LOC (remaining · realized/it) | Risks |
|---|---|---|---|---|
| genus-0 rigidity | Rigidity chain + Cor 1.5 + Cor 1.2 CLOSED axiom-clean; base case route RESOLVED = 𝔾_m-scaling shortcut | ~10–18 | ~2000–4000 · chain+Cor done, base-case 0/it | concrete ℙ¹/𝔾_m + σ_× new infra (elementary, char-free); RR bridge has no Mathlib support |

Phase entered current sub-phase iter-164 (route resolution). Elapsed in this sub-phase:
2 iters (164, 165). Iters left (per STRATEGY): 10–18.

### Planner's iter-166 `## Current Objectives` proposal

TWO parallel prover lanes:

1. **`AlgebraicJacobian/AbelianVarietyRigidity.lean`** —
   - `import AlgebraicJacobian.Genus0BaseObjects`;
   - refactor `morphism_P1_to_grpScheme_const` (currently L927-936, abstract `P1`-proxy)
     to the concrete `ProjectiveLineBar`-signature (statement becomes "for all
     `f : ProjectiveLineBar ⟶ A`, ∃ `a₀`, `f = toUnit ≫ a₀`");
   - prove its body via the proven `hom_additive_decomp_of_rigidity` (Cor 1.5) +
     `gmScalingP1_collapse_at_zero` (as `_hf`) + density `Gm ⊆ ProjectiveLineBar` +
     `ext_of_eqOnOpen` (proven, `Rigidity.lean`) — full proof chain detailed in
     blueprint `prop:morphism_P1_to_AV_constant` (AVR.tex L1199-1278);
   - refactor `genusZero_curve_iso_P1`'s target to `ProjectiveLineBar` (so
     `rigidity_genus0_curve_to_grpScheme` can transport via the iso).

2. **`AlgebraicJacobian/Genus0BaseObjects.lean`** — close the LIVE-CONSUMER scaffold
   sorries that Lane 1 references as black boxes:
   - `gm_grpObj` (`GrpObj.ofRepresentableBy` with units functor; consumed by Cor 1.5);
   - `gmScalingP1` body (chartwise glue via `Scheme.Cover.glueMorphisms`);
   - `gmScalingP1_collapse_at_zero` body (chart-level computation);
   - `ProjectiveLineBar.zeroPt` body (`Proj.awayι ≫ Spec.map` for `[0 : 1]`);
   - optionally: `ProjectiveLineBar.onePt`, `ProjectiveLineBar.inftyPt`, the GeometricallyIrreducible
     + SmoothOfRelativeDimension 1 sub-builds if time permits.

Lane 1 and Lane 2 are file-disjoint (parallel-safe). Lane 1's proof body uses Lane 2's
signatures as black boxes — even if Lane 2 ships PARTIAL, Lane 1's theorem still
type-checks (propagates `sorryAx` through the upstream scaffolds until they close).

## Questions for the critic

1. **Watch-tripwire compliance.** The iter-164 critic's tripwire was "iter-166 must
   show AVR refactor / proof body started, else CHURNING." Does the planner's
   2-lane dispatch (Lane 1 = the AVR refactor + proof body) satisfy the tripwire?
   If yes, certify Route C as CONVERGING. If no — i.e. you read Lane 1 as still
   "scaffolding"-shaped or planner is dispatching a 3rd cosmetic round — name the
   gap.

2. **Lane count.** Is 2 parallel lanes the right count, or would you recommend 1
   sequential lane (Lane 2 first to unblock Lane 1)? Note that the AVR signature
   refactor only consumes Lane 2's SIGNATURES (already landed iter-165), not the
   bodies, so the lanes are formally independent.

3. **Reversal signal.** If Lane 1 fails (the proof body of
   `morphism_P1_to_grpScheme_const` does not close this iter), what is the cheapest
   signal that the route needs corrective action? My read: a Lane 1 failure with
   blocker phrase "instance synthesis at the V/W slots of Cor 1.5" would suggest
   the abstract→concrete refactor is the issue, not the math.

4. **Iters-left consistency check.** STRATEGY says ~10–18 iters left for genus-0
   rigidity at ~chain+Cor done, base-case 0/it velocity. iter-165 added 4 main
   objects + 13 instances/defs — that's a substantial velocity jump (from 0/it to
   ~17 instances/defs). Should the planner re-estimate? My read is yes: if Lane 1
   closes iter-166 and Lane 2 mostly closes iter-167, the base case is done in
   ~3 iters from iter-164's route-resolution — well under 10. But the
   `genusZero_curve_iso_P1` Riemann-Roch sub-build remains, which the STRATEGY
   row already flags as "RR bridge has no Mathlib support".

## Required output sections

- `## Verdict per route` — CONVERGING / CHURNING / STUCK / UNCLEAR for Route C.
- `## Tripwire compliance` — answer Q1 explicitly (yes/no + the evidence).
- `## Lane count` — answer Q2.
- `## Reversal signals` — answer Q3.
- `## Iters-left re-estimation` — answer Q4 (recommend a refresh number or "keep").
- `## Recommended correctives (if non-CONVERGING)` — name the corrective TYPE
  (blueprint expansion / Mathlib-idiom consult / structural refactor / route pivot);
  the planner picks the matching subagent.
