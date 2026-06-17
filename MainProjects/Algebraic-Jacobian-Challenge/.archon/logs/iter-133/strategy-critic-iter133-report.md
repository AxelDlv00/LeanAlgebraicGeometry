# Strategy Critic Report

## Slug
iter133

## Iteration
133

## Re-verification framing

STRATEGY.md was substantively edited iter-132 in 4 places after `strategy-critic-iter132`. Iter-133 has not yet edited STRATEGY.md; I am re-verifying the iter-132-revised STRATEGY.md and judging whether the 3 iter-133 planned edits (reinstate ground (iv), mark piece (i.a) DONE, record the fibre-free unconditional-evaluation decision) are warranted.

I spot-checked the iter-132 close artifact directly: `AlgebraicJacobian/Cotangent/GrpObj.lean:244–282` is `cotangentSpaceAtIdentity_finrank_eq` and is `sorry`-free, closing via `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq` against a `Classical.choose`-chain reproduced from the body. Both load-bearing lemmas were verified present in Mathlib `b80f227`. The reinstatement criterion in STRATEGY.md (line 498) is therefore objectively satisfied.

## Routes audited

### Route: Over-k cotangent-vanishing pile (M2.body-pile)

- **Goal-alignment**: PASS — pile (i)+(ii)+(iii) feeds `rigidity_over_kbar` body → `genusZeroWitness` body → genus-stratified body of `nonempty_jacobianWitness`. Aligns with the protected target.
- **Mathematical soundness**: PASS — piece (i.a) closure is observable in the tree; pieces (i.b)/(i.c)/(ii)/(iii) decomposition is correct (absolute Frobenius for (iii) is the right choice over non-perfect `k`; shear-iso functoriality for (i.b) is the correct mathematical hinge; the named Mathlib pieces all check out).
- **Sunk-cost reasoning detected**: yes — but adequately contained. STRATEGY.md lines 493–500 explicitly track grounds (i), (iv) as STRUCK previously and define a concrete *content-bearing* reinstatement criterion for (iv). The iter-132 close meets that criterion. **However**, ground (ii) ("blueprint cleanliness") is itself partly a downstream consequence of past investment in `RigidityKbar.tex`; STRATEGY.md does not currently flag it as such.
- **Phantom prerequisites**: none of the named Mathlib pieces are phantom; verified `Module.finrank_baseChange`, `Ideal.IsLocalRing.CotangentSpace`, `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`. Confirmed `AlgebraicGeometry.Scheme.absoluteFrobenius` is genuinely absent — strategy correctly flags this as a "build" item.
- **Effort honesty**: reasonable — piece (i.a) revised iter-131 from 1–2 iter to 5 iter; the iter-132 close (5 iter, body shape closing rank lemma in ~60 LOC of tactic body) is now in-band of the revision. The honest revision is now load-bearing for piece (i.b)+(i.c) too — iter-133 should monitor 2–4 iter for (i.b) closely and not allow another silent slip.
- **Verdict**: **SOUND** with one minor scope-narrowing recommendation on the iter-133 edits (see Must-fix-this-iter).

### Route: M2.a body closure via `rigidity_over_kbar`

- **Goal-alignment**: PASS — `rigidity_over_kbar` produces the M2.a content for `genusZeroWitness`; its current scaffold (`AlgebraicJacobian/RigidityKbar.lean:75–87`) has the right signature.
- **Mathematical soundness**: PASS — the decomposition (C.2.b reduction → C.2.c image-dimension dichotomy → C.2.d cotangent-vanishing keystone) follows Mumford. The body is gated on the shared pile, which is consistent.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none new.
- **Effort honesty**: reasonable — gated on pile closure; the iter-151+ slot in the sequencing table is plausible.
- **Verdict**: **SOUND**.

### Route: M2.b `genusZeroWitness` (vacuity-branch + C(k) ≠ ∅ branch)

- **Goal-alignment**: PASS — produces the genus-0 arm of the case-split, with the vacuity-branch verification already explicit in STRATEGY.md lines 178–184.
- **Mathematical soundness**: PASS — vacuity-on-empty branch is logically sound on the protected signature (`∀ P, IsAlbanese …` is vacuously true when `𝟙_ _ ⟶ C` is empty).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: terminal-object instance cluster on `Spec k` (GrpObj, SmoothOfRelativeDimension 0, IsProper, GeometricallyIrreducible) is unbuilt; STRATEGY.md acknowledges this and budgets 320–750 LOC over 2–4 iter at iter-153–156. Reasonable.
- **Effort honesty**: reasonable — the iter-130 Q5-revised estimate is honest.
- **Verdict**: **SOUND**.

### Route: M3 positive-genus (Route A FGA / Route B Sym^n + Stein)

- **Goal-alignment**: PASS — either route produces `positiveGenusWitness` to close the case-split.
- **Mathematical soundness**: PASS — both routes are established mathematically.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: every top-3 gating piece is genuinely missing from Mathlib; STRATEGY.md correctly documents the gap.
- **Effort honesty**: reasonable — the iter-123 audit produced 6500/9000 LOC midpoints; the 5000-LOC fallback was triggered and the iter-126 user-hint resolved it.
- **Verdict**: **SOUND** for now. The iter-126 user-hint endorsement is still load-bearing at iter-133 — M3 is multi-month away and a fresh user re-check is not yet warranted. Watchpoint, not a CHALLENGE.

## Alternative routes (suggested)

### Alternative: Pull ℙ¹-specific rigidity hedge analogist forward from iter-140 to iter-135–138

- **What it looks like**: STRATEGY.md line 508 schedules the iter-140+ analogist consult on the C(k) ≠ ∅ ℙ¹-specific rigidity sub-route. The hedge, if it works, would entirely obviate pieces (ii)+(iii) on the C(k) ≠ ∅ branch (and C(k) = ∅ is already vacuous), neutralising piece (iii)'s 800–1500 LOC scheme-level absolute Frobenius build.
- **Why it might be cheaper or sounder**: the hedge fires *before* piece (iii) scaffolding (currently iter-143+) and could rescope or eliminate the entire build. Running the analogist iter-135–138, immediately after piece (i.b) scaffold, would let its verdict feed into the iter-141 piece (ii) scaffolding. Running it iter-140+ in parallel with piece (i.c) misses this scheduling win.
- **What the current strategy may have rejected**: not rejected; merely scheduled at iter-140+ on the grounds that piece (iii) work begins iter-144+. The honest scheduling argument has not considered the dependency: if the hedge succeeds, piece (ii) work *also* might compress to ring-side `k[t]` / `k[1/t]` (since the ℙ¹ structure is concrete enough to avoid scheme-level df=0 → factors-through-Spec-k as currently planned).
- **Severity of the omission**: minor — STRATEGY.md schedules the consult; the suggestion is to advance the schedule by 2–5 iters.

### Alternative: Higher-Kähler-vanishing alternative analogist consult brought forward from iter-140 to inform piece (i.c) scaffolding

- **What it looks like**: STRATEGY.md line 443 schedules an iter-140+ consult on the "no-Frobenius / higher-Kähler-vanishing alternative" for piece (iii). If the alternative checks out, piece (iii) becomes a non-iterative cotangent-vanishing argument with materially lower LOC than the scheme-level absolute-Frobenius build.
- **Why it might be cheaper or sounder**: same observation as above for the ℙ¹ hedge — the alternative *might* also affect piece (i.c) (`omega_free` / `omega_rank_eq_dim`) and piece (ii) scaffolding (the ring-side `Differential.ContainConstants` may compose differently with a higher-Kähler-vanishing argument). Pulling the consult forward to iter-135–138 lets its verdict shape the piece (i.c)/(ii) bills-of-materials.
- **What the current strategy may have rejected**: not rejected; just kicked to iter-140+. The iter-132 strategy-critic flagged "kick the can on a decision that should fire sooner" as the SC3 sunk-cost flag; iter-133's verdict on M3 must-fix accepts the iter-140+ schedule, but I am re-raising the same concern for piece (iii) specifically because its LOC envelope (800–1500) is the largest single-piece item in the pile and an early de-risking has high option value.
- **Severity of the omission**: minor.

### Alternative: Fibre-free piece (i) reformulation evaluation should use a 4-axis scorecard, not a 1-axis LOC differential rule

- **What it looks like**: STRATEGY.md line 506 says "If the evaluation tips fibre-free (i.e. fibre-free is materially smaller — `>20%` LOC differential the iter-132 critic's recommendation), iter-133+ pivots". This is single-axis: LOC only.
- **Why it might be cheaper or sounder**: the directive itself names "canonicity, downstream API shape, blueprint alignment" as considerations the planner should weigh. A 1-axis rule may force a pivot for a 20% LOC win that loses on canonicity (fibre-free has no named cotangent-at-identity object, which removes the ability to talk about a "Lie algebra" at the type level) — or vice versa.
- **What the current strategy may have rejected**: not rejected; the iter-132 critic's recommendation was a 1-axis rule and iter-132 STRATEGY.md adopted it verbatim. The iter-133 plan agent should record the evaluation with explicit 4-axis findings, not a single LOC compare.
- **Severity of the omission**: minor — does not change the iter-133 evaluation timing, just its scoring shape.

### Alternative: Piece (i.b) mathlib-analogist directive must explicitly surface 2 sharp sub-questions beyond the iter-131-defined consult shape

- **What it looks like**: the iter-131 trigger (a') consult shape is "does the shear iso compose with the iter-131 `Classical.choose`-chain body of `cotangentSpaceAtIdentity` (chart-dependent fibre) or requires constructing the (B)→(A) bridge (~300–600 LOC) inline". This is the *outermost* question. Two sharper sub-questions are likely implicit but should be explicit in the iter-133 directive:
  - (a) **Chart-set behavior under translation**. Does `mulRight_g : G → G` (right multiplication by `g`) admit an explicit description over the affine chart `V` used in (B)'s body? If `mulRight_g(V) ≠ V`, the chart-shear iso composition becomes a cocycle between `V`'s chart and `mulRight_g(V)`'s chart — non-trivial under (B)'s `Classical.choose`-chain because the two charts are independently extracted.
  - (b) **Type-check of the shear iso under (B)**. The cotangent at `mulRight_g(e)` is a *different* `Classical.choose` extraction from the cotangent at identity. The semantic statement "they're both `k`-modules of dimension `n`" is true, but the Lean-level identification requires either a basis-comparison or a structural bridge through `cotangentSpaceAtIdentity_eq_extendScalars`.
- **Why it might be cheaper or sounder**: surfacing these sub-questions explicitly lets the analogist scope the cocycle-cost or bridge-cost precisely instead of returning a single LOC range.
- **What the current strategy may have rejected**: unclear, planner should clarify in the iter-133 piece (i.b) analogist directive.
- **Severity of the omission**: major — these are concrete piece (i.b) closure obstacles the analogist must address.

## Sunk-cost flags

- "**The over-k commitment (iter-132) is now defended on cleanliness (ii) + active revert option (iii) + the LOC arithmetic**" (STRATEGY.md line 500) — Why this is sunk-cost: ground (ii) "the over-k blueprint is cleaner (one chapter `RigidityKbar.tex` over `[Field k]` instead of two chapters)" is itself a downstream consequence of having invested iters in writing `RigidityKbar.tex` under the over-k framing. The blueprint cleanliness is real but *cheap to reproduce* under the over-`k̄` baseline (the chapter could be re-titled with a Galois-descent appendix at modest cost). Recommendation: when iter-133 reinstates ground (iv), explicitly note that the defense now has two grounds with active content ((iii) auto-revert + (iv) iter-132 tractability evidence) and one ground (cleanliness) that is itself partially sunk; weight ground (iv) as the load-bearing one going forward.

- "**ground (iv) reinstates as iter-132 tractability evidence**" (STRATEGY.md line 498) — Why this is *not* sunk-cost: this is explicitly content-bearing — the rank-lemma `Module.finrank` actually closes against `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq` in the tree at `Cotangent/GrpObj.lean:244–282`. **However**, the iter-133 edit must be scope-narrow: this is piece-(i.a) tractability evidence, not whole-pile or whole-over-k-path validation. The iter-133 edit should explicitly say "piece (i.a) tractability" not just "tractability". Otherwise the next iter risks quietly upgrading the scope.

## Prerequisite verification

- `Module.finrank_baseChange`: VERIFIED (`Mathlib.LinearAlgebra.Dimension.Constructions`).
- `Module.finrank_eq_of_rank_eq`: VERIFIED (consumed in `Cotangent/GrpObj.lean:282`).
- `Ideal.IsLocalRing.CotangentSpace`: VERIFIED (`Mathlib.RingTheory.Ideal.Cotangent`).
- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`).
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: MISSING (consistent with STRATEGY.md claim — must be built by the project at 800–1500 LOC).
- `Mathlib.Algebra.CharP.Frobenius` (ring-side): VERIFIED (per STRATEGY.md).
- `Mathlib.RingTheory.Derivation.DifferentialRing.ContainConstants`: VERIFIED (per STRATEGY.md citation; not re-spot-checked this iter).
- `Scheme.smooth_locally_free_omega` (project lemma): VERIFIED (in tree at `AlgebraicJacobian/Differentials.lean`).

## Iter-133 planned edits — verdict

The 3 iter-133 STRATEGY.md edits are:

1. **Reinstate over-k ground (iv) as iter-132 tractability evidence**: **WARRANTED**. The reinstatement criterion in line 498 is objectively met (the rank lemma in tree, refs `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`). MUST-FIX scope guardrail: the edit must specify "piece (i.a) tractability evidence" not blanket "tractability". See sunk-cost flag above.
2. **Mark piece (i.a) phase 1 status DONE on sequencing table** (row "128 → 132"): **WARRANTED**. Record-keeping that matches the in-tree state.
3. **Record fibre-free unconditional evaluation decision**: **WARRANTED but scoring shape must be improved**. The decision should be recorded as a 4-axis evaluation (LOC, canonicity, blueprint alignment, downstream API shape), not a 1-axis `>20%` LOC compare. See the third alternative above.

## Must-fix-this-iter

- Route Over-k pile: CHALLENGE — iter-133's reinstatement of ground (iv) must specify "iter-132 piece (i.a) tractability evidence" (not bare "iter-132 tractability evidence"). The piece (i.b)/(i.c)/(ii)/(iii) tractability over k remains empirically untested; conflating piece (i.a) success with whole-path validation is a sunk-cost trap waiting to fire. Edit must keep scope narrow.

- Alternative "piece (i.b) analogist directive 2-sub-question expansion": major — the iter-133 piece (i.b) analogist directive must explicitly ask (a) chart-set behavior under right-translation and (b) type-checking of the shear iso under (B)'s `Classical.choose`-chain body. These are concrete piece (i.b) closure obstacles the analogist must scope.

- Alternative "fibre-free evaluation 4-axis scorecard": minor — iter-133 must record the fibre-free evaluation with explicit canonicity / blueprint-alignment / downstream-API-shape findings alongside LOC, not just a `>20%` LOC compare.

- Alternative "ℙ¹-specific rigidity hedge pulled forward iter-135–138": minor — consider rescheduling the iter-140+ hedge analogist to iter-135–138 so its verdict feeds piece (ii)+(iii) sequencing. Recommend, not require.

- Alternative "Higher-Kähler-vanishing alternative pulled forward iter-135–138": minor — analogous to above; piece (iii) is the largest single-piece LOC item and early de-risking has high option value. Recommend, not require.

- Watchpoint (not CHALLENGE): if piece (i.b) prover lane at iter-134+ shows >2 iter slip on the 2–4 iter / 200–500 LOC estimate without converging, trigger (a')/(c) auto-revert must fire. The iter-133 plan-agent should pre-commit to this discipline in plan.md.

- Watchpoint (not CHALLENGE): if piece (i.b) closure requires constructing the full (B)→(A) bridge inline (~300–600 LOC), trigger (a') strengthened-iter-130 clause fires; do not silently absorb the bridge cost. M3 user-hint endorsement is still load-bearing at iter-133+ but should refresh if M2 close slips past iter-180.

## Overall verdict

A fresh mathematician would approve this strategy as-is, with the scope-narrowing edit on ground (iv) reinstatement and the two-sub-question expansion on the iter-133 piece (i.b) analogist directive. The iter-132 STRATEGY.md edits were well-absorbed — strikethrough framing, reinstatement criteria, and unconditional-evaluation triggers are all concrete and testable, and the iter-132 close objectively validates the reinstatement of ground (iv) for piece (i.a). The over-k commitment retains its honest narrow defense (qualitative cleanliness + active auto-revert wiring + content-bearing piece (i.a) evidence); the marginal quantitative case (0–500 LOC savings, lower-bound zero) is held in place by the trigger framework, not by sunk-cost padding. The 3 iter-133 planned edits are warranted with minor scope guardrails. The route remains SOUND; iter-133 should proceed.

---

**One-line summary**: `iter133: SOUND with 3 minor-to-major CHALLENGEs — 4 routes audited, 0 REJECT verdicts`

Path to report: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/task_results/strategy-critic-iter133.md`
