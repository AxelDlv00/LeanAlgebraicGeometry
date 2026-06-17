# Iter-172 plan-agent run

## Headline outcome

**The "iter-171 body-skeleton CONVERGES + open Lane B (Picard) and Lane C (RR.1) for real Route A parallelism" iter.** iter-171 closed PARTIAL-acceptable on the genus-0 body-skeleton (3 named scaffold sorries + 1 surjective helper); reversal trigger DID NOT fire; option (c) inline chart-glue committed remains the strategy. iter-172 commits to:

1. **Lane A continuation on `Genus0BaseObjects.lean`** — multi-sorry attack on iter-171's named scaffolds (close `mvPolyToHomogeneousLocalizationAway_surjective` + `gmScalingP1_over_coherence` + `gmScalingP1_chart kbar i` as PRIMARY; `gmScalingP1_chart_agreement` as SECONDARY).
2. **Lane C on `RiemannRoch/WeilDivisor.lean`** (NEW file-skeleton) — opens the in-tree RR sub-build, the first concrete prover work on the RR bridge. `RiemannRoch_WeilDivisor.tex` chapter (445 LOC, 9 `\lean{...}` pins) is on disk from iter-171.
3. **Lane B on `Picard/RelativeSpec.lean`** (NEW file-skeleton) — opens the FIRST concrete prover work on Route A in 6 iters of zero dispatch. Gated on `blueprint-writer route-a1-retry2` (3rd attempt) landing the Picard chapter THIS iter + scoped blueprint-reviewer fast-path. If writer fails for the third time, Lane B defers to iter-173.

## Subagent dispatches this plan phase (6 in parallel)

- **progress-critic `route172`** (HIGHLY RECOMMENDED) — per-route verdict on Route 1 (genus-0), Route 2 (A.1.a, just-dispatched-via-writer), Route 3 (RR.1).
- **strategy-critic `route172`** (HIGHLY RECOMMENDED) — STRATEGY.md edited iter-171 (4 Route A rows + Parallelism reality paragraph + A.4 open question); SHA-unchanged skip condition fails.
- **blueprint-reviewer `route172`** (HIGHLY RECOMMENDED) — whole-blueprint audit; HARD GATE for Lane C on `RiemannRoch_WeilDivisor.tex` + Lane B on `Picard_RelativeSpec.tex` (if writer landed).
- **blueprint-writer `surjective-pin`** — per iter-171 lean-vs-blueprint-checker MAJOR finding: pin `mvPolyToHomogeneousLocalizationAway_surjective` as new sub-lemma in AbelianVarietyRigidity.tex + refresh stale NOTEs on def:proj_chart_ring_iso + def:gm encoding.
- **blueprint-writer `route-a1-retry2`** — **third dispatch** for `Picard_RelativeSpec.tex` (iter-171 attempts 1 and 2 both failed to write the file to disk). Directive prioritises WRITING THE CHAPTER over deep verbatim-quote retrieval (better an 80%-complete chapter on disk than a 100%-research-but-zero-chapter outcome — the prior two attempts' failure mode).
- **refactor `jacobian-purge-excuse`** — per iter-171 lean-auditor CRITICAL must-fix: purge the L237-263 excuse-comment in `Jacobian.lean` claiming 3 invalid gates + refresh stale strategic docstring L182-208 (the `rigidity_genus0_curve_to_grpScheme` route C path).

## Decision made (lane count + route progression)

**Three prover lanes this iter (Lane A continuation + Lane C file-skeleton + Lane B file-skeleton if writer lands the chapter)**, balancing user-hint B "many objectives have ~0/it" against the parallel/serial structure of the project.

Reasoning vs alternatives:

- **Alternative 1: Only Lane A continuation this iter, defer Lane B + Lane C.** Rejected — would extend the 6-iter zero-prover-dispatch streak on Route A AND zero-prover-dispatch on RR; the user hint B explicitly calls out the `~0/it` velocity pattern as a problem.
- **Alternative 2: Lane A continuation + Lane B + Lane C + Lane D on Jacobian.lean (close `genusZeroWitness.key` via wiring).** Rejected — Lane D's wiring needs the `k→k̄` pullback functor which is itself a sub-build; the refactor agent's excuse-comment purge is the correct iter-172 action, and the actual closure waits for the pullback sub-build (could be its own iter-173 lane).
- **Alternative 3: Open Lane B without the writer retry — scaffold-from-summary.** Rejected — HARD GATE requires a complete+correct chapter; scaffolding from a summary the file doesn't have is the "false progress" pattern.
- **Alternative 4: Open G0BO refactor in parallel with Lane A.** Rejected — file-disjointness violated; Lane A actively edits the same file. Defer G0BO refactor to iter-173 once Lane A's sorry residual stabilises.

**Cheapest reversal signal**: if iter-172 Lane A continuation closes 0 of the 4 sorries it attacks (i.e. `mvPolyToHomogeneousLocalizationAway_surjective` doesn't yield to `Away.adjoin_mk_prod_pow_eq_top`), iter-173 fires an api-alignment `mathlib-analogist` consult on the `Algebra.adjoin → adjoin_mk_prod_pow_eq_top` chain before assigning another lane. Falsification predicate: the `aux_left` chain can't be made axiom-clean with the recipe the iter-171 prover identified.

## Prior critique status

- **progress-critic `route172`**: COMPLETE. **Route 1 CHURNING** (qualified — by strict 3-of-4 PARTIAL rule; iter-171 structural break genuine; iter-172 is the make-or-break test). **Route 2 STUCK** (5+ iters deferral + 2 writer failures). **Route 3 UNCLEAR** (fresh post-commitment, healthy). Iter-172 corrective: continue Lane A as CHURNING-reversal test (if <2 of 3 scaffolds close, fire mathlib-analogist iter-173); third-strike on Picard writer (LANDED this iter); RR.1 file-skeleton lane fires this iter.
- **strategy-critic `route172`**: COMPLETE. **7 CHALLENGES**: A.1 phantom claim, A.2 needs sub-rows under 1000 LOC, A.4 needs bypass-question resolution or worst-case re-estimate, RR-bridge needs 4 sub-rows, Route A overall under-dispatched. **Addressed**: STRATEGY.md restructured with 12 Phases rows (A.1.a/b/c + A.2.a/b/c + A.3 + A.4 + genus-0 + RR.1/2/3/4 + 2 refactors); A.4 audit dispatched (`blueprint-writer a4-bypass-audit`); A.4 row now carries dual `Iters left` covering both bypass-holds / Auslander-Buchsbaum-required scenarios. Mathlib name nit (`Scheme.Cover.glueMorphisms`) noted but VERIFIED working in iter-171 prover — no action.
- **blueprint-reviewer `route172`**: COMPLETE. **3 must-fix**: AVR missing surjective-pin (addressed THIS iter by `blueprint-writer surjective-pin` LANDED), Picard chapter missing (addressed THIS iter by `route-a1-retry2` LANDED), **9 unstarted-phase proposals** (A.1.b LineBundlePullback, A.1.c RelPicFunctor, A.2 split [FlatteningStratification + QuotConstruction], A.3 Pic0IdentityComponent, A.4 AlbaneseUP, RR.2 RRFormula, RR.3 OcOfD, RR.4 RationalIsoP1). Each gets a concrete chapter outline.
  - **Decision**: defer 8 of 9 unstarted-phase chapter writers to iter-173+ with rationale: iter-172 plan-phase already saturated (7 dispatches landed; max_parallel=2 ⟹ wall-time ~50 min through the queue). iter-173 plan-phase dispatches the highest-leverage 2-3 of them, starting with `Picard_FGA_FlatteningStratification.tex` (lone parallel-startable A.2 entry) + `Picard_LineBundlePullback.tex` (A.1.b immediate continuation) + `RiemannRoch_RRFormula.tex` (RR.2 parallel-startable per blueprint). The A.4 dedicated chapter is partially covered by the iter-172 `a4-bypass-audit` dispatch on Jacobian.tex; a dedicated chapter may follow once the audit verdict is known.

## Plan-phase additions after critic feedback

- **`blueprint-writer a4-bypass-audit`**: COMPLETE. **Verdict: Outcome (b) — bypass FAILS.** Milne III §6 Prop 6.1 invokes Thm 3.2 directly; the autoduality-via-cube detour was excised iter-163. A.4 row in STRATEGY.md updated to `Iters left ~22-35`, `~2500+ LOC` — A.4 inherits the Thm 3.2 + Lemma 3.3 + Auslander–Buchsbaum sub-build. New strategic question recorded: schedule a blueprint cross-reference audit iter-173 once RR.1 file-skeleton lands, to identify what material A.4 / Lemma 3.3 and RR.1 can SHARE (both need closed-point order, divisor degree, codim-1 indeterminacy structure).
- **`blueprint-reviewer picard-scoped172`** (same-iter fast path): COMPLETE. **HARD GATE: PASS** for `Picard_RelativeSpec.tex`. One soon-severity finding (`% SOURCE QUOTE PROOF: TODO` on `thm:relative_spec_univ` proof) is acceptable for the file-skeleton Lane B — must be filled before any iter-173 body-implementation lane on that proof. Lane B GO this iter.

## Iter-171 lean-auditor + lean-vs-blueprint findings, mapping to actions

- **CRITICAL (lean-auditor)**: `Jacobian.lean` L237-263 excuse-comment + L182-208 stale docstring → addressed via `refactor jacobian-purge-excuse` this iter.
- **MAJOR (lean-vs-blueprint-checker)**: `mvPolyToHomogeneousLocalizationAway_surjective` not `\lean{...}`-pinned → addressed via `blueprint-writer surjective-pin` this iter.
- **MAJOR (lean-auditor)**: 4 stale-narrative blocks in fallback-route files (ChartAlgebra, GrpObj, RigidityKbar, AVR iter-tag drift) → DEFERRED to a future hygiene iter (low-risk, not gating any active lane).
- **MINOR (multiple)**: `push Not at h` syntax, `@[simp]` on private, unused haveI name, code duplication, time-stamp convention → DEFERRED (cosmetic / no functional impact).

## Iter-172 prover lane proposal

### Lane A: `AlgebraicJacobian/Genus0BaseObjects.lean` — multi-sorry continuation

**PRIMARY 1**: close `mvPolyToHomogeneousLocalizationAway_surjective` (L372) via `Away.adjoin_mk_prod_pow_eq_top` specialised to `d = 1, v = ![X 0, X 1], dv = ![1, 1]`. ~60-80 LOC. Mathlib citation: `Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean:1064`. Closure unblocks `aux_left` axiom-clean + downstream `gmScalingP1_chart`.

**PRIMARY 2**: close `gmScalingP1_over_coherence` (L721) via `Scheme.Cover.hom_ext` — each chart's composite to `Spec k̄` agrees by construction (factoring through `Spec.map (algebraMap kbar _)`). ~30-50 LOC; mechanical.

**PRIMARY 3**: close `gmScalingP1_chart kbar i` (L695) via `pullbackSpecIso ≫ Spec.map gmScalingP1_chart_i_ringMap ≫ Spec.map homogeneousLocalizationAwayIso.symm ≫ Proj.awayι`. ~30 LOC per chart, ~60 LOC total. Gated on PRIMARY 1 closing `aux_left` axiom-clean.

**SECONDARY**: close `gmScalingP1_chart_agreement` (L705) — cocycle on `D₊(X 0·X 1)`. Reduces via `analogies/gmscaling-deep.md` Q4 to a ring-level identity `λ·u = (1/t)·λ` in `Localization.Away t ⊗ GmRing`. ~40 LOC once chart morphisms land.

**Target outcome**:
- COMPLETE: 4 sorries closed; G0BO 10 → 6 (-4).
- PARTIAL-acceptable: 2-3 sorries closed; G0BO 10 → 7 or 8 (-2 or -3).
- PARTIAL-low: 1 sorry closed; G0BO 10 → 9 (-1).
- INCOMPLETE: 0 sorries closed → iter-173 mathlib-analogist consult on the surjectivity recipe.

### Lane B: `AlgebraicJacobian/Picard/RelativeSpec.lean` — NEW file-skeleton (CONDITIONAL)

**Conditional dispatch**: fires THIS iter only if (a) `blueprint-writer route-a1-retry2` lands `Picard_RelativeSpec.tex` to disk, AND (b) blueprint-reviewer `route172` clears HARD GATE for that chapter (mandatory whole-blueprint dispatch this iter covers it, no scoped fast-path needed).

**Scope**: scaffold 6 declarations from the chapter (`QcohAlgebra`, `RelativeSpec`, `RelativeSpec.UniversalProperty`, `RelativeSpec.affine_base_iff`, `RelativeSpec.base_change`, `RelativeSpec.functor`) with bodies as `sorry`. Add imports + namespace boilerplate. Update `AlgebraicJacobian.lean` umbrella to `import AlgebraicJacobian.Picard.RelativeSpec`. ~100-200 LOC of stubs.

**NOT in scope**: filling any body. The bodies are iter-173+ work.

### Lane C: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — NEW file-skeleton

**Dispatch this iter**: chapter `RiemannRoch_WeilDivisor.tex` already on disk (iter-171, 445 LOC); HARD GATE clears via iter-172 mandatory blueprint-reviewer dispatch.

**Scope**: scaffold 9 declarations from the chapter (`WeilDivisor`, `RationalMap.order`, `WeilDivisor.ofClosedPoint`, `WeilDivisor.degree`, `WeilDivisor.degree_hom`, `WeilDivisor.principal`, `WeilDivisor.principal_hom`, `WeilDivisor.principal_degree_zero`, `WeilDivisor.LinearEquivalence`) with bodies as `sorry`. Add imports + namespace boilerplate. Update `AlgebraicJacobian.lean` umbrella to `import AlgebraicJacobian.RiemannRoch.WeilDivisor`. ~150-300 LOC of stubs.

**NOT in scope**: filling any body. The bodies are iter-173+ work (RR.2 chapter must land first for the dimension-formula body).

## Iter-172 reversal triggers

- **Lane A INCOMPLETE** (closes 0 sorries): iter-173 fires `mathlib-analogist` cross-domain-inspiration consult on `Algebra.adjoin → adjoin_mk_prod_pow_eq_top` specialisation. Falsification: the recipe was wrong.
- **Lane B can't fire** (writer fails 3rd attempt): iter-173 fires `reference-retriever` first to ensure all Stacks tags 01LL/01LO/01LQ/01LR/01LS are quotable from a local file, then re-dispatches the writer with retrieved sources prefetched.
- **Lane C INCOMPLETE** (file-skeleton fails to scaffold): unexpected — this is mechanical stub-creation work; if it fails, the chapter blueprint is structurally inadequate and needs writer revision.

## Iter-172 commitments to iter-173 (forward-look)

- If Lane A closes ≥3 of 4 PRIMARY sorries → iter-173 attacks `gmScalingP1_collapse_at_zero` + `iotaGm_isDominant` in AVR (the trivial gate-clearance once body chain is axiom-clean).
- If Lane B lands → iter-173 opens body lane on `RelativeSpec` declarations (probably starting with `affine_base_iff` — the affine-base case is the foundation).
- If Lane C lands → iter-173 dispatches `blueprint-writer rr2-formula` on `RiemannRoch_RRFormula.tex` (RR.2 sub-build chapter).
- G0BO refactor schedule iter-173: split into `Genus0BaseObjects.lean` (bare schemes) + `Genus0BaseObjects/Points.lean` (`pointOfVec` + 3 `k̄`-points) + `Genus0BaseObjects/ChartIso.lean` (iso + ring helpers) + `Genus0BaseObjects/GmScaling.lean` (`gmScalingP1` + chart helpers).

## Subagent skips

(None this iter; all 3 [HIGHLY RECOMMENDED] critics dispatched.)

## Blueprint-reviewer unstarted-phase proposals — deferral rationale

The whole-blueprint `blueprint-reviewer route172` returned **9 unstarted-phase chapter proposals**:

1. `Picard_LineBundlePullback.tex` (A.1.b)
2. `Picard_RelPicFunctor.tex` (A.1.c)
3. `Picard_FGA_FlatteningStratification.tex` (A.2.a — parallel-startable!)
4. `Picard_FGA_QuotConstruction.tex` (A.2.b)
5. `Picard_Pic0_IdentityComponent.tex` (A.3)
6. `Picard_AlbaneseUP.tex` (A.4 — DEDICATED chapter)
7. `RiemannRoch_RRFormula.tex` (RR.2)
8. `RiemannRoch_OcOfD.tex` (RR.3)
9. `RiemannRoch_RationalIsoP1.tex` (RR.4)

**Deferral decision**: 8 of 9 chapter writers deferred to iter-173. Rationale:

- **iter-172 plan-phase already saturated** with 7 dispatched subagents (3 critics + 3 writers + 1 refactor + 1 scoped re-reviewer = 8 in flight or completed). `max_parallel=2` means cumulative wall-time through the queue dominates. Adding 9 more writer dispatches this iter would extend the plan phase by hours with no marginal value to the iter-172 prover phase (none of these chapters gate THIS iter's prover lanes).
- **Highest-leverage deferral target for iter-173**: 3 of the 9 are blueprint-side parallel-startable (A.2.a flattening, A.1.b LineBundlePullback, RR.2 RRFormula). iter-173 plan-phase will fan out these 3 writers in parallel as the first action, then proceed with prover lanes.
- **A.4 dedicated chapter (#6) partially superseded** by the iter-172 `blueprint-writer a4-bypass-audit` dispatch on Jacobian.tex's A.4 section. Once that audit's verdict is known (outcome a/b/c), the iter-173 planner decides whether the dedicated `Picard_AlbaneseUP.tex` is needed (outcome a — bypass holds — likely yes, to document the Picard-functoriality proof) or whether the audit's update to Jacobian.tex § A.4 + the iter-173 mandatory blueprint-reviewer suffice.
- **Gated chapters (#2 A.1.c, #4 A.2.b, #5 A.3, #8 RR.3, #9 RR.4)** are not parallel-startable; writing them iter-172 would be premature (their parent chapters need to land first to establish the `\uses{}` cross-references correctly).

No information lost in this deferral: the reviewer's report at `.archon/task_results/blueprint-reviewer-route172.md` contains the concrete chapter outlines, ready to be re-used as iter-173 writer directives.

## Iter-172 cross-route iter-budget snapshot

Per strategy-critic + progress-critic combined view:

- **Route 1 (genus-0)**: `Iters left ~4-7` (re-estimated up from `~3-5` per progress-critic OVER_BUDGET finding).
- **Route 2 (A.1.a Picard RelativeSpec)**: now `Iters left ~3-5` per the post-restructure A.1.a row (chapter LANDED this iter; iter-173 file-skeleton lane fires unless picard-scoped172 PASSES and Lane B fires this iter).
- **Route 3 (RR.1)**: `Iters left ~3-6` per the new RR.1 row.
- **Route A.4**: dual `Iters left ~7-11 / ~22-35` pending iter-172 audit outcome.

**Aggregate project**: rough envelope (sum of critical-path-or-gating rows) at `~6 + 33-54 + 12-20 + 3-5 + 1 = ~55-83 iters` plus parallelism savings (RR + genus-0 may close concurrent with Route A.1/A.2 work). The 3-route opening this iter is the highest-leverage broadening of the dispatch pattern in 5+ iters.

## Tool substitutions

(None — the references the subagents needed were already present in `references/`.)

