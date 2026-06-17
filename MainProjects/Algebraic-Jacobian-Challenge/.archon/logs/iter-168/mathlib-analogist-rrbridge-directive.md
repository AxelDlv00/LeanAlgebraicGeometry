# Mathlib-analogist directive — slug `rrbridge`

## Mode

api-alignment

## Iteration

168

## Question

The progress-critic's `routec168` verdict (iter-168) raised a dispatch CHALLENGE:
`genusZero_curve_iso_P1` (`AlgebraicJacobian/AbelianVarietyRigidity.lean:1135`)
— the Riemann–Roch bridge for "genus-0 + k̄-point ⟹ ≅ ℙ¹" — has been described as
a "long pole" for 3 iters with no prover engagement. The planner must state
explicitly whether it is dispatchable as a parallel Lane B lane this iter, or
name the upstream chapter expansion required and schedule it.

### Sub-questions

**Q1** — Does Mathlib have a Riemann–Roch theorem for curves? If yes (in any form
— integral, divisor-theoretic, line-bundle-theoretic, sheafy `χ(L) = deg L + 1 - g`),
cite file:line. If no, confirm absence and identify the closest existing piece.

**Q2** — Does Mathlib have:
  - A divisor / Weil divisor theory for schemes? (`Divisor`, `WeilDivisor`, …)
  - A degree map `Pic X → ℤ` for a curve?
  - A `Mor(C, ℙ¹)` ≅ `degree-1 line bundles + section` classification?
  - A genus-0 reduction route via Hurwitz / Castelnuovo?

For each, cite file:line if present, or confirm absence.

**Q3** — Hartshorne's proof of IV.1.3.5 (the source proof block is in the chapter
at `AbelianVarietyRigidity.tex` near `prop:genusZero_curve_iso_P1`) goes via:
"pick two distinct points P, Q; apply Riemann–Roch to D = P - Q; deg(K − D) = −2
gives l(K − D) = 0; l(D) = 1; D divisor of degree 0 with l(D) = 1 implies D ∼ 0;
so P ∼ Q; X is rational ⟹ X ≅ ℙ¹." Each piece requires:
  (i) a divisor of a closed point on a curve,
  (ii) Riemann–Roch's dimension formula `l(D) - l(K - D) = deg D + 1 - g`,
  (iii) linear equivalence of divisors,
  (iv) "X rational ⟹ X ≅ ℙ¹" (Hartshorne II.6.10.1 — birational + smooth + proper
       curve ⟹ iso to the curve representing the function field).

Which of (i)-(iv) is in Mathlib at scheme-level? Which would require a multi-iter
sub-build? What is the cheapest-to-formalize variant of "genus-0 ⟹ ≅ ℙ¹" *that
Mathlib could support TODAY*, e.g. via:
  - the `H^0(C, O(D))` cohomology Mathlib already computes,
  - the `Pic⁰` group scheme infrastructure (project Route A engine),
  - a function-field / valuation-theoretic argument,
  - direct construction of a degree-1 line bundle from a chosen k̄-point?

**Q4** — If the answer to "is this dispatchable today" is NO, what is the upstream
chapter expansion the planner should schedule? Specifically: should the planner
dispatch a blueprint-writer to expand `prop:genusZero_curve_iso_P1`'s proof into
sub-lemmas at a level matching what Mathlib supports? Or should the chapter retain
a single-statement Hartshorne-faithful proof and the project waits for upstream
Mathlib infrastructure?

**Q5** — Concrete Lean signature: the current `genusZero_curve_iso_P1` returns
`Nonempty (C ≅ ProjectiveLineBar kbar)` over `Spec kbar`. Is that the right shape,
or would a more useful shape (e.g. an iso parameterised by the choice of a k̄-point
of C, or carrying additional data) be a better target? The project's only consumer
is `rigidity_genus0_curve_to_grpScheme` which uses the iso to transport `f : C → A`
to `f' : ℙ¹ → A`.

### Constraint

- Read ONLY references/hartshorne-algebraic-geometry.pdf (Example IV.1.3.5, IV.1
  pp.293-300 if needed) and the `AbelianVarietyRigidity.tex` block for the existing
  proof sketch.
- Verify EVERY Mathlib citation by `lean_local_search` or direct file read. Do not
  guess at lemma names from naming-convention extrapolation.
- The deliverable lands at `analogies/rrbridge-survey.md`.

### Output expectation

Verdict per sub-question: PROCEED / ALIGN_WITH_MATHLIB / NEEDS_MATHLIB_GAP_FILL /
DEFER_TO_UPSTREAM. The headline deliverable is a single sentence answering
"Is `genusZero_curve_iso_P1` dispatchable as a prover lane this iter, or does it
require N-iter upstream work first? If N > 0, name the upstream pieces and order
them." That sentence + ~150-200 lines of supporting detail.
