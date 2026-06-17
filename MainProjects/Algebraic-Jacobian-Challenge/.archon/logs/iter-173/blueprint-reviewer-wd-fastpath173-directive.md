# Blueprint-reviewer directive — slug `wd-fastpath173`

## Scope (SAME-ITER FAST PATH — scoped to ONE chapter)

Re-review **only** `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`. Do NOT read other chapters.

## Context

Iter-173 plan-phase: `blueprint-reviewer route173` returned HARD-GATE-BLOCKED PRE-REPAIR for the `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` body-fill lane because the chapter under-specified (i) the `Scheme.PrimeDivisor` encoding and (ii) the standing hypothesis $(*)$ → Lean typeclass mapping. With $(*)$ vague and `PrimeDivisor` un-pinned, the placeholder `isCodim1AndIntegral : True := trivial` cannot be soundly repaired by the prover (no clear target).

In the same plan-phase, `blueprint-writer wd-spec-refine` LANDED with:

- **NEW** `def:prime_divisor` (`\lean{AlgebraicGeometry.Scheme.PrimeDivisor}`) pinning the helper structure to `Order.coheight point = 1`; reuses Hartshorne II.6 verbatim quote already present in the chapter; rejected-alternatives paragraph documenting why other Mathlib candidates were not adopted.
- **NEW** standing-hypothesis $(*)$ prose block decomposing into three Mathlib typeclass layers (basic / order-principal / curve).
- **Revised** `def:codim1_cycles` (replaces the iter-172 NOTE block with a `\uses{def:prime_divisor}` cross-ref + "Lean signature scope" paragraph).
- **Revised** `def:divisor_closed_point`, `def:divisor_degree` (Lean signature scope paragraphs documenting the bare-scheme signature decision).

Concrete iter-173 prover to-do list documented in the writer's task result.

## Question

Does `RiemannRoch_WeilDivisor.tex` now CLEAR HARD GATE for the `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` body-fill lane?

Specifically:

- Does the chapter now name a precise Mathlib predicate for the `PrimeDivisor` codim-1+integral witness (the writer chose `Order.coheight point = 1`)?
- Is the standing hypothesis $(*)$ pin (three-layer decomposition) precise enough that the prover can thread the right Mathlib typeclass set on each declaration?
- Are the `Lean signature scope` paragraphs on `def:divisor_degree` and `def:divisor_closed_point` internally consistent with the existing Lean signatures (Lean uses scheme-level signatures; chapter prose now matches)?
- Is the existing `\uses{...}` graph still consistent after the new `def:prime_divisor` block + the revised `def:codim1_cycles`?
- Are the existing `\lean{...}` pins still well-formed and pointing at existing Lean declarations?
- Is the new `def:prime_divisor` pin (pointing at `AlgebraicGeometry.Scheme.PrimeDivisor` at `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:84`) well-formed?

## Constraints on your output

- One-line verdict: `complete: true/partial/false`, `correct: true/partial/false`, must-fix-this-iter findings (or `none`).
- If `complete: true` AND `correct: true` AND no must-fix touches the chapter, HARD GATE CLEARS for the lane and the iter-173 prover may dispatch this iter.
- Otherwise enumerate the remaining must-fix items.
- Whole RR.1 chapter is in scope (~500 LOC post-refine), but bulk of attention on the new `def:prime_divisor` block + revised hypothesis prose.
