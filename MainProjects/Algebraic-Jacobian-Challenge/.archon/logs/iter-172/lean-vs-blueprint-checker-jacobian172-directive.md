# Lean ↔ Blueprint Checker Directive

## Slug
jacobian172

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Jacobian.tex`

## Iter-172 changes this iter
- Refactor agent `jacobian-purge-excuse` removed the L237-263 excuse-comment block and refreshed the `genusZeroWitness` docstring at L182-208 to align with Route C (`rigidity_genus0_curve_to_grpScheme` consumer; iter-163 commitment).
- No body sorries closed. No declarations renamed. No signatures touched.

## Audit scope
Bidirectional:
(A) Does the Lean follow the blueprint? — focus on whether the refreshed `genusZeroWitness` docstring's Status-block (iter-172) accurately describes the route C path the chapter prescribes. The chapter has been edited iter-163 to use Route C; the docstring should now match. Verify the `\lean{...}` pin and signature for `genusZeroWitness` and `nonempty_jacobianWitness` (or whichever appears in the chapter) match the Lean side.
(B) Is the blueprint adequate? — Jacobian.tex was audited iter-171 with `a4-bypass-audit` which returned "outcome (b) — bypass FAILS". Check if the chapter still carries any prose claiming the bypass holds (i.e. claims A.4 is Iters-left ~7-11 without the dual-figure caveat). Flag if any.

## Out of scope
- `genusZeroWitness.key` body (still `sorry` — properly gated; this is not a checker-target).
- `positiveGenusWitness` block (unchanged this iter).
- Strategy-level questions (out of checker's scope).
