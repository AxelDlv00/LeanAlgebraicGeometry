# Progress-critic directive — slug `route173`

## Mode

Per-route fresh-context audit of recent prover trajectory. **Do NOT read** STRATEGY.md, blueprint chapters, iter sidecars in full, or anything outside what I extract below. My value is the convergence call; that depends on isolation from sunk-cost framing.

## K window

K = 5 iters (iter-168 through iter-172).

## Active routes this iter (iter-173)

### Route 1 — genus-0 rigidity / `gmScalingP1` body chain

Files: `AlgebraicJacobian/Genus0BaseObjects.lean`, `AlgebraicJacobian/AbelianVarietyRigidity.lean` (the latter is a downstream consumer; both sorries gated on Route 1 closing).

Phase entered: iter-164 (the 𝔾_m-scaling shortcut decision); `Iters left` in STRATEGY.md = `~4-7`.

Signal extraction (K=5):

- **Sorry counts** on `Genus0BaseObjects.lean` per iter:
  - iter-168: 10 (post iter-167 helper landings)
  - iter-169: 8 (close 2 of `gmScalingP1_chart{0,1}_ringMap`)
  - iter-170: 8 (Lane A died to API-500, 0 edits)
  - iter-171: 10 (body skeleton landing — splits 1 sorry into 3 named scaffold sorries; +1 aux helper sorry; net +2)
  - iter-172: 9 (PRIMARY 1 closed axiom-clean: `mvPolyToHomogeneousLocalizationAway_surjective`; unblocks `aux_left` + `homogeneousLocalizationAwayIso` propagation axiom-clean)
- **Helpers added per iter**: iter-168 +2 (algebra bridges); iter-169 +2 (chart ring maps); iter-170 +0 (API failure); iter-171 +5 (chart morphism scaffold + cocycle + over-coherence + cover + algebraKbarAway + aux_left rewrite); iter-172 +1 (surjectivity helper, BUT it closed `aux_left` propagation).
- **Prover statuses**: iter-168 PARTIAL; iter-169 PARTIAL; iter-170 INCOMPLETE (API-500); iter-171 PARTIAL-acceptable (body skeleton); iter-172 PARTIAL-low (PRIMARY 1 only).
- **Recurring blocker phrases**:
  - iter-168–169: "`Algebra` synthesis hop missing" (resolved iter-170+ via `Algebra.compHom`).
  - iter-170: "API outage" (external).
  - iter-171: "body skeleton landed; 3 named internal scaffold sorries pending".
  - iter-172: "PRIMARY 2 hint was wrong (over_coherence depends on chart); PRIMARY 3 needs structural lemma `(cover).X i ≅ Spec((Away 𝒜 X_i) ⊗[kbar] (GmRing kbar))`".
- iter-172 review classified Route 1 as "CONVERGING-in-disguise": PARTIAL-low bucket but PRIMARY 1 closure propagates axiom-cleanness through 2 downstream consumers (`aux_left`, `homogeneousLocalizationAwayIso`). Per the KB pattern this can be re-classified.

### Route 2 — Picard A.1.a `RelativeSpec` file-skeleton

Files: `AlgebraicJacobian/Picard/RelativeSpec.lean` (NEW; does not exist on disk yet).

Phase entered: iter-171 (writer started landing chapter); `Iters left` in STRATEGY.md = `~3-5`.

Signal extraction (K=5):

- **Prover statuses**: iter-168 N/A; iter-169 N/A; iter-170 N/A; iter-171 N/A (writer failed 2nd attempt, no prover lane); iter-172 INCOMPLETE (Lane B died to API-529 after 13 turns, only `mkdir` ran; chapter HARD GATE was CLEARED iter-172 plan-phase via scoped review).
- **Helpers added per iter**: zero (file does not exist).
- **Recurring blocker phrases**: "writer fails to land chapter to disk" (iters 169–171, resolved iter-172 plan-phase by writer route-a1-retry2 landing 449-LOC chapter); "API-529 outage on prover" (iter-172).
- iter-172 review classified Route 2 as "no-longer-STUCK" per same KB pattern: external API outages do not falsify the route.

### Route 3 — RR.1 `Weil divisors` file-skeleton

Files: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (NEW iter-172, builds green; 6 sorry bodies + 3 sorry-free + 1 must-fix `True` placeholder field).

Phase entered: iter-171 (writer landed chapter); `Iters left` in STRATEGY.md = `~3-6`.

Signal extraction (K=5):

- **Prover statuses**: iter-168 N/A; iter-169 N/A; iter-170 N/A; iter-171 N/A; iter-172 COMPLETE (file-skeleton landed clean).
- **Helpers added per iter**: iter-172 +9 pinned declarations + 1 helper struct + 1 sync_leanok-applied marker pile.
- **Blocker phrases**: zero this iter; (must-fix `PrimeDivisor.isCodim1AndIntegral := True` placeholder is a write-up issue, not a blocker for body work).

## Planner's iter-173 proposal (objectives I'm about to commit)

3 prover lanes:

1. **Lane A** on `Genus0BaseObjects.lean` (Route 1 continuation; gated on mathlib-analogist `chart-bridge173` returning the structural-lemma recipe; targets `gmScalingP1_chart`, `gmScalingP1_over_coherence`, `gmScalingP1_chart_agreement` + iter-172 SECONDARY).
2. **Lane B** on `Picard/RelativeSpec.lean` (Route 2; re-dispatch verbatim per the external-API-failure-pattern protocol; targets file-skeleton scaffolding of 6 pins).
3. **Lane D** on `RiemannRoch/WeilDivisor.lean` (Route 3; targets the iter-172 must-fix `PrimeDivisor` placeholder repair + body fill for `degree_hom` 3-line Finsupp lemma; gated on `wd-spec-refine` blueprint-writer landing the codim-1 / (*) predicate pin).

## Question to you

Per-route verdict: `CONVERGING / CHURNING / STUCK / UNCLEAR`. For CHURNING / STUCK, name the corrective TYPE (blueprint expansion / Mathlib-idiom consult / structural refactor / route pivot) and the cheapest signal that would change the verdict.

Specifically for Route 1: does the iter-172 review's "CONVERGING-in-disguise" re-classification hold up, or is this still CHURNING under the strict rule?

Specifically for Route 2: does the 2nd consecutive external-API-failure (iter-170 + iter-172) license re-dispatch verbatim, or should the plan flip to a different cheapest-signal test (e.g. very short single-pin scaffold instead of 6-pin file-skeleton)?

Specifically for Route 3: any sign the planner's Lane D proposal mis-scopes (e.g. attempting `degree_hom` body fill before the chapter spec refinement lands is premature)?
