# Progress Critic Directive

## Slug
iter129

## Active routes (this iter's consideration)

The plan agent is considering for iter-129:

- Route **M2.body-pile piece (i)** — group-scheme cotangent triviality. Iter-128 closed sub-piece (i.a) `AlgebraicGeometry.GrpObj.lieAlgebra` body. Iter-129 candidate sub-pieces are (a) the rank lemma `lieAlgebra_finrank_eq_dim` and (b) the shear iso `mulRight_globalises_cotangent`.
- Route **`rigidity_over_kbar`** (M2.a) — gating route; no prover work iter-128, no plan to dispatch iter-129 (body closure depends on the full piece (i)+(ii)+(iii) pile).
- Route **`genusZeroWitness`** (M2.b) — iter-127 scaffold; no prover work iter-128, no plan to dispatch iter-129 (body closure depends on `rigidity_over_kbar`).

## Per-route signal trail (iter-125 through iter-128)

### Route: M2.body-pile piece (i)

| Iter | Sorry count (this route's file) | Helpers added | Prover status | Recurring blocker |
|---|---|---|---|---|
| iter-125 | n/a (file `Cotangent/GrpObj.lean` did not exist) | 0 | n/a | — |
| iter-126 | n/a | 0 (M2.a scaffold landed in `RigidityKbar.lean` instead) | n/a | — |
| iter-127 | n/a | 0 (mathlib-analogist over-k consult; no prover) | n/a | — |
| iter-128 | 1 → 0 (scaffold `sorry` added then closed same iter) | 1 declaration (`lieAlgebra`) | COMPLETE | — |

Iter-128 was a same-iter refactor + prover combo: refactor created `Cotangent/GrpObj.lean` with a 75 LOC scaffold containing `AlgebraicGeometry.GrpObj.lieAlgebra : ModuleCat k := sorry`; prover lane closed the body in a single Edit using the pullback-along-section bridge through `relativeDifferentialsPresheaf` evaluated at the top open + `ModuleCat.extendScalars`. `lean_verify` returns kernel-only (no sorryAx).

Iter-128 review-phase findings flagged 2 must-fix-iter-129 items: (a) signature hardcodes `[SmoothOfRelativeDimension 1 G.hom]` (should be `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` so downstream consumer `rigidity_over_kbar` can apply it to abelian varieties of arbitrary relative dimension); (b) opening docstring claims the result is the `k`-linear dual but the body returns the cotangent space itself — naming/docstring inconsistency.

### Route: `rigidity_over_kbar` (M2.a)

| Iter | Sorry count | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| iter-125 | n/a (file did not exist) | 0 | n/a | — |
| iter-126 | 0 → 1 (new file + scaffold sorry) | 1 declaration | n/a (no prover lane on this file) | — |
| iter-127 | 1 (unchanged) | 0 | n/a | over-k strategic commitment |
| iter-128 | 1 (unchanged) | 0 | n/a | — |

Per the strategy, body closure depends on piece (i)+(ii)+(iii) of the cotangent-vanishing pile and lands iter-150+. No prover work expected on this file iter-129.

### Route: `genusZeroWitness` (M2.b)

| Iter | Sorry count | Helpers added | Prover status | Notes |
|---|---|---|---|---|
| iter-125 | n/a (declaration did not exist) | 0 | n/a | — |
| iter-126 | n/a | 0 | n/a | — |
| iter-127 | 0 → 1 (scaffold sorry) | 1 declaration | n/a | — |
| iter-128 | 1 (unchanged) | 0 | n/a | — |

Body closure depends on `rigidity_over_kbar` body lands iter-150+. No prover work expected iter-129.

## Project-wide signals (iter-125 through iter-128)

| Iter | Total project sorries | Net change | Prover status (active lanes only) |
|---|---|---|---|
| iter-125 | 2 → 2 | Rigidity.lean refactor; no net sorry change | n/a (plan-phase-only) |
| iter-126 | 2 → 2 | M1 excise (−1) + M2.a scaffold (+1) | n/a (plan-phase-only) |
| iter-127 | 2 → 3 | M2.b scaffold (+1) | n/a (plan-phase-only) |
| iter-128 | 3 → 4 → 3 | Piece (i.a) scaffold (+1) then prover close (−1) | COMPLETE on `lieAlgebra` |

3 consecutive plan-phase-only iters (iter-125/126/127) triggered the iter-128 META-PATTERN TRIPWIRE; iter-128 fired the corrective via same-iter refactor + prover combo on `lieAlgebra` and the lane returned COMPLETE.

## Specific question for this iter

The plan agent is considering for iter-129 a fix-up refactor lane (relax `lieAlgebra` signature `1 → free n` + rename declaration + scaffold rank lemma `lieAlgebra_finrank_eq_dim` per the iter-128 review's iter-129 staged scope), a blueprint-writer pass on `RigidityKbar.tex` (add rank-lemma bridge sketch), and OPTIONALLY a prover lane on either (a) the new rank lemma or (b) piece (i.b) shear iso `mulRight_globalises_cotangent`.

Q1: Is the M2.body-pile piece (i) route CONVERGING after iter-128's COMPLETE close on (i.a)? Or does the iter-128 review's flagging of two must-fix items count as a residual that means we are still UNCLEAR?

Q2: For the iter-129 prover lane candidate, the iter-128 prover task result recommends a `mathlib-analogist` consult before the rank lemma (because the rank computation needs the presheaf-vs-sheaf bridge that `smooth_locally_free_omega` provides at the local-ring level but not yet at the global-sections level). Is this CHURNING risk on the rank lemma high enough that iter-129 should DEFER the prover round and instead just do refactor + blueprint-writer, with prover scheduled iter-130?

Q3: If iter-129 dispatches a prover lane, which target has lower CHURNING risk: (a) the rank lemma `lieAlgebra_finrank_eq_dim` (needs the presheaf-vs-sheaf bridge), or (b) the shear iso `mulRight_globalises_cotangent` (pure categorical, no scheme cotangent infrastructure)?

## Output format

Per § "Acting on my verdicts" of `.archon/subagents/progress-critic.md`. CONVERGING / CHURNING / STUCK / UNCLEAR per route. Specific corrective recommendations when CHURNING or STUCK. The plan agent will use these verdicts to set this iter's prover objectives (or to defer them).
