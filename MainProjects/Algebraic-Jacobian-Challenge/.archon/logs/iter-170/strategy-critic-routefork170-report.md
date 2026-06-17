# Strategy Critic Report

## Slug
routefork170

## Iteration
170

## Routes audited

### Route: A — Picard scheme / Albanese via FGA

- **Goal-alignment**: PASS — Route A produces the positive-genus object `J = Pic⁰_{C/k}` which the protected `Jacobian.nonempty_jacobianWitness` requires for `genus ≥ 1`.
- **Mathematical soundness**: PASS — Kleiman §4/§5 + Nitsure §4-5 supply the construction; Milne III §6 supplies the Albanese UP. No mathematical gaps in the route as written.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — see Infrastructure-deferral findings below.
- **Effort honesty**: under-counted — `~5100+ LOC · 0/it` with `~40-70 iters` is an honest *static* count, but the `0/it` velocity figure means the schedule is not yet a schedule: every line is still future. The "NOT yet itemised in ~5100 — true budget higher" footnote on the Albanese UP confirms the planner knows the number is soft. Strategy explicitly defers it ("after the genus-0 stack") — that deferral compounds risk because Route A is the longest, riskiest piece in the project and has had no decomposition iteration.
- **Parallelism under-exploited**: yes — Route A's sub-phases (Quot representability, Hilbert representability, Pic⁰ identity-component, Albanese UP) are largely independent of the genus-0 work and of each other. Strategy serializes them entirely behind the genus-0 stack despite the genus-0 stall being the bottleneck. At minimum, blueprint decomposition + Mathlib-survey iters of Route A could run in parallel with prover work on the genus-0 chart-glue.
- **Verdict**: CHALLENGE — Route A's infrastructure-deferral + effort honesty are interlocking issues; planner must address.

### Route: C — genus-0 rigidity completion via Milne §I.3

- **Goal-alignment**: PASS — produces `rigidity_genus0_curve_to_grpScheme`, the keystone for the genus-0 arm. Object is trivial `Spec k`; only the rigidity equation is owed.
- **Mathematical soundness**: PASS — the 𝔾_m-scaling shortcut is sound. Cor 1.5 + scaling fixed point + density ⟹ Mor(ℙ¹,A) = const. Cor 1.5 is proven axiom-clean. The argument never invokes Thm 3.2, `Hom(𝔾_a,A)=0`, the cube, or Serre duality. Char-general. Mathematically the route is in excellent shape.
- **Sunk-cost reasoning detected**: no — Route C's commitment is justified on merits (least Mathlib-blocked per `route-support.md`; char-general; uses proven assets), not on prior investment.
- **Infrastructure-deferral detected**: yes — `gmScalingP1` body + `genusZero_curve_iso_P1` (RR bridge) are both named as scaffold-only without concrete sub-phase plans in STRATEGY.md. See Infrastructure-deferral findings below.
- **Effort honesty**: under-counted in iter cost (LOC plausible) — the row reads `Iters left: ~5-12` with the `gmScalingP1` body sitting un-touched. The fact that this row's wording has been edited multiple times *without* the residual iter-count budging downward is the warning. A "5-12" estimate that does not move after 5 consecutive iters of zero body progress is no longer an estimate; it's an aspiration.
- **Parallelism under-exploited**: minor — `Genus0BaseObjects.lean` Lane A (group-object instances) and the chart-glue body are partially independent; `genusZero_curve_iso_P1` (RR bridge) is independent of both. Strategy could schedule all three lanes concurrently rather than sequentially gating the RR bridge behind the σ_× body.
- **Verdict**: SOUND — the route is right; the *scheduling* and the *infrastructure-deferral inside the route* are the issues, not the route itself.

### Route: off-path fallbacks

- **Verdict**: SOUND — strategy correctly keeps `(a)` Serre-duality `df=0` artifact (`rigidity_over_kbar` in `RigidityKbar.lean`, `[CharZero]`-gated, 1 residual sorry) in tree as a non-pursued fallback. Listing them prevents knowledge loss without committing iter budget.

## Format compliance

- **Size**: 166 lines / ~8 KB — within budget.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in canonical order.
- **Per-iter narrative detected**: yes — `gmScalingP1 scaffold landed iter-165`, `~390 LOC iter-165` (inside a LOC table cell), `strategy-critic 'basecase-reopen'`, `blueprint-writer 'basecase-4throute' Finding 2`, `(strategy-critic basecase-reopen gave the direct-rigidity route; blueprint-writer basecase-4throute Finding 2 sharpened it to the scaling variant)`. These reference prior-iter subagent slugs and iter numbers — exactly the kind of history that belongs in iter sidecars, not in STRATEGY.md.
- **Accumulation detected**: yes — the "Open strategic questions" item "Base-case route — RESOLVED = 𝔾_m-scaling shortcut" is a resolved question still occupying space; it should be excised (the route is committed in `## Routes`; restating it as a "resolved" open question is double-bookkeeping). The "Off-path fallbacks (kept in tree, NOT pursued)" subsection is appropriate retention, but the in-prose "Architecture (settled)" item under Open strategic questions reads as historical commentary that the canonical skeleton does not need to host.
- **Table discipline**: FAIL (mild) — the LOC cell for the genus-0 rigidity row reads `~1500–3500 · base-case infra +~390 LOC iter-165`, which is a narrative gloss in a column whose canonical content is `remaining · realized/it`. The Route A LOC cell `~5100+ · 0/it` is technically compliant but its `0/it` velocity coexisting with `~40-70 iters left` is the dishonest-estimate smell flagged in route audit.
- **Format verdict**: DRIFTED — the document has accumulated enough per-iter narrative that it should be restructured in-place this iter. The drift is recoverable in ~20 lines of edits; left untreated it will continue compounding.

## Infrastructure-deferral findings

### Deferred: `gmScalingP1` (the σ_× : ℙ¹ × 𝔾_m → ℙ¹ scheme morphism body)

- **Required by goal**: yes — the 𝔾_m-scaling shortcut is the COMMITTED route for the genus-0 base case (`prop:morphism_P1_to_AV_constant`), which is the *only* mathematical content owed by the genus-0 arm. Without σ_× as a real scheme morphism, Cor 1.5 cannot be applied and `rigidity_genus0_curve_to_grpScheme` cannot close.
- **Current plan for building it**: STRATEGY.md describes the route at the math level but does not enumerate the SCHEME-CONSTRUCTION sub-phases (chart cover, chart-side ring map, cross-chart agreement, glueMorphisms wrap, Q2 helper iso). The mathematician's `analogies/gmscaling-deep.md` does enumerate them concretely (~190-265 LOC across 6 sub-steps), but STRATEGY.md does not reference any of that decomposition. The row says "scaffold landed" as if the scaffold being landed *is* progress on the body; it is not.
- **Timeline**: vague — `Iters left: ~5-12` has not moved across 5 iters of zero body progress.
- **Verdict**: CHALLENGE — the body needs either (i) sub-phase decomposition in STRATEGY.md with concrete LOC + iter estimates per sub-phase, or (ii) explicit reclassification (the work moves to a different route).

### Deferred: `genusZero_curve_iso_P1` (RR bridge: smooth proper geom-irreducible genus-0 curve over `k̄` ⟹ `≅ ℙ¹`)

- **Required by goal**: yes — the chain `rigidity_genus0_curve_to_grpScheme` is `(C → ℙ¹) ≫ (ℙ¹ → A const)`. Without the iso the chain does not close.
- **Current plan for building it**: STRATEGY.md mentions it as a "shared, no Mathlib RR" item and flags it the "long pole" but provides no decomposition. References say the math is Hartshorne IV.1.3.5; the project has no Mathlib RR to lean on.
- **Timeline**: absent — listed inside the same `~5-12` envelope that already houses gmScalingP1, with no separate budget.
- **Verdict**: CHALLENGE — needs its own row in Phases & estimations or an explicit sub-bullet in the genus-0 row with LOC + iter estimate; it cannot share a hidden budget with σ_×.

### Deferred: Route A's representability decomposition

- **Required by goal**: yes — Route A is the *only* path to the positive-genus object. The protected `Jacobian.nonempty_jacobianWitness` is not satisfied without it.
- **Current plan for building it**: STRATEGY.md says "flesh to prover-ready blocks (entry: `RelativeSpec` ~700–1100 LOC) after the genus-0 stack." That is a deferral, not a plan: A.1–A.4 do not have per-sub-phase iter budgets, LOC estimates, or risk surface analysis.
- **Timeline**: vague — `~40-70 iters` with `0/it` velocity, gated behind a genus-0 stack whose own iter count is suspect.
- **Verdict**: CHALLENGE — Route A's "post-genus-0 deferral" is one of the largest single-line deferrals in the strategy. Even without starting prover work, a blueprint-level decomposition iter for Route A should run *in parallel* with genus-0 prover work, not be sequenced behind it.

## Alternative routes (suggested)

### Alternative: option (c) inline chart-glue at scale — *primary recommendation*

- **What it looks like**: ~190-265 LOC across 6 sub-steps, all enumerated verbatim in `analogies/gmscaling-deep.md`: (1) `projectiveLineBarAffineCover` ~15 LOC; (2) `homogeneousLocalizationAwayIso` ~60-90 LOC (this is the long pole, *not* ~30 LOC as a prior iter assumed); (3) `gmScalingP1_chart{0,1}_ringMap` + `gmScalingP1_chart{0,1}` ~30 LOC; (4) `gmScalingP1` body via `Scheme.Cover.glueMorphisms` ~40-60 LOC; (5) `zeroPt_left_factors_through_chart1` helper ~15 LOC; (6) `gmScalingP1_collapse_at_zero` body ~30-50 LOC. All Mathlib citations verified in the analogies file. 2-3 prover iters.
- **Why it might be cheaper or sounder**: it is the only option that (i) is fully under the project's control (no Mathlib PR review cycle), (ii) delivers exactly the artifact the project needs and nothing more, (iii) has a concrete recipe already written, (iv) does not weaken the project's stated goal (char-general).
- **What the current strategy may have rejected**: nothing — STRATEGY.md doesn't acknowledge the ~200-LOC scope; the strategy treats the gmScalingP1 body as a single short sub-task. The directive's "iter-169 LOC budget" issue is real but is a per-iter LOC issue, not a per-route LOC issue; the answer is to schedule (c) across 2-3 iters with explicit per-iter LOC caps, not to bail to (a) or (b).
- **Severity of the omission**: critical — this is the only option whose iter-cost is small, deterministic, and project-internal.

### Alternative: option (a) Mathlib upstream sub-build — *rejected*

- **What it looks like**: PR `Algebra.TensorProduct` `CommRing` instance for `HomogeneousLocalization.Away`-rings; PR relative-Proj base-change iso `Proj(MvPoly (Fin n) R) ≅ Proj(MvPoly (Fin n) k) ×_{Spec k} Spec R`. Estimated ~5 iters of internal work + indefinite Mathlib PR review.
- **Why it might be cheaper or sounder**: it would unblock *both* the chart-glue iso AND the functoriality-of-Proj route simultaneously, and would be net-positive for downstream Mathlib users.
- **What the current strategy may have rejected**: the strategy isn't currently expressing this option, but the implicit reason to reject it is real-world: Mathlib PR review is not a 5-iter quantity. PRs touching `RingTheory/GradedAlgebra/HomogeneousLocalization.lean` are reviewed by a small set of maintainers; the relative-Proj base-change iso is novel enough that it would likely require multiple review cycles. The project's iter-count would balloon, *and* the Mathlib reviewers' time would be spent on infrastructure the project itself does not need at this generality.
- **Severity of the omission**: minor — keeping (a) on the table as a future Mathlib contribution is fine; it should *not* be the gating dependency for closing the genus-0 arm.

### Alternative: option (b) `[CharZero]` hypothesis — *REJECT AS A GOAL WEAKENING*

- **What it looks like**: revert to consuming `rigidity_over_kbar` (in `RigidityKbar.lean`, `[CharZero]`-gated) as the genus-0 char-0-only artifact.
- **Why it might be cheaper or sounder**: it appears cheap because the artifact "already exists".
- **What the current strategy may have rejected**: (b) is misnamed in the directive's framing. Two reasons it is unsound: (i) `rigidity_over_kbar` *itself* still carries 1 sorry — it is not a closed artifact, it is a stalled artifact on the demoted Serre-duality route the project rejected for being char-restricted AND missing scheme-level Ω + RR + cohomology. So (b) doesn't close the genus-0 arm; it just trades one stalled route for a different stalled route. (ii) The protected signature `Jacobian.nonempty_jacobianWitness` is over arbitrary `k`, char-unconstrained. Imposing `[CharZero]` is a *goal weakening* per the infrastructure-deferral rule's third bullet ("the strategy splits the goal into a 'main case' and one or more 'exceptional cases'" — char-positive becomes the exceptional case and is deferred indefinitely).
- **Severity of the omission**: critical — listing (b) as a strategic option at all is dangerous; the directive's framing partially flagged this ("misleadingly named") but a fresh-context audit must REJECT (b) explicitly. The strategy must not adopt (b).

### Alternative: option (d) — *no fresh option distinct from (c) was found*

- **What it looks like**: investigated four candidate (d) framings — (d.1) skip σ_× entirely via Milne Thm 3.2 codim-1 extension (rejected: needs Weil divisors / `Hom(𝔾_a,A)=0`, both Mathlib gaps deeper than chart-glue); (d.2) functor-of-points σ_× (rejected: Cor 1.5 consumes σ_× as a *scheme* morphism, so representability lands at the same Proj-base-change gap as the iter-169 attempt 3); (d.3) 1-chart-plus-point gluing (𝔸¹ ∪ {∞}, with σ_× on 𝔸¹ being `MvPolynomial.aeval` and trivial on ∞) — this *is* a (c)-variant with a simpler gluing topology (one chart + one point ⟹ cross-chart agreement is trivially the point-condition), worth flagging as the prover's preferred concrete decomposition within (c) if the 2-chart symmetric path is heavier than the analogies file estimates; (d.4) Proj-functoriality via a different identification — rejected, same Mathlib gap.
- **Why it might be cheaper or sounder**: the (d.3) variant could potentially shave 30-50 LOC off the chart-glue body by making one of the chart-agreement cases vacuous. The project should investigate (d.3) as a tactical variant of (c) if the prover finds the 2-chart symmetric route to be more than ~250 LOC.
- **Severity of the omission**: minor — (d.3) is a refinement-of-(c), not a fundamental alternative. It does not change the (a)/(b)/(c) verdict.

## Sunk-cost flags

- `(strategy-critic 'basecase-reopen' gave the direct-rigidity route; blueprint-writer 'basecase-4throute' Finding 2 sharpened it to the scaling variant)` — Why this is sunk-cost: justifies the current route by citing the chain of prior subagent verdicts that produced it, rather than by re-arguing on merits. Recommendation: excise the parenthetical citation; the route's merits stand on `route-support.md` and the Mathlib gap analysis, not on which subagent surfaced it.

## Must-fix-this-iter

- Route A: infrastructure-deferral CHALLENGE — `~5100+ LOC · 0/it`, no sub-phase decomposition, deferred behind genus-0. Planner must either (i) schedule a blueprint-decomposition iter for Route A in parallel with the genus-0 prover lane this iter, or (ii) record explicit rebuttal naming why blueprint-level Route A decomposition cannot run in parallel.
- Route C: infrastructure-deferral CHALLENGE — `gmScalingP1` body has no sub-phase decomposition in STRATEGY.md despite the mathematician's `analogies/gmscaling-deep.md` providing one. Planner must lift the 6-sub-step decomposition into STRATEGY.md (or a footnote citing the analogies file) with per-sub-step LOC + iter estimates.
- Route C: infrastructure-deferral CHALLENGE — `genusZero_curve_iso_P1` (RR bridge) has no separate iter budget; cannot share the `~5-12` envelope already housing σ_×. Planner must split it into its own row or sub-bullet with LOC + iter estimate.
- Alternative (c) inline chart-glue: critical recommendation — adopt (c) at ~190-265 LOC across 2-3 iters with explicit per-iter LOC caps; reject (a) (Mathlib PR cycle outside project control) and REJECT (b) (goal weakening — `[CharZero]` violates the protected signature, AND `rigidity_over_kbar` is itself unproven).
- Effort honesty: the "5-12 iters left" estimate for the genus-0 row has not moved across 5 iters of zero σ_× body progress. Under (c) the realistic envelope is ~3-5 iters from iter-170 (~200-265 LOC chart-glue + ~30-50 LOC collapse-at-zero proof) + ~3-6 iters for the RR bridge `genusZero_curve_iso_P1` (no concrete decomposition exists yet, so this is a soft estimate). Total ~6-11 iters; the "5-12" envelope is preserved on the upper end but the lower end of "5" is no longer defensible. Crosses the >30% revision threshold only if planner cannot get the genus0-curve-iso-P1 decomposition under ~5 iters; safer to revise the row to `~7-13` and split RR bridge to its own line.
- Format: DRIFTED — restructure STRATEGY.md in-place this iter. Three specific edits: (1) excise the parenthetical subagent slug citations in `## Open strategic questions`; (2) collapse the LOC cell narrative `base-case infra +~390 LOC iter-165` to a velocity figure `~390/it`; (3) excise the "Base-case route — RESOLVED" item in Open strategic questions (the route is committed in `## Routes`; restating it as a resolved question is double-bookkeeping).

## Overall verdict

The strategy's *mathematical* core — Route A for the positive-genus object, Route C with the 𝔾_m-scaling shortcut for the genus-0 base case — is sound and should not be disturbed. The fork in the iter-170 directive (options a/b/c) has a clear winner: **option (c) inline chart-glue at ~190-265 LOC over 2-3 iters**, scheduled with explicit per-iter LOC caps to prevent another iter-169-style "the LOC budget ran out at 200" failure. Option (a) cedes the project's iter cadence to the Mathlib PR review queue. Option (b) is a goal weakening dressed as a strategic decision: the strategy defers the char-positive case to `rigidity_over_kbar`, which is required for the stated goal AND is itself an unproved 1-sorry artifact on a route the project rejected on merits — adopting (b) would be both a goal weakening and a route trade for an equally-stalled route. No fresh option (d) was found; (d.3) one-chart-plus-point gluing is a (c)-variant worth holding in reserve.

The strategy's most pressing issues are NOT the fork — they are the **infrastructure-deferral patterns inside the routes the planner already committed to**: Route A's `~5100+ LOC · 0/it · ~40-70 iters` row with zero blueprint decomposition; Route C's gmScalingP1 body without sub-phase decomposition despite the recipe existing in `analogies/gmscaling-deep.md`; and the `genusZero_curve_iso_P1` RR bridge sharing a hidden budget with σ_×. **The strategy defers blueprint-level decomposition of Route A**, which is required for the stated `Jacobian.nonempty_jacobianWitness` goal, with no concrete timeline — that deferral must be addressed this iter via a parallel blueprint-decomposition lane. Format-wise, STRATEGY.md has DRIFTED (per-iter narrative leaking into the body and into a LOC table cell, plus accumulation in `## Open strategic questions`); a ~20-line in-place restructure this iter will keep it on the canonical skeleton.
