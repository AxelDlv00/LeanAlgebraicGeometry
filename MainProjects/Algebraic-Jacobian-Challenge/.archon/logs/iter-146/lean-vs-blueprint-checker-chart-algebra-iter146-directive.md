# lean-vs-blueprint-checker directive (iter-146 review phase)

## File

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

## Blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex`

The relevant section is § "Chart-algebra piece (ii) first-class
decomposition" beginning around L1827, with the five first-class
declaration blocks at L1835–L2072.

## Iter-146 prover scope

The prover refined and (partially) closed 3 of 5 sub-piece sorries:

- (α) `algebra_isPushout_of_affine_product` (Lean L84) — CLOSED;
  blueprint block at L1835–L1853 (`lem:chart_algebra_isPushout_of_affine_product`).
- (β-aux) `constants_integral_over_base_field` (Lean L144) — PARTIAL
  (signature refined to `RingHom.range … = ⊤`; substeps 1–2 closed
  in body; substep 3 deferred to iter-147+); blueprint block at
  L1944–L1967 (`lem:constants_integral_over_base_field`).
- (lift) `Scheme.Over.ext_of_diff_zero` (Lean L208) — CLOSED by
  delegating to `Scheme.Over.ext_of_eqOnOpen`; blueprint block at
  L2041–L2072 (`lem:Scheme_Over_ext_of_diff_zero`). NOTE: the prover
  dropped the `df = dg` hypothesis from the iter-146 signature on
  the grounds that `eqOnOpen` alone suffices; this is a deliberate
  reduction. Please flag whether the blueprint statement is
  consistent with this reduction or if a `% NOTE:` is warranted.

## Output

Bidirectional report: Lean → blueprint AND blueprint → Lean.
- Are the Lean signatures faithful to the blueprint statements?
- Are the blueprint statements detailed enough to guide the
  remaining body closure (substep 3 of constants; future β-core +
  KDM)?
- Note the `ext_of_diff_zero` signature-reduction call-out:
  is the blueprint statement (with `df = dg`) now stronger than the
  Lean statement (without)? Decide whether this is a Lean → blueprint
  mismatch (the blueprint should add a `% NOTE:`) or a blueprint →
  Lean mismatch (the Lean signature should add `df = dg` back).

Write your report to
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/task_results/lean-vs-blueprint-checker-chart-algebra-iter146.md`.
