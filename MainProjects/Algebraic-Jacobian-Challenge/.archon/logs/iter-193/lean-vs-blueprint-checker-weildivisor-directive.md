# lean-vs-blueprint-checker — RiemannRoch/WeilDivisor.lean ↔ RiemannRoch_WeilDivisor.tex

## Scope

Compare exactly one `.lean` file with its blueprint chapter,
bidirectionally.

- **Lean file**:
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- **Blueprint chapter**:
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## Why this file in particular

This file's `degree_positivePart_principal_eq_finrank` has been
diagnosed as MATHEMATICALLY FALSE in two consecutive iterations
(iter-192 first counter-witness `K=K(C), t=1`; iter-193 second
counter-witness `K=K(C), t=u(u-1)` even with the `hlp` augmentation).
The chapter prose was updated this review iter with a
`% NOTE (iter-193 review, prover-surfaced CRITICAL)` documenting the
second counter-witness.

Iter-193 prover also landed 8 axiom-clean substrate helpers
(`principal_apply`, `positivePart_single`, `degree_single`,
`one_le_degree_positivePart_principal_of_order_one`, `degree_zero`,
`degree_add`, `Scheme.RationalMap.order_one`, `principal_one`) and
restructured the body of `degree_positivePart_principal_eq_finrank` to
extract `Y₀` from `hlp`.

## What to check (bidirectional)

1. **Lean → blueprint**: do the new substrate helpers have any
   blueprint-pinable content? Or are they purely internal substrate
   not deserving `\lean{...}` pins?
2. **Lean → blueprint**: does the `degree_positivePart_principal_eq_finrank`
   Lean signature (with the iter-193 `hlp` parameter) match the
   chapter prose's "`t_∞` is a local parameter at `∞ ∈ ℙ¹`" condition?
   Note: the answer is NO per the iter-193 prover finding — confirm
   that the `% NOTE` correctly documents this mismatch.
3. **Blueprint → Lean**: is the chapter's recipe (Hartshorne II.6.9
   ramification-inertia argument) at a level of detail the Lean side
   needs in order to close the body in iter-194+? Or does the chapter
   need to be EXPANDED (e.g. to spell out the per-affine-chart
   factorisation of `φ : C → ℙ¹`)?
4. **Lean ↔ blueprint**: are the OTHER sorries in the file
   (`rationalMap_order_finite_support` `f ≠ 0` branch line 248;
   `principal_degree_zero` non-constant line 537) backed by adequate
   blueprint coverage for iter-194+ closure?
5. Soundness: are there other Lean signatures in the file that could
   be similarly mathematically-suspect (over-general)?

## Output

Write your report to
`.archon/task_results/lean-vs-blueprint-checker-weildivisor-iter193.md`
per the wrapper's standard path. Flag MUST-FIX-THIS-ITER on any
correctness gap that blocks downstream consumers (e.g. the consumer
at `RationalCurveIso.lean:521` `?hlp` is blocked by the unsound
signature).

## Strict context discipline

Read ONLY the two files named above + Mathlib references on demand.
Do NOT read `STRATEGY.md`, `PROGRESS.md`, other chapters, or session
journals. The narrow file-vs-chapter view is the point.
