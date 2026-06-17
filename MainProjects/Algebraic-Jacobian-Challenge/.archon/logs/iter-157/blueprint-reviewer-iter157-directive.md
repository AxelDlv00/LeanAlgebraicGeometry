# Blueprint Reviewer Directive

## Slug
iter157

Audit the WHOLE blueprint at
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/`
(chapters under `blueprint/src/chapters/`, assembled via `blueprint/src/content.tex`).
Produce your standard per-chapter checklist (complete? correct? Lean targets well-formed?
proofs detailed enough to formalize? broken `\uses`/`\cref`?) and the HARD-GATE verdict
per chapter.

## Focus this iter (do not let it narrow the whole-blueprint sweep)
The genus-0 critical path has committed to **route (c)**: a characteristic-free
abelian-variety rigidity stack (theorem of the cube → Rigidity Theorem → rational-map-
extends → unirational⟹constant → genus-0-curve-to-AV constant). These blocks currently
live in `Jacobian.tex` (subsection `sec:av_rigidity_route_c`,
labels `thm:theorem_of_the_cube`, `lem:rigidity_theorem`,
`cor:complete_product_to_AV_decomp`, `lem:rational_map_to_AV_extends`,
`prop:unirational_to_AV_constant`, `prop:rigidity_genus0_curve_to_AV`) at
statement + Milne-citation level.

For these route-(c) blocks specifically, judge:
1. **Are the proofs prover-ready?** They currently cite Milne's terse notes. The project
   has just added Mumford's *Abelian Varieties* (the canonical full-proof source) and
   Hartshorne. Is the current proof detail enough for a prover to formalize, or does each
   block (esp. theorem of the cube, rigidity theorem) need substantially more detail
   sourced from Mumford? Flag exactly which blocks are too thin.
2. **Are the `\lean{...}` targets present and well-formed?** These declarations do not yet
   exist in Lean (they will live in a NEW upstream file). Are the intended Lean names /
   signatures specified clearly enough to scaffold?
3. **`% archon:covers` hygiene.** `RigidityKbar.tex` declares
   `% archon:covers RigidityKbar.lean Cotangent/ChartAlgebra.lean` — the blueprint-doctor
   flags these as nonexistent because it resolves paths relative to the repo root while
   they are written relative to `AlgebraicJacobian/`. Confirm the correct fix is to write
   full paths (`AlgebraicJacobian/RigidityKbar.lean`, `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`).
   Also assess: should the route-(c) AV-rigidity stack be a separate chapter, or is a
   consolidated `% archon:covers` on `Jacobian.tex` (covering both `Jacobian.lean` and the
   new AV-rigidity file) the cleaner choice?

## Carry-over items to confirm resolved or still-live
- iter-156 `% NOTE:` items in `Jacobian.tex` `def:genusZeroWitness`: (1) the uniqueness
  paragraph justifies uniqueness by the terminal-object property (mathematically loose;
  the sound argument is epi-cancellation of `toUnit C`); (2) the C.2.f descent is billed
  "∼2 lines" but is actually a multi-iter base-change sub-build. Are these still live?
- Cross-chapter consistency: does `RigidityKbar.tex` still frame the cotangent/`df=0` route
  as the live path while `Jacobian.tex` has moved to route (c)? Flag the mismatch.

## Output
Your standard per-chapter checklist + HARD-GATE table + the focus findings above. Write to
your `task_results/` report.
