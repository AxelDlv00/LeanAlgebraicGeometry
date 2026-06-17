# Iter-147 objectives sidecar

Per-attempt detail / dispatch-level state for iter-147 prover lane.

## Lane 1 — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

### Pre-dispatch state

- File LOC: 225 (iter-146 close).
- Sorries: 3 inline (L97, L107, L177).
- Build state: clean per iter-146 finalize meta.json (`lake.ok: true`).

### Pre-dispatch hints to the prover

- **Order suggestion**: KDM ring-side (L107) first because β-core
  (L97) Step 1 reduces to KDM on chart-affine rings. If KDM is hard,
  pivot to constants substep 3 (L177) as the smallest standalone
  piece.
- **β-core Step 3 chart-Čech MV**: reuse `Cohomology_MayerVietoris.tex`
  / `AlgebraicJacobian/Cohomology/MayerVietoris*` machinery applied
  to `Ω_{C/k}^{⊕n}` instead of `O_C`. The abstract MV exactness
  theorem `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`
  exists in `Cohomology_MayerVietoris.tex` L520; you supply
  `(F = Ω_{C/k}^{⊕n}, C = the curve, AffineCoverMVSquare = the 2-chart
  cover)` to instantiate.
- **2-chart-cover existence on a smooth proper curve**: Stacks Tag
  0F8L (per iter-146 writer's β-core Step 3.aux paragraph).
- **KDM (p1) char-p path**: Stacks Tag 07F4 supplies the standard-
  smooth-presentation → `ker D = B^p` chain. Mathlib has no off-the-
  shelf lemma here; the prover must articulate the 4-substep recipe
  per the iter-146 writer's KDM (p1) expansion.
- **constants substep 3**: the iter-146 prover's L167–176 block
  comment in `ChartAlgebra.lean` documents the 5-step closure chain.
  Follow it.

### Lean-side avoidances

- Per the iter-146 prover's "Dead-end warnings" block in their
  task_result: do NOT try to remove `[IsReduced X]` from
  `constants_integral_over_base_field`; do NOT try to drop the
  `attribute [local instance] Algebra.TensorProduct.rightAlgebra` at
  L74 (without it the canonical `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)`
  instance is not in scope); do NOT encode the `df = dg` hypothesis
  as a `True`-placeholder for the iter-147+ refinement of
  `ext_of_diff_zero` (prover-prompt "tautologically-true type"
  guardrail).

### Post-dispatch absorption hooks for iter-148 planner

- If β-core closes: the iter-147+ refinement of `ext_of_diff_zero`
  (add `df = dg` + derive `eqOnOpen` from β-core) becomes a
  candidate iter-148 prover target.
- If KDM closes: β-core Step 1 is unblocked; the iter-148 prover
  lane can co-fire β-core + the `ext_of_diff_zero` refinement.
- If constants substep 3 closes: `constants_integral_over_base_field`
  becomes sorry-free and the file's sorry count drops to 2 (β-core +
  KDM only).
- If any of the 3 sorries returns PARTIAL: iter-148 plan-agent
  consults iter-147 progress-critic's escalation hook before
  re-dispatching (per `iter/iter-147/plan.md`).
