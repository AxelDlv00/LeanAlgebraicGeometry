# Lean ↔ Blueprint Checker — `RigidityKbar.lean` ↔ `RigidityKbar.tex` (iter-126, Archon canonical)

Per-file bidirectional verification of the newly-introduced M2.a
scaffold.

## File pair (one .lean, one .tex)

- **Lean file**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean` (87 lines; NEW iter-126; one declaration `AlgebraicGeometry.rigidity_over_kbar` with a single `sorry` body at L87)
- **Blueprint chapter**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex` (~120 LOC; NEW iter-126; statement at L16-30 + proof decomposition + shared cotangent-vanishing pile inventory + use-in-project + Mathlib status)

## What to check

### (A) Lean → blueprint
- The `\lean{AlgebraicGeometry.rigidity_over_kbar}` macro in the
  blueprint's Theorem block (L18) must name a declaration that
  exists in the Lean file with the matching signature.
- The Lean signature uses the "Option B" abstract encoding
  (`SmoothOfRelativeDimension 1 C.hom + IsProper C.hom +
  GeometricallyIrreducible C.hom + genus C = 0`). The blueprint's
  Theorem hypothesis list at L20-25 should match this. The Encoding
  note (L29) should accurately describe the deviation from a literal
  `ℙ¹` encoding.
- The blueprint's "Proof decomposition" sub-steps (C.2.b, C.2.c,
  C.2.d, C.2.e) and the "Shared cotangent-vanishing pile" piece
  inventory (i-iv) at L43-77 should be a faithful description of
  what the Lean `sorry` body conceptually represents.

### (B) Blueprint → Lean
- Is the blueprint chapter detailed enough that a future prover
  could formalize `rigidity_over_kbar`'s body from the chapter
  alone? Pay attention to: are the sub-steps (C.2.b reduction
  via `Scheme.Over.ext_of_eqOnOpen`; C.2.c image-dimension
  dichotomy; C.2.d cotangent-vanishing keystone) prover-actionable?
- The four-piece (i-iv) shared-pile inventory should give the
  iter-129+ prover unambiguous Mathlib leverage names. Check the
  target names (`GrpObj.omega_free`, `GrpObj.omega_rank_eq_dim`,
  `Scheme.Over.ext_of_diff_zero`, `frobenius`/`iterateFrobenius`)
  are not hallucinated.

### Out of scope
- Do NOT verify the body proof closure (it's deliberately `sorry`).
- Do NOT critique the strategic choice of M2.a as a route (that's
  strategy-critic territory).

## Output

Write your report to `.archon/task_results/lean-vs-blueprint-checker-rigiditykbar-iter126.md`.
Bidirectional findings + severity (must-fix / major / minor) per
your descriptor.
