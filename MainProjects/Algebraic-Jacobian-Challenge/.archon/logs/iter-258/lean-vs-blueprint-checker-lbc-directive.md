# Directive: lean-vs-blueprint check — LineBundleCoherence

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/LineBundleCoherence.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_LineBundleCoherence.tex`

## What to check
Iter-258 redirected this file's local `chartOverIso` sorry-def to the shared root
`Scheme.Modules.chartOverIso` (in `Picard/SheafOverEquivalence.lean`); the file is now
locally sorry-free. The 5 pinned decls are `exists_trivializing_cover`,
`chartPresentation`, `isFinitePresentation`, `isFiniteType`, `chart_free_rank_one`.

Report bidirectionally:
- Lean → blueprint: do the pinned decls match the chapter's `\lean{...}` and statements?
- Blueprint → Lean: does the chapter reflect that `chartOverIso` is now an imported
  shared-root construction (not a local sorry)? Any stale prose claiming a local sorry?

Flag any must-fix-this-iter blueprint inadequacy. Write to your task_results file.
